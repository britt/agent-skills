# Customizing the Daily Planning Ritual

The Daily Planning Ritual skill reads persistent content from a **Google Doc named `Daily Planning Notes`** in your Google Drive (fetched via the Google Drive connector during context gathering). Edit that document to customize what appears in your plans.

## How It Works

During Step 1 (Gather Context), the skill searches Google Drive for a document titled `Daily Planning Notes` and copies these sections into each daily plan:

- **Climbing Goals** - Your ongoing climbing objectives
- **Life Projects** - Personal projects and initiatives
- **Work Priorities** - Current work focus areas
- **Work Questions** - Reflective questions about work
- **Life Questions** - Broader life reflection questions

These sections are copied exactly as-is, so you can customize the skill's output by editing the Google Doc. If the document can't be found, the skill mentions the gap and proceeds without the static sections.

## Creating the Daily Planning Notes Doc

Create a Google Doc named `Daily Planning Notes` with this structure:

```markdown
Climbing Goals
[Your climbing goals here]

Life Projects
[Your life projects here]

Work Priorities
[Your work priorities here]

Work Questions
[Your work reflection questions here]

Life Questions
[Your life reflection questions here]
```

## Customization Examples

### Change Section Names

You can rename sections in the doc to match your priorities:

```markdown
Fitness Goals
[Instead of Climbing Goals]

Creative Projects
[Instead of Life Projects]

Career Priorities
[Instead of Work Priorities]
```

**Important:** If you change section names, you **must** also update `skills/daily-planning-ritual/SKILL.md`:

1. Update **Step 3** - Modify the plan format to use your new section names
2. Update **Step 2** - If you renamed "Life Questions", update the reference in the closing questions section

The skill looks for exact section headers, so both the Google Doc and SKILL.md must match. Alternatively, keep the original section names and customize only the content.

### Customize Reflection Questions

The skill selects one question from your **Life Questions** section during the planning conversation. Customize this section to control what questions get asked:

```markdown
Life Questions
- What am I avoiding that needs attention?
- Where am I creating unnecessary friction?
- What would make today feel complete?
- How can I be more present with others?
```

Add, remove, or reorder questions to match your reflection style.

### Update Priorities Over Time

Edit the Google Doc whenever your priorities change:

- **Weekly:** Update Work Priorities as projects shift
- **Monthly:** Refresh Life Projects as initiatives evolve
- **Seasonally:** Adjust Climbing Goals or fitness objectives

Changes take effect immediately—the next planning session will use the updated content.

### Add New Sections

To include additional persistent sections in your plans:

1. Add the section to the `Daily Planning Notes` Google Doc
2. Update `skills/daily-planning-ritual/SKILL.md` **Step 3** to add the new section to the plan format template

Example: Add a "Learning Goals" section:

```markdown
Learning Goals
[Your learning objectives]
```

Then update SKILL.md to reference "Learning Goals" in the Step 3 plan format.

## Relationship to the Skill

The skill is **read-only** regarding static sections—it copies content from the Google Doc but never modifies it:

- **Content changes** - Edit the Google Doc directly (no skill changes needed)
- **Section name changes** - Update both the Google Doc AND `SKILL.md` Step 2/Step 3 references
- **New sections** - Add to the Google Doc AND update `SKILL.md` Step 3

The Google Doc acts as a configuration file, but the skill must know which sections to look for. Keep them in sync when customizing section structure.
