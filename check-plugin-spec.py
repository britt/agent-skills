#!/usr/bin/env python3
"""Fail if any Agent Plugins-facing plugin root breaks the Agent Plugins 1.0.0 spec.

The plugin roots are the repo root (the full library) and each bundles/<name>/,
the same bundles check-bundles.sh walks. For each root this checks that:

  1. plugin.json exists inside the root and validates against the vendored
     Agent Plugins 1.0.0 manifest schema (schemas/agent-plugins/1.0.0/).
  2. Every immediate child of skills/ that holds a SKILL.md resolves inside
     the plugin root (a realpath prefix check), as Agent Plugins 4.1 and 7.1
     require, and that SKILL.md is a regular file.
  3. Every SKILL.md frontmatter follows the Agent Skills spec
     (https://agentskills.io/specification): only the allowed fields; a name
     that matches its directory and the name pattern; a 1-1024 character
     description; metadata as a string-to-string map.
  4. If the root has an mcp.json, it validates against the vendored MCP
     schema and its $schema names the same Agent Plugins version as
     plugin.json.

The schemas are vendored at a pinned version and never fetched: the spec says
clients must not retrieve a schema while loading a plugin, and CI should not
depend on the network for it either.

Usage:
  ./check-plugin-spec.py              # check the repo root and bundles/*/
  ./check-plugin-spec.py DIR [DIR...] # check only the given plugin roots

Requires jsonschema and PyYAML: pip install -r requirements-check.txt
"""

import json
import os
import re
import sys
from pathlib import Path

try:
    import jsonschema
    import yaml
except ImportError as e:
    sys.exit(
        f"error: {e.name} is required. Run: pip install -r requirements-check.txt"
    )

REPO = Path(__file__).resolve().parent
SPEC_VERSION = "1.0.0"
SCHEMA_DIR = REPO / "schemas" / "agent-plugins" / SPEC_VERSION

PLUGIN_SCHEMA_ID = re.compile(
    r"^https://agent-plugins\.org/schemas/([^/]+)/plugin\.schema\.json$"
)
MCP_SCHEMA_ID = re.compile(
    r"^https://agent-plugins\.org/schemas/([^/]+)/mcp\.schema\.json$"
)

# Agent Skills frontmatter fields (https://agentskills.io/specification).
SKILL_FIELDS = {
    "name",
    "description",
    "license",
    "compatibility",
    "metadata",
    "allowed-tools",
}
SKILL_NAME = re.compile(r"^[a-z0-9]+(?:-[a-z0-9]+)*$")

errors = []


def err(msg):
    errors.append(msg)
    print(f"error: {msg}", file=sys.stderr)


def load_validator(filename):
    with open(SCHEMA_DIR / filename, encoding="utf-8") as f:
        schema = json.load(f)
    cls = jsonschema.validators.validator_for(schema)
    cls.check_schema(schema)
    return cls(schema)


def inside(path, root_real):
    """True if path's filesystem-resolved location is within root_real."""
    real = os.path.realpath(path)
    return real == root_real or real.startswith(root_real + os.sep)


def schema_errors(validator, instance):
    for e in sorted(validator.iter_errors(instance), key=lambda e: list(e.path)):
        where = "/".join(str(p) for p in e.absolute_path) or "(top level)"
        yield f"{where}: {e.message}"


def load_json(path):
    try:
        with open(path, encoding="utf-8") as f:
            return json.load(f)
    except (OSError, ValueError) as e:
        err(f"{path}: not readable JSON: {e}")
        return None


def check_manifest(root, root_real, validator):
    """Validate plugin.json; return its spec version, or None."""
    path = root / "plugin.json"
    if not os.path.lexists(path):
        err(f"{path} is missing; Agent Plugins requires a manifest at the plugin root")
        return None
    if not inside(path, root_real):
        err(f"{path} resolves outside the plugin root ({os.path.realpath(path)})")
        return None
    if not path.is_file():
        err(f"{path} is not a regular file")
        return None

    manifest = load_json(path)
    if manifest is None:
        return None
    for msg in schema_errors(validator, manifest):
        err(f"{path}: {msg}")

    if isinstance(manifest, dict):
        m = PLUGIN_SCHEMA_ID.match(str(manifest.get("$schema", "")))
        if m:
            return m.group(1)
    return None


