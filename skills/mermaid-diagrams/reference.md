# Mermaid Diagram Type Reference

Additional per-type examples for the `mermaid-diagrams` skill. All rules from SKILL.md apply: never use parentheses inside labels, and always match brackets.

## Class Diagram
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

## State Diagram
```mermaid
stateDiagram-v2
    [*] --> Draft
    Draft --> Review: submit
    Review --> Published: approve
    Review --> Draft: reject
    Published --> [*]
```

## Entity Relationship Diagram
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

## API Flow (Sequence)
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
