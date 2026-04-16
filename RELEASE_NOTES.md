# Release Notes

## 2.0.0

This release moves distribution to the full skills bundle, adds changelog generation guidance, and refreshes supporting documentation for the 2.0.0 layout.

### Breaking Changes

* Shifted installation from individual marketplace entries to the full `britt/claude-code-skills` bundle, so the `/plugin install britt/<skill-name>` flow no longer works.
* Replaced zip archive downloads with cloned repository installs and removed `package.sh`, so Claude.ai users now upload skill directories instead of downloading archives.

### Added

* Added the new `changelog-generation` skill for structured changelog and release note work.
* Published semantic release example documents that show feature, fix, performance, and breaking change commit formats.

### Changed

* Updated the marketplace metadata and bundled plugin to version 2.0.0.
* Refreshed the README and contributing guidance to reflect the bundle first distribution model and the updated repository layout.
* Expanded the site skill listing to include the new `changelog-generation` skill.