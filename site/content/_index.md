---
title: "Agent Skills"
description: "Learn how to install and use Agent Skills across supported coding agents"
---

## Getting Started

Skills are reusable instruction sets that extend supported coding agents for specific tasks. Choose the installation path that matches the tool in use.

## Installation Methods

### Claude Code

Claude Code installs skills through the plugin marketplace.

```bash
/plugin marketplace add britt/agent-skills
/plugin install agent-skills@britt
/plugin install project-foundations@britt
```

### Codex CLI

Codex CLI installs the repository through its plugin marketplace.

```bash
codex plugin marketplace add britt/agent-skills
codex plugin install agent-skills@britt
codex plugin install project-foundations@britt
```

### Cursor

Cursor adds the repository through its dashboard based marketplace flow and installs the same bundles from there.

1. Open **Dashboard → Plugins → Team Marketplaces → Add Marketplace → Import from Repo**
2. Point it at `britt/agent-skills`
3. Install `agent-skills` or `project-foundations` from **Customize**

### Shared `.agents/skills/` Path

Codex CLI, OpenCode, and Cursor can also read a shared `.agents/skills/` directory. Use this fallback when a marketplace flow is not available.

```bash
git clone https://github.com/britt/agent-skills.git ~/.agent-skills-src
mkdir -p ~/.agents/skills
for dir in ~/.agent-skills-src/skills/*/; do
  ln -s "$dir" ~/.agents/skills/"$(basename "$dir")"
done
```

### Claude.ai

Claude.ai uses project knowledge uploads.

1. Download the skill zip from the [Releases page](https://github.com/britt/agent-skills/releases/)
2. Open the target project in Claude.ai
3. Upload the zip file under **Project knowledge**

Browse the [Skills](./skill-list/) index for the full catalog.

## Rules

The repository also includes reusable rule sets in the `rules/` directory. The most notable is **TDD.rules.md** which enforces strict Test-Driven Development practices.

## Creating Your Own Skills

See the [Contributing Guide](https://github.com/britt/agent-skills/blob/main/CONTRIBUTING.md) for details on creating new skills.

## All Skills

| Skill | Description |
| --- | --- |
| [Architecture Diagramming](/skills/architecture-diagramming/) | Generate Mermaid architecture diagrams showing system components, layers, and data flows |
| [At-Risk Detection](/skills/at-risk-detection/) | Proactively identify at-risk issues and PRs: stale items, blocked work, deadline risks, scope creep, and unassigned high-priority items |
| [Build FAQ from Issues](/skills/build-faq-from-issues/) | Extract common questions from closed GitHub issues and generate an FAQ document with answers |
| [Consolidate Notes Summary](/skills/consolidate-notes-summary/) | Search project notes by topic, synthesize findings into a consolidated summary with cross-references |
| [Context-Aware Questions](/skills/context-aware-questions/) | Identify information gaps in project context and generate actionable questions to surface missing requirements |
| [Daily Planning Ritual](/skills/daily-planning-ritual/) | Interactive daily planning across work and personal life dimensions |
| [Dependency Mapping](/skills/dependency-mapping/) | Generate Mermaid dependency graphs showing issue relationships, blocking chains, and critical paths |
| [Idea to Design](/skills/idea-to-design/) | Transform raw idea notes into comprehensive design documents with research and decisions |
| [Issue Decomposition](/skills/issue-decomposition/) | Decompose project descriptions into well-structured GitHub issues with user stories, acceptance criteria, and estimates |
| [Markdown Formatting](/skills/markdown-formatting/) | Format AI outputs into consistent, readable Markdown for PRs, issues, docs, and notes |
| [Mermaid Diagrams](/skills/mermaid-diagrams/) | Guide for creating syntactically correct Mermaid diagrams that render properly on GitHub |
| [Prepare Meeting Agenda](/skills/prepare-meeting-agenda/) | Generate meeting agendas from recent issues, PRs, and notes for sprint planning, retros, and standups |
| [Project Analysis](/skills/project-analysis/) | Analyze project codebase structure, architecture, key files, and dependencies |
| [Project Foundations (Bundle)](/skills/project-foundations/) | A curated bundle for taking a new project from concept to a diagrammed, story-driven plan with supported coding agents |
| [Project Planning](/skills/project-planning/) | Orchestrate comprehensive project planning with issues, architecture diagrams, dependency maps, and timelines |
| [Requirement Elicitation](/skills/requirement-elicitation/) | Adaptive conversational wizard for eliciting project requirements across functional, nonfunctional, and edge-case dimensions |
| [Research Topic and Summarize](/skills/research-topic-summarize/) | Research topics via web search, synthesize detailed summaries with sources and screenshots |
| [Setting Up a Project](/skills/setting-up-a-project/) | Author CLAUDE.md with project purpose, tech stack, and development practices |
| [SGAI Goal Authoring](/skills/sgai-goal/) | Compose GOAL.md files for SGAI workspaces through interactive conversation |
| [Stakeholder Tracking](/skills/stakeholder-tracking/) | Define stakeholder personas and track their goals to ensure all perspectives are addressed |
| [Stakeholder Updates](/skills/stakeholder-updates/) | Craft clear, concise stakeholder communications with appropriate context and framing |
| [Summarize Conversation Thread](/skills/summarize-conversation-thread/) | Summarize GitHub issue and PR threads into key decisions, action items, and next steps |
| [Timeline Planning](/skills/timeline-planning/) | Generate Mermaid Gantt charts for project timelines with phases, dependencies, and milestones |
| [Triage New Issues](/skills/triage-new-issues/) | Review new GitHub issues, assess priority and urgency, suggest labels, and recommend assignees |
| [Working on an Issue](/skills/working-on-an-issue/) | Hands-off implementation of GitHub issues, reviewed at the PR |
| [Writing Product Specs](/skills/writing-product-specs/) | Write comprehensive product specification documents |
| [Writing User Stories](/skills/writing-user-stories/) | Write properly formatted user stories for task definition |
| [Writing Verification Plans](/skills/writing-verification-plans/) | Create real-world acceptance testing procedures |