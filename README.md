# Claude Skills

A collection of skills for Claude to enhance AI-assisted development workflows.

## Skills Included

### Development Workflow

| Skill | Description | Claude Code | Claude.ai |
|-------|-------------|:-----------:|:---------:|
| **sgai-goal** | Compose GOAL.md files for SGAI workspaces through interactive conversation | * | |
| **setting-up-a-project** | Author CLAUDE.md with project purpose, tech stack, and development practices | * | |
| **working-on-an-issue** | Work on, read, or implement a GitHub issue | * | |
| **project-analysis** | Analyze project codebase structure, architecture, key files, and dependencies | * | * |
| **project-planning** | Orchestrate end-to-end project planning with issues, diagrams, dependencies, and timelines | * | * |
| **issue-decomposition** | Decompose projects into well-structured GitHub issues with user stories and estimates | * | * |
| **dependency-mapping** | Generate Mermaid dependency graphs showing issue relationships and critical paths | * | * |
| **timeline-planning** | Generate Mermaid Gantt charts for project timelines with phases and milestones | * | * |

### Requirements & Planning

| Skill | Description | Claude Code | Claude.ai |
|-------|-------------|:-----------:|:---------:|
| **requirement-elicitation** | Conversational wizard for eliciting functional, nonfunctional, and edge-case requirements | * | * |
| **idea-to-design** | Turn an idea note into a design document | * | * |
| **writing-product-specs** | Write comprehensive product specification documents | * | * |
| **writing-user-stories** | Write properly formatted user stories with Given-When-Then acceptance criteria and an INVEST quality checklist | * | * |
| **writing-verification-plans** | Acceptance test verification plans (real-world testing, never mocks) | * | * |
| **context-aware-questions** | Identify information gaps and generate questions to surface missing requirements | * | * |

### Project Management

| Skill | Description | Claude Code | Claude.ai |
|-------|-------------|:-----------:|:---------:|
| **at-risk-detection** | Identify at-risk issues and PRs: stale items, blocked work, deadline risks, scope creep | * | * |
| **triage-new-issues** | Review new GitHub issues, assess priority, suggest labels, and recommend assignees | * | * |
| **stakeholder-tracking** | Define stakeholder personas and track their goals | * | * |
| **stakeholder-updates** | Craft clear, concise stakeholder communications | * | * |
| **prepare-meeting-agenda** | Generate meeting agendas from recent issues, PRs, and notes | * | * |

### Documentation & Communication

| Skill | Description | Claude Code | Claude.ai |
|-------|-------------|:-----------:|:---------:|
| **architecture-diagramming** | Generate Mermaid architecture diagrams showing system components and data flows | * | * |
| **mermaid-diagrams** | Guide for creating syntactically correct Mermaid diagrams for GitHub | * | * |
| **markdown-formatting** | Format AI outputs into consistent, readable Markdown | * | * |
| **build-faq-from-issues** | Extract common questions from closed issues and generate an FAQ document | * | * |
| **summarize-conversation-thread** | Summarize GitHub issue/PR threads into key decisions and action items | * | * |
| **consolidate-notes-summary** | Synthesize findings across multiple notes into a consolidated summary | * | * |
| **research-topic-summarize** | Research topics via web search and synthesize detailed summaries with sources | * | * |

### Personal & Utilities

| Skill | Description | Claude Code | Claude.ai |
|-------|-------------|:-----------:|:---------:|
| **daily-planning-ritual** | Interactive daily planning across work and personal life dimensions | * | * |

## Installation

### Claude Code: Plugin Marketplace (Recommended)

Add this repository as a plugin marketplace:

```bash
/plugin marketplace add britt/claude-code-skills
```

**Install all skills:**

```bash
/plugin install claude-code-skills@britt
```

**Install a curated bundle:**

```bash
# project-foundations: setup, issue decomposition, user stories,
# verification plans, and architecture/dependency/Mermaid diagrams
/plugin install project-foundations@britt
```

**Install individual skills:**

```bash
/plugin install architecture-diagramming@britt
/plugin install at-risk-detection@britt
/plugin install build-faq-from-issues@britt
/plugin install consolidate-notes-summary@britt
/plugin install context-aware-questions@britt
/plugin install daily-planning-ritual@britt
/plugin install dependency-mapping@britt
/plugin install idea-to-design@britt
/plugin install issue-decomposition@britt
/plugin install markdown-formatting@britt
/plugin install mermaid-diagrams@britt
/plugin install prepare-meeting-agenda@britt
/plugin install project-analysis@britt
/plugin install project-planning@britt
/plugin install requirement-elicitation@britt
/plugin install research-topic-summarize@britt
/plugin install sgai-goal@britt
/plugin install setting-up-a-project@britt
/plugin install stakeholder-tracking@britt
/plugin install stakeholder-updates@britt
/plugin install summarize-conversation-thread@britt
/plugin install timeline-planning@britt
/plugin install triage-new-issues@britt
/plugin install working-on-an-issue@britt
/plugin install writing-product-specs@britt
/plugin install writing-user-stories@britt
/plugin install writing-verification-plans@britt
```

### Claude Code: Manual Installation

Skills can be installed globally or per-project.

**Global installation** (available in all projects):

```bash
# Clone the entire repository
git clone https://github.com/britt/claude-code-skills.git ~/.claude/skills/claude-code-skills
```

**Project-specific installation**:

```bash
# Clone the entire repository into the project
git clone https://github.com/britt/claude-code-skills.git .claude/skills/claude-code-skills
```

Restart Claude Code after installation to load new skills.

### Claude.ai (Web and iOS)

Skills can be added to Claude.ai projects as project knowledge:

1. **Download the skill zip file**
   - Go to the [Releases page](https://github.com/britt/claude-code-skills/releases/)
   - Download the zip file for the skill you want (e.g., `writing-product-specs.zip`)

2. **Add to your Claude.ai project**
   - Open [claude.ai](https://claude.ai) and go to your project
   - Click on **Project knowledge** in the sidebar
   - Upload the zip file

3. **Use the skill**
   - The skill will be available in all conversations within that project
   - Claude will automatically use it when the context matches the skill's description

**Note:** Some skills (like `sgai-goal` and `setting-up-a-project`) require Claude Code-specific features and won't work in Claude.ai.

## Rules

The `rules/` directory contains reusable rule sets that can be copied into your project's CLAUDE.md.

### TDD.rules.md

Strict Test-Driven Development rules for Claude. Used by the `setting-up-a-project` skill.

**Key rules:**
- No production code without a failing test first (RED-GREEN-REFACTOR)
- 90%+ test coverage required on all metrics
- Violations mean delete and start over
- Commit early, commit often (after every TDD cycle)
- Tasks aren't complete until tests pass, build succeeds, and no linter errors

**Usage:** The `setting-up-a-project` skill copies this file verbatim into your project's CLAUDE.md. You can also copy it manually:

```bash
curl -o CLAUDE.md \
  https://raw.githubusercontent.com/britt/claude-code-skills/main/rules/TDD.rules.md
```

Fill in the placeholder commands (`<test command>`, `<build command>`, etc.) for your tech stack.

## Documentation

- [Contributing Guide](CONTRIBUTING.md) - Repository structure, creating skills, and contribution guidelines
- [Claude Code Skills Documentation](https://docs.claude.com/en/docs/claude-code/skills) - Official documentation

## License

[MIT](LICENSE)
