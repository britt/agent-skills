---
name: architecture-diagramming
description: "Generate Mermaid architecture diagrams showing system components, layers, and data flows"
instructions: "When visualizing system architecture, component relationships, layers, or data flows as diagrams"
allowed-tools: "read_project_file get_project_scan add_note list_project_directory"
---

# Architecture Diagramming Skill

Generate clear, GitHub-compatible Mermaid architecture diagrams that visualize system components, layers, boundaries, and data flows.

## When to Use

Activate this skill when:
- User asks for an architecture diagram
- User says "show me the system architecture", "diagram the components"
- During project planning to visualize the system design
- When explaining how components interact

## Available Tools

| Tool | Purpose |
|------|---------|
| `read_project_file` | Read existing code to understand structure |
| `get_project_scan` | Get cached project scan with structure and language data |
| `add_note` | Save diagram to project notes |
| `list_project_directory` | Explore project structure |

## CRITICAL: Mermaid Syntax Rules

### NEVER use parentheses inside labels

Parentheses in Mermaid labels cause rendering errors on GitHub.

**WRONG - Will break:**
```mermaid
flowchart TD
    A[Component (main)]
    B[Service (auth)]
```

**CORRECT - Use dashes or commas:**
```mermaid
flowchart TD
    A[Component - main]
    B[Service - auth]
```

### ALWAYS ensure matching brackets

Each node shape uses specific brackets that must match:
- `[Rectangle]` - Standard component
- `{Diamond}` - Decision point
- `([Stadium])` - Pill shape
- `[(Database)]` - Cylinder for data stores
- `((Circle))` - Circle node

**WRONG:**
```mermaid
flowchart TD
    A{Decision]
```

**CORRECT:**
```mermaid
flowchart TD
    A{Decision}
```

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

### Microservices

Show service boundaries and communication:

```mermaid
flowchart TB
    subgraph Public
        Gateway[API Gateway]
    end

    subgraph Services
        UserSvc[User Service]
        OrderSvc[Order Service]
        PaymentSvc[Payment Service]
    end

    subgraph Infrastructure
        MQ[(Message Queue)]
        Cache[(Shared Cache)]
    end

    Gateway --> UserSvc
    Gateway --> OrderSvc
    OrderSvc --> PaymentSvc
    OrderSvc --> MQ
    PaymentSvc --> MQ
    UserSvc --> Cache
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

## Arrow Types

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

## Example Output

Given a description of a "REST API with authentication and database":

```mermaid
flowchart TB
    subgraph Client Layer
        Web[Web Client]
        Mobile[Mobile Client]
    end

    subgraph API Layer
        Gateway[API Gateway]
        AuthSvc[Auth Service]
        CoreAPI[Core API]
    end

    subgraph Data Layer
        DB[(PostgreSQL)]
        Cache[(Redis)]
        Sessions[(Session Store)]
    end

    Web --> Gateway
    Mobile --> Gateway
    Gateway --> AuthSvc
    Gateway --> CoreAPI
    AuthSvc --> Sessions
    AuthSvc --> Cache
    CoreAPI --> DB
    CoreAPI --> Cache
```

## After Generating Diagram

- Offer to save the diagram to project notes
- Suggest adding to planning document
- Ask if user wants more detail in any area
- Recommend `dependency-mapping` for issue visualization
