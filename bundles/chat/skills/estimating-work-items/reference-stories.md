# Reference Stories

Generic reference stories for the powers-of-two scale in `estimating-work-items`. Use these when the target repo has no `docs/estimation/reference-stories.md` of its own. Each entry says what made it that size, because the traits are what you compare against, not the feature.

Triangulate: pick one story slightly smaller than your item and one slightly larger, then decide which it is closer to.

## 1 point

| Story | Why it is a 1 |
|---|---|
| Fix a typo or wording in a CLI help string and its snapshot test | One file, one assertion, nothing to decide |
| Bump a minor dependency version with a green test suite | Mechanical; the only work is running CI |
| Add a missing index on a column that is already queried, with a migration | One migration, known pattern, no data transformation |

## 2 points

| Story | Why it is a 2 |
|---|---|
| Add a `--verbose` flag to an existing command that toggles log output already in place | One command file, one flag, a test per state; no new behaviour |
| Add a required field to an existing form with server-side validation and an error message | Form, handler, validation, three tests; the pattern already exists in the codebase |
| Return a new attribute in an existing JSON endpoint from a column that already exists | Serializer, test, docs line; no query change |

## 4 points

| Story | Why it is a 4 |
|---|---|
| Add a `--json` output mode to an existing command | A second output path plus a public contract for field names and the empty case; stdout and stderr discipline |
| Add a webhook receiver for one event type from a known provider, with signature verification | New endpoint, verification logic, retries to think about, fixture-based tests |
| Add a background job that emails a weekly digest to users who opted in | Job, template, scheduling, opt-in query; one new pattern if there is no job framework yet |

## 8 points

| Story | Why it is an 8 |
|---|---|
| Add a new subcommand with its own store query, output rendering, and flags | New command, new query, new rendering, tests across all three; likely a design question on flags |
| Migrate password reset from a hand-rolled token to a signed, expiring token, keeping old links valid for 24 hours | Security-sensitive, backward compatibility window, migration of live data |
| Add rate limiting to the public API with per-key limits and `Retry-After` headers | Middleware, storage for counters, config, operational concerns, load-tested edge cases |

## Epics

Epics are not sized by comparison. Their points are the exact sum of their child issues, with no rounding and no upper limit. These examples show the shape of a decomposition and the sum it produces.

| Epic | Children and sum |
|---|---|
| Add SAML single sign-on for one tenant | IdP metadata config (4), SP metadata endpoint (2), assertion consumer endpoint (8), SSO-only login setting (1). Sum 15. |
| Replace the client-side search index with a hosted search service | Indexing pipeline (8), query API and client (4), rollout behind a flag (4), removal of the old index (2). Sum 18. |
| Add multi-tenant support to a single-tenant app | Sub-epic: tenant model and scoped data access (tenant table 4, scoping middleware 8, backfill migration 8, cross-tenant leak tests 4; sum 24). Sub-epic: per-tenant billing (billing account model 4, Stripe customer per tenant 8, invoice routing 4; sum 16). Member management UI (8). Sum 24 + 16 + 8 = 48. |

## Not estimable

These are goals, not work. They fail the estimability gate and get a question or a spike, never a number.

| Item | What to do instead |
|---|---|
| "Fix the flaky test suite" | Spike (2): collect two weeks of CI failures, group them by cause, propose one issue per cause |
| "Improve onboarding" | Ask: which step do users drop off at, and what does better look like? |
| "Performance work on the dashboard" | Spike (1): measure the three slowest requests and write up the top cause of each |

## Seeding a repo-local file

Copy the structure above into `docs/estimation/reference-stories.md` and replace the rows with closed issues from the repo, linked by number. Choose issues the team still agrees were that size and that most contributors remember. Keep 15 to 30 entries, and retire ones nobody recognises any more.
