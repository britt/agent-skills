---
name: daily-planning-ritual
description: Use when the user asks to plan their day with phrases like "plan the day", "plan my day", "plan today", or similar variations, or wants a morning check-in on how to spend the day across work and the rest of their life.
---

# Day Planning Ritual

A short morning conversation (5-10 minutes) that ends in a plan for the day. The plan answers two questions: **how does the user want to feel today**, and **where does their time go across the areas of their life**. Balance across areas is the point. The task list is a by-product.

## Workflow Overview

1. **Gather context** (silent) - Pull calendar, reminders, emails, Drive docs, and the planning notes doc, then sort what you found by area
2. **Converse** - Open with a read of the day and ask how the user feels, shape it together while learning how they want to feel and what matters most, then check the balance
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

Tag every calendar event, reminder, and email urgency with the area it belongs to. If something fits none of the areas, put it under the closest one and say so when it comes up; do not add an area the user has not named. Note which areas are full, which are empty, and what is time-critical. This sorted view is the raw material for the first read in Step 2; do not present it yet.

## Step 2: The Conversation

**Shape of every Claude turn**: one sentence reflecting back something you heard or noticed, then one question. One question per turn. Never ask something the gathered context already answers. The opening turn is the one exception: it carries the read of the day and a single two-part question.

The conversation has four beats. 2a is fixed in its parts, not its wording. 2b adapts to the person. 2c is required before any plan is drafted. 2d closes.

### 2a. Open with a read of the day

The first turn is a read of the day, not a question asked in a vacuum. It has three parts:

1. **How busy the day looks**, in one plain word or phrase: light, full, overfull, packed. Judge it from calendar density, time-critical items, and how much unscheduled time is left.
2. **Where the day sits across the areas**: which areas are over-represented (full or dominant), which are under-represented (thin or empty), and anything urgent from reminders or email, placed under its area. Stated as a read, not a list. Two to four sentences.
3. **One two-part question, always last**: how they are feeling right now, and what is going on today that you missed.

Lead with whatever is most striking about today (an overfull calendar, an empty area the notes doc says matters, one urgent item), so the opener reads differently on different days.

Example:

> Morning. Light day on paper: work has just the design review at two, and the only thing with a clock on it is the pharmacy pickup before it closes at six. Life projects has the lease renewal and the garage shelves still waiting, and your notes say the draft chapter is overdue, so self has a claim on the open morning. Relationships, friendships, and fitness have nothing down. A lot of open space, and it could go to the chapter or get eaten by the shelves. How are you feeling this morning, and what's going on today that I've missed?

Tasks, chores, and errands the user adds get captured here.

### 2b. Shape the day

**Goal**: for each area in play, know what happens today (if anything) and roughly how much of the day it gets, and learn two anchors along the way: **how the user wants to feel by the end of the day** and **what is most important today**. **Budget**: three to five exchanges.

Choose each next question by these rules, in priority order:

1. **Follow the thread the user just offered** before opening a new topic. If they say "I'm anxious about the proposal," ask about the proposal, not about fitness.
2. **Pick the anchors up from what they say before asking for them.** "I just want the review to go well" has already told you what matters most; "I'd love to end the day not thinking about work" is the desired feeling. Reflect it back in one clause so they can correct it, and do not ask the question again.
3. **Ask directly for any anchor that has not surfaced**, one per turn, starting no later than the third exchange, phrased to fit the conversation rather than as a form field: "Given all that, how do you want to feel when the day's done?" or "Of everything on here, what matters most?"
4. **Ask about empty areas together, not one by one.** "Anything for fitness, Sam, or yourself today, or is that a closed day?" is one turn. Six separate "any plans for X?" turns is the failure this skill exists to prevent.
5. **When the user closes an area**, accept it in one clause and move on. Do not re-ask it.
6. **Let the notes doc prompt you.** If a doc section points at an area (a training goal, a creative practice), ask about that area even when the calendar is empty there.
7. **Stop when you can state every area's share and both anchors.** Do not keep asking to fill a form.

### 2c. Balance check

**Required before drafting.** Say the shape of the day back in two or three sentences, name the skew plainly, connect it to how they said they want to feel and what they said matters most, and ask. Pattern:

> As it stands: [each area and its rough share]. That's [skew stated plainly]. You said you wanted to feel [feeling] and that [most important thing] is what matters. Is that the day you want, or should something move?

Example:

> As it stands: work has the whole day with the roadmap review at its centre, house gets two phone calls in the lunch hold, and body, Sam, friends, and you have nothing. That's a day that's all work. You said you wanted to end it settled rather than scattered, and that the review is what matters. Is that the day you want, or should something move?

A skewed day the user chooses is a good plan. A skewed day nobody named is not. If they move something, reflect the change in one sentence, then continue.

### 2d. Question of the Day

**Pose one Question of the Day.** Either pick one from the reflective-question sections of the planning notes doc, or craft one of your own in the same spirit: same register and length as theirs, open rather than leading, pointed at the shape of this particular day. Use the doc's question when one fits the day; craft when none does. Introduce it naturally: "Something to sit with today: [question]." It is offered, not asked; do not wait for an answer.

If the doc has no reflective questions, or was not available, craft one from the conversation and add one clause noting that a section of questions in the doc gives this step material to draw from.

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
- Synthesize what they said is most important today
- Evoke the feeling they want to end the day with
- Be poetic but grounded
- Be 1-2 sentences maximum

**Examples:**
- "Today is about domestic order and being comfortable in my own life."
- "Today is about momentum and creating space for what matters."
- "Today is about presence with others and trust in the process."

### Selecting the Question of the Day

Claude picks or crafts the question for the user—do not ask them to choose. Selection should be informed by:
- The day's main purpose and activities
- Themes that emerged in the conversation
- Productive tension or resonance with what's planned

When presenting the draft plan, briefly explain why you chose this question (1-2 sentences), and say in a clause whether it came from the notes doc or you wrote it. The explanation should connect the question to the day's shape without being heavy-handed.

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

- Every Claude turn after the opener is one reflection plus one question. If you are about to ask a second question in the same turn, cut it. The opener is the one turn that asks two things, and it asks them together.
- How the user wants to feel and what matters most are learned in conversation, not asked as a fixed sequence. Pick them up from what the user says; ask directly for whichever has not surfaced, starting no later than the third exchange.
- The balance check is not optional and not an afterthought on the draft. It happens before the plan exists, and again whenever the shape changes.
- Empty areas stay visible in the plan. Seeing "Friendships — nothing today" is the point.
- The user changes their areas, goals, and questions by editing the notes doc. Sections are reproduced exactly as-is, headings and all; this skill only ever reads that doc, never edits it.
- Total process should feel contemplative, not rushed, but stay within 5-10 minutes.
