---
title: "Release Notes"
description: "Release notes for Claude Code Skills releases"
draft: false
---

This page contains release notes for Claude Code Skills releases.

## v2.0.0

* Added a new `changelog-generation` skill that helps generate changelog or release note drafts from git history by using conventional commit conventions.
* Refined the contributor guide so the repository structure now matches the current layout, including the Hugo site, rules, examples, and the expanded skills collection.
* Removed individual skill installs through `/plugin install britt/<skill-name>` as a breaking change, and now requires installation of the bundled plugin with `/plugin install britt/claude-code-skills` instead.
* Shifted Claude.ai distribution away from release zip files as a breaking change, so it now requires cloning the repository and uploading individual skill directories as project knowledge instead of downloading zip archives.