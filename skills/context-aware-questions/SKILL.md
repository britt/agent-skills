---
name: context-aware-questions
description: "Proactively identify information gaps in project context and generate actionable questions to surface missing requirements, unclear specifications, or documentation gaps"
instructions: "When identifying gaps in project requirements, surfacing unclear specifications, or generating questions to fill missing context"
tags:
  - questions
  - gaps
  - requirements
  - analysis
  - documentation
allowed-tools: "list_github_issues get_github_issue_with_comments read_project_file get_project_scan"
---

# Context-Aware Question Generator Skill

Analyze project context to surface information gaps and generate prioritized, actionable questions.

## When to Use

Activate when:
- User asks "what am I missing?" or "what questions should I be asking?"
- Reviewing issues before starting work
- Analyzing documentation completeness
- Preparing a draft (issue, PR, document) for submission
- During project planning or kickoff

## Available Tools

| Tool | Purpose |
|------|---------|
| `list_github_issues` | Fetch open issues for project-wide gap analysis |
| `get_github_issue_with_comments` | Deep-dive into specific issues for detailed analysis |
| `read_project_file` | Read README, docs, and config files for documentation gaps |
| `get_project_scan` | Get project structure and language data for architecture analysis |

## Analysis Modes

### 1. Project-Wide Review

When asked "what am I missing?" or "what questions should I be asking?":

1. Use `list_github_issues` to fetch all open issues
2. Use `get_project_scan` to understand project structure
3. Use `read_project_file` to check README and documentation
4. Analyze all gathered data for information gaps
5. Generate prioritized questions

### 2. Issue Review

When asked to review a specific issue:

1. Use `get_github_issue_with_comments` to fetch the issue and all comments
2. Analyze for missing requirements, unclear specs, and gaps
3. Generate targeted questions for that issue

### 3. Draft Review

When reviewing a draft (issue, PR, note) before submission:

1. Analyze the provided text for completeness
2. Check against standard templates and best practices
3. Suggest specific improvements

### 4. Documentation Gap Analysis

When asked about documentation completeness:

1. Use `read_project_file` to read README.md and files in docs/
2. Use `get_project_scan` to understand what the project contains
3. Identify missing documentation by comparing project content to docs

## Gap Detection Heuristics

### Issue Analysis
- **Missing acceptance criteria**: No checkboxes, no "done when" statement
- **Vague descriptions**: Less than 100 characters, contains "unclear", "might", "maybe"
- **Missing labels or assignees**: Issue has no labels or no assignee
- **Stale issues**: Open more than 30 days with no activity
- **Bug reports without reproduction steps**: No "steps to reproduce" section

### Documentation Analysis
- **Missing README sections**: No install, usage, or examples sections
- **No dedicated docs/ directory**: For projects with more than 10 files
- **Short README**: Less than 500 characters
- **Missing license information**: No LICENSE file or license section
- **No inline documentation**: Missing JSDoc/docstrings in key files

### Project-Wide Analysis
- **Inconsistencies between issues and notes**: Conflicting descriptions
- **Missing architecture documentation**: No system overview for complex projects
- **Undocumented key files**: Entry points without explaining comments
- **No project scan available**: Suggest running a scan first

## Output Structure

Questions are categorized and prioritized:

### Categories
- **requirements**: Missing acceptance criteria, unclear specs, vague descriptions
- **technical**: Implementation questions, architecture decisions
- **documentation**: Missing docs, unclear README sections
- **process**: Workflow gaps, missing labels/assignees
- **consistency**: Conflicting information across sources
- **architecture**: High-level design questions

### Priorities
- **high**: Blocking or critical gaps that need immediate attention
- **medium**: Important gaps that should be addressed soon
- **low**: Nice-to-have clarifications

## Example Output

```markdown
## Information Gaps Found

### High Priority (3)
1. [requirements] Issue #42 lacks acceptance criteria
   - Context: "Add login feature" has no definition of done
   - Suggested Action: Add checkboxes with acceptance criteria

2. [documentation] No API documentation found
   - Context: Project has 15 endpoints but no API reference
   - Suggested Action: Create docs/api.md with endpoint documentation

3. [requirements] Issue #38 has vague description
   - Context: Description is only 20 characters
   - Suggested Action: Expand with problem statement and expected behavior

### Medium Priority (5)
...
```

## Best Practices

### When Generating Questions
1. Always prioritize by impact
2. Group related questions together
3. Provide actionable suggested actions
4. Link to specific sources (issue number, file path)

### When Reviewing Drafts
1. Be constructive, not critical
2. Suggest specific improvements
3. Provide example text when helpful
4. Acknowledge what's already good

### When Analyzing Documentation
1. Check against industry standards
2. Consider the project type (CLI needs different docs than library)
3. Leverage project scan data when available
