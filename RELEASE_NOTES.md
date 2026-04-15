# Release Notes

## 2.0.0

This release expands release guidance, adds the changelog generation skill, refreshes contributor and installation documentation, and shifts distribution to the full marketplace bundle.

### Breaking Changes

* Changed installation so the marketplace now accepts only the full `britt/claude-code-skills` bundle instead of single skill installs.
* Migrated distribution away from release zip downloads to the marketplace bundle, and now uses cloned skill directories for Claude.ai setup.

### Added

* Added the `changelog-generation` skill and documented it across the marketplace, README, and site.

### Changed

* Clarified release commit examples for `fix`, `feat`, `perf`, and `BREAKING CHANGE` formats.
* Refreshed the contributing guide so the documented repository structure matches the current layout.

### Chore

* Streamlined the packaging transition with a `--clean` option that removed stale archives before rebuilding.

### Fixed

* Fixed packaging safety checks so archive builds stop on errors and fail when no skill directories exist.