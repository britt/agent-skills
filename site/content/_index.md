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

Browse the [Skills]({{< relref "skill-list.md" >}}) index for the full catalog.

## Rules

The repository also includes reusable rule sets in the `rules/` directory. The most notable is **TDD.rules.md** which enforces strict Test-Driven Development practices.

## Creating Your Own Skills

See the [Contributing Guide](https://github.com/britt/agent-skills/blob/main/CONTRIBUTING.md) for details on creating new skills.

## All Skills

| Skill | Description |
| --- | --- |
| [Architecture Diagramming]({{< relref "skills/architecture-diagramming.md" >}}) | Generate Mermaid architecture diagrams showing system components, layers, and data flows |
| [At-Risk Detection]({{< relref "skills/at-risk-detection.md" >}}) | Proactively identify at-risk issues and PRs: stale items, blocked work, deadline risks, scope creep, and unassigned high-priority items |
| [Build FAQ from Issues]({{< relref "skills/build-faq-from-issues.md" >}}) | Extract common questions from closed GitHub issues and generate an FAQ document with answers |
| [Consolidate Notes Summary]({{< relref "skills/consolidate-notes-summary.md" >}}) | Search project notes by topic, synthesize findings into a consolidated summary with cross-references |
| [Context-Aware Questions]({{< relref "skills/context-aware-questions.md" >}}) | Identify information gaps in project context and generate actionable questions to surface missing requirements |
| [Daily Planning Ritual]({{< relref "skills/daily-planning-ritual.md" >}}) | Interactive daily planning across work and personal life dimensions |
| [Dependency Mapping]({{< relref "skills/dependency-mapping.md" >}}) | Generate Mermaid dependency graphs showing issue relationships, blocking chains, and critical paths |
| [Idea to Design]({{< relref "skills/idea-to-design.md" >}}) | Transform raw idea notes into comprehensive design documents with research and decisions |
| [Issue Decomposition]({{< relref "skills/issue-decomposition.md" >}}) | Decompose project descriptions into well-structured GitHub issues with user stories, acceptance criteria, and estimates |
| [Markdown Formatting]({{< relref "skills/markdown-formatting.md" >}}) | Format AI outputs into consistent, readable Markdown for PRs, issues, docs, and notes |
| [Mermaid Diagrams]({{< relref "skills/mermaid-diagrams.md" >}}) | Guide for creating syntactically correct Mermaid diagrams that render properly on GitHub |
| [Prepare Meeting Agenda]({{< relref "skills/prepare-meeting-agenda.md" >}}) | Generate meeting agendas from recent issues, PRs, and notes for sprint planning, retros, and standups |
| [Project Analysis]({{< relref "skills/project-analysis.md" >}}) | Analyze project codebase structure, architecture, key files, and dependencies |
| [Project Foundations (Bundle)]({{< relref "skills/project-foundations.md" >}}) | Establish and repair project foundations, then take a project from concept to a diagrammed, story-driven plan with supported coding agents |
| [Project Planning]({{< relref "skills/project-planning.md" >}}) | Orchestrate comprehensive project planning with issues, architecture diagrams, dependency maps, and timelines |
| [Requirement Elicitation]({{< relref "skills/requirement-elicitation.md" >}}) | Adaptive conversational wizard for eliciting project requirements across functional, nonfunctional, and edge-case dimensions |
| [Research Topic and Summarize]({{< relref "skills/research-topic-summarize.md" >}}) | Research topics via web search, synthesize detailed summaries with sources and screenshots |
| [Repairing Project Setup]({{< relref "skills/repairing-project-setup.md" >}}) | Audit an existing project setup, repair only its gaps, and confirm the result with a full re-audit |
| [Setting Up a Project]({{< relref "skills/setting-up-a-project.md" >}}) | Survey the repository, record and run its commands, and create distinct CLAUDE.md and AGENTS.md files with project-specific rules, a populated root TDD.rules.md, and verification guidance |
| [SGAI Goal Authoring]({{< relref "skills/sgai-goal.md" >}}) | Compose GOAL.md files for SGAI workspaces through interactive conversation |
| [Stakeholder Tracking]({{< relref "skills/stakeholder-tracking.md" >}}) | Define stakeholder personas and track their goals to ensure all perspectives are addressed |
| [Stakeholder Updates]({{< relref "skills/stakeholder-updates.md" >}}) | Craft clear, concise stakeholder communications with appropriate context and framing |
| [Summarize Conversation Thread]({{< relref "skills/summarize-conversation-thread.md" >}}) | Summarize GitHub issue and PR threads into key decisions, action items, and next steps |
| [Timeline Planning]({{< relref "skills/timeline-planning.md" >}}) | Generate Mermaid Gantt charts for project timelines with phases, dependencies, and milestones |
| [Triage New Issues]({{< relref "skills/triage-new-issues.md" >}}) | Review new GitHub issues, assess priority and urgency, suggest labels, and recommend assignees |
| [Working on an Issue]({{< relref "skills/working-on-an-issue.md" >}}) | Hands-off implementation of GitHub issues, reviewed at the PR |
| [Writing Product Specs]({{< relref "skills/writing-product-specs.md" >}}) | Write comprehensive product specification documents |
| [Writing User Stories]({{< relref "skills/writing-user-stories.md" >}}) | Write properly formatted user stories for task definition |
| [Writing Verification Plans]({{< relref "skills/writing-verification-plans.md" >}}) | Create real-world acceptance testing procedures |