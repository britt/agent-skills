---
title: "Chat (Bundle)"
description: "A curated bundle for chat agents rather than coding agents: writing, research, diagrams, requirements, and daily planning"
---

Most skills in this library assume a repository, a `git` history, and an authenticated `gh` CLI. A chat agent has none of those. This bundle is the subset that works with nothing but the conversation, a web search, connectors, and at most a scratch filesystem.

## Where it runs

| Surface | Supported |
|-------|:---------:|
| Claude.ai | ✓ |
| Claude Desktop | ✓ |
| Other chat agents with connectors | ✓ |
| Coding agents | ✓ |

## Included Skills

| Skill | Description |
|-------|-------------|
| [Stakeholder Updates]({{< relref "skills/stakeholder-updates.md" >}}) | Craft clear, concise stakeholder communications with appropriate context and framing. |
| [Markdown Formatting]({{< relref "skills/markdown-formatting.md" >}}) | Format AI outputs into consistent, readable Markdown for PRs, issues, docs, and notes. |
| [Mermaid Diagrams]({{< relref "skills/mermaid-diagrams.md" >}}) | Guide for creating syntactically correct Mermaid diagrams that render properly on GitHub. |
| [Architecture Diagramming]({{< relref "skills/architecture-diagramming.md" >}}) | Generate Mermaid architecture diagrams showing system components, layers, and data flows. |
| [Writing User Stories]({{< relref "skills/writing-user-stories.md" >}}) | Write properly formatted user stories with Given-When-Then acceptance criteria and an INVEST quality checklist. |
| [Writing Product Specs]({{< relref "skills/writing-product-specs.md" >}}) | Write comprehensive product specification documents. |
| [Requirement Elicitation]({{< relref "skills/requirement-elicitation.md" >}}) | Adaptive conversational wizard for eliciting project requirements across functional, nonfunctional, and edge-case dimensions. |
| [Issue Decomposition]({{< relref "skills/issue-decomposition.md" >}}) | Decompose project descriptions into well-structured GitHub issues with user stories, acceptance criteria, and estimates. |
| [Context-Aware Questions]({{< relref "skills/context-aware-questions.md" >}}) | Identify information gaps in project context and generate actionable questions to surface missing requirements. |
| [Summarize Conversation Thread]({{< relref "skills/summarize-conversation-thread.md" >}}) | Summarize GitHub issue and PR threads into key decisions, action items, and next steps. |
| [Research Topic and Summarize]({{< relref "skills/research-topic-summarize.md" >}}) | Research topics via web search, synthesize detailed summaries with sources and screenshots. |
| [Daily Planning Ritual]({{< relref "skills/daily-planning-ritual.md" >}}) | Interactive daily planning across work and personal life dimensions. |

## How to use it

Install the bundle when the agent you are talking to writes, researches, and plans rather than edits code. Two skills reach beyond the conversation: `research-topic-summarize` needs a web search tool, and `daily-planning-ritual` reads calendar, mail, and document connectors. Everything else runs on what you paste into the chat.

Each skill in the bundle points back to its canonical definition under `skills/`, so bundle and standalone installs stay in sync.
