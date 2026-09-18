---
name: daily-planning-ritual
description: Use when the user asks to plan their day with phrases like "plan the day", "plan my day", "plan today", or similar variations, or wants a morning check-in on how to spend the day across work and the rest of their life.
---

# Day Planning Ritual

A short morning conversation (5-10 minutes) that ends in a plan for the day. The plan answers two questions: **how does the user want to feel today**, and **where does their time go across the areas of their life**. Balance across areas is the point. The task list is a by-product.

## Workflow Overview

1. **Gather context** (silent) - Pull calendar, reminders, emails, Drive docs, and the planning notes doc, then sort what you found by area
2. **Converse** - Open on the person, give a first read of the day, shape it together, then check the balance
3. **Draft plan** - Poetic opening, agenda, where the day goes, notes-doc sections
4. **Refine** - Iterate, restating the balance whenever it shifts
5. **Finalize** - Write or present the final plan when approved

The user customizes this ritual by editing their planning notes document, never by editing this skill.

## Areas of Life

Every part of this ritual is organized by **area**: the first read, the questions, the balance check, and the plan.

**Default areas** (used when the notes doc does not name its own):

| Area | Covers |
|------|--------|
| Work | Job, meetings, deadlines, professional obligations |
| Life projects | House, admin, errands, personal builds, the long-running list |
| Relationships | Partner, family, household people |
| Friendships | Friends, community, people to reach out to |
| Self | Rest, reading, reflection, play, time that is only theirs |
| Fitness | Movement, training, recovery, health |

**Doc override**: if the notes doc contains a section whose heading names areas of life (`Areas`, `Areas of my life`, `Dimensions`, `What matters`, `Buckets`, or similar), or whose body is a short list of life areas rather than tasks or questions, that list **replaces** the default set, in the doc's order. Use the user's names for them verbatim.

## Step 1: Gather Context

**Prerequisites**: Requires Google Calendar, Gmail, Google Drive, and Reminders MCP connectors; skip any source that is unavailable and note the gap in the plan.

**Before saying anything**, silently gather:

1. **Calendar events** - fetch today's calendar events (e.g. `list_gcal_events`)
2. **Reminders** - fetch incomplete reminders, focusing on the "today" list or items due today (e.g. `reminder_search_v0`)
3. **Recent emails** - search the last 24 hours of email for urgencies (e.g. `search_gmail_messages` with `newer_than:1d`)
4. **Planning notes** by reading a Google Doc named `Daily Planning Notes` - the user's persistent goals, priorities, areas, and reflective questions
5. **Relevant Drive docs** if calendar shows meetings today - search Drive for related materials (e.g. `google_drive_search`)

### Reading the planning notes doc

The notes doc is the user's configuration file for this ritual, so **read whatever sections it actually contains — never assume a particular set of section names.**

- Capture every section: its heading exactly as written, its body exactly as written, and its position in the document.
- Do not rename, merge, reorder, split, or skip sections, and do not expect any section to be present.
- Note which section (if any) names the user's **areas of life** (see Areas of Life above). It replaces the default areas.
- Note which sections (if any) hold **reflective questions** — headings like `Open Questions`, `Reflections`, or `Things to sit with`, or bodies that are a list of questions. These are the pool for the Question of the Day.
- If the document cannot be found, say so once, briefly explain that it is how the user customizes this ritual without editing the skill, and continue without it.

### Sort what you found by area

Tag every calendar event, reminder, and email urgency with the area it belongs to. Note which areas are full, which are empty, and what is time-critical. This sorted view is the raw material for the first read in Step 2; do not present it yet.

## Step 2: The Conversation

**Shape of every Claude turn**: one sentence reflecting back something you heard or noticed, then one question. One question per turn. Never ask something the gathered context already answers.

The conversation has four beats. Beats 2a and 2b are fixed. Beat 2c adapts to the person. Beat 2d is required before any plan is drafted.

### 2a. Open on the person

Three questions, one per turn, in this order:

1. **How do you feel right now?**
2. **How do you want to feel by the end of today?**
3. **What is today for?**

After the third answer, reflect the distance between now and desired in one sentence before moving on. Example: "Tired and anxious now, aiming for calm and done."

### 2b. First read of the day

Present what is already spoken for, **grouped by area and stated as a read, not a list**: which areas are full, which are empty, what is urgent. Reminders and email urgencies go under their areas. Two to four sentences. Then ask what else needs to happen today that is not there yet.

Example:

> Here's what's already spoken for. Work has your whole day from nine to five plus an optional budget call, and Dana needs numbers before ten. Life projects has two waiting items, the drawers and the plumber. Fitness, Sam, friends, and time for yourself have nothing yet. What else needs to happen today that isn't here?

Tasks, chores, and errands get captured here.

### 2c. Shape the day

**Goal**: for each area in play, know what happens today (if anything) and roughly how much of the day it gets. **Budget**: two to four exchanges.

