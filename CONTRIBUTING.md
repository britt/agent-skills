# Contributing

Guidelines for contributing to this skills repository.

🤷 **Real talk:** Skills are just markdown files and setting up your own marketplace is literally one JSON file. You probably want to make your own repo instead of contributing here. But hey, if you've got improvements to my skills or want to share something cool, I'm happy to post it! PRs welcome. 🎉

## Repository Structure

```
agent-skills/
├── README.md                 # Installation and usage guide
├── CONTRIBUTING.md           # This file
├── plugin.json               # Agent Plugins 1.0.0 manifest (full bundle)
├── sync-agents-skills.sh     # Keeps .agents/skills/ symlinks, the rules/ mirror, and the bundle copies in sync with skills/
├── sync-bundles.sh           # Regenerates the real skill and icon copies under bundles/ (run by sync-agents-skills.sh)
├── check-bundles.sh          # Fails if a bundle copy has drifted from skills/ or assets/, or holds a symlink (runs in CI)
├── sync-claude-plugin.sh     # Regenerates claude-plugin/ for Anthropic's plugin directory (run by sync-agents-skills.sh and on every push to main)
├── check-claude-plugin.sh    # Fails if claude-plugin/ has drifted or breaks a plugin directory rule (runs in CI)
├── check-plugin-spec.py      # Fails if a plugin root breaks the Agent Plugins 1.0.0 or Agent Skills spec (runs in CI)
├── requirements-check.txt    # Pinned Python dependencies for check-plugin-spec.py
├── schemas/agent-plugins/1.0.0/  # Vendored Agent Plugins schemas (plugin.schema.json, mcp.schema.json)
├── .claude-plugin/
│   ├── marketplace.json      # Claude Code plugin marketplace configuration
│   └── plugin.json           # Claude Code plugin manifest (full bundle)
├── .codex-plugin/
│   └── plugin.json           # Codex CLI plugin manifest (full bundle; reuses .claude-plugin/marketplace.json)
├── .cursor-plugin/
│   ├── marketplace.json      # Cursor plugin marketplace configuration
│   └── plugin.json           # Cursor plugin manifest (full bundle)
├── .agent-marketplace.json   # Paradev plugin marketplace configuration
├── claude-plugin/            # The one plugin folder submitted to Anthropic's plugin directory (see "The plugin directory folder")
│   ├── .claude-plugin/plugin.json  # Generated copy of the root Claude manifest
│   ├── README.md             # Hand-maintained: the directory shows it as the listing's description
│   ├── LICENSE               # Generated copy
│   ├── assets/icon.png       # Generated copy
│   └── skills/               # Generated copies of every skill in skills/
├── bundles/
│   ├── britts-agent-skills/  # Paradev-only source for the full library: plugin.json + generated copies of every skill
│   ├── project-foundations/  # Curated bundle: per-agent manifests, plugin.json, generated skill copies
│   ├── llpm/
│   └── chat/
├── .agents/
│   └── skills/                       # Symlinks only — read by Codex CLI, OpenCode, Cursor
│       ├── daily-planning-ritual -> ../../skills/daily-planning-ritual
│       └── ...
├── docs/
│   └── plans/                # Design documents for skills
│       └── 2025-11-09-summoning-user-design.md
└── skills/
    ├── daily-planning-ritual/
    │   ├── README.md         # Customization guide
    │   └── SKILL.md          # Skill implementation
    ├── writing-product-specs/
    │   └── SKILL.md
    └── writing-user-stories/
        └── SKILL.md
```

