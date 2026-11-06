# Issue #115 plan: portable plugin.json at the repo root

Part of epic #117. Based on `issue-113-bundle-schema`.

## Changes

1. `plugin.json` (new, repo root): Agent Plugins 1.0.0 manifest for the full
   library. `$schema`, `name` (`britts-agent-skills`), `version`, `description`,
   `author` (`name`, `email`), `homepage`, `repository`, `license`, `keywords`.
   Values copied from `.claude-plugin/plugin.json`. No `extensions`.
2. `package-bundles.sh`: add `plugin.json` to `ROOT_INCLUDES`.
3. `check-versions.sh`: for the root bundle (source `./`), add `./plugin.json`
   to the versions compared, reported as MISSING if the file is absent.
4. `CONTRIBUTING.md` and the `version-check.yml` header comment: document the
   root manifest and that it is part of the lockstep.

## Assumptions

- Client-only fields (`displayName`, `icon`, `category`, `tags`, `skills`) stay
  in the client-specific manifests; the root manifest has no `extensions` key.
- `description` and `author` follow the client-specific full-library manifests
  (author `email`), not the Paradev bundle manifest (author `url`).
- Skills are found at the spec's default `skills/<name>/SKILL.md`; no path field
  is needed (the schema has none).
- `bundles/britts-agent-skills` is left in place; whether to remove it belongs
  to #114. It is still needed by Paradev, which cannot publish from `./` and
  requires `extensions.superset`, which the root manifest does not carry.

## Risks

- Codex/Cursor/Claude read their own `.<client>-plugin/plugin.json`; a root
  `plugin.json` should not affect them. Nothing in this repo reads a root
  `plugin.json` other than `check-versions.sh`.
