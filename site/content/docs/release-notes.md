---
title: "Release Notes"
description: "Release notes for Claude Code Skills releases"
draft: false
---

This page contains release notes for Claude Code Skills releases.

## v2.0.0

* Added a new `changelog-generation` skill that helps draft changelogs and release notes from git history by organizing changes with conventional commit rules.
* Refined the contributor guide so the repository structure now matches the current layout, including the Hugo site, rules, examples, and the expanded skills structure.
* Removed individual skill installs through `/plugin install britt/<skill-name>` in a breaking change, and now requires the bundled plugin install command `/plugin install britt/claude-code-skills`.
* Shifted Claude.ai distribution away from release zip files in a breaking change, so it now requires cloning the repository and uploading individual skill directories as project knowledge instead of downloading zip archives.