# Release Notes

## 2.0.0

This major release introduces changelog generation guidance and shifts distribution from individual or archive based delivery to the full marketplace bundle.

### Breaking Changes

* Shifted marketplace installation to the full `britt/claude-code-skills` bundle, so teams no longer install skills one by one with `/plugin install britt/<skill-name>`.
* Retired zip archive downloads and removed `package.sh`, so teams now use the marketplace bundle and Claude.ai projects upload cloned skill directories instead of release archives.

### Added

* Expanded release guidance with the `changelog-generation` skill, so teams can turn conventional commit history into structured changelogs and release notes with breaking changes called out clearly.

### Changed

* Updated `README.md` so installation guidance points to the full bundle and Claude.ai guidance points to uploaded skill directories instead of archives.
* Refreshed `CONTRIBUTING.md` so contributors can follow the current repository layout, including docs examples, rules, site content, plugin metadata, and the expanded skill set.
* Revised `site/content/_index.md` so the published guidance reflects the current skills list and installation model.
* Adjusted packaging cleanup during the transition with a temporary `./package.sh --clean` option that cleared stale archive output before rebuilding.
* Clarified the 2.0.0 release scope in pull request #34 around full bundle distribution, archive removal, changelog guidance, release note updates, and supporting documentation changes.
* Added the first 2.0.0 release notes draft to introduce the version bump, the move away from individual installs, and the broader documentation refresh.
* Expanded the next 2.0.0 release notes draft to call out zip archive and `package.sh` removal as a breaking change and to add the changelog generation skill.
* Withdrew an intermediate `RELEASE_NOTES.md` draft during a rewrite pass so the 2.0.0 notes could be reworked before restoration.
* Reintroduced a broader `RELEASE_NOTES.md` draft to cover bundle installation, archive removal, changelog generation, documentation changes, and packaging behavior changes.
* Cleared another revised `RELEASE_NOTES.md` draft during a later iteration while the 2.0.0 wording was refined.
* Restored a fuller `RELEASE_NOTES.md` draft to document the two distribution changes, the changelog generation addition, documentation updates, and packaging cleanup and safety improvements.
* Deleted a further intermediate `RELEASE_NOTES.md` draft during repeated refinement of the 2.0.0 messaging.
* Finalized the last 2.0.0 `RELEASE_NOTES.md` draft to summarize marketplace only distribution, archive removal, the new changelog generation skill, documentation refreshes, and packaging reliability improvements.

### Fixed

* Hardened `package.sh` checks, so archive builds stopped on shell errors and failed clearly when no skill directories were present instead of finishing with broken output.