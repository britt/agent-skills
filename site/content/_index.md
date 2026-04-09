---
title: "Claude Skills"
description: "Claude Skills are reusable instruction sets that give Claude structured workflows, best practices, and domain expertise for specific kinds of work. Instead of writing a new prompt every time, you install a skill once and reuse it whenever you need that capability. Each skill focuses on a concrete workflow, like planning your day, setting up a project, or writing specs and user stories."
---

## Available Skills

### Development Workflow

| Skill | Description | Claude Code | Claude.ai |
|-------|-------------|:-----------:|:---------:|
| [Setting Up a Project](./skills/setting-up-a-project/) | Authors a CLAUDE.md file that defines your project's purpose, tech stack, and development practices before any code is written. | ✓ | |
| [Project Analysis](./skills/project-analysis/) | Analyze a project's codebase structure, architecture, key files, and dependencies. | ✓ | ✓ |
| [Project Planning](./skills/project-planning/) | Orchestrate end-to-end project planning with issues, architecture diagrams, dependency maps, and timelines. | ✓ | ✓ |
| [Issue Decomposition](./skills/issue-decomposition/) | Decompose projects into well-structured GitHub issues with user stories, acceptance criteria, and estimates. | ✓ | ✓ |
| [Dependency Mapping](./skills/dependency-mapping/) | Generate Mermaid dependency graphs showing issue relationships, blocking chains, and critical paths. | ✓ | ✓ |
| [Timeline Planning](./skills/timeline-planning/) | Generate Mermaid Gantt charts for project timelines with phases, dependencies, and milestones. | ✓ | ✓ |

### Requirements & Planning

| Skill | Description | Claude Code | Claude.ai |
|-------|-------------|:-----------:|:---------:|
| [Requirement Elicitation](./skills/requirement-elicitation/) | Conversational wizard for eliciting functional, nonfunctional, and edge-case requirements with domain-specific questions. | ✓ | ✓ |
| [Idea to Design](./skills/idea-to-design/) | Turn an idea note into a design document with clear goals, constraints, and implementation guidance. | ✓ | ✓ |
| [Writing Product Specs](./skills/writing-product-specs/) | Write comprehensive product specification documents that explain what you are building, why, and how success will be measured. | ✓ | ✓ |
| [Writing User Stories](./skills/writing-user-stories/) | Write properly formatted user stories that identify the persona, desired action, and expected benefit. | ✓ | ✓ |
| [User Story Template](./skills/user-story-template/) | Guide writing well-formed user stories with acceptance criteria following best practices. | ✓ | ✓ |
| [Writing Verification Plans](./skills/writing-verification-plans/) | Create verification plans for real-world acceptance testing with concrete scenarios and success criteria. | ✓ | ✓ |
| [Context-Aware Questions](./skills/context-aware-questions/) | Identify information gaps and generate prioritized questions to surface missing requirements or documentation gaps. | ✓ | ✓ |

### Project Management

| Skill | Description | Claude Code | Claude.ai |
|-------|-------------|:-----------:|:---------:|
| [At-Risk Detection](./skills/at-risk-detection/) | Identify at-risk issues and PRs: stale items, blocked work, deadline risks, scope creep, and unassigned high-priority items. | ✓ | ✓ |
| [Triage New Issues](./skills/triage-new-issues/) | Review new GitHub issues, assess priority and urgency, suggest labels, and recommend assignees. | ✓ | ✓ |
| [Stakeholder Tracking](./skills/stakeholder-tracking/) | Define stakeholder personas and track their goals to ensure all perspectives are addressed. | ✓ | ✓ |
| [Stakeholder Updates](./skills/stakeholder-updates/) | Craft clear, concise stakeholder communications with appropriate context and framing. | ✓ | ✓ |
| [Prepare Meeting Agenda](./skills/prepare-meeting-agenda/) | Generate meeting agendas from recent issues, PRs, and notes for sprint planning, retros, and standups. | ✓ | ✓ |

### Documentation & Communication

| Skill | Description | Claude Code | Claude.ai |
|-------|-------------|:-----------:|:---------:|
| [Architecture Diagramming](./skills/architecture-diagramming/) | Generate Mermaid architecture diagrams showing system components, layers, and data flows. | ✓ | ✓ |
| [Mermaid Diagrams](./skills/mermaid-diagrams/) | Guide for creating syntactically correct Mermaid diagrams that render properly on GitHub. | ✓ | ✓ |
| [Markdown Formatting](./skills/markdown-formatting/) | Format AI outputs into consistent, readable Markdown for PRs, issues, docs, and notes. | ✓ | ✓ |
| [Build FAQ from Issues](./skills/build-faq-from-issues/) | Extract common questions from closed GitHub issues and generate an FAQ document with answers. | ✓ | ✓ |
| [Summarize Conversation Thread](./skills/summarize-conversation-thread/) | Summarize GitHub issue/PR threads into key decisions, action items, and next steps. | ✓ | ✓ |
| [Consolidate Notes Summary](./skills/consolidate-notes-summary/) | Synthesize findings across multiple notes into a consolidated summary with cross-references. | ✓ | ✓ |
| [Research Topic Summarize](./skills/research-topic-summarize/) | Research topics via web search and synthesize detailed summaries with sources. | ✓ | ✓ |

### Personal & Utilities

| Skill | Description | Claude Code | Claude.ai |
|-------|-------------|:-----------:|:---------:|
| [Daily Planning Ritual](./skills/daily-planning-ritual/) | An interactive morning practice that helps you plan your entire day through a reflective conversation across work and personal life dimensions. | ✓ | ✓ |
| [Summoning the User](./skills/summoning-the-user/) | Gets your attention when Claude or background subagents reach a blocking decision and need your input to proceed. | ✓ | |

## Quick Start

### Claude Code (Recommended)

```bash
# Add the marketplace
/plugin marketplace add britt/claude-code-skills
```

### Manual Installation

```bash
# Clone to global skills directory
git clone https://github.com/britt/claude-code-skills.git ~/.claude/skills/claude-code-skills
```

### Claude.ai

Download zip files from the [Releases page](https://github.com/britt/claude-code-skills/releases/) and upload them to your project's knowledge.
