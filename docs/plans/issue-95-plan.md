# Implementation Plan — Issue #95: record the model, harness, and skill version in the Estimate section

## What changes

1. `skills/estimating-work-items/SKILL.md`
   - Frontmatter: add `metadata:` with `version: "1.2.0"`.
   - Step 6, Record the estimate: the Estimate section ends with an `Estimated by:` line.
   - Estimate section contract: define the provenance line (format, model, harness, skill version, human case, parsing rule, replace on re-estimate) and add it to the issue, epic, and not-yet-estimated examples.
   - Anti-patterns: add a row on guessing the model or harness version.
   - Worked Example: the Record step mentions the line.
2. `check-versions.sh`: for every `./skills/*` plugin entry whose `SKILL.md` declares `metadata.version`, compare it with the marketplace entry's version and fail on a mismatch. Skills that declare no version are skipped.
3. `CONTRIBUTING.md`: document that a skill's frontmatter `metadata.version` is bumped together with its marketplace entry.
4. `site/content/skills/estimating-work-items.md`: mention the provenance line under "Recorded where tools can read it".
5. `skills/issue-decomposition/SKILL.md`: add the `Estimated by:` line to its issue-body template (see Assumptions).
6. Version bumps: estimating-work-items 1.1.0 → 1.2.0, issue-decomposition 1.3.0 → 1.4.0, agent-skills 6.4.0 → 6.5.0, project-foundations 2.5.0 → 2.6.0, llpm 1.5.0 → 1.6.0, chat 1.2.0 → 1.3.0 (each bundle that carries estimating-work-items or issue-decomposition, in all of its manifests).

## Order

1. `check-versions.sh` first, test-first: add the SKILL.md check, add `metadata.version: "9.9.9"` and watch it fail, then set the real version and watch it pass.
2. Skill text, then issue-decomposition template, then docs, then version bumps.
3. Run the verification plan.

## Assumptions

- **`metadata.version`, not a top-level `version`.** The issue left this open. Both the Claude and Codex `skill-creator` validators (`quick_validate.py`) reject unknown top-level keys and allow `metadata`, so the version lives at `metadata.version`. It is quoted so YAML keeps it as a string, as the Agent Skills spec expects for `metadata` values.
- **issue-decomposition's template gets the line too.** It copies the Estimate section contract into its own issue-body template, and it writes most estimated issues. Without the line there, issues produced through decomposition would lack provenance, contradicting the issue's first acceptance criterion. This is one template line plus a version bump.
- **Humans keep the skill version.** The contract example in the issue shows `Estimated by: human (@britt), estimating-work-items 1.2.0`, so the skill version stays on human estimates recorded through the skill.
- **Model IDs drop context-window suffixes** (added during verification). The test agent's model ID was `claude-opus-5-5[1m]`, and the skill didn't say whether `[1m]` belongs in the line. It is a context variant of the same model, so the skill now says to drop it.
- **No repo CLAUDE.md.** The repo has none; setting one up is out of scope for this issue.
- Work happens on the Conductor-provided branch rather than a new `issue-95-*` branch, because Conductor tracks the checked-out branch.

## Risks

- Parsing YAML frontmatter in bash: kept to a narrow awk match on the `metadata:` block's `version:` key, which is all this repo uses.
