---
title: "Agent Skills"
description: "Learn how to install and use Agent Skills across supported coding agents"
---

Coding agents are smart, but left alone they improvise: skipping verification, inventing their own project structure, redoing work you already explained last week. Agent Skills fixes that by giving agents a library of proven workflows to follow instead of guessing — how to set up a project, break down issues into stories, plan a timeline, run a verification pass — so the process stays consistent whoever's driving and whichever agent is doing the work. Install just the bundle your team needs, across Claude Code, Codex CLI, Cursor, or OpenCode, and stop re-teaching the same playbook every session.

---

## Bundles

### All Skills (`agent-skills`)

Every skill bundled together for AI-assisted development: project setup, product specs, user stories, verification plans, daily planning, and more.

### Project Foundations (`project-foundations`)

A curated bundle for taking a new project from concept to a diagrammed, story-driven plan: project setup, issue decomposition, user stories, verification plans, and architecture/dependency/Mermaid diagrams.

### LLPM (`llpm`)

LLPM's product-management and project-management skills: requirements, specs, user stories, stakeholders, meetings, triage, risk, timelines, and dependency/critical-path planning.

### Chat (`chat`)

For chat agents rather than coding agents: writing and communication, research, diagrams, requirements, specs, and daily planning. Nothing in it needs a repository, `git`, or the `gh` CLI.

Browse the [Skills](./skill-list/) index for the full catalog of individual skills.

---

## Installation Methods

### Claude Code

Claude Code installs skills through the plugin marketplace.

```bash
/plugin marketplace add britt/agent-skills
/plugin install agent-skills@britt
/plugin install project-foundations@britt
/plugin install llpm@britt
/plugin install chat@britt
```

### Codex CLI

Codex CLI installs the repository through its plugin marketplace.

```bash
codex plugin marketplace add britt/agent-skills
codex plugin install agent-skills@britt
codex plugin install project-foundations@britt
codex plugin install llpm@britt
codex plugin install chat@britt
```

### Cursor

Cursor adds the repository through its dashboard based marketplace flow and installs the same bundles from there.

1. Open **Dashboard → Plugins → Team Marketplaces → Add Marketplace → Import from Repo**
2. Point it at `britt/agent-skills`
3. Install `agent-skills`, `project-foundations`, `llpm`, or `chat` from **Customize**

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
