# Rules for Claude

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

- **Minimum 90%** coverage on ALL metrics:
  - Lines: 90%+
  - Functions: 90%+
  - Branches: 85%+
  - Statements: 90%+
- Coverage below threshold = Implementation incomplete
- Untested code = Code that shouldn't exist

### 4. Implementation Order

Follow the plan tasks listed in @IMPLEMENTATION_PLAN.md in EXACT order.

### 5. Before Writing ANY Code

Ask yourself:
1. Did I write a failing test for this?
2. Did I run the test and see it fail?
3. Did it fail for the expected reason?

If ANY answer is "no" → STOP. Write the test first.

### 6. Test File Structure

For every production file, there MUST be a corresponding test file:
- `src/example.ts` → `src/__tests__/example.test.ts`
- `src/another-example.ts` → `src/__tests__/another-example.test.ts`
- `src/causes_edge_cases.ts` → `src/__tests__/causes_edge_cases.test.ts`

### 7. Task Completion Requirements

**MANDATORY RULE**: NO TASK IS COMPLETE until:
- ✅ ALL tests pass (100% green)
- ✅ Build succeeds with ZERO errors
- ✅ NO linter errors or warnings
- ✅ Coverage meets minimum thresholds (90%+)
- ✅ Progress documented in PROGRESS.md

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

### 9. Git Commits - Commit Early, Commit Often

**MANDATORY RULE**: COMMIT EARLY, COMMIT OFTEN

- **Commit after EACH successful TDD cycle**:
  - ✅ After RED-GREEN-REFACTOR cycle completes
  - ✅ After each test file is created
  - ✅ After each module implementation
  - ✅ After fixing bugs or issues
  - ✅ After updating documentation

- **Frequency Requirements**:
  - Minimum: After each completed subtask
  - Maximum: No more than 30 minutes without a commit
  - Never have more than one feature in a single commit

- **Each commit MUST**:
  - Have failing tests written first
  - Pass all tests
  - Build successfully
  - Have no linter errors
  - Meet coverage requirements (if code was added)
  - Have progress documented
  - Include clear commit message mentioning TDD

- **Commit Message Format**:
  ```
  type(scope): brief description

  - RED: What tests were written first
  - GREEN: What minimal code was added
  - Status: X tests passing, build successful
  - Coverage: X% (if applicable)
  ```

- **Benefits of Frequent Commits**:
  - Easy rollback if something breaks
  - Clear history of TDD progression
  - Smaller, reviewable changes
  - Proof of TDD discipline

## Development Workflow

For EACH feature/function:

```
1. Write test file or add test case
2. Run: <test command>
3. See RED (test fails)
4. Understand WHY it fails
5. Write minimal production code
6. Run: <test command>
7. See GREEN (test passes)
8. Refactor if needed
9. Run: <test command> (stays green)
10. Check coverage: <coverage command>
11. Repeat for next feature
```

## Commands You'll Use Constantly

```bash
# Watch mode - keep this running ALWAYS
<test command>

# Run once
<test command>

# Check coverage
<coverage command>

# Build - MUST succeed before task is complete
<build command>

# Check for Linter errors
<linter command>
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
- Coverage below 90% = unfinished work

## Accountability Check

Before marking ANY task complete, verify:
1. ✓ Test written first?
2. ✓ Test failed first?
3. ✓ Minimal code to pass?
4. ✓ All tests green?
5. ✓ Coverage maintained (90%+)?
6. ✓ Build succeeds (`<build command>`)?
7. ✓ No linter errors?
8. ✓ Progress documented in PROGRESS.md?

Missing ANY ✓ = Task is NOT complete. Fix it first.

## Final Rule

**When in doubt**: Write a test.
**When not in doubt**: Write a test anyway.
**When it seems too simple**: Especially write a test.

There are NO exceptions to TDD in this project. None.

---

*This document is your contract. Breaking these rules means breaking the project's core quality commitment. The discipline of TDD is what separates professional, reliable code from hopeful guesswork.*