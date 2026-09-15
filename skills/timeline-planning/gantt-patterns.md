# Gantt Timeline Patterns

Reusable Mermaid Gantt patterns for the timeline-planning skill.

## Linear Project

```mermaid
gantt
    title API Development
    dateFormat YYYY-MM-DD

    section Setup
    Project initialization    :a, 2025-01-15, 1d
    Database setup           :b, after a, 2d

    section Development
    User endpoints           :c, after b, 3d
    Auth endpoints           :d, after c, 3d

    section Testing
    Unit tests               :e, after d, 2d
    Integration tests        :f, after e, 2d
```

## Parallel Workstreams

```mermaid
gantt
    title Full Stack Development
    dateFormat YYYY-MM-DD

    section Backend
    API Design              :a, 2025-01-15, 2d
    API Implementation      :b, after a, 5d

    section Frontend
    UI Design               :c, 2025-01-15, 3d
    UI Implementation       :d, after c, 5d

    section Integration
    Connect Frontend-Backend :e, after b d, 3d
    End-to-end tests        :f, after e, 2d
```

## With Milestones

```mermaid
gantt
    title Release Timeline
    dateFormat YYYY-MM-DD

    section Phase 1
    Core features           :a, 2025-01-15, 10d
    Alpha Release           :milestone, m1, after a, 0d

    section Phase 2
    Additional features     :b, after m1, 7d
    Beta Release            :milestone, m2, after b, 0d

    section Phase 3
    Polish and fixes        :c, after m2, 5d
    Production Release      :milestone, m3, after c, 0d
```

## With Critical Path

```mermaid
gantt
    title Project with Critical Path
    dateFormat YYYY-MM-DD

    section Critical Path
    Database design         :crit, a, 2025-01-15, 2d
    Core API                :crit, b, after a, 5d
    Integration             :crit, c, after b, 3d

    section Parallel Work
    Documentation           :d, 2025-01-15, 10d
    UI polish               :e, after a, 5d
```

## From Real GitHub Issues

Task names carry the issue number, ids are `i<number>`, and every colon from the original issue
title has been replaced with ` -` so the label survives rendering. The tracking/epic parent issue
is a `section` heading and the closing milestone — not a bar of its own.

```mermaid
gantt
    title Skill library review - epic 44
    dateFormat YYYY-MM-DD
    axisFormat %b %d
    excludes weekends

    section Skill updates
    #45 skill - consolidate-notes-summary deprecate :i45, 2026-09-15, 3d
    #46 skill - daily-planning-ritual update        :i46, 2026-09-15, 3d
    #47 skill - prepare-meeting-agenda update       :i47, 2026-09-15, 3d
    #48 skill - project-planning update             :i48, 2026-09-15, 3d
    #49 skill - timeline-planning update            :i49, 2026-09-15, 3d

    section Milestone
    Library review complete :milestone, m1, after i45 i46 i47 i48 i49, 0d
```

All five issues are unestimated, so each bar is the 3d Medium default — flag that when presenting
a chart like this one.
