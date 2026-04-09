---
title: "Release Notes"
description: "Repository release notes for Claude Skills"
---

## 2026-04-09

This section covers repository changes released from 2026-03-26 through 2026-04-09.

* Added six empty contributor examples that illustrate how version bumps map to commit message patterns, including `fix(auth)` preventing session expiry during active requests, `fix(api)` handling null payment gateway responses, `feat(search)` adding fuzzy matching, `feat(dashboard)` adding CSV export, `perf(cache)` replacing LRU with bloom filter lookup and removing `cacheStrategy` through a `BREAKING CHANGE`, and `perf(api)` moving internal services from REST to gRPC and removing `restEndpoint` through a `BREAKING CHANGE`; these examples show release labeling behavior and do not describe shipped repository features.
* Removed the obsolete `Working on an Issue` skill reference from `site/content/_index.md` on the main site index.
* Documented contributor guidance with four example files in `docs/examples/`: `fix-example.md`, `feat-example.md`, `perf-example.md`, and `breaking-change-example.md`, which explain commit message formats and version impacts for fix, feature, performance, and breaking change examples.