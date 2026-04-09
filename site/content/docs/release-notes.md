---
title: "Release Notes"
description: "Repository release notes for Claude Skills"
---

## 2026-04-09

This section covers repository changes released from 2026-03-26 through 2026-04-09.

* Added six empty contributor examples that illustrate how version bumps map to commit message patterns, including `fix(auth)` preventing session expiry during active requests, `fix(api)` handling null payment gateway responses, `feat(search)` adding fuzzy matching, `feat(dashboard)` adding CSV export, `perf(cache)` replacing LRU with bloom filter lookup, and `perf(api)` moving internal services from REST to gRPC; **BREAKING CHANGE:** the `perf(cache)` example removes `cacheStrategy`, and **BREAKING CHANGE:** the `perf(api)` example removes `restEndpoint`, making both examples explicit major version demonstrations within this contributor facing set rather than shipped repository features.
* Removed the obsolete `Working on an Issue` skill reference from `site/content/_index.md` on the main site index.
* Documented contributor guidance with four example files in `docs/examples/`: `fix-example.md`, `feat-example.md`, `perf-example.md`, and `breaking-change-example.md`, which explain commit message formats and version impacts for fix, feature, performance, and breaking change examples, including a breaking change example that demonstrates a major version bump in plain terms from `1.0.0` to `2.0.0`.