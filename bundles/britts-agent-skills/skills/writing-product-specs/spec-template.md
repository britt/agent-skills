# Product Spec Format

Below is the format for a product spec. Each section includes guidance on what to write.

# [Project / Feature Title]

Provide a brief (1-2 sentences max) description of what we are building. This is the tl;dr that should explain the entire project and its benefits in a few sentences. A reader should understand the core value proposition from this title and description alone. Include:
- Clear, descriptive title that captures the feature/project
- One to two sentences summarizing what is being built
- The primary benefit or value this delivers

## Background

### Context

Describe the world the problem exists in and the problem in broad strokes. Set the stage for why this work matters. Include:
- Current state of the world/workflow/system
- Why this problem exists or has become relevant now
- Any relevant trends, constraints, or external factors
- The gap between current state and desired state

### Audience

Identify who we are solving this problem for. Be specific about user personas, roles, or user types (e.g., end user, administrator, developer integrating with the product, internal operations staff). If there are multiple audiences, list them and explain how each benefits. Include:
- Primary user personas or roles affected
- Secondary audiences if applicable
- How each audience will benefit from the solution
- Any specific user characteristics or needs that matter

### Problem Statements

List the specific problems we are solving. Use bullet format, one problem per bullet. Be succinct and direct—the background context has already been established. Include:
- Each problem as a separate bullet point
- Specific, concrete problems (avoid vague statements)
- Problems that are directly addressable by the solution
- Focus on user pain points or business needs

## Hypothesis

Explain why we believe solving these problems will help customers achieve their goals. This is the "why" behind the "what"—the reasoning that connects the problems to the proposed solution. Include:
- The expected outcome if problems are solved
- The logical connection between problems and solution
- Why this approach will be effective
- Any assumptions being made

## Success Criteria

Define how we will know that the problem is solved. These should be measurable, testable, or observable indicators of success. Include:
- Specific, measurable metrics (e.g., adoption rates, performance improvements, user satisfaction scores)
- QA/validation steps or acceptance criteria
- Observable behaviors or outcomes that indicate success
- Timeframes or thresholds for success (if relevant)

## Requirements

List what is necessary for us to build in order to solve this problem. Each requirement should be clear enough that an engineer can understand what needs to be built. Include:
- Functional requirements (what the system/feature must do)
- Technical requirements (performance, scalability, compatibility needs)
- User experience requirements (if applicable)
- Integration or dependency requirements
- Prioritization (must-have vs. nice-to-have) if relevant

## Non-requirements

Explicitly state what we are not doing, what is out of scope, and what we don't have to do. This prevents scope creep and sets clear boundaries. Include:
- Features or capabilities explicitly out of scope
- Related problems we are not solving
- Future work that might seem related but isn't part of this spec
- Assumptions about what we don't need to build

## Tradeoffs and concerns

When you write this section just include the placeholder below in italics.

    Especially from engineering, what hard decisions will we have to make in order to implement this solution? What future problems might we have to solve because we chose to implement this?
