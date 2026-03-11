---
name: dependency-mapping
description: "Generate Mermaid dependency graphs showing issue relationships, blocking chains, and critical paths"
instructions: "When mapping issue dependencies, visualizing blocking chains, or identifying the critical path through project work"
allowed-tools: "list_github_issues get_github_issue_with_comments add_note search_github_issues"
---

# Dependency Mapping Skill

Generate Mermaid flowcharts that visualize GitHub issue dependencies, blocking relationships, and critical paths through the project.

## When to Use

Activate this skill when:
- User asks "show me the dependencies", "map the issue dependencies"
- User wants to see which issues block others
- During sprint planning to identify critical path
- After issue decomposition to visualize relationships

## Available Tools

| Tool | Purpose |
|------|---------|
| `list_github_issues` | Get all open issues with labels and state |
| `get_github_issue_with_comments` | Get full issue details with body text |
| `search_github_issues` | Find specific issues by criteria |
| `add_note` | Save dependency graph to project notes |

## CRITICAL: Mermaid Syntax Rules

### NEVER use parentheses in node labels

Parentheses break GitHub rendering.

**WRONG:**
```mermaid
flowchart LR
    I1[#1 Setup (init)]
```

**CORRECT:**
```mermaid
flowchart LR
    I1[#1 Setup - init]
```

### Issue Node Naming Convention

Use consistent naming for issue nodes:

```mermaid
flowchart LR
    I201[#201 Setup auth module]
    I202[#202 Implement login]
    I203[#203 Add password reset]
```

Format: `I<number>[#<number> <short title>]`

## Dependency Graph Patterns

### Linear Dependencies

Issues that must be done in sequence:

```mermaid
flowchart LR
    I1[#1 Setup project] --> I2[#2 Create database]
    I2 --> I3[#3 Add API endpoints]
    I3 --> I4[#4 Integration tests]
```

### Parallel Work

Issues that can be done simultaneously:

```mermaid
flowchart TB
    I1[#1 Setup project]
    I1 --> I2[#2 Frontend setup]
    I1 --> I3[#3 Backend setup]
    I2 --> I4[#4 Integration]
    I3 --> I4
```

### Complex Dependencies

Multiple blocking relationships:

```mermaid
flowchart TB
    subgraph Foundation
        I1[#1 Project setup]
        I2[#2 Database schema]
    end

    subgraph Features
        I3[#3 User auth]
        I4[#4 User profile]
        I5[#5 Settings page]
    end

    subgraph Integration
        I6[#6 End-to-end tests]
    end

    I1 --> I2
    I1 --> I3
    I2 --> I3
    I3 --> I4
    I3 --> I5
    I4 --> I6
    I5 --> I6
```

### Critical Path Highlighting

Emphasize the longest dependency chain:

```mermaid
flowchart LR
    I1[#1 Setup]
    I2[#2 Database]
    I3[#3 Auth]
    I4[#4 API]
    I5[#5 Tests]

    I1 ==> I2
    I2 ==> I3
    I3 ==> I4
    I4 ==> I5

    I1 --> I6[#6 Docs]

    style I1 fill:#f96
    style I2 fill:#f96
    style I3 fill:#f96
    style I4 fill:#f96
    style I5 fill:#f96
```

## Dependency Analysis Process

### Step 1: Gather Issues

Use `list_github_issues` to get all open issues:
- Note issue numbers and titles
- Check for "blocked by" or "depends on" in labels
- Look for dependency keywords in descriptions

### Step 2: Parse Dependencies

Look for dependency indicators:
- **Labels**: `blocked`, `waiting`, `depends-on`
- **Body text**: "Blocked by #X", "Depends on #X", "After #X"
- **Comments**: Discussion about ordering

### Step 3: Build Dependency Map

Create a map of relationships:
```
#201 → blocks → #202, #203
#202 → blocks → #204
#203 → blocks → #204
```

### Step 4: Identify Critical Path

Find the longest chain of dependencies - this is the critical path that determines minimum project duration.

### Step 5: Generate Diagram

Create the Mermaid flowchart with:
- All issues as nodes
- Arrows showing "blocks" direction
- Subgraphs for phases or areas
- Styling for critical path

## Dependency Detection Keywords

Look for these patterns in issue bodies:

| Pattern | Meaning |
|---------|---------|
| "Blocked by #X" | This issue depends on #X |
| "Depends on #X" | This issue depends on #X |
| "After #X" | Do this after #X |
| "Blocks #X" | This issue must complete before #X |
| "Required for #X" | This issue must complete before #X |
| "Prerequisite: #X" | This issue depends on #X |

## Output Format

### Simple Graph

```mermaid
flowchart LR
    I1[#1 Setup] --> I2[#2 Feature A]
    I1 --> I3[#3 Feature B]
    I2 --> I4[#4 Integration]
    I3 --> I4
```

### With Phases

```mermaid
flowchart TB
    subgraph Phase 1 - Foundation
        I1[#1 Project setup]
        I2[#2 Database design]
    end

    subgraph Phase 2 - Core Features
        I3[#3 User management]
        I4[#4 Authentication]
    end

    subgraph Phase 3 - Polish
        I5[#5 Testing]
        I6[#6 Documentation]
    end

    I1 --> I2
    I2 --> I3
    I2 --> I4
    I3 --> I5
    I4 --> I5
    I5 --> I6
```

## Arrow Types

| Arrow | Use For |
|-------|---------|
| `-->` | Standard dependency |
| `==>` | Critical path |
| `-.->` | Soft dependency or optional |
| `--text-->` | Labeled relationship |

## Best Practices

1. **Left-to-right for linear** - Use `flowchart LR` for sequential work
2. **Top-to-bottom for complex** - Use `flowchart TB` for many branches
3. **Group by phase** - Use subgraphs for project phases
4. **Highlight critical path** - Use thick arrows and colors
5. **Keep titles short** - Truncate to fit in diagram
6. **Link to issues** - Include issue numbers for reference

## Example Output

For a set of issues about building an API:

```mermaid
flowchart TB
    subgraph Setup
        I1[#101 Initialize project]
        I2[#102 Configure database]
    end

    subgraph Core API
        I3[#103 User endpoints]
        I4[#104 Auth endpoints]
        I5[#105 Data endpoints]
    end

    subgraph Testing
        I6[#106 Unit tests]
        I7[#107 Integration tests]
    end

    I1 --> I2
    I2 --> I3
    I2 --> I4
    I2 --> I5
    I3 --> I6
    I4 --> I6
    I5 --> I6
    I6 --> I7

    %% Critical path
    linkStyle 0,1,3,5,7 stroke:#f00,stroke-width:2px
```

## After Generating Graph

- Offer to save the graph to project notes
- Identify the critical path length
- Flag any circular dependencies as errors
- Suggest `timeline-planning` skill for Gantt chart
- Recommend addressing blockers first
