---
name: build-faq-from-issues
description: "Use when building or updating an FAQ from closed GitHub issues, documenting recurring support questions, or reducing repeat questions - extracts common questions from resolved issues and generates a categorized FAQ document with synthesized answers and source links"
---

# Build FAQ from Issues Skill

Extract common questions from closed GitHub issues and generate a structured FAQ document with answers and source links.

## When to Use

Activate when:
- Creating or updating a project FAQ
- Documenting common support questions
- Reducing repeat questions in issues
- Onboarding new users/contributors

**When NOT to use**: not for open-issue triage, changelogs or release notes, or repos with too few closed issues to find recurring patterns.

## Workflow

Prerequisite: requires the `gh` CLI authenticated to the target repository.

1. List closed issues: `gh issue list --state closed --limit 200 --json number,title,labels,url`. Optionally filter by question/support labels (e.g. `--label question`).
2. Read resolutions for candidate issues with `gh issue view <n> --comments` to find the accepted answer or fix.
3. Group recurring questions — cluster issues that ask the same thing into a single candidate FAQ entry.
4. Synthesize a standalone answer for each entry from the clearest resolution.
5. Emit the FAQ using the template below.

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

## Common Mistakes

- Copying issue text verbatim instead of writing a standalone answer a reader can use without opening the issue.
- Including one-off bugs that will never recur as FAQ entries.
- Embedding version-specific commands or config without noting which version they apply to.
