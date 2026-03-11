---
name: timeline-planning
description: "Generate Mermaid Gantt charts for project timelines with phases, dependencies, and milestones"
instructions: "When creating a project timeline, generating a Gantt chart, or planning phases and milestones for scheduled work"
allowed-tools: "list_github_issues add_note search_github_issues"
---

# Timeline Planning Skill

Generate Mermaid Gantt charts that visualize project timelines, task scheduling, phases, and milestones based on GitHub issues and their estimates.

## When to Use

Activate this skill when:
- User asks "what would the timeline look like?"
- User says "create a Gantt chart", "show me the project schedule"
- After issue decomposition to visualize scheduling
- During sprint planning to allocate work

## Available Tools

| Tool | Purpose |
|------|---------|
| `list_github_issues` | Get issues with estimates and dependencies |
| `add_note` | Save timeline to project notes |
| `search_github_issues` | Find specific issues for timeline |

## Mermaid Gantt Syntax

### Basic Structure

```mermaid
gantt
    title Project Timeline
    dateFormat YYYY-MM-DD

    section Phase 1
    Task A :a, 2025-01-15, 2d
    Task B :b, after a, 3d

    section Phase 2
    Task C :c, after b, 2d
```

### Key Elements

- `title` - Chart title
- `dateFormat` - How dates are parsed
- `section` - Groups related tasks
- Task format: `Name :id, start, duration`

## Estimate to Duration Conversion

Convert T-shirt size estimates to days:

| Estimate | Duration | Notes |
|----------|----------|-------|
| Small | 1d | Single-day task |
| Medium | 3d | Few days of work |
| Large | 5d | Almost a week |
| XL | 8d | Full week+ |

Adjust based on:
- Team velocity
- Complexity indicators
- Buffer for unknowns

## Task States

| Modifier | Meaning | Example |
|----------|---------|---------|
| `done` | Completed | `Task A :done, a, 2025-01-15, 2d` |
| `active` | In progress | `Task B :active, b, after a, 3d` |
| `crit` | Critical path | `Task C :crit, c, after b, 5d` |
| `milestone` | Milestone | `MVP :milestone, m, after c, 0d` |

## Timeline Patterns

### Linear Project

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

### Parallel Workstreams

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

### With Milestones

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

### With Critical Path

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

## Timeline Generation Process

### Step 1: Gather Issues

Use `list_github_issues` to get:
- Issue titles
- Estimates or labels indicating size
- Dependencies or blocking relationships

### Step 2: Determine Start Date

- Use today's date as default start
- Or ask user for preferred start date
- Consider sprint boundaries

### Step 3: Convert Estimates

Transform issue estimates to durations:
```
#101 [Small] → 1d
#102 [Medium] → 3d
#103 [Large] → 5d
```

### Step 4: Respect Dependencies

Order tasks based on blocking:
```
#101 → start immediately
#102 blocked by #101 → after #101
#103 blocked by #102 → after #102
```

### Step 5: Group into Phases

Organize tasks into logical sections:
- Setup/Foundation
- Core Features
- Testing
- Polish

### Step 6: Generate Gantt Chart

Create the Mermaid syntax with all tasks, dependencies, and phases.

## Date Formats

| Format | Example |
|--------|---------|
| `YYYY-MM-DD` | 2025-01-15 |
| `after id` | after a |
| `Nd` | 3d - duration in days |

## Best Practices

1. **Use sections** - Group related tasks for clarity
2. **Show dependencies** - Use `after id` to chain tasks
3. **Mark milestones** - Highlight key deliverables
4. **Indicate critical path** - Use `:crit` for must-do-first tasks
5. **Keep titles short** - Fit in the chart view
6. **Add buffer** - Include slack for unknowns

## Example Output

For a set of issues about user authentication:

```mermaid
gantt
    title User Authentication System
    dateFormat YYYY-MM-DD

    section Foundation
    Setup auth module       :a, 2025-01-20, 1d
    Database schema         :b, after a, 1d

    section Core Auth
    Registration endpoint   :c, after b, 3d
    Login endpoint          :d, after b, 3d
    Password reset          :e, after c, 2d

    section Security
    JWT implementation      :f, after d, 2d
    Rate limiting           :g, after f, 1d

    section Testing
    Unit tests              :h, after e g, 2d
    Integration tests       :i, after h, 2d

    section Milestone
    Auth Complete           :milestone, m1, after i, 0d
```

## Handling Edge Cases

### No Estimates

If issues lack estimates:
- Use Medium (3d) as default
- Flag for user to review

### Circular Dependencies

If dependencies form a loop:
- Error and ask user to resolve
- Cannot generate valid timeline

### Too Many Tasks

If > 20 tasks:
- Group into summary tasks
- Suggest breaking into phases

## After Generating Timeline

- Show total project duration
- Identify the end date
- Flag if timeline exceeds any stated deadlines
- Offer to save to project notes
- Suggest adding milestones if missing
