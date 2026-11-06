# Implementation Plan — Issue #113: bundle manifests declare a non-spec `$schema`

Part of epic #117 (Conform to the Agent Plugins 1.0.0 spec).

## Change

1. In all four `bundles/*/plugin.json`, replace `"$schema": "https://superset.sh/schemas/plugin/1.0.0.json"` with `"$schema": "https://agent-plugins.org/schemas/1.0.0/plugin.schema.json"`.
2. Keep `extensions.superset` (see Assumptions) and document it in CONTRIBUTING.md §5 as a known client deviation from Agent Plugins §8.
3. Add a CONTRIBUTING.md sentence that bundle manifests must use the Agent Plugins `$schema`, so the old URL isn't reintroduced.

## Files

- `bundles/{britts-agent-skills,project-foundations,llpm,chat}/plugin.json`
- `CONTRIBUTING.md`

## Risks

- Paradev could require its own `$schema` value. Checked: its schema types `$schema` as any string, so the Agent Plugins URL validates there too.

## Assumptions

- **Extensions key.** Paradev's published plugin schema (`https://paradev.com/schemas/plugin/1.0.0.json`, also served at the old `superset.sh` URL) defines `extensions.superset` as its only property and marks it `required`. Its Build a Plugin guide says "Paradev settings go under `extensions.superset`". Neither mentions a reverse-domain key. So the key stays `superset`, and the exception goes in CONTRIBUTING.md, which the issue allows.
- **No version bump.** The issue doesn't ask for one, and `check-versions.sh` passes without it. Releasing is a separate step.
- **Out of scope** (sibling issues): root `plugin.json`, `ROOT_INCLUDES`, `check-versions.sh` (#115); the bundle symlinks and sync scripts (#114); spec-validation CI (#116). Validation here is a one-off local run, not a new script.
