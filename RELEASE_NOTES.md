# Release Notes

## 2.0.0

Version 2.0.0 introduces semantic release examples, adds a changelog generation skill, refreshes contributor and installation documentation, and delivers a major shift from individual or archive based distribution to the full marketplace bundle.

### Breaking Changes

* Removed individual skill marketplace entries and ended support for `/plugin install britt/<skill-name>`, so installations now use the full `britt/claude-code-skills` bundle.
* Replaced zip archive distribution and removed `package.sh`; migrate by installing the full bundle from the plugin marketplace, and for Claude.ai clone the repository and upload skill directories instead of downloading zip archives.

### Added

* Introduced the `changelog-generation` skill so teams can assemble release notes and changelogs from semantic commit history more consistently.

### Changed

* Updated archive cleanup behavior during the packaging transition work in this pull request, then superseded that `--clean` option when the same 2.0.0 release removed zip packaging entirely.
* Refreshed `CONTRIBUTING.md`, `README.md`, and site documentation so the published guidance matches the new repository layout and full bundle distribution model.

### Fixed

* Strengthened packaging failure checks so archive builds stopped early and reported missing skill directories instead of finishing with silent errors.