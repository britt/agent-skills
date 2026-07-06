---
name: daily-planning-ritual
description: Interactive daily planning ritual that guides the user through a reflective conversation across all life dimensions (work, fitness, relationship, social, adventure) and produces a holistic day plan. Use when the user requests to plan their day with phrases like "plan the day", "plan my day", "plan today", or similar variations.
---

# Day Planning Ritual

An interactive morning practice that helps plan the entire day holistically across work and personal life.

## Workflow Overview

This is a conversational ritual that takes 5-10 minutes:

1. **Gather context** (silent) - Pull calendar, emails, Drive docs, static sections
2. **Reflective conversation** - Ask questions across life dimensions
3. **Draft plan** - Create initial plan with poetic opening
4. **Refine** - Iterate based on feedback
5. **Finalize** - Write or present the final plan when approved

## Step 1: Gather Context

**Prerequisites**: Requires Google Calendar, Gmail, Google Drive, and Reminders MCP connectors; skip any source that is unavailable and note the gap in the plan.

**Before asking any questions**, silently gather:

1. **Calendar events** - fetch today's calendar events (e.g. `list_gcal_events`)
2. **Reminders** - fetch incomplete reminders, focusing on the "today" list or items due today (e.g. `reminder_search_v0`)
3. **Recent emails** - search the last 24 hours of email for urgencies (e.g. `search_gmail_messages` with `newer_than:1d`)
4. **Static sections** by reading a Google Doc named `Daily Planning Notes` - This document contains other goals, questions, and useful information. If you cannot find it mention that and why its useful and proceed.
5. **Relevant Drive docs** if calendar shows meetings today - search Drive for related materials (e.g. `google_drive_search`)

Keep this context in mind but don't present it yet - it informs the questions you'll ask.

## Step 2: Conversational Planning

Ask questions in a natural, flowing conversation. Keep it concise - 5-10 minutes total.

### Task Collection (ask first)

Before diving into reflection, review what's already captured and ask for anything else:

**Present reminders and tasks you found**, then ask: **"Anything else you need to do today that's not captured yet?"**

This ensures:
- All iOS Reminders are accounted for
- Any additional chores, errands, or commitments get added
- Work tasks not reflected in meetings or reminders are captured

### Opening Questions (always ask these)

1. **How do you feel right now?**
2. **What is the main purpose of today?**
3. **How do you want to feel?**

### Life Dimension Questions

For each area, ask 1-2 focused questions informed by the context you gathered:

**Work**
- Present relevant meetings/deadlines from calendar
- "What's the ONE most important outcome for work today?"
- If emails show urgencies, mention them

**Fitness & Health**
- "What movement is planned? Climbing session? Other exercise?"
- "How's your energy level? Any recovery needs?"

**Relationship**
- "Any dedicated time for your partner or family today?"
- "Anything they need from you?"

**Social Life**
- "Any social commitments or people to reach out to?"
- Check calendar for social events

**Adventure**
- "Any outdoor time or adventure planned?"
- "Or is this more of a rest/recovery day?"

### Closing Questions

- **Pose one Life Question**: Select one from their Life Questions list for reflection. Introduce it naturally: "Something to sit with today: [question]"

## Step 3: Draft the Plan

After gathering their responses, create a draft plan following this exact format:

```markdown
Plan
[1-2 sentence poetic statement about the day's priorities and desired feeling]

Agenda for today
* [List events from calendar and tasks mentioned]

Climbing Goals
[Copy from static sections]

Life Projects
[Copy from static sections]

Work Priorities
[Copy from static sections]

Work Questions
[Copy from static sections]

Life Questions
[Copy from static sections]
```

### Crafting the Poetic Opening

The opening statement should:
- Synthesize the main purpose they identified
- Evoke the feeling they want to cultivate
- Be poetic but grounded
- Be 1-2 sentences maximum

**Examples:**
- "Today is about domestic order and being comfortable in my own life."
- "Today is about momentum and creating space for what matters."
- "Today is about presence with others and trust in the process."

Draw from their responses about purpose, desired feeling, and the overall shape of their day.

### Selecting the Question of the Day

Claude picks one Life Question for the user—do not ask them to choose. Selection should be informed by:
- The day's main purpose and activities
- Themes that emerged in the conversation
- Productive tension or resonance with what's planned

When presenting the draft plan, briefly explain why you chose this question (1-2 sentences). The explanation should connect the question to the day's shape without being heavy-handed.

## Step 4: Refine

Present the draft plan **in the chat** (don't write the file yet).

Ask: "How does this feel? Any adjustments?"

Iterate based on their feedback. Common refinements:
- Adjust the poetic opening
- Add/remove agenda items
- Reorder priorities
- Clarify phrasing

## Step 5: Finalize

When the user indicates they're satisfied, write the plan to a markdown file (e.g. `daily-plan-YYYY-MM-DD.md`) or present it directly, titled "Daily Plan - [Today's Date]"

## Important Notes

- Keep the conversation flowing and natural - don't robotically go through every question
- If a life dimension has nothing happening, acknowledge briefly and move on
- The poetic opening is key - take time to craft something meaningful
- Static sections should be copied exactly as-is from the `Daily Planning Notes` Google Doc
- Total process should feel contemplative, not rushed, but stay within 5-10 minutes