`skills/` is the canonical copy of every skill. `.agents/skills/` holds only symlinks back into it (read natively by Codex CLI, OpenCode, and Cursor) — never commit real files there. `bundles/<name>/skills/` and `claude-plugin/skills/` hold generated copies, not symlinks (see [Bundle contents](#bundle-contents) and [The plugin directory folder](#the-plugin-directory-folder)) — never edit them by hand.

## Creating a New Skill

Skills should follow this structure:

### 1. Design Document (Optional)

Create `docs/plans/YYYY-MM-DD-topic-design.md` with:
- Overview and purpose
- Decision criteria or workflow
- Implementation details
- Examples

### 2. Skill File (Required)

Create `skills/skill-name/SKILL.md` with:

```markdown
---
name: skill-name
description: Brief description of when to use this skill
---

# Skill Name

## Overview

What this skill does and its core principle.

## When to Use This Skill

Use this skill when:
- Condition 1
- Condition 2

## Process

Step-by-step instructions...
```

Required elements:
- YAML frontmatter with `name` and `description`
- Overview and core principles
- When to use the skill
- Step-by-step process

Optional elements:
- Key principles table
- Anti-patterns
- Examples

### 3. Link into .agents/skills/ (Required)

Run `./sync-agents-skills.sh` to add the `.agents/skills/<name>` symlink for your new skill (and clean up any stale ones). This is what makes the skill discoverable by Codex CLI, OpenCode, and Cursor — commit the symlink, not a copy of the file.

The same script runs `./sync-bundles.sh`, which copies the new skill into `bundles/britts-agent-skills/skills/` (the full library) and refreshes every other bundle's copies. Commit those copies too. Re-run it after any edit to a skill that a bundle carries; CI fails otherwise.

The same script refreshes `rules/`, which mirrors rule sets bundled inside skills so they stay fetchable by raw URL. Edit the copy inside the skill; never edit `rules/` directly. Skills must stay self-contained — single-skill installs use `"source": "./skills/<name>"`, so a symlink out of the skill directory would dangle.

### 4. Update Marketplace (Required)

Add the new skill to `.claude-plugin/marketplace.json`:

```json
{
  "name": "your-skill-name",
  "source": "./skills/your-skill-name",
  "description": "Same description as in SKILL.md frontmatter",
  "version": "1.0.0",
  "author": {
    "name": "Your Name"
  },
  "repository": "https://github.com/britt/agent-skills",
  "license": "MIT",
  "keywords": ["keyword1", "keyword2"],
  "category": "workflow|productivity|documentation",
  "tags": ["tag1", "tag2"]
}
```

New skills are picked up automatically by the Codex/Cursor full-bundle plugins (they reference the whole `skills/` directory) — no per-skill entry needed there. Granular per-skill installs are currently a Claude Code-only feature.

A skill that needs to know its own version at runtime (for example, `estimating-work-items` records it in every estimate) declares it in its frontmatter under `metadata`, not as a top-level key, which the Claude and Codex skill validators reject:

```markdown
---
name: your-skill-name
description: ...
metadata:
  version: "1.0.0"
---
```

That value must match the skill's `version` in `.claude-plugin/marketplace.json`. Bump both together; `./check-versions.sh` fails if they differ.

### 5. Bumping the Bundle Version (Required when releasing)

The full-bundle skill archive is described in places that must stay in lockstep: the root `plugin.json`, `.claude-plugin/plugin.json`, `.codex-plugin/plugin.json`, `.cursor-plugin/plugin.json`, the `britts-agent-skills` entry and top-level `version` in `.claude-plugin/marketplace.json`, and the `britts-agent-skills` entry in `.agent-marketplace.json` with its `bundles/britts-agent-skills/plugin.json`. Each curated bundle has its own set of three manifests under `bundles/<name>/` (`project-foundations`, `llpm`, `chat`), versioned independently of the full bundle, plus a matching entry in `.claude-plugin/marketplace.json` and `.cursor-plugin/marketplace.json`.

The bundle's `displayName` ("Britt's Agent Skills") lives in those same manifests, plus the `britts-agent-skills` entry in `.cursor-plugin/marketplace.json`. The bundle's `icon` (`./assets/icon.png`) sits beside it in the same three plugin manifests. Claude Code ignores `icon` at load time — it is read by Anthropic's plugin directory — and it belongs only in a plugin manifest: `claude plugin validate` reports it as an unknown field in `marketplace.json`, at the top level and in a plugin entry alike. The display name is display text only. The plugin's `name` is `britts-agent-skills`: it namespaces every skill (`britts-agent-skills:issue-decomposition`) and forms the install id (`britts-agent-skills@britts-agent-skills`), so renaming it again means adding another entry to the marketplace's `renames` map, which migrates existing installs

The root `plugin.json` is the full library's [Agent Plugins 1.0.0](https://agent-plugins.org/specification) manifest; the spec requires one at the plugin root, and `package-bundles.sh` puts it at the root of the full-library zip. The spec's manifest schema is closed (`additionalProperties: false`), so it holds only spec fields: no `displayName`, `icon`, `category`, or `skills`. Those stay in the client-specific manifests. A conforming client finds the skills at the default `skills/<name>/SKILL.md` location.

Each `bundles/<name>/plugin.json` is an [Agent Plugins 1.0.0](https://agent-plugins.org/specification) manifest, so its `$schema` must be exactly `https://agent-plugins.org/schemas/1.0.0/plugin.schema.json`. The published schema enforces that value with `const`, and a conforming client rejects a plugin whose `$schema` it does not recognize, loading none of its skills. Do not put Paradev's own schema URL (`https://paradev.com/schemas/plugin/1.0.0.json`, formerly `https://superset.sh/schemas/plugin/1.0.0.json`) there: Paradev's schema accepts any string for `$schema`, so the Agent Plugins URL satisfies both.

**Known client deviation: `extensions.superset`.** Agent Plugins §8 says `extensions` keys should be reverse-domain namespaces (for example `sh.superset`). Paradev reads only the bare key `superset`: its plugin schema lists `superset` as the one `extensions` property and marks it required, and its [Build a Plugin](https://docs.paradev.com/plugins/build-a-plugin) guide says "Paradev settings go under `extensions.superset`". Moving the data to a reverse-domain key would hide it from the only client that uses it, so the bundles keep `extensions.superset`. It still validates against the Agent Plugins schema, which only requires each `extensions` value to be an object. Switch to a reverse-domain key once Paradev reads one.

Paradev keeps its own icon, at `extensions.superset.interface.icon` in each `bundles/<name>/plugin.json`. Its schema says only `"type": "string"`, so the convention is ours to set: all four bundles name the file, `./assets/icon.png`, matching the three Claude/Codex/Cursor manifests. Paradev's own plugins instead put a brand slug there (`"icon": "github"`), which works only because the app compiles their artwork in by plugin name; a slug from this repo would resolve to nothing. The icon belongs only in a plugin manifest: the Paradev marketplace schema sets `additionalProperties: false` on a plugin entry and has no `icon`, so `.agent-marketplace.json` would fail validation.

A relative icon path has to resolve inside the bundle, so each `bundles/<name>/assets/icon.png` is a generated copy of the canonical `assets/icon.png`, the same arrangement the skills use (see [Bundle contents](#bundle-contents)). `assets/` is in that script's `ROOT_INCLUDES` for the same reason. Today's Paradev desktop still draws a puzzle glyph for any plugin it does not ship artwork for, so the field changes nothing on the Plugins page yet; what it does guarantee is that the path it names is real.

Run `./check-versions.sh` to verify a bundle's sources agree before opening a PR. The same check runs on every pull request and again in the release workflow before any asset is built.

### Bundle contents

Each `bundles/<name>/` is its own plugin root, and [Agent Plugins 1.0.0 §4.1.3–4.1.4](https://agent-plugins.org/specification) rejects any symlink that resolves outside a plugin root: a conforming client installing a symlinked bundle from a git checkout loads none of its skills. So a bundle's `skills/<name>/` directories and its `assets/icon.png` are real copies of the canonical `skills/<name>/` and `assets/icon.png`, generated by `./sync-bundles.sh` and committed. A bundle is still a curation, not a fork: edit the canonical copy, never the one under `bundles/`, then run the script.

- `britts-agent-skills` carries every skill in `skills/`, so new skills land there automatically. It is listed in `FULL_LIBRARY_BUNDLES` in both `sync-bundles.sh` and `check-bundles.sh`.
- Every other bundle carries exactly the skills whose directories exist under its `skills/`. To add one, `mkdir bundles/<bundle>/skills/<name>` and run `./sync-bundles.sh`; to drop one, delete that directory.

`./check-bundles.sh` fails if any bundle contains a symlink, if a bundled skill or icon differs from its canonical copy (contents or executable bit), or if the full-library bundle's skill set differs from `skills/`. It runs on every pull request; the fix is always `./sync-bundles.sh` and a commit.

### The plugin directory folder

[Anthropic's plugin directory](https://claude.com/docs/plugins/submit) reads one plugin folder from a GitHub repository: the folder that holds `.claude-plugin/plugin.json`, named by the submission's **Plugin path**. Submitting this repository's root fails the directory's [pre-submission checks](https://claude.com/docs/plugins/pre-submission-checklist): the root is a marketplace that lists several plugins (**Pick one plugin first** blocks the submission), `.agents/skills/` is a tree of symlinks and `site/themes/` a git submodule (the directory wants regular files), and the root README is written for four tools rather than for a listing. So the full library is submitted from `claude-plugin/`, which holds exactly one plugin and nothing else. Set **Plugin path** to `claude-plugin` and leave the tracked branch as `main`.

What is in it:

- Generated by `./sync-claude-plugin.sh`, never edited by hand: `.claude-plugin/plugin.json` (a copy of the root `.claude-plugin/plugin.json`, so the version stays in lockstep with the bundle), `skills/` (a copy of `skills/` minus the skills named in `EXCLUDED_SKILLS` in `./sync-claude-plugin.sh`: `supervising-conductor-workspaces` and `supervising-paradev-workspaces` depend on a bundled shell script, which the directory does not accept, so they ship only through the repository's own marketplace), `assets/icon.png`, and `LICENSE`.
- Hand-maintained: `README.md`. The directory shows it as the listing's description and requires at least 40 words outside code blocks. It lists every skill by name in backticks; `./check-claude-plugin.sh` fails if a skill in `skills/` is missing from it, so add a line for each new skill. It also states what the plugin runs, sends, and stores, which the directory's security scan compares against the source.

How it stays current:

- `.github/workflows/sync-claude-plugin.yml` runs the sync on every push to `main` and commits the result to `main` when anything changed. Merging a PR is therefore enough to ship a new version; a PR does not need to carry regenerated copies of `claude-plugin/`. The directory picks up that commit through its GitHub webhook or its scheduled check. The workflow pushes with the built-in `GITHUB_TOKEN`, so `main` must allow pushes from GitHub Actions (a branch protection rule that requires pull requests for everyone will block it; allow the `github-actions` app to bypass it, or use a deploy key or a fine-grained token with contents write in place of the default token).
- `.github/workflows/claude-plugin-check.yml` runs on every pull request. It regenerates `claude-plugin/` in the runner from the PR's `skills/` and manifests, runs `./check-claude-plugin.sh`, and then runs `claude plugin validate --strict ./claude-plugin`, which covers a subset of the directory's own checks. The portal's **Validate** button is the full check.
- `./sync-agents-skills.sh` also runs the sync, so a local run leaves `claude-plugin/` matching `skills/` too. Committing that is fine; the workflow then has nothing to do.

`./check-claude-plugin.sh` fails if a generated file differs from its source (contents or executable bit), if the folder holds a symlink or an OS junk file such as `.DS_Store`, if any entry other than the five above is present, if the manifest lacks a name, version, description, author, or license, if the manifest's `icon` does not exist inside the folder, if the README is missing, too short, or does not name every skill, or if an excluded skill is present, if a file is not Markdown, text, JSON, YAML, `LICENSE`, or a PNG, JPEG, GIF, WebP, or ICO image, if a file starts with `#!`, if a file is a package manager configuration (`package.json`, a lockfile, `pnpm-workspace.yaml`, `.npmrc`, `pyproject.toml`, `requirements.txt`, and the like), if a text file is not valid UTF-8 or holds a NUL byte, or if a file size or count would hold the version for a reviewer (any non-image file of 256 KiB or more, any file of 5 MiB or more, more than 512 files).

Bumping the full bundle's version (see above) is what the directory treats as a release: raise it in the root manifests, and the synced copy follows.

### Checking spec conformance

`./check-plugin-spec.py` checks every Agent Plugins-facing plugin root, which means the repo root and each `bundles/<name>/`, against [Agent Plugins 1.0.0](https://agent-plugins.org/specification) and the [Agent Skills spec](https://agentskills.io/specification). Client-specific manifests and marketplaces (`.claude-plugin/`, `.codex-plugin/`, `.cursor-plugin/`, `.agent-marketplace.json`) are not covered. It fails if:

- `plugin.json` is missing or does not validate against the manifest schema. The schema is closed, so an unknown top-level field fails too.
- an immediate child of `skills/` holding a `SKILL.md` resolves outside the plugin root (a `realpath` prefix check), or its `SKILL.md` is not a regular file;
- a `SKILL.md` frontmatter has a field other than `name`, `description`, `license`, `compatibility`, `metadata` and `allowed-tools`; a `name` that does not match its directory or the pattern (1–64 characters of `a-z`, `0-9` and single hyphens, no leading or trailing hyphen); a `description` outside 1–1024 characters; a `compatibility` outside 1–500 characters; or `metadata` that is not a string-to-string map. Quote numeric-looking values such as `version: "1.0"`, because YAML would otherwise read them as numbers.
- an `mcp.json` exists and does not validate against the MCP schema, or its `$schema` names a different Agent Plugins version from `plugin.json`.

Run it locally before opening a PR:

```bash
pip install -r requirements-check.txt   # jsonschema and PyYAML, pinned
./check-plugin-spec.py                  # or pass plugin roots to check only those
```

It runs on every pull request through `.github/workflows/plugin-spec-check.yml`. `check-bundles.sh` covers a different failure: it checks that the bundle copies still match `skills/` and `assets/`.

The schemas are vendored under `schemas/agent-plugins/1.0.0/`, copied verbatim from `https://agent-plugins.org/schemas/1.0.0/`. The spec says clients must not fetch a schema while loading a plugin, and the check never fetches one either. To move to a new spec version, add a `schemas/agent-plugins/<version>/` directory beside the old one, update `SPEC_VERSION` in the script, and change `$schema` in every `plugin.json` in the same PR.

## Building Skill Archives

To create zip archives of all skills for distribution:

```bash
./package.sh
```

This creates a `dist/` directory containing zip files for each skill (e.g., `dist/writing-user-stories.zip`).

To build the per-bundle archives that get attached to a release:

```bash
./package-bundles.sh
```

This writes one zip per bundle to `dist/`, named `<bundle>-<version>.zip` using the version from that bundle's own `.claude-plugin/plugin.json` — e.g. `agent-skills-5.1.0.zip`, `llpm-1.3.0.zip`. Bundles are discovered from `.claude-plugin/marketplace.json` (any plugin entry whose `source` is not a single skill under `./skills/`), so a new bundle needs no change to the script. Bundles hold real copies of their skills, so each archive unzips standalone.

The `chat` bundle additionally carries a zip per skill at its archive root, alongside `skills/` — each one holding `<skill>/` at its root so it can be uploaded to a chat agent as-is. Bundles opted into this are listed in `NESTED_SKILL_ZIPS` in the script.

## Releasing

Publishing a GitHub release triggers `.github/workflows/release-artifacts.yml`, which checks out the released tag, runs `package-bundles.sh`, and uploads the archives to the release. Bump the bundle versions (see above) before tagging — the archive filenames come from the manifests, not the tag.

To rebuild assets for an existing release, run the workflow manually from the Actions tab with that tag as input. This only works for tags that already contain `package-bundles.sh`.

## Testing Skills

Before submitting:
1. Install the skill locally
2. Test with Claude Code or Claude.ai
3. Verify the skill triggers correctly based on its description
4. Check that all instructions are clear and actionable

## Pull Request Guidelines

1. One skill per PR (unless they're closely related)
2. Include a brief description of what the skill does
3. Explain how you tested it
4. Update the README if adding a new skill
