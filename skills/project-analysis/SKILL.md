---
name: project-analysis
description: "Analyze project codebase structure, architecture, key files, and dependencies using scan and filesystem tools"
instructions: "When analyzing a project's codebase structure, understanding its architecture, or mapping key files and dependencies"
tags:
  - analysis
  - architecture
  - codebase
  - project-management
allowed-tools: "scan_project get_project_scan read_project_file list_project_directory"
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

## Available Tools

| Tool | Purpose |
|------|---------|
| `scan_project` | Scan codebase for file counts, languages, structure |
| `get_project_scan` | Retrieve cached scan results |
| `read_project_file` | Read specific files for deeper analysis |
| `list_project_directory` | Explore directory structure |

## Analysis Workflow

### Step 1: Initial Scan

Use `scan_project` to get a high-level overview:
- Total files and lines of code
- Languages detected and their distribution
- File type breakdown
- Directory structure overview

If a recent scan exists, use `get_project_scan` to retrieve cached results instead of rescanning.

### Step 2: Understand Project Type

Based on scan results, identify the project type:

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

Use `read_project_file` to examine critical files:

**Always check:**
- `README.md` - Project purpose and documentation
- `package.json` / `Cargo.toml` / `pyproject.toml` - Dependencies and metadata

**Check if they exist:**
- `tsconfig.json` / `vite.config.ts` / `webpack.config.js` - Build configuration
- `Dockerfile` / `docker-compose.yml` - Container setup
- `.env.example` - Environment variables
- `CONTRIBUTING.md` - Development workflow

### Step 4: Explore Architecture

Use `list_project_directory` to understand the directory layout:

1. List the root directory to see top-level structure
2. List key directories (src/, lib/, app/, etc.) to understand component organization
3. Identify architectural patterns:

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

## Output Format

Present analysis in this structure:

```markdown
## Project Analysis: [Name]

### Overview
- **Type**: [Web app / API / CLI / Library / etc.]
- **Primary Language**: [language] (X%)
- **Secondary Languages**: [languages]
- **Total Files**: X
- **Total Lines**: X

### Architecture
- **Pattern**: [MVC / Layered / Feature-based / etc.]
- **Key Directories**:
  - `src/commands/` - CLI command implementations
  - `src/services/` - Business logic layer
  - `src/tools/` - AI tool definitions
  - `src/utils/` - Shared utilities

### Key Files
| File | Purpose |
|------|---------|
| `index.ts` | Application entry point |
| `package.json` | Dependencies and scripts |
| `tsconfig.json` | TypeScript configuration |

### Dependencies
- **Package Manager**: [npm/yarn/pnpm]
- **Runtime** (X packages): [key ones listed]
- **Development** (Y packages): [key ones listed]

### Observations
- [Notable patterns or concerns]
- [Suggested improvements]
```

## Analysis Depth Levels

### Quick Overview
1. `get_project_scan` or `scan_project`
2. Present file count, languages, and structure summary

### Standard Analysis
1. Scan project
2. Read README and dependency file
3. List key directories
4. Present full analysis

### Deep Dive
1. Scan project
2. Read all key configuration files
3. Explore all major directories
4. Read entry points and core modules
5. Present comprehensive analysis with architecture diagram suggestions

## Best Practices

1. **Start with cached data**: Use `get_project_scan` first; only `scan_project` if no cache exists
2. **Read before concluding**: Don't guess architecture from file names alone; read key files
3. **Be specific**: Name actual files and directories, don't generalize
4. **Suggest next steps**: After analysis, recommend architecture diagramming or dependency mapping
5. **Note concerns**: Flag large files, missing docs, or unusual patterns
