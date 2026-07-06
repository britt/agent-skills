---
name: mermaid-diagrams
description: "Use when creating any Mermaid diagram (flowchart, sequence, class, state, ER, Gantt) in markdown, or when a diagram fails to render on GitHub - covers the syntax rules that break GitHub rendering (parentheses in labels, mismatched brackets) plus per-type examples"
---

# Mermaid Diagrams Skill

Use Mermaid syntax to create clear, maintainable diagrams directly in markdown. Mermaid diagrams are rendered by GitHub, GitLab, and many documentation tools.

## When to Use Mermaid

- **Flowcharts**: Process flows, decision trees, algorithms
- **Sequence Diagrams**: API calls, user interactions, system communication
- **Class Diagrams**: Object relationships, database schemas
- **State Diagrams**: State machines, workflow states
- **Entity Relationship Diagrams**: Database design
- **Gantt Charts**: Project timelines, task scheduling
- **Git Graphs**: Branch strategies, release flows

## IMPORTANT INSTRUCTIONS

### 1. NEVER use parentheses inside a label

**Using parentheses inside a label causes syntax errors when rendering on GitHub.**

**NEVER DO THIS:**
```mermaid
flowchart TD
  Start[Start agent loop (beginning)]
  Criteria[Define completion criteria checklist 3-5]
  ShowCriteria[Show criteria to user for approval]
  CriteriaOK{User approved (causes errors)}
```

**ALWAYS DO THIS INSTEAD:**
```mermaid
flowchart TD
  Start[Start agent loop - beginning]
  Criteria[Define completion criteria checklist 3-5]
  ShowCriteria[Show criteria to user for approval]
  CriteriaOK{User approved}
```

### 2. ALWAYS ensure that labels are wrapped in matching brackets

**Labels must have matching opening and closing brackets based on their shape.**

**CORRECT - Matching brackets:**
```mermaid
flowchart TD
  Start[Start agent loop]
  Criteria[Define completion criteria checklist 3-5]
  ShowCriteria[Show criteria to user for approval]
  CriteriaOK{User approved}
```

**INCORRECT - Mismatched brackets:**
```mermaid
flowchart TD
  Start[Start agent loop]
  Criteria[Define completion criteria checklist 3-5]
  ShowCriteria[Show criteria to user for approval]
  CriteriaOK{User approved]
```
Notice that the brackets do not match on the label for CriteriaOK (`{` opens but `]` closes).

## Basic Syntax Examples

### Flowchart
```mermaid
flowchart TD
    A[Start] --> B{Decision}
    B -->|Yes| C[Action 1]
    B -->|No| D[Action 2]
    C --> E[End]
    D --> E
```

### Sequence Diagram
```mermaid
sequenceDiagram
    participant Client
    participant API
    participant Database

    Client->>API: Request data
    API->>Database: Query
    Database-->>API: Results
    API-->>Client: Response
```

Class, state, and entity relationship diagram examples: see [reference.md](reference.md).

For system architecture diagrams (components, layers, data flows), use the `architecture-diagramming` skill.

## Best Practices

1. **Keep it Simple**: Start with basic shapes and relationships
2. **Use Descriptive Labels**: Make node names clear and meaningful
3. **Limit Complexity**: Break complex diagrams into multiple smaller ones
4. **Add Context**: Include a brief description above the diagram
5. **Test Rendering**: Verify diagrams render correctly in your target environment

## Common Patterns

### Decision Flow
```mermaid
flowchart TD
    Start[Receive Request] --> Auth{Authenticated?}
    Auth -->|No| Reject[Return 401]
    Auth -->|Yes| Valid{Valid Input?}
    Valid -->|No| BadReq[Return 400]
    Valid -->|Yes| Process[Process Request]
    Process --> Success[Return 200]
```

## Syntax Reference

### Node Shapes
- `[Rectangle]` - Basic box
- `(Rounded)` - Rounded edges
- `{Diamond}` - Decision point
- `([Stadium])` - Pill shape
- `[[Subroutine]]` - Double border
- `[(Database)]` - Cylinder
- `((Circle))` - Circle

### Arrow Types
- `-->` - Solid arrow
- `-.->` - Dotted arrow
- `==>` - Thick arrow
- `--text-->` - Labeled arrow
- `---` - Line (no arrow)

### Styling
```mermaid
flowchart TD
    A[Normal]
    B[Highlighted]

    style B fill:#f96,stroke:#333,stroke-width:4px
```

## Resources

- [Mermaid Official Docs](https://mermaid.js.org/)
- [Live Editor](https://mermaid.live/)
- GitHub/GitLab automatically render Mermaid in markdown
