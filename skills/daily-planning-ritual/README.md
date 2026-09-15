# Customizing the Daily Planning Ritual

The Daily Planning Ritual skill reads persistent content from a **Google Doc named `Daily Planning Notes`** in your Google Drive (fetched via the Google Drive connector during context gathering). That document is the skill's configuration file: **edit the doc, never the skill.**

## How It Works

During Step 1 (Gather Context), the skill finds the `Daily Planning Notes` doc and reads **whatever sections it contains** — it has no built-in list of section names. Every section is then reproduced in the day's plan under its own heading, in the document's own order, with its content copied exactly as written.

That means:

- **Rename a section** → the new name shows up in your next plan.
- **Add a section** → it appears in your next plan, in the position you put it.
- **Remove a section** → it stops appearing.
- **Reorder sections** → your plan follows the new order.

None of these require touching `SKILL.md`. If the document can't be found, the skill says so once and proceeds without the persistent sections.

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

Near the end of the conversation the skill poses one reflective question for you to sit with. It draws that question from any section of your doc that holds reflective questions — recognized by a heading such as `Open Questions`, `Reflections`, or `Things to sit with`, or by a body that is simply a list of questions.

```markdown
Open Questions
- What am I avoiding that needs attention?
- Where am I creating unnecessary friction?
- What would make today feel complete?
- How can I be more present with others?
```

Add, remove, or reorder questions to match your reflection style. Claude chooses which one to pose based on the shape of your day; you don't pick. If your doc has no question section at all, the skill simply skips this step rather than inventing a question.

### Life Dimensions

The conversation walks through life dimensions — **work, fitness, relationship, social, and adventure by default**. That set is a starting point, not a fixed taxonomy. To change it, either say so during the ritual ("skip social today, but ask me about studio time") or name your dimensions in your notes doc; the skill drops defaults that don't apply to you and picks up the ones you use instead. Keep the list short enough that the whole ritual still fits in 5-10 minutes.

## Relationship to the Skill

The skill is **read-only** regarding your notes doc — it copies content but never modifies it, and never summarizes or rewrites what you wrote. Because sections are discovered rather than hardcoded, the doc and the skill cannot drift out of sync: there is no list of section names in `SKILL.md` to keep matching.
