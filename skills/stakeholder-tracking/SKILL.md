---
name: stakeholder-tracking
description: "Define stakeholder personas and track their goals to ensure all perspectives are addressed"
instructions: "When defining stakeholder personas, tracking stakeholder goals, or ensuring all perspectives are represented in planning"
tags:
  - stakeholders
  - goals
  - planning
  - requirements
---

# Stakeholder Tracking

## Purpose

Help users define stakeholder personas and track their goals, ensuring all perspectives are addressed throughout the project lifecycle.

## When to Use This Skill

- Starting a new project and need to identify stakeholders
- Planning features and want to ensure all perspectives are covered
- Reviewing a plan to check stakeholder coverage
- Resolving conflicts between different stakeholder needs
- Linking GitHub issues to stakeholder goals

## Stakeholder Note Format

Each stakeholder is stored as a note with YAML content. Use the title format "Stakeholder: [Name]" for easy searching.

```yaml
type: stakeholder
name: End User
role: Product manager
description: Uses LLPM for specs and planning
goals:
  - Quickly create well-formed issues
  - AI assistance for gap analysis
painPoints:
  - Writing specs is time-consuming
  - Context switching between tools
priorities:
  - Context
  - Quality
  - Integration
linkedIssues:
  - goal: "Quickly create well-formed issues"
    issues: [42, 56]
```

## Workflow

### Adding Stakeholders

When a user wants to add a stakeholder, engage conversationally:

1. Ask for the stakeholder's name and role
2. Ask for a brief description
3. Ask about their goals (what do they want to achieve?)
4. Ask about pain points (what frustrates them currently?)
5. Ask about priorities (what matters most, in order?)
6. Confirm the profile and save using the YAML format above

### Listing Stakeholders

When asked to list stakeholders:

1. Search for all stakeholder profiles (e.g., by "type: stakeholder")
2. Present a summary table with name, role, and top goals

### Viewing Stakeholder Details

When asked about a specific stakeholder:

1. Search for the stakeholder by name
2. Present the full profile with goals, pain points, and linked issues

### Updating Stakeholders

When asked to update a stakeholder:

1. Find the stakeholder profile
2. Retrieve the full content
3. Make the requested changes
4. Save the updated profile

### Removing Stakeholders

When asked to remove a stakeholder:

1. Find the stakeholder profile
2. Confirm deletion with the user
3. Remove the profile

### Linking Issues to Goals

When an issue addresses a stakeholder goal:

1. Find the stakeholder profile
2. Add the issue number to the `linkedIssues` section under the matching goal
3. Save the updated profile

### Checking Coverage

When asked about stakeholder coverage:

1. Find all stakeholder profiles
2. Fetch open issues to check goal-issue linkage
3. For each stakeholder, check which goals have linked issues and which don't
4. Calculate coverage percentages
5. Present a coverage report highlighting gaps

Coverage report format:
```markdown
## Stakeholder Coverage Report

### End User (2/3 goals covered - 67%)
- [x] Quickly create well-formed issues (linked: #42, #56)
- [x] AI assistance for gap analysis (linked: #78)
- [ ] **GAP**: Fast context switching - no issues address this

### Product Owner (1/2 goals covered - 50%)
- [x] Track project progress (linked: #12)
- [ ] **GAP**: Stakeholder visibility - no issues address this

### Overall Coverage: 60% (3/5 goals linked to issues)
```

### Resolving Conflicts

When stakeholder priorities might conflict:

1. Identify the conflicting priorities by comparing stakeholder profiles
2. Present the conflict clearly to the user
3. Offer resolution options:
   - Prioritize one stakeholder's needs
   - Find a compromise
   - Document as a known tradeoff
4. Record the resolution by updating the relevant stakeholder notes

## Natural Language Triggers

Respond to these types of questions:

| Question Type | Action |
|--------------|--------|
| "Who are the stakeholders?" | Find and list all stakeholder profiles |
| "Add a stakeholder" | Start conversational profile creation |
| "What are [Name]'s goals?" | Find and show specific stakeholder's goals |
| "Does this address stakeholder concerns?" | Generate coverage report |
| "Show me stakeholder coverage" | Generate coverage report |
| "Link issue #X to [goal]" | Update stakeholder profile with issue link |
| "Are there any conflicts?" | Compare stakeholder priorities for conflicts |

## Best Practices

1. **Start with key stakeholders**: Focus on 3-5 primary stakeholders initially
2. **Be specific with goals**: "Complete checkout in under 2 minutes" is better than "Fast checkout"
3. **Link issues early**: When creating issues, immediately link them to relevant goals
4. **Review coverage regularly**: Check coverage when planning sprints or releases
5. **Document conflicts**: When priorities conflict, record the decision and rationale