def check_frontmatter(skill_md, dirname):
    text = skill_md.read_text(encoding="utf-8")
    lines = text.splitlines()
    if not lines or lines[0].strip() != "---":
        err(f"{skill_md}: does not start with a '---' frontmatter block")
        return
    try:
        end = next(i for i, line in enumerate(lines[1:], 1) if line.strip() == "---")
    except StopIteration:
        err(f"{skill_md}: frontmatter block is not closed with '---'")
        return
    try:
        fm = yaml.safe_load("\n".join(lines[1:end]))
    except yaml.YAMLError as e:
        err(f"{skill_md}: frontmatter is not valid YAML: {e}")
        return
    if not isinstance(fm, dict):
        err(f"{skill_md}: frontmatter is not a mapping")
        return

    for key in sorted(set(fm) - SKILL_FIELDS, key=str):
        err(f"{skill_md}: frontmatter field {key!r} is not allowed by the Agent Skills spec")

    name = fm.get("name")
    if name is None:
        err(f"{skill_md}: frontmatter 'name' is required")
    elif not isinstance(name, str):
        err(f"{skill_md}: frontmatter 'name' must be a string")
    else:
        if not 1 <= len(name) <= 64 or not SKILL_NAME.match(name):
            err(
                f"{skill_md}: name {name!r} must be 1-64 characters of a-z, 0-9 and "
                "single hyphens, not starting or ending with a hyphen"
            )
        if name != dirname:
            err(f"{skill_md}: name {name!r} does not match its directory {dirname!r}")

    desc = fm.get("description")
    if desc is None:
        err(f"{skill_md}: frontmatter 'description' is required")
    elif not isinstance(desc, str):
        err(f"{skill_md}: frontmatter 'description' must be a string")
    elif not desc.strip() or len(desc) > 1024:
        err(f"{skill_md}: description must be 1-1024 characters (is {len(desc)})")

    for key in ("license", "allowed-tools"):
        if key in fm and not isinstance(fm[key], str):
            err(f"{skill_md}: frontmatter {key!r} must be a string")

    if "compatibility" in fm:
        compat = fm["compatibility"]
        if not isinstance(compat, str):
            err(f"{skill_md}: frontmatter 'compatibility' must be a string")
        elif not compat.strip() or len(compat) > 500:
            err(f"{skill_md}: compatibility must be 1-500 characters (is {len(compat)})")

    if "metadata" in fm:
        meta = fm["metadata"]
        if not isinstance(meta, dict):
            err(f"{skill_md}: frontmatter 'metadata' must be a map of strings to strings")
        else:
            for k, v in meta.items():
                if not isinstance(k, str) or not isinstance(v, str):
                    err(
                        f"{skill_md}: metadata entry {k!r}: {v!r} is not string to "
                        "string (quote the value)"
                    )


def check_skills(root, root_real):
    """Return the number of skills found."""
    skills = root / "skills"
    if not os.path.lexists(skills):
        return 0
    if not inside(skills, root_real):
        err(f"{skills} resolves outside the plugin root ({os.path.realpath(skills)})")
        return 0
    if not skills.is_dir():
        err(f"{skills} is not a directory")
        return 0

    count = 0
    for child in sorted(skills.iterdir()):
        if child.is_symlink() and not child.exists():
            err(f"{child} is a dangling symlink")
            continue
        skill_md = child / "SKILL.md"
        if not os.path.lexists(skill_md):
            continue
        count += 1
        outside = [p for p in (child, skill_md) if not inside(p, root_real)]
        if outside:
            err(
                f"{outside[0]} resolves outside the plugin root "
                f"({os.path.realpath(outside[0])}); a conforming client skips it"
            )
            continue
        if not skill_md.is_file():
            err(f"{skill_md} is not a regular file")
            continue
        check_frontmatter(skill_md, child.name)
    return count


def check_mcp(root, root_real, validator, plugin_version):
    path = root / "mcp.json"
    if not os.path.lexists(path):
        return False
    if not inside(path, root_real):
        err(f"{path} resolves outside the plugin root ({os.path.realpath(path)})")
        return True
    if not path.is_file():
        err(f"{path} is not a regular file")
        return True

    config = load_json(path)
    if config is None:
        return True
    for msg in schema_errors(validator, config):
        err(f"{path}: {msg}")

    if isinstance(config, dict):
        m = MCP_SCHEMA_ID.match(str(config.get("$schema", "")))
        mcp_version = m.group(1) if m else None
        if mcp_version and plugin_version and mcp_version != plugin_version:
            err(
                f"{path}: $schema targets Agent Plugins {mcp_version} but "
                f"plugin.json targets {plugin_version}"
            )
    return True


def default_roots():
    os.chdir(REPO)
    return [Path(".")] + sorted(p for p in Path("bundles").glob("*") if p.is_dir())


def main(argv):
    roots = [Path(a) for a in argv] if argv else default_roots()
    plugin_validator = load_validator("plugin.schema.json")
    mcp_validator = load_validator("mcp.schema.json")

    for root in roots:
        if not root.is_dir():
            err(f"{root} is not a directory")
            continue
        root_real = os.path.realpath(root)
        before = len(errors)
        version = check_manifest(root, root_real, plugin_validator)
        count = check_skills(root, root_real)
        has_mcp = check_mcp(root, root_real, mcp_validator, version)
        if len(errors) == before:
            extra = ", mcp.json" if has_mcp else ""
            print(f"OK: {root}/ (plugin.json, {count} skills{extra})")

    if errors:
        print(
            f"{len(errors)} Agent Plugins {SPEC_VERSION} conformance error(s). "
            "See CONTRIBUTING.md, 'Checking spec conformance'.",
            file=sys.stderr,
        )
        return 1
    print(f"OK: every plugin root conforms to Agent Plugins {SPEC_VERSION}.")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
