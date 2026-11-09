# Britt's Agent Skills

A library of 30 skills that teach Claude how to run a software project the way
an experienced engineering lead would: set up a repository, turn an idea into a
spec and user stories, break work into estimated GitHub issues, map
dependencies and timelines, work issues and epics through to reviewable pull
requests, keep stakeholders informed, and plan your day. Every skill is plain
Markdown that Claude reads when the conversation calls for it; there are no
hooks, no MCP servers, and no background processes.

This folder is the plugin as published to Anthropic's directory. Its skills
are generated copies of the canonical `skills/` directory in the
[britt/agent-skills](https://github.com/britt/agent-skills) repository, kept
in sync automatically on every merge to `main`.

## Skills

### Development workflow

- `sgai-goal`: compose GOAL.md files for SGAI workspaces through interactive conversation
- `setting-up-a-project`: author CLAUDE.md and AGENTS.md with project purpose, tech stack, and development practices
- `repairing-project-setup`: audit a repo against what setting-up-a-project would generate and repair only the gaps
- `working-on-an-issue`: implement a GitHub issue hands-off, with scoped recon and a PR as the approval gate
- `working-on-an-epic`: coordinate an epic by running child issues in parallel agent workspaces, tracked to reviewable PRs
- `project-analysis`: analyze a codebase's structure, architecture, key files, and dependencies
- `project-planning`: orchestrate end-to-end project planning with issues, diagrams, dependencies, and timelines
- `issue-decomposition`: decompose projects into well-structured GitHub issues with user stories and estimates
- `estimating-work-items`: size issues with story points on a powers-of-two scale and total epics from their children
- `estimating-change-footprint`: estimate an issue's change footprint to predict coding-agent token spend
- `dependency-mapping`: generate Mermaid dependency graphs showing issue relationships and critical paths
- `timeline-planning`: generate Mermaid Gantt charts for project timelines with phases and milestones

### Requirements and planning

- `requirement-elicitation`: conversational wizard for eliciting functional, nonfunctional, and edge-case requirements
- `idea-to-design`: turn an idea note into a design document
- `writing-product-specs`: write comprehensive product specification documents
- `writing-user-stories`: write user stories with Given-When-Then acceptance criteria and an INVEST quality checklist
- `writing-verification-plans`: acceptance test verification plans that use real-world testing, never mocks
- `context-aware-questions`: identify information gaps and generate questions to surface missing requirements

### Project management

- `at-risk-detection`: identify at-risk issues and PRs such as stale items, blocked work, deadline risks, and scope creep
- `triage-new-issues`: review new GitHub issues, assess priority, suggest labels, and recommend assignees
- `stakeholder-tracking`: define stakeholder personas and track their goals
- `stakeholder-updates`: craft clear, concise stakeholder communications
- `prepare-meeting-agenda`: generate time-boxed meeting agendas from recent issues, PRs, and notes

### Documentation and communication

- `architecture-diagramming`: generate Mermaid architecture diagrams showing system components and data flows
- `mermaid-diagrams`: create syntactically correct Mermaid diagrams that render on GitHub
- `markdown-formatting`: format AI output into consistent, readable Markdown
- `build-faq-from-issues`: extract common questions from closed issues and generate an FAQ document
- `summarize-conversation-thread`: summarize GitHub issue and PR threads into key decisions and action items
- `research-topic-summarize`: research topics via web search and synthesize detailed summaries with sources

### Personal

- `daily-planning-ritual`: interactive daily planning across work and personal life dimensions

## How to use it

Add the plugin from Anthropic's directory in claude.ai, or install it from the
repository's marketplace in Claude Code:

```text
/plugin install britts-agent-skills --marketplace britt/agent-skills
```

Then ask Claude for the work in your own words: "break this
feature into issues", "write user stories for the checkout flow", "plan my
day", "summarize this PR thread". Claude picks the matching skill from its
description and announces which one it is using. In Claude Code every skill is
also available as a slash command namespaced under the plugin,
for example `/britts-agent-skills:issue-decomposition`.

Skills that read or write GitHub issues, pull requests, and projects expect the
`gh` CLI to be installed and authenticated. Skills that run other agents
(`working-on-an-epic`, `supervising-conductor-workspaces`,
`supervising-paradev-workspaces`) expect the Conductor or Paradev CLI. Everything
else works from a conversation alone.

## What the plugin runs, sends, and stores

- **Runs:** nothing. There are no hooks, MCP servers, scripts, or
  executables; every file is Markdown, text, JSON, or an image. The two
  fleet-supervision skills in the repository (`supervising-conductor-workspaces`
  and `supervising-paradev-workspaces`) ship a shell script, so they are left
  out of this folder; install them from the repository's marketplace instead.
- **Sends:** nothing to any service of its own. When a skill instructs Claude
  to use `gh`, `git`, Conductor, Paradev, or web search, that traffic goes to
  the services you already use, with your own credentials, and only in the
  course of the task you asked for.
- **Stores:** nothing outside your repository. Some skills write files into
  the project you are working on (a CLAUDE.md, a spec under `docs/`, a dated
  meeting agenda) and say so before they do.

## License

MIT. See the LICENSE file in this folder.
