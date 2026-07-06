---
name: architecture-diagramming
description: "Use when the user asks for an architecture diagram, says 'show me the system architecture' or 'diagram the components', or during project planning - generates GitHub-compatible Mermaid flowcharts showing components, layers, subgraph boundaries, and data flows"
---

# Architecture Diagramming Skill

Generate clear, GitHub-compatible Mermaid architecture diagrams that visualize system components, layers, boundaries, and data flows.

## When to Use

Activate this skill when:
- User asks for an architecture diagram
- User says "show me the system architecture", "diagram the components"
- During project planning to visualize the system design
- When explaining how components interact

**When NOT to use:** not for issue/task dependencies (use `dependency-mapping`) or API call sequences and process flows (use `mermaid-diagrams` sequence diagrams).

## Syntax Rules

Follow the `mermaid-diagrams` skill for syntax rules — in particular, never use parentheses inside node labels (they break GitHub rendering); use dashes or 'and' instead.

## Diagram Patterns

### System Overview

Show major components and their relationships:

```mermaid
flowchart TB
    subgraph Client Layer
        Web[Web App]
        Mobile[Mobile App]
    end

    subgraph API Layer
        Gateway[API Gateway]
        Auth[Auth Service]
    end

    subgraph Data Layer
        DB[(Database)]
        Cache[(Redis Cache)]
    end

    Web --> Gateway
    Mobile --> Gateway
    Gateway --> Auth
    Gateway --> DB
    Auth --> Cache
```

### Layered Architecture

Show horizontal layers with clear boundaries:

```mermaid
flowchart TB
    subgraph Presentation
        UI[User Interface]
        API[REST API]
    end

    subgraph Business
        Services[Business Services]
        Rules[Business Rules]
    end

    subgraph Data
        Repos[Repositories]
        Entities[Domain Entities]
    end

    UI --> Services
    API --> Services
    Services --> Rules
    Services --> Repos
    Repos --> Entities
```

### Request Flow

Show how a request flows through the system:

```mermaid
flowchart LR
    Client[Client] --> LB[Load Balancer]
    LB --> API1[API Server 1]
    LB --> API2[API Server 2]
    API1 --> Queue[(Message Queue)]
    API2 --> Queue
    Queue --> Worker[Background Worker]
    Worker --> DB[(Database)]
```

## Architecture Analysis Process

### Step 1: Identify Components
- What are the major modules or services?
- What external systems are involved?
- What data stores are used?

### Step 2: Determine Layers
Common layers to consider:
- **Presentation**: UI, API endpoints
- **Business**: Core logic, workflows
- **Data**: Repositories, entities
- **Infrastructure**: External services, queues

### Step 3: Map Relationships
- Request/response flows
- Data dependencies
- Event/message flows
- Shared resources

### Step 4: Apply Boundaries
Use subgraphs to show:
- Team ownership
- Deployment units
- Security boundaries
- Scalability zones

### Step 5: Generate Diagram
Create a clean Mermaid diagram that:
- Fits on one screen when possible
- Uses consistent naming
- Shows data flow direction
- Groups related components

## Node Naming Conventions

Use clear, abbreviated names:
- `API` not `ApplicationProgrammingInterface`
- `Auth` not `AuthenticationService`
- `DB` or use `[(Name)]` for databases
- `Queue` or `MQ` for message queues

## Arrow Semantics

| Arrow | Meaning |
|-------|---------|
| `-->` | Standard request/response |
| `-.->` | Async or optional |
| `==>` | Critical path |
| `--text-->` | Labeled relationship |

## Subgraph Styling

```mermaid
flowchart TB
    subgraph External[External Systems]
        PaymentAPI[Payment Gateway]
        EmailAPI[Email Service]
    end

    subgraph Internal[Internal Services]
        App[Application]
    end

    App --> PaymentAPI
    App --> EmailAPI
```

## Best Practices

1. **Keep it simple** - 5-15 components max per diagram
2. **Use subgraphs** - Group related components
3. **Show data flow** - Arrows indicate direction
4. **Label relationships** - When meaning isn't obvious
5. **Avoid clutter** - Break complex systems into multiple diagrams
6. **Be consistent** - Same naming conventions throughout

## After Generating Diagram

- Offer to save the diagram to an appropriate location in the project
- Suggest adding to a planning or design document
- Ask if user wants more detail in any area
- Recommend `dependency-mapping` for issue visualization
