# Release Notes

## 2.0.0

This major release introduces changelog generation guidance and shifts distribution from individual or archive based delivery to the full marketplace bundle.

### Breaking Changes

* Removed individual marketplace entries, so `/plugin install britt/<skill-name>` no longer works and installation now uses the full `britt/claude-code-skills` bundle.
* Replaced zip archive downloads and removed `package.sh`, so installation now uses the marketplace bundle and Claude.ai projects now upload cloned skill directories instead of release archives.

### Added

* Introduced the `changelog-generation` skill, so teams can turn conventional commit history into structured changelogs and release notes with breaking changes called out clearly.

### Changed

* Updated `README.md` to explain the full bundle installation path and to replace archive based Claude.ai guidance with uploaded skill directories.
* Refreshed `CONTRIBUTING.md` so contributors can follow the current repository layout, including docs examples, rules, site content, plugin metadata, and the expanded skill set.
* Revised `site/content/_index.md` so the published guidance reflects the current skills list and installation model.
* Adjusted archive cleanup behavior during the packaging transition with a temporary `./package.sh --clean` option that removed stale build output before rebuilding.
* Clarified the 2.0.0 release scope in pull request #34 around full bundle distribution, archive removal, changelog guidance, release note updates, and supporting documentation changes.
* Added the first 2.0.0 release notes draft that outlined the version bump, the move away from individual installs, and the broader documentation refresh.
* Expanded the 2.0.0 release notes draft to call out zip archive and `package.sh` removal as a breaking change and to add the changelog generation skill.
* Removed an intermediate `RELEASE_NOTES.md` draft during a rewrite pass so the 2.0.0 notes could be reworked before restoration.
* Reintroduced a broader `RELEASE_NOTES.md` draft that covered bundle installation, archive removal, changelog generation, documentation changes, and packaging behavior changes.
* Removed another revised `RELEASE_NOTES.md` draft during a later iteration while the 2.0.0 wording was refined.
* Restored a fuller `RELEASE_NOTES.md` draft that documented the two distribution changes, the changelog generation addition, documentation updates, and packaging related cleanup and safety improvements.
* Deleted a further intermediate `RELEASE_NOTES.md` draft during repeated refinement of the 2.0.0 messaging.
* Added the final 2.0.0 `RELEASE_NOTES.md` draft that summarized marketplace only distribution, archive removal, the new changelog generation skill, documentation refreshes, and packaging reliability improvements.

### Fixed

* Strengthened `package.sh` safety checks, so archive builds stopped on shell errors and failed clearly when no skill directories were present instead of finishing with broken output.