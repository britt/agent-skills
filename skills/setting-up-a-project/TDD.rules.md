# Rules for the Coding Agent

> **This file is a template.** Every `{{PLACEHOLDER}}` must be replaced with a real
> value before it lands in a project. A shipped `{{TEST_COMMAND}}` is a bug.
>
> Referenced by `CLAUDE.md` and `AGENTS.md`. It applies to every agent working in
> the repo, whichever entry file brought you here.

## ABSOLUTE RULES - NO EXCEPTIONS

### 1. Test-Driven Development is MANDATORY

**The Iron Law**: NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST

Every single line of production code MUST follow this cycle:
1. **RED**: Write failing test FIRST
2. **Verify RED**: Run test, watch it fail for the RIGHT reason
3. **GREEN**: Write MINIMAL code to pass the test
4. **Verify GREEN**: Run test, confirm it passes
5. **REFACTOR**: Clean up with tests staying green

### 2. Violations = Delete and Start Over

If ANY of these occur, you MUST delete the code and start over:
- ❌ Wrote production code before test → DELETE CODE, START OVER
- ❌ Test passed immediately → TEST IS WRONG, FIX TEST FIRST
- ❌ Can't explain why test failed → NOT TDD, START OVER
- ❌ "I'll add tests later" → DELETE CODE NOW
- ❌ "Just this once without tests" → NO. DELETE CODE.
- ❌ "It's too simple to test" → NO. TEST FIRST.
- ❌ "Tests after achieve same goal" → NO. DELETE CODE.

### 3. Test Coverage Requirements

- **Minimum {{COVERAGE_THRESHOLD}}%** coverage on ALL metrics:
  - Lines: {{COVERAGE_THRESHOLD}}%+
  - Functions: {{COVERAGE_THRESHOLD}}%+
  - Branches: {{BRANCH_COVERAGE_THRESHOLD}}%+
  - Statements: {{COVERAGE_THRESHOLD}}%+
- Coverage below threshold = Implementation incomplete
- Untested code = Code that shouldn't exist

### 4. Implementation Order

If the project has an `IMPLEMENTATION_PLAN.md`, follow its tasks in EXACT order.

### 5. Before Writing ANY Code

Ask yourself:
1. Did I write a failing test for this?
2. Did I run the test and see it fail?
3. Did it fail for the expected reason?

If ANY answer is "no" → STOP. Write the test first.

### 6. Test File Structure

For every production file, there MUST be a corresponding test file. This project's
convention:

{{TEST_FILE_CONVENTION}}

### 7. Task Completion Requirements

**MANDATORY RULE**: NO TASK IS COMPLETE until:
- ✅ ALL tests pass (100% green)
- ✅ Build succeeds with ZERO errors
- ✅ NO linter errors or warnings
- ✅ Coverage meets minimum thresholds ({{COVERAGE_THRESHOLD}}%+)
- ✅ Progress documented in PROGRESS.md
- ✅ Work committed, following the Git Commit Rules in CLAUDE.md / AGENTS.md

A task with failing tests, build errors, or linter warnings is INCOMPLETE. Period.

### 8. Progress Documentation

**MANDATORY RULE**: YOU MUST REPORT YOUR PROGRESS IN `PROGRESS.md`

After completing EACH task:
1. Create `PROGRESS.md` if it doesn't exist
2. Document:
   - Task completed
   - Tests written/passed
   - Coverage achieved
   - Any issues encountered
   - Timestamp

Format:
```markdown
## Task X: [Name] - [COMPLETE/IN PROGRESS]
- Started: [timestamp]
- Tests: X passing, 0 failing
- Coverage: Lines: X%, Functions: X%, Branches: X%, Statements: X%
- Build: ✅ Successful / ❌ Failed
- Linting: ✅ Clean / ❌ X errors
- Completed: [timestamp]
- Notes: [any relevant notes]
```

## Development Workflow

For EACH feature/function:

```
1. Write test file or add test case
2. Run: {{TEST_COMMAND}}
3. See RED (test fails)
4. Understand WHY it fails
5. Write minimal production code
6. Run: {{TEST_COMMAND}}
7. See GREEN (test passes)
8. Refactor if needed
9. Run: {{TEST_COMMAND}} (stays green)
10. Check coverage: {{COVERAGE_COMMAND}}
11. Commit (see the Git Commit Rules in CLAUDE.md / AGENTS.md)
12. Repeat for next feature
```

## Commands You'll Use Constantly

```bash
# Watch mode - keep this running ALWAYS
{{TEST_WATCH_COMMAND}}

# Run once
{{TEST_COMMAND}}

# Check coverage
{{COVERAGE_COMMAND}}

# Build - MUST succeed before task is complete
{{BUILD_COMMAND}}

# Check for Linter errors
{{LINT_COMMAND}}
```

## Red Flags - STOP Immediately

If you catch yourself:
- Opening a code file before a test file
- Writing function implementation before test
- Thinking "I know this works"
- Copying code from examples without tests
- Skipping test runs
- Ignoring failing tests
- Writing multiple features before testing

**STOP. DELETE. START WITH TEST.**

## The Mindset

- Tests are not optional
- Tests are not added after
- Tests DRIVE the implementation
- If it's not tested, it doesn't exist
- Coverage below {{COVERAGE_THRESHOLD}}% = unfinished work

## Accountability Check

Before marking ANY task complete, verify:
1. ✓ Test written first?
2. ✓ Test failed first?
3. ✓ Minimal code to pass?
4. ✓ All tests green?
5. ✓ Coverage maintained ({{COVERAGE_THRESHOLD}}%+)?
6. ✓ Build succeeds (`{{BUILD_COMMAND}}`)?
7. ✓ No linter errors?
8. ✓ Progress documented in PROGRESS.md?
9. ✓ Work committed?

Missing ANY ✓ = Task is NOT complete. Fix it first.

## Final Rule

**When in doubt**: Write a test.
**When not in doubt**: Write a test anyway.
**When it seems too simple**: Especially write a test.

There are NO exceptions to TDD in this project. None.

---

*This document is your contract. Breaking these rules means breaking the project's core quality commitment. The discipline of TDD is what separates professional, reliable code from hopeful guesswork.*
