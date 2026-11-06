# Customizing the Daily Planning Ritual

The Daily Planning Ritual skill reads persistent content from a **Google Doc named `Daily Planning Notes`** in your Google Drive (fetched via the Google Drive connector during context gathering). That document is the skill's configuration file: **edit the doc, never the skill.**

## How It Works

During Step 1 (Gather Context), the skill finds the `Daily Planning Notes` doc and reads **whatever sections it contains** — it has no built-in list of section names. The doc shapes the conversation rather than the plan: goals and priorities inform the first read of the day and the questions Claude asks, a section naming your areas of life replaces the default areas, and a section of reflective questions feeds the Question of the Day. The doc's sections are never copied into the plan itself.

That means:

- **Add or change a goal** → Claude reads the day against it, but the goal does not appear in the plan.
- **Change your areas** → the "Where the day goes" section follows the new list.
- **Add or remove questions** → the Question of the Day pool changes.

None of these require touching `SKILL.md`. If the document can't be found, the skill says so once and proceeds with the default areas and no Question of the Day.

## Creating the Daily Planning Notes Doc

Create a Google Doc named `Daily Planning Notes`. Any set of sections works — this is one example layout, not a required one:

```markdown
Training Goals
[What you're working toward physically right now]

Studio Practice
[The creative work you're keeping alive]

This Quarter at Work
[Current work focus areas]

Open Questions
- [A question worth sitting with]
- [Another one]
```

Pick headings that mean something to you. `Studio Practice`, `Garden`, `Recovery`, `Money`, `Reading List`, `People to Check On` are all equally valid.

## Customization

### Sections

Edit, rename, add, remove, or reorder sections in the doc whenever your priorities change. The next planning session picks the change up automatically — there is nothing to keep in sync.

- **Weekly:** refresh the section holding your current work focus
- **Monthly:** revisit personal projects and initiatives
- **Seasonally:** adjust fitness or training objectives

### The Question of the Day

Near the end of the conversation the skill poses one reflective question for you to sit with. It draws on any section of your doc that holds reflective questions — recognized by a heading such as `Open Questions`, `Reflections`, or `Things to sit with`, or by a body that is simply a list of questions — and either picks one of yours or writes one of its own in the same spirit when the day calls for something more specific.

```markdown
Open Questions
- What am I avoiding that needs attention?
- Where am I creating unnecessary friction?
- What would make today feel complete?
- How can I be more present with others?
```

Add, remove, or reorder questions to match your reflection style. Claude chooses which one to pose based on the shape of your day; you don't pick. Your questions set the register for any it crafts, so the more you add, the more the crafted ones sound like you. If your doc has no question section, the skill still poses a question drawn from the conversation, and mentions once that a section of questions in the doc gives it material to work from.

### Areas of Life

The whole ritual is organized by **areas of life**: the first read of your day, the questions, the balance check, and the "Where the day goes" section of the plan. By default the areas are **work, life projects, relationships, friendships, self, and fitness**.

To use your own, add a section to your doc that names them. Any heading that clearly means "areas" works (`Areas`, `Areas of my life`, `Dimensions`, `What matters`, `Buckets`), and so does a section whose body is simply a short list of areas rather than tasks or questions:

```markdown
Areas of my life
- Work
- Studio
- Sam and the kids
- Friends
- Garden
- Body
```

Your list replaces the default set entirely, in your order and with your names. Every area shows up in the plan every day, including the ones that get nothing, so an empty area is visible rather than forgotten. Keep the list short enough that the whole ritual still fits in 5-10 minutes.

## Relationship to the Skill

The skill is **read-only** regarding your notes doc — it copies content but never modifies it, and never summarizes or rewrites what you wrote. Because sections are discovered rather than hardcoded, the doc and the skill cannot drift out of sync: there is no list of section names in `SKILL.md` to keep matching.
