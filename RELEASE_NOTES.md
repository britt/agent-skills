# Release Notes

## 2.0.0

Version 2.0.0 introduces semantic release examples, adds a changelog generation skill, refreshes the published guidance, and delivers a major shift from individual or archive based distribution to the full marketplace bundle.

### Breaking Changes

* Removed individual skill marketplace entries and ended support for `/plugin install britt/<skill-name>`, so installations now use the full `britt/claude-code-skills` bundle.
* Replaced zip archive downloads and removed archive packaging; migrate by installing the full bundle from the plugin marketplace, and for Claude.ai clone the repository and upload skill directories instead of downloading zip archives.

### Added

* Introduced the `changelog-generation` skill so teams can assemble release notes and changelogs from semantic commit history more consistently.

### Changed

* Updated archive cleanup during the packaging transition work in this pull request, then superseded the `--clean` option when the same 2.0.0 release removed zip packaging entirely.
* Refreshed `CONTRIBUTING.md`, `README.md`, and site documentation so the published guidance reflects the new repository layout and full bundle distribution model.

### Fixed

* Strengthened archive build checks so packaging stopped early and reported missing skill directories instead of finishing with silent errors.