Choose each next question by these rules, in priority order:

1. **Follow the thread the user just offered** before opening a new topic. If they say "I'm anxious about the proposal," ask about the proposal, not about fitness.
2. **Ask about empty areas together, not one by one.** "Anything for fitness, Sam, or yourself today, or is that a closed day?" is one turn. Six separate "any plans for X?" turns is the failure this skill exists to prevent.
3. **When the user closes an area**, accept it in one clause and move on. Do not re-ask it.
4. **Let the notes doc prompt you.** If a doc section points at an area (a training goal, a creative practice), ask about that area even when the calendar is empty there.
5. **Stop when you can state every area's share.** Do not keep asking to fill a form.

### 2d. Balance check

**Required before drafting.** Say the shape of the day back in two or three sentences, name the skew plainly, connect it to how they said they want to feel, and ask. Pattern:

> As it stands: [each area and its rough share]. That's [skew stated plainly]. You said you wanted to feel [feeling]. Is that the day you want, or should something move?

Example:

> As it stands: work has the whole day, life projects gets a phone call squeezed between meetings, and fitness, Sam, friends, and you have nothing. That's a day that's all work. You said you wanted to end it calm rather than reactive. Is that the day you want, or should something move?

A skewed day the user chooses is a good plan. A skewed day nobody named is not. If they move something, reflect the change in one sentence, then continue.

### 2e. Question of the Day

**Pose one Question of the Day**: select one question from the reflective-question sections you found in the planning notes doc. Introduce it naturally: "Something to sit with today: [question]." It is offered, not asked; do not wait for an answer.

If the doc has no reflective questions, or was not available, skip this rather than inventing a question, and mention once that adding a section of questions to the doc turns it on.

## Step 3: Draft the Plan

After the balance check, create a draft plan in this format:

```markdown
Plan
[1-2 sentence poetic statement about the day's priorities and desired feeling]

Agenda for today
* [Events from calendar and tasks captured in the conversation, in day order]

Where the day goes
* [Area] — [rough share]: [what happens in it]
* [Area] — nothing today
* ...
[One sentence: the balance read, tied to the desired feeling]

[Then reproduce the planning notes doc's sections here]
```

### Where the day goes

- **One line per area in play**, in the order the areas are defined. Areas with nothing get an explicit "nothing today" so absence is visible.
- **Shares are in words**, not clock times or percentages: "most of the day," "the morning," "an hour before dinner," "a phone call between meetings," "the evening."
- **The closing sentence restates the outcome of the balance check**: what the day is weighted toward and whether that is by choice. Example: "Weighted to work by choice; the morning run and the drawers tonight keep it from being only that."

### Notes-doc sections

Mirror the notes doc exactly:

- Reproduce **every** section it contains, in the document's own order, each under its own heading copied verbatim.
- Copy the body of each section as-is. This content is the user's, not yours to summarize or improve.
- Add no section the doc doesn't have, and omit none that it does.
- If the doc was unavailable, leave this part out and note the gap in one line under the agenda.

### Crafting the Poetic Opening

The opening statement should:
- Synthesize what they said today is for
- Evoke the feeling they want to end the day with
- Be poetic but grounded
- Be 1-2 sentences maximum

**Examples:**
- "Today is about domestic order and being comfortable in my own life."
- "Today is about momentum and creating space for what matters."
- "Today is about presence with others and trust in the process."

### Selecting the Question of the Day

Claude picks the question for the user—do not ask them to choose. Selection should be informed by:
- The day's main purpose and activities
- Themes that emerged in the conversation
- Productive tension or resonance with what's planned

When presenting the draft plan, briefly explain why you chose this question (1-2 sentences). The explanation should connect the question to the day's shape without being heavy-handed.

## Step 4: Refine

Present the draft plan **in the chat** (don't write the file yet).

Ask: "How does this feel? Anything to move?"

Iterate based on their feedback. After any change that shifts an area's share, restate the balance sentence before asking again, so the user always sees the shape they are agreeing to.

Common refinements:
- Adjust the poetic opening
- Move something between areas or into an empty one
- Add/remove agenda items
- Clarify phrasing

## Step 5: Finalize

When the user indicates they're satisfied, write the plan to a markdown file (e.g. `daily-plan-YYYY-MM-DD.md`) or present it directly, titled "Daily Plan - [Today's Date]"

## Important Notes

- Every Claude turn is one reflection plus one question. If you are about to ask a second question in the same turn, cut it.
- The balance check is not optional and not an afterthought on the draft. It happens before the plan exists, and again whenever the shape changes.
- Empty areas stay visible in the plan. Seeing "Friendships — nothing today" is the point.
- The user changes their areas, goals, and questions by editing the notes doc. Sections are reproduced exactly as-is, headings and all; this skill only ever reads that doc, never edits it.
- Total process should feel contemplative, not rushed, but stay within 5-10 minutes.
