---
name: project-analysis
description: "Use when starting work on an unfamiliar codebase or asked to 'analyze this project' - maps structure, project type, architecture pattern, key files, and dependencies into a standard report"
---

# Project Analysis Skill

Perform comprehensive analysis of a project codebase to understand its structure, architecture, key files, and dependencies.

## When to Use

Activate when:
- User asks "analyze this project" or "what does this codebase look like?"
- Starting work on an unfamiliar codebase
- Reviewing project architecture before making changes
- Generating documentation about project structure
- Understanding dependency landscape

**When NOT to use**: For questions about a single file or feature, just read the relevant file directly — a full analysis is overkill.

## Analysis Workflow

### Step 1: Survey the Codebase

Build a high-level overview using standard filesystem operations:

1. List the directory tree with `ls` or Glob to see top-level structure
2. Read manifest files to identify the stack: `package.json`, `go.mod`, `pyproject.toml`, `Cargo.toml`, `Gemfile`, `pom.xml`, etc.
3. If useful, count files by extension to gauge language distribution, e.g. `find . -name '*.ts' -not -path '*/node_modules/*' | wc -l`

### Step 2: Understand Project Type

Based on what the survey found, identify the project type:

| Indicator | Project Type |
|-----------|-------------|
| package.json + React/Next.js | Web application |
| package.json + Express/Fastify | API server |
| Cargo.toml | Rust project |
| pyproject.toml / setup.py | Python project |
| go.mod | Go project |
| Dockerfile + docker-compose | Containerized service |
| index.ts + bin/ | CLI tool |

### Step 3: Read Key Files

Examine critical files:

**Always check:**
- `README.md` - Project purpose and documentation
- `package.json` / `Cargo.toml` / `pyproject.toml` - Dependencies and metadata

**Check if they exist:**
- `tsconfig.json` / `vite.config.ts` / `webpack.config.js` - Build configuration
- `Dockerfile` / `docker-compose.yml` - Container setup
- `.env.example` - Environment variables
- `CONTRIBUTING.md` - Development workflow

### Step 4: Explore Architecture

List key directories (src/, lib/, app/, etc.) to understand component organization, then identify architectural patterns:

| Pattern | Indicators |
|---------|-----------|
| MVC | controllers/, models/, views/ directories |
| Layered | services/, repositories/, handlers/ |
| Feature-based | Feature directories with co-located files |
| Monorepo | packages/ or apps/ directories |
| Microservices | Multiple service directories with own configs |

### Step 5: Analyze Dependencies

Read the dependency file to understand:
- **Runtime dependencies**: Core libraries the project relies on
- **Dev dependencies**: Build tools, test frameworks, linters
- **Package manager**: npm, yarn, pnpm, cargo, pip, etc.
- **Dependency count**: Overall complexity indicator

## Analysis Depth

Scale depth to the request — quick = structure + project type only; deep = all steps plus reading entry points and core modules.

## Output Format

Present analysis in this structure:

```markdown
## Project Analysis: [Name]

### Overview
- **Type**: [Web app / API / CLI / Library / etc.]
- **Primary Language**: [language] (X%)
- **Total Files**: X

### Architecture
- **Pattern**: [MVC / Layered / Feature-based / etc.]
- **Key Directories**:
  - `src/commands/` - CLI command implementations
  - `src/services/` - Business logic layer

### Key Files
| File | Purpose |
|------|---------|
| `index.ts` | Application entry point |
| `package.json` | Dependencies and scripts |

### Dependencies
- **Package Manager**: [npm/yarn/pnpm]
- **Runtime** (X packages): [key ones listed]
- **Development** (Y packages): [key ones listed]

### Observations
- [Notable patterns or concerns]
- [Suggested improvements]
```

## Best Practices

1. **Be specific**: Name actual files and directories, don't generalize
2. **Note concerns**: Flag large files, missing docs, or unusual patterns

## Common Mistakes

- **Don't guess architecture from file names alone** — read key files before concluding
- **Don't include vendored/generated directories** (node_modules, dist, target) in counts or structure
