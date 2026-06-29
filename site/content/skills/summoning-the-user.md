---
title: "Summoning the User"
description: "Gets user's attention when Claude needs input while running in the background"
---

Gets your attention when Claude or background subagents reach a blocking decision and need your input to proceed. It uses a decision framework to decide when your input is required and triggers external notifications so you can unblock long-running workflows.

### Installation

Add the marketplace and install this skill:

```bash
/plugin marketplace add britt/claude-code-skills
/plugin install summoning-the-user@britt
```

Or install all skills at once:

```bash
/plugin install claude-code-skills@britt
```

## Compatibility

| Platform | Supported |
|----------|:---------:|
| Claude Code | ✓ |
| Claude.ai | |

## How to use it

Use this skill when an agent encounters a blocking decision while running in the background and needs you to choose how to proceed.

## Features

**Decision framework for user input**
Provides a decision framework that distinguishes between high-risk and low-risk situations to decide when your input is needed.

**External notification support**
Supports external notification tools such as terminal-notifier, OSA Script, and the Slack CLI so you can be notified outside the editor.

**Terminal detection and activation**
Performs proper terminal detection and activation so that notifications appear in the right place.
