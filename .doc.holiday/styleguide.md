# Claude Code Skills - Project Styleguide

## Project Overview

**Claude Code Skills** is a collection of reusable skills and prompts for Claude that enhance AI-assisted software development workflows. The project serves dual purposes:

1. **Skill Library** - Distributable skill definitions that can be installed into Claude Code or Claude.ai
2. **Documentation Site** - A GitHub Pages site that showcases and documents the available skills

**Key Details:**
- **Version:** 1.2.0
- **License:** MIT
- **Repository:** https://github.com/britt/claude-code-skills
- **Live Site:** https://britt.github.io/claude-code-skills/

---

## Directory Structure

```
claude-code-skills/
├── README.md                    # Main installation and usage guide
├── CONTRIBUTING.md              # Contribution guidelines
├── LICENSE                      # MIT license
├── package.sh                   # Script to package skills as zip archives
│
├── .claude-plugin/              # Plugin marketplace configuration
│   └── marketplace.json         # Defines this repo as a Claude Code plugin
│
├── .context/                    # Internal context tracking (gitignored)
│
├── .github/workflows/           # CI/CD automation
│   ├── hugo.yml                 # Builds Hugo site and deploys to Pages
│   └── static.yml               # Alternative static deployment
│
├── docs/plans/                  # Design documents and planning notes
│
├── rules/                       # Reusable rulesets
│   └── TDD.rules.md             # Test-Driven Development rules
│
├── skills/                      # SKILL DEFINITIONS (source of truth)
│   ├── daily-planning-ritual/
│   ├── setting-up-a-project/
│   ├── writing-product-specs/
│   ├── writing-user-stories/
│   └── writing-verification-plans/
│
└── site/                        # GITHUB PAGES SITE (Hugo)
    ├── hugo.toml                # Hugo configuration
    ├── content/                 # Markdown pages for the site
    ├── layouts/                 # Custom Hugo templates
    ├── themes/paper/            # Hugo theme (git submodule)
    └── public/                  # Built output (gitignored)
```

---

## Key Directory Explanations

### `/skills/` - Skill Definitions

This is the **source of truth** for all skills. Each skill lives in its own subdirectory containing:

- `SKILL.md` - The skill definition that Claude reads and executes
- `README.md` (optional) - Additional documentation or customization notes

**Available Skills:**
| Skill | Purpose |
|-------|---------|
| `sgai-goal` | Composes GOAL.md files for SGAI workspaces |
| `setting-up-a-project` | Authors CLAUDE.md project documentation |
| `working-on-an-issue` | Implements a GitHub issue with a verification-driven approach |
| `project-analysis` | Analyzes project codebase structure, architecture, and dependencies |
| `project-planning` | Orchestrates end-to-end project planning |
| `issue-decomposition` | Decomposes projects into well-structured GitHub issues |
| `dependency-mapping` | Generates Mermaid dependency graphs for issues |
| `timeline-planning` | Generates Mermaid Gantt charts for project timelines |
| `requirement-elicitation` | Conversational wizard for eliciting requirements |
| `idea-to-design` | Turns an idea note into a design document |
| `writing-product-specs` | Creates comprehensive product specifications |
| `writing-user-stories` | Generates properly formatted user stories (INVEST, Given-When-Then) |
| `writing-verification-plans` | Creates acceptance testing procedures |
| `context-aware-questions` | Identifies information gaps and generates questions |
| `at-risk-detection` | Identifies at-risk issues and PRs |
| `triage-new-issues` | Reviews and prioritizes new GitHub issues |
| `stakeholder-tracking` | Tracks stakeholder personas and goals |
| `stakeholder-updates` | Crafts stakeholder communications |
| `prepare-meeting-agenda` | Generates meeting agendas from issues and PRs |
| `architecture-diagramming` | Generates Mermaid architecture diagrams |
| `mermaid-diagrams` | Guide for syntactically correct Mermaid diagrams |
| `markdown-formatting` | Formats AI outputs into consistent Markdown |
| `build-faq-from-issues` | Extracts an FAQ from closed GitHub issues |
| `summarize-conversation-thread` | Summarizes GitHub issue/PR threads |
| `consolidate-notes-summary` | Synthesizes findings across multiple notes |
| `research-topic-summarize` | Researches topics via web search |
| `daily-planning-ritual` | Interactive morning planning across life dimensions |

Also see `bundles/project-foundations/` — a curated bundle plugin that groups related skills (setup, issue decomposition, user stories, verification plans, and diagrams) via symlinks back to the canonical `skills/` directories.

### `/site/` - GitHub Pages Site

The documentation website built with **Hugo** static site generator.

**Important:** The `/site/` directory is entirely separate from `/skills/`. The site documents the skills but doesn't define them.

---

## GitHub Pages Site Structure

### Location

All GitHub Pages content lives under `/site/`:

```
site/
├── hugo.toml           # Site configuration (base URL, theme, params)
├── content/            # Markdown content (becomes HTML pages)
│   ├── _index.md       # Homepage
│   ├── docs/           # Documentation section
│   │   └── _index.md   # Installation guide
│   └── skills/         # Individual skill pages
│       ├── _index.md   # Skills listing
│       └── *.md        # One page per skill
├── layouts/
│   └── index.html      # Custom homepage template
└── themes/paper/       # Hugo Paper theme (git submodule)
```

### Hugo Configuration

From `site/hugo.toml`:
- **Base URL:** `https://britt.github.io/claude-code-skills/`
- **Theme:** Paper (`hugo-paper`)
- **Theme Color:** Linen

### Content Organization

| Path | URL | Purpose |
|------|-----|---------|
| `content/_index.md` | `/` | Homepage with skills table |
| `content/docs/_index.md` | `/docs/` | Installation instructions |
| `content/skills/_index.md` | `/skills/` | Skills listing page |
| `content/skills/*.md` | `/skills/<name>/` | Individual skill documentation |

### Deployment

GitHub Actions workflow (`.github/workflows/hugo.yml`) automatically:
1. Builds the Hugo site with `hugo --minify`
2. Deploys to GitHub Pages

Built files go to `site/public/` (gitignored).

---

## Plugin Marketplace

The `.claude-plugin/marketplace.json` file configures this repository as a Claude Code plugin marketplace, allowing installation via:

```bash
/plugin marketplace add britt/claude-code-skills
```

---

## Distribution Methods

1. **Claude Code Marketplace** - Primary method using plugin system
2. **Manual Installation** - Clone to `~/.claude/skills/`
3. **Project-specific** - Clone to `.claude/skills/` in a project
4. **Claude.ai** - Upload zip files (created by `package.sh`) to project knowledge

---

## Key Distinctions

| Aspect | `/skills/` | `/site/` |
|--------|-----------|----------|
| Purpose | Skill definitions (executable) | Documentation (readable) |
| Format | SKILL.md files | Hugo content pages |
| Consumers | Claude Code / Claude.ai | Human visitors |
| Deployment | Installed as plugin | GitHub Pages |

The skills in `/skills/` are what Claude actually uses. The site in `/site/` helps humans discover, understand, and install those skills.
