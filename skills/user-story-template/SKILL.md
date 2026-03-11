---
name: user-story-template
description: "Guide writing well-formed user stories with acceptance criteria following best practices"
instructions: "When creating new features, writing GitHub issues for product work, or documenting user requirements"
tags:
  - user-story
  - requirements
  - agile
  - planning
allowed_tools:
  - github
  - notes
---

# User Story Template Skill

This skill helps create well-formed user stories that follow product management best practices.

## When to Use

Activate this skill when:
- Creating new features or requirements
- Writing GitHub issues for product work
- Planning sprints or releases
- Documenting user needs

## User Story Format

Every user story should follow this structure:

### Title
Clear, concise feature name (what, not how)

### User Story Statement
```
As a [type of user]
I want [an action or feature]
So that [benefit or value]
```

**Examples:**
- ✅ As a project manager, I want to view all active issues in one dashboard, so that I can quickly assess project status
- ✅ As a developer, I want to filter issues by label, so that I can focus on my assigned work
- ❌ As a user, I want a button (too vague, doesn't explain why)

### Acceptance Criteria

Clear, testable conditions that must be met. Use "Given-When-Then" format:

```
Given [initial context]
When [action occurs]
Then [expected outcome]
```

**Example:**
```
Given I am viewing the project dashboard
When I click the "Filter" button
Then I see a dropdown with all available labels
And I can select multiple labels to filter by
And the issue list updates to show only matching issues
```

### Additional Sections (Optional)

**Dependencies:**
- What must be completed first?
- What other systems/features does this rely on?

**Open Questions:**
- What needs clarification?
- What decisions need to be made?

**Technical Notes:**
- Implementation guidance (if known)
- Performance considerations
- Security concerns

**Design Assets:**
- Links to mockups, wireframes, or designs
- Screenshots or examples

## Quality Checklist

Before finalizing a user story, verify:

- [ ] **Independent** - Can be developed separately from other stories
- [ ] **Negotiable** - Details can be discussed and refined
- [ ] **Valuable** - Delivers clear value to users or business
- [ ] **Estimable** - Team can estimate effort reasonably
- [ ] **Small** - Can be completed in one sprint (typically)
- [ ] **Testable** - Success criteria are clear and verifiable

## Common Pitfalls to Avoid

### Too Technical
❌ "Add a REST endpoint at /api/v2/users with authentication"
✅ "As an admin, I want to manage user accounts via API, so that I can automate user provisioning"

### Too Vague
❌ "Make the dashboard better"
✅ "As a manager, I want to see project velocity trends, so that I can forecast delivery dates"

### Missing the "Why"
❌ "As a user, I want dark mode"
✅ "As a user, I want dark mode, so that I can reduce eye strain during evening work sessions"

### No Acceptance Criteria
Stories without clear acceptance criteria lead to:
- Scope creep
- Unclear completion
- Misaligned expectations
- Difficult QA

## Workflow Integration

When creating user stories:

1. **Search notes first** - Check if similar features have been discussed
2. **Write the story** - Follow the template above
3. **Add to project board** - Link to appropriate milestone/epic
4. **Tag appropriately** - Use labels like 'feature', 'enhancement', 'user-story'
5. **Save insights** - Record decisions and rationale in notes

## Example: Complete User Story

**Title:** Multi-Project Dashboard View

**User Story:**
As a product manager overseeing multiple projects
I want to view aggregated metrics across all my projects in one dashboard
So that I can identify bottlenecks and allocate resources effectively

**Acceptance Criteria:**

Given I manage 3 active projects
When I navigate to the "Overview" dashboard
Then I see a summary card for each project showing:
- Project name and status
- Open vs closed issues count
- Recent activity (last 7 days)
- Team members assigned

And I can click any project card to drill into details
And the dashboard loads in under 2 seconds
And data refreshes every 5 minutes automatically

**Dependencies:**
- Project metadata API must support batch queries
- User must have "manager" role on at least one project

**Open Questions:**
- Should we limit to 10 projects max, or paginate?
- Do we show archived projects by default?

**Technical Notes:**
- Consider caching strategy for performance
- Use existing project card component for consistency

**Design Assets:**
- See Figma: [link to dashboard mockup]
