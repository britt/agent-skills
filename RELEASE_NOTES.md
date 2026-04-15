# Release Notes

## 2.0.0

This release consolidates installation and distribution around the `britt/claude-code-skills` bundle, removes the older zip download path, adds the `changelog-generation` skill, and refreshes published guidance so installation and repository documentation reflect the 2.0.0 model.

### Breaking Changes

* Retired individual marketplace installs and requires `/plugin install britt/claude-code-skills`; `/plugin install britt/<skill-name>` no longer works.
* Replaced zip archive downloads with repository based distribution; release zip downloads and package based distribution are no longer supported, and Claude.ai projects should clone the repository and upload the required skill directories instead.

### Added

* Introduced the `changelog-generation` skill for turning conventional commit history into grouped Markdown changelogs and release notes.

### Changed

* Refreshed `README.md`, `CONTRIBUTING.md`, and the site homepage so published installation guidance and repository structure match the bundle based distribution model and current layout.
* Updated the marketplace to version `2.0.0` and updated the bundled `claude-code-skills` entry to version `2.0.0`.

### Fixed

* Hardened the transitional archive packaging script so it failed fast when required skill directories were missing instead of producing incomplete output.
* Added a `--clean` option during the transition away from archive packaging so stale build artifacts could be removed before rebuilding; archive packaging is not part of 2.0.0.