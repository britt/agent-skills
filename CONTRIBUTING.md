# Contributing

Guidelines for contributing to this skills repository.

🤷 **Real talk:** Skills are just markdown files and setting up your own marketplace is literally one JSON file. You probably want to make your own repo instead of contributing here. But hey, if you've got improvements to my skills or want to share something cool, I'm happy to post it! PRs welcome. 🎉

## Repository Structure

```
claude-code-skills/
├── README.md                 # Installation and usage guide
├── CONTRIBUTING.md           # This file
├── sync-agents-skills.sh     # Keeps .agents/skills/ symlinks and the rules/ mirror in sync with skills/
├── .claude-plugin/
│   ├── marketplace.json      # Claude Code plugin marketplace configuration
│   └── plugin.json           # Claude Code plugin manifest (full bundle)
├── .codex-plugin/
│   └── plugin.json           # Codex CLI plugin manifest (full bundle; reuses .claude-plugin/marketplace.json)
├── .cursor-plugin/
│   ├── marketplace.json      # Cursor plugin marketplace configuration
│   └── plugin.json           # Cursor plugin manifest (full bundle)
├── .agents/
│   └── skills/                       # Symlinks only — read by Codex CLI, OpenCode, Cursor
│       ├── daily-planning-ritual -> ../../skills/daily-planning-ritual
│       └── ...
├── docs/
│   └── plans/                # Design documents for skills
│       └── 2025-11-09-summoning-user-design.md
└── skills/
    ├── daily-planning-ritual/
    │   ├── README.md         # Customization guide
    │   └── SKILL.md          # Skill implementation
    ├── writing-product-specs/
    │   └── SKILL.md
    └── writing-user-stories/
        └── SKILL.md
```

`skills/` is the single canonical copy of every skill. `.agents/skills/` holds only symlinks back into it (read natively by Codex CLI, OpenCode, and Cursor) — never commit real files there.

## Creating a New Skill

Skills should follow this structure:

### 1. Design Document (Optional)

Create `docs/plans/YYYY-MM-DD-topic-design.md` with:
- Overview and purpose
- Decision criteria or workflow
- Implementation details
- Examples

### 2. Skill File (Required)

Create `skills/skill-name/SKILL.md` with:

```markdown
---
name: skill-name
description: Brief description of when to use this skill
---

# Skill Name

## Overview

What this skill does and its core principle.

## When to Use This Skill

Use this skill when:
- Condition 1
- Condition 2

## Process

Step-by-step instructions...
```

Required elements:
- YAML frontmatter with `name` and `description`
- Overview and core principles
- When to use the skill
- Step-by-step process

Optional elements:
- Key principles table
- Anti-patterns
- Examples

### 3. Link into .agents/skills/ (Required)

Run `./sync-agents-skills.sh` to add the `.agents/skills/<name>` symlink for your new skill (and clean up any stale ones). This is what makes the skill discoverable by Codex CLI, OpenCode, and Cursor — commit the symlink, not a copy of the file.

The same script refreshes `rules/`, which mirrors rule sets bundled inside skills so they stay fetchable by raw URL. Edit the copy inside the skill; never edit `rules/` directly. Skills must stay self-contained — single-skill installs use `"source": "./skills/<name>"`, so a symlink out of the skill directory would dangle.

### 4. Update Marketplace (Required)

Add the new skill to `.claude-plugin/marketplace.json`:

```json
{
  "name": "your-skill-name",
  "source": "./skills/your-skill-name",
  "description": "Same description as in SKILL.md frontmatter",
  "version": "1.0.0",
  "author": {
    "name": "Your Name"
  },
  "repository": "https://github.com/britt/claude-code-skills",
  "license": "MIT",
  "keywords": ["keyword1", "keyword2"],
  "category": "workflow|productivity|documentation",
  "tags": ["tag1", "tag2"]
}
```

New skills are picked up automatically by the Codex/Cursor full-bundle plugins (they reference the whole `skills/` directory) — no per-skill entry needed there. Granular per-skill installs are currently a Claude Code-only feature.

### 5. Bumping the Bundle Version (Required when releasing)

The full-bundle skill archive is described in four places that must stay in lockstep: `.claude-plugin/plugin.json`, `.codex-plugin/plugin.json`, `.cursor-plugin/plugin.json`, and the `claude-code-skills` entry in `.claude-plugin/marketplace.json`. The `project-foundations` bundle has the same set under `bundles/project-foundations/`.

## Building Skill Archives

To create zip archives of all skills for distribution:

```bash
./package.sh
```

This creates a `dist/` directory containing zip files for each skill (e.g., `dist/writing-user-stories.zip`).

## Testing Skills

Before submitting:
1. Install the skill locally
2. Test with Claude Code or Claude.ai
3. Verify the skill triggers correctly based on its description
4. Check that all instructions are clear and actionable

## Pull Request Guidelines

1. One skill per PR (unless they're closely related)
2. Include a brief description of what the skill does
3. Explain how you tested it
4. Update the README if adding a new skill
