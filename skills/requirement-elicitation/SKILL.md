---
name: requirement-elicitation
description: Use when gathering project requirements, or when a user says 'help me define requirements' or 'figure out what to build' - adaptive wizard covering functional, nonfunctional, constraints, and edge cases with domain-specific questions for web apps, APIs, CLIs, mobile, and data pipelines
---

# Requirement Elicitation Wizard

You are guiding the user through a comprehensive requirement elicitation process. Your goal is to capture all functional, nonfunctional, and edge-case requirements before they start building.

## How This Works

1. **Start**: User says something like "Let's define requirements" or "Help me figure out what to build"
2. **Domain Selection**: Ask what type of project they're building
3. **Guided Questions**: Walk through each section, asking questions one at a time
4. **Adaptive Flow**: Branch based on answers (e.g., if they mention integrations, ask which ones)
5. **Refinement**: Allow revisiting any section
6. **Output**: Generate a comprehensive requirements document saved as `requirements-<project>.md` in the working directory

## Conversation Flow

### Starting the Session

When the user wants to define requirements:
1. Ask the user what type of project they're building
2. Explain what you'll cover: Overview, Functional, Nonfunctional, Constraints, Edge Cases
3. Ask the first question

### Sections to Cover

Walk through these five sections in order:

1. **Project Overview** - Name, purpose, target users, success criteria
2. **Functional Requirements** - Features, endpoints, integrations, user workflows
3. **Nonfunctional Requirements** - Performance, security, reliability, scalability
4. **Constraints** - Timeline, budget, technical requirements, team size
5. **Edge Cases & Risks** - Error handling, failure modes, boundary conditions

### Asking Questions

For each question:
1. Ask clearly and conversationally (not robotically)
2. Include context explaining why you're asking
3. Indicate if it's required or optional
4. After the user answers, mentally note the response and continue

### Section Transitions

When a section is complete:
1. Summarize what was captured: "Great, for the overview I captured: [summary]"
2. Ask if they want to add anything else to this section
3. Append the completed section to `requirements-<project>.md` in the working directory
4. Introduce the next section briefly

### User Commands

Handle these natural language requests:
- "Skip this section" - Move to next section, note it was skipped
- "Let's revisit [section]" - Re-read `requirements-<project>.md` to find the saved section, then update it
- "What have we captured?" - Summarize all captured requirements from `requirements-<project>.md`
- "Generate the document" - Compile all captured sections into the final requirements document
- "Save this" - Write current state to `requirements-<project>.md`

## Question Style

**DO:** Ask one question at a time; be conversational ("Tell me about..."); provide context ("This helps us understand scale requirements"); accept natural language answers.

**DON'T:** Dump all questions at once; be robotic or form-like; require yes/no when open answers are better; skip ahead without confirmation.

## Domain Options

When asking the user what type of project they're building, present these options:

| Domain | Description |
|--------|-------------|
| web-app | Frontend web applications |
| api | REST or GraphQL backend services |
| full-stack | Combined frontend and backend applications |
| cli | Command-line tools and terminal applications |
| mobile | iOS, Android, or cross-platform mobile apps |
| data-pipeline | ETL processes, data transformations, analytics pipelines |
| library | Reusable packages, SDKs, or libraries |
| infrastructure | DevOps, cloud infrastructure, platform tools |
| ai-ml | AI/ML applications, model training, inference services |
| general | Projects that don't fit the above categories |

## Domain-Specific Questions

### Web App / Full-Stack
- What framework/tech stack?
- What pages/views are needed?
- Authentication requirements?
- Third-party integrations?

### API
- REST or GraphQL?
- What endpoints are needed?
- Authentication method (JWT, OAuth, API key)?
- Rate limiting requirements?
- Versioning strategy?

### CLI
- What commands are needed?
- Interactive or batch mode?
- Configuration file format?
- Output formats (JSON, table, plain text)?

### Mobile
- iOS, Android, or cross-platform?
- Offline support needed?
- Push notifications?
- Device features (camera, GPS, etc.)?

### Data Pipeline
- Data sources and destinations?
- Batch or streaming?
- Volume and frequency?
- Error handling and retry strategy?

For library, infrastructure, ai-ml, full-stack (beyond the web-app questions above), and general projects, there is no dedicated question set — walk through the generic five sections, adapting questions to the domain.

## Requirements Document Format

When generating the final document, use this structure:

```markdown
# Requirements: [Project Name]

## 1. Project Overview
- **Name**: [name]
- **Purpose**: [description]
- **Target Users**: [who]
- **Success Criteria**: [how to measure success]

## 2. Functional Requirements
### [Feature Group 1]
- FR-1: [requirement]
- FR-2: [requirement]

## 3. Nonfunctional Requirements
- NFR-1: [performance/security/reliability requirement]

## 4. Constraints
- CON-1: [constraint]

## 5. Edge Cases & Risks
- RISK-1: [risk and mitigation]

## 6. Open Questions
- [any unresolved items]
```

## Persistence

Append each completed section to `requirements-<project>.md` in the working directory so nothing is lost if the session ends. To revisit or summarize earlier work, re-read that file. When finished, compile all sections into the final document in the same file and confirm with the user:
> "I've compiled your requirements document into `requirements-<project>.md`. Want to review or adjust anything?"

## After Completing Requirements

Suggest natural next steps:
- `issue-decomposition` skill (if available) to break requirements into actionable work items
- `architecture-diagramming` skill (if available) to visualize the system
