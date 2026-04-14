# Contributing

Guidelines for contributing to this skills repository.

🤷 **Real talk:** Skills are just markdown files and setting up your own marketplace is literally one JSON file. You probably want to make your own repo instead of contributing here. But hey, if you've got improvements to my skills or want to share something cool, I'm happy to post it! PRs welcome. 🎉

## Repository Structure

```
claude-code-skills/
├── README.md                 # Installation and usage guide
├── CONTRIBUTING.md           # This file
├── LICENSE                   # MIT license
├── package.sh                # Build skill zip archives for distribution
├── .claude-plugin/
│   └── marketplace.json      # Plugin marketplace configuration
├── docs/
│   ├── examples/             # Semantic release commit examples
│   └── plans/                # Design documents for skills
├── rules/
│   └── TDD.rules.md         # Reusable TDD rules for CLAUDE.md
├── site/                     # Hugo documentation site
│   ├── hugo.toml
│   └── content/
└── skills/                   # One directory per skill
    ├── daily-planning-ritual/
    │   ├── README.md         # Customization guide
    │   ├── SKILL.md          # Skill implementation
    │   └── .claude-plugin/
    │       └── plugin.json   # Plugin metadata
    ├── sgai-goal/
    │   └── SKILL.md
    ├── summoning-the-user/
    │   └── SKILL.md
    ├── writing-product-specs/
    │   └── SKILL.md
    └── ...                   # 25+ additional skills
```

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

### 3. Update Marketplace (Required)

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

## Building Skill Archives

To create zip archives of all skills for distribution:

```bash
./package.sh
```

This creates a `dist/` directory containing zip files for each skill (e.g., `dist/summoning-the-user.zip`).

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
