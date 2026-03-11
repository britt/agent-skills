---
name: mermaid-diagrams
description: "Guide for creating syntactically correct Mermaid diagrams that render properly on GitHub"
instructions: "When creating flowcharts, sequence diagrams, class diagrams, or any visual diagrams in markdown"
tags:
  - diagram
  - visualization
  - mermaid
  - flowchart
  - sequence
  - architecture
  - github
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

### Class Diagram
```mermaid
classDiagram
    class User {
        +String name
        +String email
        +login()
        +logout()
    }

    class Post {
        +String title
        +String content
        +publish()
    }

    User "1" --> "*" Post : creates
```

### State Diagram
```mermaid
stateDiagram-v2
    [*] --> Draft
    Draft --> Review: submit
    Review --> Published: approve
    Review --> Draft: reject
    Published --> [*]
```

### Entity Relationship Diagram
```mermaid
erDiagram
    USER ||--o{ POST : creates
    USER {
        int id PK
        string name
        string email
    }
    POST {
        int id PK
        int user_id FK
        string title
        text content
    }
```

## Best Practices

1. **Keep it Simple**: Start with basic shapes and relationships
2. **Use Descriptive Labels**: Make node names clear and meaningful
3. **Limit Complexity**: Break complex diagrams into multiple smaller ones
4. **Add Context**: Include a brief description above the diagram
5. **Test Rendering**: Verify diagrams render correctly in your target environment

## Common Patterns

### API Flow
```mermaid
sequenceDiagram
    participant U as User
    participant F as Frontend
    participant A as API
    participant D as Database

    U->>F: Click button
    F->>A: POST /api/resource
    A->>D: INSERT data
    D-->>A: Success
    A-->>F: 201 Created
    F-->>U: Show confirmation
```

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

### System Architecture
```mermaid
flowchart LR
    Client[Client App]
    LB[Load Balancer]
    API1[API Server 1]
    API2[API Server 2]
    Cache[(Redis Cache)]
    DB[(Database)]

    Client --> LB
    LB --> API1
    LB --> API2
    API1 --> Cache
    API2 --> Cache
    API1 --> DB
    API2 --> DB
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

## Tips for Documentation

1. **Inline Diagrams**: Embed directly in documentation for context
2. **Version Control**: Mermaid is text, so it diffs well in git
3. **Collaboration**: Team members can edit without special tools
4. **Automation**: Generate diagrams from code or data
5. **Accessibility**: Add alt text descriptions for screen readers

## Resources

- [Mermaid Official Docs](https://mermaid.js.org/)
- [Live Editor](https://mermaid.live/)
- GitHub/GitLab automatically render Mermaid in markdown

## Tool Usage

When asked to create diagrams:
1. Choose the appropriate Mermaid diagram type
2. **NEVER use parentheses inside labels** - use dashes or commas instead
3. **ALWAYS ensure brackets match** - `[...]`, `{...}`, `(...)`, etc.
4. Use clear, descriptive labels
5. Keep complexity manageable
6. Add a brief description above the diagram
7. Verify syntax is correct (no trailing commas, proper formatting)
