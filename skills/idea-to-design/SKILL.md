---
name: idea-to-design
description: Use when asked to turn an idea note into a design document, plan an idea, or make an idea real - autonomously researches the idea and produces Design.md, Decisions.md, and Research.md in an Ideas/<Idea Name>/ folder, asking zero questions
---

# Idea to Design

Transform raw idea notes into comprehensive design documents autonomously.

**Prerequisites/Context:** Operates on an Obsidian vault (or any markdown folder) containing an `Ideas/` folder; if no Ideas/ folder is found, ask the user for the vault path.

## When to Use

Activate when asked to:
- Turn an idea note into a design
- Plan an idea or "make an idea real"

**Not for** features in an existing codebase — use `writing-product-specs` or a brainstorming skill instead.

## Process

1. **Read the idea note** - Understand what's being proposed
2. **Create folder** - Inside the Ideas folder, create a subfolder named after the idea
3. **Move original** - Move the original idea note into the new folder
4. **Research** - Investigate unknowns, find relevant information, explore feasibility
5. **Write design doc** - Answer: What is it? Who is it for? How does it work? Where is it deployed?
6. **Document decisions** - Create explicit Decisions.md listing choices made and reasoning

## Required Outputs

All files go in `Ideas/<Idea Name>/`:

| File | Purpose |
|------|---------|
| `<Original>.md` | The original idea note (moved here) |
| `Design.md` | Comprehensive design document |
| `Decisions.md` | Explicit list of decisions with reasoning |
| `Research.md` | Sources consulted, findings, and references |

## Autonomy

**Ask zero questions.** Make reasonable decisions and document them. If something is unclear:
- State the assumption
- Make a choice
- Document it in Decisions.md

## Design Doc Should Answer

- Is it software, hardware, or a service?
- Who is the target audience?
- How will it work technically?
- Where will it be deployed/run?
- What's the business model (if applicable)?
- What are the risks and mitigations?
- What are the next steps?

## Diagrams

**Use Mermaid for all diagrams.** Obsidian renders Mermaid natively.

- Architecture diagrams: `flowchart TB` or `flowchart LR`
- Sequences: `sequenceDiagram`
- Data flow: `flowchart` with subgraphs
- State machines: `stateDiagram-v2`

Never use ASCII art.

## Research.md Should Include

- Questions that needed answering
- Sources consulted (web searches, docs, etc.)
- Key findings that informed the design
- Gaps that couldn't be filled

## Decisions.md Format

```markdown
# Decisions

## <Decision Title>
**Choice:** What was decided
**Alternatives:** What else was considered
**Reasoning:** Why this choice was made
```

## Common Mistakes

- **Writing Design.md before Research.md**: Research must inform the design — complete and record the research first, then write the design document based on its findings.