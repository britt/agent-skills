---
name: stakeholder-tracking
description: "Use when identifying project stakeholders, asked 'who are the stakeholders', checking whether a plan covers all stakeholder goals, or linking GitHub issues to stakeholder needs - maintains persona profiles (goals, pain points, priorities) and generates goal-to-issue coverage reports with gaps"
---

# Stakeholder Tracking

## Purpose

Help users define stakeholder personas and track their goals, ensuring all perspectives are addressed throughout the project lifecycle.

## When to Use This Skill

- Starting a new project and need to identify stakeholders
- Plus any of the triggers in the Natural Language Triggers table below

## Storage Format

Each stakeholder is a markdown file at `docs/stakeholders/<name>.md` containing a YAML block. List stakeholders with Glob over `docs/stakeholders/*.md`; search profile contents (a goal, role, or issue number) with Grep over that directory.

```yaml
type: stakeholder
name: End User
role: Product manager
description: Plans features and writes specs for the engineering team
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

### Managing Profiles

To add a stakeholder, ask conversationally for their name, role, description, goals (what they want to achieve), pain points (current frustrations), and priorities (in order); confirm the profile, then write it to `docs/stakeholders/<name>.md` in the YAML format above. To list, Glob the directory and present a summary table of name, role, and top goals. To view, update, or remove a stakeholder, Read their file and present it, apply the requested edits, or delete it (confirm before deleting).

### Linking Issues to Goals

When an issue addresses a stakeholder goal:

1. Read the stakeholder's file in `docs/stakeholders/`
2. Add the issue number to the `linkedIssues` section under the matching goal
3. Save the updated file

### Checking Coverage

When asked about stakeholder coverage:

1. Read all profiles in `docs/stakeholders/`
2. Fetch open issues with `gh issue list --state open --json number,title` (requires the gh CLI)
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

1. Identify the conflicting priorities by comparing stakeholder files
2. Present the conflict clearly to the user
3. Offer resolution options:
   - Prioritize one stakeholder's needs
   - Find a compromise
   - Document as a known tradeoff
4. Record the resolution by updating the relevant stakeholder files

## Natural Language Triggers

Respond to these types of questions:

| Question Type | Action |
|--------------|--------|
| "Who are the stakeholders?" | List all profiles in `docs/stakeholders/` |
| "Add a stakeholder" | Start conversational profile creation |
| "What are [Name]'s goals?" | Read and show specific stakeholder's goals |
| "Does this address stakeholder concerns?" | Generate coverage report |
| "Show me stakeholder coverage" | Generate coverage report |
| "Link issue #X to [goal]" | Update stakeholder file with issue link |
| "Are there any conflicts?" | Compare stakeholder priorities for conflicts |

## Best Practices

1. **Start with key stakeholders**: Focus on 3-5 primary stakeholders initially
2. **Be specific with goals**: "Complete checkout in under 2 minutes" is better than "Fast checkout"
3. **Link issues early**: When creating issues, immediately link them to relevant goals
4. **Review coverage regularly**: Check coverage when planning sprints or releases
5. **Document conflicts**: When priorities conflict, record the decision and rationale
