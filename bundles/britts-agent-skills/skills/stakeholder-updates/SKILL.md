---
name: stakeholder-updates
description: Use when writing status updates, communicating delays or blockers, announcing launches, or requesting decisions and resources from stakeholders - structures the message by audience level (exec/management/peer/team) with lead-with-the-punchline framing
---

# Stakeholder Updates Skill

This skill helps craft effective communications for stakeholders at various levels.

## When to Use

Activate this skill when:
- Writing status updates or progress reports
- Communicating delays or blockers
- Sharing launch announcements
- Requesting decisions or resources
- Reporting on milestones or outcomes

Do NOT use this skill for technical documentation or commit messages — it is for audience-facing status communication.

## Core Principles

### Know Your Audience

**Executives (C-level):**
- Lead with business impact
- Be concise (3-5 sentences)
- Include metrics and outcomes
- Avoid technical jargon
- Focus on "what" and "why", not "how"

**Management (Directors, VPs):**
- Balance detail with brevity
- Include both progress and blockers
- Provide context for decisions
- Mention resource needs
- Highlight risks and mitigation

**Peers (Other PMs, Team Leads):**
- Can be more detailed
- Include tactical information
- Share lessons learned
- Discuss trade-offs and alternatives
- Be transparent about challenges

**Team Members:**
- Provide full context
- Explain "why" behind decisions
- Share timelines and expectations
- Acknowledge contributions
- Be specific about next steps

## Update Structure

### Status Update Template

**Subject/Title:** [Concise summary of current state]

**TL;DR:** (1-2 sentences)
Current status in plain language with key takeaway

**Progress This Week:**
- Completed: [specific accomplishments]
- In Progress: [active work with % complete]
- Planned Next: [upcoming priorities]

**Metrics/Impact:**
- [Quantifiable results or leading indicators]

**Blockers/Risks:**
- [Issue]: Impact and proposed resolution

**Decisions Needed:**
- [Decision]: Context, options, recommendation, deadline

**Next Milestones:**
- [Date]: [Milestone and success criteria]

### Example: Team Update (Project Delay)

**Subject:** Q2 Mobile Release - Timeline Update

**Context:**
We've hit an integration blocker with the third-party payment SDK that requires vendor support.

**Impact:**
- Original ship date: May 15
- Revised ship date: May 29 (2-week delay)
- Affects: iOS and Android apps
- Does NOT affect: Web release (still May 15)

**What Happened:**
The SDK update (required for PCI compliance) introduced breaking changes to the refund flow. Vendor confirmed this is a known issue and they're releasing a patch.

**Mitigation:**
- Vendor committed to patch by May 22
- QA time reduced by reusing web test scenarios
- Stakeholder communications sent
- Customer impact: None (no existing feature affected)

**What I Need:**
- Your approval to adjust the milestone in Jira
- Communication to sales team (I've drafted a message)

**Lessons:**
Adding "SDK update review" step to our release checklist to catch this earlier next time.

## Communication Best Practices

### Lead with the Punchline
❌ "We've been working on improving the checkout flow and after several iterations and testing..."
✅ "Checkout conversion is up 23% since Tuesday's launch."

### Use the "So What?" Test
Every statement should answer: "Why does this matter?"

❌ "We added a progress indicator"
✅ "We added a progress indicator, reducing checkout abandonment by 12%"

### Be Specific with Numbers
❌ "Most users are happy"
✅ "NPS increased from 42 to 58 (n=247 responses)"

### Own Problems, Share Credit
When things go wrong: "I underestimated the integration complexity"
When things go right: "The engineering team delivered this ahead of schedule"

### Provide Context for Decisions
Don't just state what you decided—explain why:
"We're prioritizing mobile over tablet because 87% of our traffic is mobile, and tablet usage is trending down (15% decrease QoQ)."

### Signal Confidence Levels
- "We will ship May 15" (high confidence, committed)
- "We expect to ship around May 15" (medium confidence, estimate)
- "We're targeting mid-May" (lower confidence, subject to change)

## Special Situations

### Announcing Bad News

1. **State the problem clearly** (no sugarcoating)
2. **Explain the impact** (who is affected, how much)
3. **Own the mistake** (if applicable)
4. **Present the solution** (what you're doing about it)
5. **Set expectations** (timeline for resolution)

Example:
"The feature we shipped yesterday caused a 30% increase in page load time. This affects all users on mobile devices. I approved the release without adequate performance testing—my mistake. We've rolled back the change and users should see normal performance within the hour. We're adding performance benchmarks to our release checklist."

The same structure adapts to requesting resources (need, justification, trade-off, options, clear next step) and celebrating wins (specific accomplishment, credit by name, tie to strategy).

## Workflow Tips

1. **Gather context** before writing updates
2. **Offer the user a draft to review** before sending, especially for sensitive or high-stakes messages
3. **Follow up** on action items and decisions requested

## Red Flags to Avoid

- ❌ **Burying the lede** - Don't hide important info in paragraph 3
- ❌ **Jargon overload** - Assume your audience doesn't know technical terms
- ❌ **Defensiveness** - Own mistakes without excuses
- ❌ **Vagueness** - "We're working on it" tells them nothing
- ❌ **Over-promising** - Under-promise and over-deliver
- ❌ **No action items** - Every update should have a clear next step
