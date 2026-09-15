---
name: daily-planning-ritual
description: Interactive daily planning ritual that guides the user through a reflective conversation across their life dimensions (work, fitness, relationship, social, and adventure by default) and produces a holistic day plan. Use when the user requests to plan their day with phrases like "plan the day", "plan my day", "plan today", or similar variations.
---

# Day Planning Ritual

An interactive morning practice that helps plan the entire day holistically across work and personal life.

## Workflow Overview

This is a conversational ritual that takes 5-10 minutes:

1. **Gather context** (silent) - Pull calendar, reminders, emails, Drive docs, and the planning notes doc
2. **Reflective conversation** - Ask questions across the user's life dimensions
3. **Draft plan** - Create initial plan with poetic opening
4. **Refine** - Iterate based on feedback
5. **Finalize** - Write or present the final plan when approved

The user customizes this ritual by editing their planning notes document, never by editing this skill.

## Step 1: Gather Context

**Prerequisites**: Requires Google Calendar, Gmail, Google Drive, and Reminders MCP connectors; skip any source that is unavailable and note the gap in the plan.

**Before asking any questions**, silently gather:

1. **Calendar events** - fetch today's calendar events (e.g. `list_gcal_events`)
2. **Reminders** - fetch incomplete reminders, focusing on the "today" list or items due today (e.g. `reminder_search_v0`)
3. **Recent emails** - search the last 24 hours of email for urgencies (e.g. `search_gmail_messages` with `newer_than:1d`)
4. **Planning notes** by reading a Google Doc named `Daily Planning Notes` - the user's persistent goals, priorities, and reflective questions
5. **Relevant Drive docs** if calendar shows meetings today - search Drive for related materials (e.g. `google_drive_search`)

### Reading the planning notes doc

The notes doc is the user's configuration file for this ritual, so **read whatever sections it actually contains — never assume a particular set of section names.**

- Capture every section: its heading exactly as written, its body exactly as written, and its position in the document.
- Do not rename, merge, reorder, split, or skip sections, and do not expect any section to be present.
- Note which sections (if any) hold reflective questions — headings like `Open Questions`, `Work Questions`, or `Things to sit with`, or bodies that are a list of questions. These are the pool for the Question of the Day in Step 2.
- If the document cannot be found, say so once, briefly explain that it is how the user customizes this ritual without editing the skill, and continue without it.

Keep this context in mind but don't present it yet - it informs the questions you'll ask.

## Step 2: Conversational Planning

Ask questions in a natural, flowing conversation. Keep it concise - 5-10 minutes total.

### Task Collection (ask first)

Before diving into reflection, review what's already captured and ask for anything else:

**Present reminders and tasks you found**, then ask: **"Anything else you need to do today that's not captured yet?"**

This ensures:
- All reminders are accounted for
- Any additional chores, errands, or commitments get added
- Work tasks not reflected in meetings or reminders are captured

### Opening Questions (always ask these)

1. **How do you feel right now?**
2. **What is the main purpose of today?**
3. **How do you want to feel?**

### Life Dimension Questions

The five dimensions below are a **default starting set, not a fixed taxonomy**. Adapt them to the person:

- If their planning notes doc or their answers point at different dimensions (creative practice, parenting, study, recovery, finances, faith, caregiving), use those instead.
- Drop any default dimension that doesn't apply to them, and don't force one that has nothing in it.
- Keep the total small enough that the whole conversation still fits in 5-10 minutes.

For each dimension in play, ask 1-2 focused questions informed by the context you gathered.

**Work**
- Present relevant meetings/deadlines from calendar
- "What's the ONE most important outcome for work today?"
- If emails show urgencies, mention them

**Fitness & Health**
- "What movement is planned today?"
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

- **Pose one Question of the Day**: Select one question from the reflective-question sections you found in the planning notes doc (Step 1). Introduce it naturally: "Something to sit with today: [question]"
- If the doc has no reflective questions - or wasn't available - skip this rather than inventing a question, and mention once that adding a section of questions to the doc turns it on.

## Step 3: Draft the Plan

After gathering their responses, create a draft plan in this format:

```markdown
Plan
[1-2 sentence poetic statement about the day's priorities and desired feeling]

Agenda for today
* [List events from calendar and tasks mentioned]

[Then reproduce the planning notes doc's sections here]
```

For the last part, mirror the notes doc exactly:

- Reproduce **every** section it contains, in the document's own order, each under its own heading copied verbatim.
- Copy the body of each section as-is. This content is the user's, not yours to summarize or improve.
- Add no section the doc doesn't have, and omit none that it does.
- If the doc was unavailable, leave this part out and note the gap in one line under the agenda.

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

Claude picks the question for the user—do not ask them to choose. Selection should be informed by:
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
- Sections from the planning notes doc are reproduced exactly as-is, headings and all; this skill only ever reads that doc, never edits it
- A renamed, added, or removed section in the doc should show up in the next plan with no change to this skill
- Total process should feel contemplative, not rushed, but stay within 5-10 minutes
