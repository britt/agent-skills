# Release Notes

## 2.0.0

This release adds semantic-release guidance, introduces the changelog-generation skill, refreshes contributor and installation documentation, and moves marketplace distribution to the full bundle.

### Breaking Changes

* Retired individual marketplace skill entries and now requires installation of the full `britt/claude-code-skills` bundle instead of single skills.
* Replaced release zip downloads and archive based setup with the marketplace bundle, and now uses cloned skill directories for Claude.ai setup.

### Added

* Introduced the `changelog-generation` skill and documented it across the marketplace, README, and site.

### Changed

* Clarified semantic-release commit examples for `fix`, `feat`, `perf`, and `BREAKING CHANGE` formats.
* Refreshed the contributing guide so the documented repository structure matches the current layout.
* Streamlined transitional packaging by adding a `--clean` option that removed stale archives before rebuilding.

### Fixed

* Hardened packaging safety checks so archive builds stopped on shell errors and failed when no skill directories existed.