---
name: sgai-goal
description: Use when starting a new feature, project, or bug fix in a repository that uses SGAI - interactively composes a GOAL.md with agent flow graph, model preferences, completion gate, and outcome-based success criteria
---

# SGAI Goal Authoring

Compose GOAL.md files for SGAI workspaces through interactive conversation.

## When to Use

- User says "start a new feature/project/fix"
- User describes work to be done in an SGAI-managed repo
- User asks to "create a goal" or "set up SGAI"

## Process

### 0. Verify SGAI Is in Use

Check for an `.sgai/` directory or other SGAI configuration in the repository. If absent, stop and ask the user whether this repo actually uses SGAI before proceeding.

### 1. Detect Tech Stack

Scan the repository for files and choose appropriate agents:

| Detection | Stack | Developer Agent | Reviewer Agent |
|-----------|-------|-----------------|----------------|
| `go.mod` | Go backend | backend-go-developer | go-readability-reviewer |
| `package.json` + react deps | React | react-developer | react-reviewer |
| `package.json` + htmx deps | HTMX | htmx-picocss-frontend-developer | htmx-picocss-frontend-reviewer |
| `*.sh`, `Makefile`, or CLI tool | Shell | shell-script-coder | shell-script-reviewer |
| `wrangler.toml` | Cloudflare Worker | general-purpose | cloudflare-worker-deployer |
| `vercel.json` or Next.js | Vercel | react-developer | vercel-deployer |
| Python + Claude SDK | Agent SDK | general-purpose | agent-sdk-verifier-py |
| TypeScript + Claude SDK | Agent SDK | general-purpose | agent-sdk-verifier-ts |
| Python + OpenAI SDK | OpenAI Agent | general-purpose | openai-sdk-verifier-py |
| TypeScript + OpenAI SDK | OpenAI Agent | general-purpose | openai-sdk-verifier-ts |
| None detected | General | general-purpose | — |

Multiple stacks combine (e.g., Go + React = both agent chains). See [agents-reference.md](agents-reference.md) for the full agent catalog and additional flow-graph variants.

### 2. Load or Ask Model Preferences

Check `.sgai/preferences.json` for saved preferences:

```json
{
  "models": {
    "coordinator": "anthropic/claude-opus-4-6 (max)",
    "default": "anthropic/claude-opus-4-6"
  }
}
```

If no preferences exist, ask:
> "What model should I use for SGAI agents? (e.g., anthropic/claude-opus-4-6)"

Save response to `.sgai/preferences.json` for future use.

### 3. Ask for Goal Description

Ask conversationally:
> "What do you want to accomplish?"

Listen for:
- **Feature**: "add", "build", "create", "implement"
- **Fix**: "bug", "fix", "broken", "error", "issue"
- **Project**: "new project", "set up", "initialize"

If unclear, ask:
> "Is this a new feature, a bug fix, or a new project?"

### 4. Draft Success Criteria

Transform the description into outcome-based success criteria:

**User says:** "Add user authentication with OAuth"

**Draft as:**
```markdown
- [ ] Users can sign in with OAuth providers
- [ ] Authenticated sessions persist across browser restarts
- [ ] Unauthenticated users are redirected to login
```

**Do NOT write implementation steps** like ~~Install passport.js~~, ~~Create auth middleware~~, ~~Add login route~~.

Ask: "Does this capture what success looks like?"

### 5. Build Flow Graph

Compose flow based on detected stack. Core pattern: `developer -> reviewer -> stpa-analyst`

**Go + React (full stack) example:**
```yaml
flow: |
  "backend-go-developer" -> "go-readability-reviewer"
  "go-readability-reviewer" -> "stpa-analyst"
  "react-developer" -> "react-reviewer"
  "react-reviewer" -> "stpa-analyst"
```

More flow variants (single-stack, shell/CLI, architecture documentation, general) are in [agents-reference.md](agents-reference.md).

Always include `stpa-analyst` as terminal node for safety analysis (except pure documentation flows).

### 6. Detect Completion Gate

| File | Gate Script |
|------|-------------|
| `go.mod` | `go test ./...` |
| `package.json` with test script | `npm test` |
| `Makefile` with test target | `make test` |
| None | Omit `completionGateScript` |

### 7. Show Preview

Display the complete GOAL.md and ask:
> "Here's the goal file. Ready to write it?"

### 8. Backup and Write

If `GOAL.md` exists:
1. Rename to `GOAL.md.YYYY-MM-DD-HHMMSS.bak`
2. Inform user of backup

Write new `GOAL.md` to repository root.

## GOAL.md Format

```yaml
---
flow: |
  "agent-a" -> "agent-b"
  "agent-b" -> "stpa-analyst"
models:
  "coordinator": "anthropic/claude-opus-4-6 (max)"
  "agent-a": "anthropic/claude-opus-4-6"
  "agent-b": "anthropic/claude-opus-4-6"
  "stpa-analyst": "anthropic/claude-opus-4-6"
interactive: yes
completionGateScript: go test ./...
---

Brief description of the goal in 1-2 sentences.

## Success Criteria

- [ ] Outcome-based criterion 1
- [ ] Outcome-based criterion 2
- [ ] Outcome-based criterion 3
```

## File References

To include context like screenshots or specs, add files to the repo and reference them:

```markdown
See `docs/mockup.png` for the desired layout.
Refer to `specs/api.md` for endpoint requirements.
```

## Common Mistakes

- **Implementation steps as success criteria** — criteria must describe outcomes ("users can sign in"), not tasks ("add login route")
- **Omitting stpa-analyst** — always include it as the terminal reviewer, except in pure documentation flows
- **Overwriting an existing GOAL.md without backup** — always rename the old file to `GOAL.md.YYYY-MM-DD-HHMMSS.bak` first

## Decisions Made by This Skill

- **Interactive mode**: Always `yes` (agents ask clarifying questions)
- **stpa-analyst**: Always included as terminal reviewer
- **Preferences location**: `.sgai/preferences.json` in project
- **Backup naming**: `GOAL.md.YYYY-MM-DD-HHMMSS.bak`
- **Success criteria style**: Outcome-based, not implementation steps
