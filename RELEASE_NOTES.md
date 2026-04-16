# Release Notes

## 2.0.0

This release introduces bundle first distribution, expands release guidance, and refreshes documentation for the 2.0.0 transition.

### Breaking Changes

* Removed individual marketplace entries, so the `/plugin install britt/<skill-name>` flow no longer works and installation now goes through the full `britt/claude-code-skills` bundle.
* Retired zip archive distribution and removed `package.sh`, so Claude.ai users now clone the repository and upload skill directories instead of downloading release archives.

### Added

* Introduced the `changelog-generation` skill, so teams can produce structured changelogs and release notes from semantic release history.
* Published semantic release example documents that show feature, fix, performance, and breaking change commit formats.

### Changed

* Updated the marketplace metadata and bundled plugin to version 2.0.0.
* Refreshed the README and contributing guidance to reflect the bundle first distribution model and the updated repository layout.
* Revised the site skill listing to include the new `changelog-generation` skill.