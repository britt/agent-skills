---
name: build-faq-from-issues
description: "Extract common questions from closed GitHub issues and generate an FAQ document with answers"
instructions: "When building an FAQ from closed issues, extracting common questions, or generating support documentation from past issues"
tags:
  - faq
  - issues
  - documentation
  - questions
  - support
---

# Build FAQ from Issues Skill

Extract common questions from closed GitHub issues and generate a structured FAQ document with answers and source links.

## When to Use

Activate when:
- Creating or updating project FAQ
- Documenting common support questions
- Reducing repeat questions in issues
- Onboarding new users/contributors

## Output Structure

```markdown
## FAQ: [Project/Topic]

**Generated from**: [X closed issues] | **Labels**: [question, help, support]

### General

#### Q: [Common question]

[Answer synthesized from issue resolution]

— See #123

#### Q: [Another question]

[Answer]

— See #456

### Setup & Installation

#### Q: [Setup question]

[Answer with steps if needed]

— See #789

### Troubleshooting

#### Q: [Error or problem question]

[Answer with solution]

— See #101

### Configuration

#### Q: [Config question]

[Answer]

— See #202
```

## Guidelines

### Question Selection

- Focus on closed/resolved issues
- Prioritize issues labeled: `question`, `help`, `support`, `faq`
- Include frequently recurring questions
- Skip one-off bugs or feature requests

### Answer Quality

- Write standalone answers (don't require reading the issue)
- Include concrete steps when applicable
- Keep answers concise but complete
- Link to docs if more detail exists elsewhere

### Organization

- Group by logical categories
- Put most common questions first within each category
- Use consistent question phrasing ("How do I..." vs "Why does...")
- Deduplicate similar questions into single entry

### Deduplication

When multiple issues ask the same thing:
- Combine into one FAQ entry
- Reference all related issues: "See #123, #456"
- Use the clearest answer from any of them

### Maintenance Notes

- Note when FAQ was last generated
- Flag answers that may be outdated
- Suggest issues that should be added to FAQ
