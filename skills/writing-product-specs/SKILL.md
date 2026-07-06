---
name: writing-product-specs
description: Use when asked to write a product spec, PRD, or requirements document, or to design a new feature or project before implementation - interactively elicits problem, audience, success criteria, and scope, then produces a structured spec file
---

# Writing Product Specifications

## Overview

Write comprehensive product specification documents that clearly communicate what we're building, why we're building it, and how we'll know it's successful. Document everything stakeholders need to understand: the problem context, target audience, requirements, success criteria, and tradeoffs. Give them a complete picture of the feature or project.

Assume the reader is a skilled product person or engineer, but knows nothing about this specific feature or the problem domain. Assume they need clear context to understand the "why" behind the work.

Announce at start: "I'm using the writing-product-specs skill to create the product specification."

**Core principle:** Product specifications are detailed descriptions of the features and functionality of a product. They are used to communicate the requirements of the product to the development team.

## When to Use This Skill

Use this skill when:
- You are explicitly asked to write a product specification, product spec, or PRD (Product Requirements Document)
- You are asked to design a new feature and need to document requirements before implementation
- You are planning a project and need to define what will be built and why
- You need to communicate product requirements to stakeholders, engineers, or designers
- A feature request needs to be expanded into a detailed specification with context, requirements, and success criteria
- You are asked to document the "what" and "why" of a product decision before moving to implementation

Do NOT use this skill for implementation plans — specs describe what to build and why, not the step-by-step engineering work.

## Process for Writing a Product Spec

Follow this process to elicit the necessary information and compose a comprehensive product specification.

### Step 1: Understand the Requested Feature or Project

Ask questions to understand the feature or project. Gather information about:

- **What is it?** What feature or project are we building? What does it do?
- **Who is the audience?** Who are we solving this problem for? What are their roles, personas, or characteristics?
- **What are their problems?** What specific pain points or challenges does the audience face? What is broken or missing?
- **How will this feature/project solve them?** What is the proposed solution? How does it address the problems?
- **How will they benefit? What specifically is the benefit?** What value does this deliver? What outcomes or improvements will users experience?
- **How will we know if we've succeeded?** What are the success metrics, validation criteria, or observable outcomes?
- **How will we know if we've failed?** What would indicate failure? What are the failure modes or negative indicators?
- **What are we NOT doing?** What is explicitly out of scope? What related features or capabilities are we excluding?

Continue asking questions until you have enough information to draft a complete spec. Don't proceed to drafting until you have clear answers to these core questions.

### Step 2: Draft the Specification

Using the information gathered, draft the product specification. Follow the section structure in [spec-template.md](spec-template.md). Present the complete draft to the user.

### Step 3: Iterate Based on Feedback

After presenting the draft:
- Ask the user for edits, clarifications, or additions
- Identify gaps in the spec and ask targeted questions to fill them
- Revise the spec based on feedback
- Continue iterating until the user confirms the spec is complete and accurate

### Step 4: Finalize and Save

Once the user confirms the spec is good enough:
- Review the final spec against the section structure in spec-template.md
- Save the spec as a markdown file named `spec-<feature-name>-MM-DD-YYYY.md` (or as requested by the user)
