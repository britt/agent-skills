# SGAI Agents Reference

Full catalog of SGAI agents and additional flow-graph variants for GOAL.md composition.

## Available Agents

### Development Agents
| Agent | Use For |
|-------|---------|
| backend-go-developer | Go APIs, CLIs, services |
| react-developer | React frontends |
| htmx-picocss-frontend-developer | Lightweight HTMX + PicoCSS UIs |
| shell-script-coder | Shell scripts, CLI tools |
| general-purpose | Multi-domain tasks, Python, other languages |
| webmaster | Marketing sites, landing pages |

### Review Agents
| Agent | Use For |
|-------|---------|
| go-readability-reviewer | Go code style and idioms |
| react-reviewer | React code review |
| htmx-picocss-frontend-reviewer | HTMX/Pico visual consistency |
| shell-script-reviewer | Shell script correctness |
| stpa-analyst | Safety/hazard analysis (terminal node) |
| project-critic-council | Multi-model consensus evaluation |
| cli-output-style-adjuster | Unix-philosophy CLI compliance |

### Verification Agents
| Agent | Use For |
|-------|---------|
| agent-sdk-verifier-py | Validate Python Claude Agent SDK apps |
| agent-sdk-verifier-ts | Validate TypeScript Claude Agent SDK apps |
| openai-sdk-verifier-py | Validate Python OpenAI Agents SDK apps |
| openai-sdk-verifier-ts | Validate TypeScript OpenAI Agents SDK apps |

### Deployment Agents
| Agent | Use For |
|-------|---------|
| cloudflare-worker-deployer | Deploy Cloudflare Workers |
| vercel-deployer | Deploy to Vercel |
| exe-dev-deployer | Deploy executable dev environments |

### Documentation Agents (C4 Model)
| Agent | Use For |
|-------|---------|
| c4-code | Code-level documentation with Mermaid |
| c4-component | Logical component architecture |
| c4-container | Deployment units and containers |
| c4-context | High-level system context diagrams |

### Meta Agents
| Agent | Use For |
|-------|---------|
| coordinator | Workflow orchestration (implicit) |
| skill-writer | Create validated SGAI skills |
| snippet-writer | Create reusable code snippets |
| retrospective | Analyze completed sessions |

## Special-Purpose Agents (add when relevant)

- `c4-code`, `c4-component`, `c4-container`, `c4-context` - Architecture documentation
- `skill-writer` - Creating SGAI skills
- `snippet-writer` - Reusable code patterns
- `webmaster` - Marketing sites and landing pages
- `project-critic-council` - Multi-model consensus review

## Flow Graph Variants

**Go backend:**
```yaml
flow: |
  "backend-go-developer" -> "go-readability-reviewer"
  "go-readability-reviewer" -> "stpa-analyst"
```

**React frontend:**
```yaml
flow: |
  "react-developer" -> "react-reviewer"
  "react-reviewer" -> "stpa-analyst"
```

**HTMX frontend:**
```yaml
flow: |
  "htmx-picocss-frontend-developer" -> "htmx-picocss-frontend-reviewer"
  "htmx-picocss-frontend-reviewer" -> "stpa-analyst"
```

**Shell/CLI tools:**
```yaml
flow: |
  "shell-script-coder" -> "shell-script-reviewer"
  "shell-script-reviewer" -> "stpa-analyst"
```

**Python/general with shell:**
```yaml
flow: |
  "general-purpose" -> "stpa-analyst"
  "shell-script-coder" -> "shell-script-reviewer"
  "shell-script-reviewer" -> "stpa-analyst"
```

**Architecture documentation:**
```yaml
flow: |
  "c4-code" -> "c4-component"
  "c4-component" -> "c4-container"
  "c4-container" -> "c4-context"
```

**General (no stack detected):**
```yaml
flow: |
  "general-purpose" -> "stpa-analyst"
```
