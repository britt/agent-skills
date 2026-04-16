# Release Notes

## 2.0.0

This release moves distribution to the full skills bundle, adds changelog generation guidance, and refreshes supporting documentation for the 2.0.0 layout.

### Breaking Changes

* Removed individual marketplace entries, so the `/plugin install britt/<skill-name>` flow no longer works and installation now happens through the full `britt/claude-code-skills` bundle.
* Retired zip archive downloads and removed `package.sh`, so Claude.ai users now clone the repository and upload skill directories instead of downloading archives.

### Added

* Introduced the new `changelog-generation` skill for structured changelog and release note work.
* Provided semantic release example documents that show feature, fix, performance, and breaking change commit formats.

### Changed

* Updated the marketplace metadata and bundled plugin to version 2.0.0.
* Refreshed the README and contributing guidance to reflect the bundle first distribution model and the updated repository layout.
* Expanded the site skill listing to include the new `changelog-generation` skill.