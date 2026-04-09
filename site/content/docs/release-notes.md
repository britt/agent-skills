---
title: "Release Notes"
description: "Repository release notes for Claude Skills"
---

## 2026-04-09

This section covers repository changes released from 2026-03-26 through 2026-04-09.

* Added six empty semantic release demonstration commits that show how patch, minor, and major version bumps work through conventional commit examples such as `fix(auth)` preventing session expiry during active requests, `fix(api)` handling null payment gateway responses, `feat(search)` adding fuzzy matching, `feat(dashboard)` adding CSV export, `perf(cache)` replacing LRU with bloom filter lookup and removing `cacheStrategy` through a `BREAKING CHANGE`, and `perf(api)` moving internal services from REST to gRPC and removing `restEndpoint` through a `BREAKING CHANGE`; these examples document semantic release behavior for contributors and do not describe shipped repository features.
* Removed the obsolete `Working on an Issue` skill reference from `site/content/_index.md` on the main site index.
* Documented semantic release commit formats and version impacts with four example files in `docs/examples/`: `fix-example.md`, `feat-example.md`, `perf-example.md`, and `breaking-change-example.md`.