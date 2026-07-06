---
name: writing-user-stories
description: Use when asked to write user stories, define requirements, break a feature into stories, or draft product/feature issues - produces stories in "As a [persona], I want [action], so that [benefit]" format with Given-When-Then acceptance criteria and an INVEST quality checklist
---

# Writing User Stories

## Overview

**Core principle:** User stories are a formulaic way of expressing user requirements. Every story identifies the persona of the actor, what they want to do, and the benefit they hope to gain.

## When to Use

- You are asked to write a user story
- You are writing GitHub issues for product work or feature requirements
- You are asked to plan a feature and express its requirements as stories

**Not for:** full product specifications — use the `writing-product-specs` skill instead.

## Story Format

```
As a [persona]
I want [action or feature]
So that [benefit or value]
```

**Example:**

```
As a non-technical stakeholder
I want to understand what changed in a release without reading code diffs
So that I can communicate updates to customers effectively
```

## Acceptance Criteria

Add clear, testable conditions in Given-When-Then format:

```
Given I am viewing the project dashboard
When I click the "Filter" button
Then I see a dropdown with all available labels
And the issue list updates to show only matching issues
```

Stories without acceptance criteria lead to scope creep, unclear completion, and misaligned expectations.

## Quality Checklist (INVEST)

Before finalizing a story, verify it is:

- [ ] **Independent** - Can be developed separately from other stories
- [ ] **Negotiable** - Details can be discussed and refined
- [ ] **Valuable** - Delivers clear value to users or business
- [ ] **Estimable** - Effort can be estimated reasonably
- [ ] **Small** - Can be completed in one sprint (typically)
- [ ] **Testable** - Success criteria are clear and verifiable

## Common Pitfalls

**Too technical:**
- ❌ "Add a REST endpoint at /api/v2/users with authentication"
- ✅ "As an admin, I want to manage user accounts via API, so that I can automate user provisioning"

**Too vague:**
- ❌ "Make the dashboard better"
- ✅ "As a manager, I want to see project velocity trends, so that I can forecast delivery dates"

**Missing the "why":**
- ❌ "As a user, I want dark mode"
- ✅ "As a user, I want dark mode, so that I can reduce eye strain during evening work sessions"

## Optional Sections

For stories destined to become GitHub issues, add sections as needed: **Dependencies** (what must complete first), **Open Questions** (decisions still needed), **Technical Notes** (implementation guidance), and **Design Assets** (mockups, wireframes).
