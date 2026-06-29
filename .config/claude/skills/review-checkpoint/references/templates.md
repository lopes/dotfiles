# Checkpoint Templates

These are the author's Obsidian templates for each checkpoint level. The skill must respect this structure when reviewing notes. The single source of truth for the framework is the author's `[[Career Checkpoint Framework]]` note in the vault — this file mirrors the rules and shapes so the skill can apply them without loading the vault note every time.

## Hierarchy

```
Weekly Impact (every Friday)
  └─► Quarterly Performance (end of quarter, from weeklies)
       └─► Yearly Review (end of year, from quarterlies)
            └─► Master CV (refreshed once per year, from yearly)
```

Each level filters for increasing impact. Weeklies capture everything meaningful. Quarterlies promote only items that change the author's narrative. Yearlies promote only career-defining wins. The CV keeps the best of the best.

## The 4 Tracks (used at every level — no renaming)

- **🛠️ Engineering** — build work for impact. Employer projects and personal research live together. Detection systems, platforms, tooling, services, prototypes, RFCs that ship code.
- **📣 Voice** — public-facing signal. Blog posts published, talks given, OSS releases with users, written pieces that traveled.
- **📚 Learning** — knowledge acquired. Bar is **completion** of a learning artifact: books finished, labs completed, courses with deliverables, certifications earned. Application of the learning surfaces in Engineering / Voice / Leadership, not in Learning. The same source can legitimately appear in multiple tracks (book finished → Learning; review post → Voice; technique applied → Engineering).
- **🤝 Leadership** — visible influence: mentorship outcomes, hiring outcomes, cross-team RFCs that changed someone else's roadmap, internal advocacy that moved a decision.

**No renaming between levels.** Same 4 names, same order. Track-name drift breaks aggregation.

## The Status Verbs (weekly level only)

Three sub-headings under each track in the weekly: `Shipped`, `Building`, `Blocked`. Each carries a strict rule.

### Shipped — must include the impact

Measurable change: numbers, time saved, scope, audience, detections added. If the author can't state the impact, it isn't Shipped. It's Building (waiting for measurement) or it doesn't belong.

- Weak: "Updated 5 wiki pages"
- Strong: "Updated 5 wiki pages covering onboarding for the data pipeline — cut new-hire ramp questions in the team channel by ~half over two weeks"

### Building — must include the status

Valid statuses: in review (with reviewers), awaiting deploy / approval (with owner), drafted to N% / a specific stage. "In progress" or "ongoing" is not a status.

- Weak: "Working on the platform RFC"
- Strong: "Platform RFC drafted, in review with two reviewers — expected merge by next Friday"

### Blocked — must include the reason

Named blocker, named unblocker. "Waiting on X" is weak; "Waiting on the infra team's IAM perms — pinged Alex Tuesday, no response yet" is real.

- Weak: "Waiting on infra"
- Strong: "Waiting on infra-team IAM permissions for the deploy account — pinged Alex on Tuesday, no response yet"

Empty status sub-headings get deleted. An entirely empty track section in a quiet week is valid — don't fill with filler.

---

## Weekly Impact Template

```markdown
---
tags:
  - topic/career
week: <week_number>
quarter: <quarter_number>
year: <year>
references:
  - "[[Career Checkpoint Framework]]"
---

## Context & Vibe
[How did this week feel? The "why" behind your performance.]

---

## 🛠️ Engineering
*Build work for impact — employer projects and personal research.*

#### Shipped
*Each bullet must state the impact.*
- 

#### Building
*Each bullet must state the status.*
- 

#### Blocked
*Each bullet must state the reason.*
- 

---

## 📣 Voice
*Public-facing signal — blog, social, talks, releases.*

#### Shipped
- 
#### Building
- 
#### Blocked
- 

---

## 📚 Learning
*Books, labs, courses, sessions attended.*

#### Shipped
- 
#### Building
- 
#### Blocked
- 

---

## 🤝 Leadership
*Mentorship, hiring, cross-team influence.*

#### Shipped
- 
#### Building
- 
#### Blocked
- 

---

## ⏭️ Next Week's Big Rocks
1. 

---

## 📂 Notes Modified This Week
[dataview]
```

**Key principles:**
- Apply the per-status rule to every bullet before committing it.
- Track-name drift between weeks kills aggregation — reject it.
- Building is not a parking lot for "stuff I touched." If a thing didn't move this week, it goes in Blocked (with a reason) or off the weekly.
- Big Rocks are concrete and achievable — 1–3 items, not aspirations.

---

## Quarterly Performance Template

```markdown
---
tags:
  - topic/career
weeks: <range>
quarter: <quarter_number>
year: <year>
references:
  - "[[Career Checkpoint Framework]]"
---

> [!abstract] Executive Summary
> [Elevator pitch — theme, biggest win, trajectory.]

---

## 🛠️ Engineering
*Aggregate Shipped + Building-that-shipped from this quarter's weeklies. Full STAR per item.*

#### [Achievement title]
- **Context:** [Why this mattered]
- **Action:** [What the author specifically did]
- **Result:** [Measurable outcome]
- **Collaborators:** [Named people]

---

## 📣 Voice
[same STAR shape]

## 📚 Learning
[same STAR shape — 2–3 max, capability shifts only]

## 🤝 Leadership
[same STAR shape]

---

## 🎯 Principal Plan Checkpoint
*Reference: [[Track - Project Principal]]*

- **Current phase:**
- **On track for phase milestones?**
- **Adjustments:**

---

## 💡 Retro
### Keep Doing
### Stop / Fix

---

## 🔮 Forward Look
### Primary Objectives
### Skills to Develop
```

**Key principles:**
- Roll-up traceability: every STAR Result must trace to a weekly Shipped (or Building-that-shipped) item from this quarter.
- Promotion filter: maintenance doesn't graduate, routine doesn't graduate, team-owned doesn't graduate as the author's achievement.
- Empty Leadership is honest signal — don't fabricate.
- Demand the Principal Plan Checkpoint is filled — it's the link to the long-horizon plan.
- Executive Summary written last.

---

## Yearly Review Template

```markdown
---
tags:
  - topic/career
year: <year>
references:
  - "[[Career Checkpoint Framework]]"
---

> [!abstract] Year in Review
> [One paragraph: the narrative arc of the year. What defined it? What shifted?]

---

## 🏆 Top Achievements
*Career-defining wins only, 5–7 total, organized by track. These graduate to [[Master CV]].*

### 🛠️ Engineering
#### [Achievement 1]
- **Context:**
- **Action:**
- **Result:**

### 📣 Voice
[same shape]

### 📚 Learning
[1–2 max — capability shifts, not course completions]

### 🤝 Leadership
[1–2 max — visible influence, not meetings attended]

---

## 🎯 Principal Plan Status
*Reference: [[Track - Project Principal]]*

- **Phase completed this year:**
- **Phase entering next year:**
- **Plan adjustments:**

---

## 🧠 Reflection
### What Worked
### What Didn't
### Surprises

---

## 🔮 Next Year Direction
### Strategic Themes
### Career Goals
### Things to Let Go
```

**Key principles:**
- Career-defining filter: "Would a top-tier interviewer spend time on this?" If no, it stays in the quarterly.
- Traceability: every Top Achievement must trace to a quarterly STAR block.
- Year in Review abstract is a narrative arc, not a summary of quarters — written last.
- Demand the Principal Plan Status is filled.

---

## Master CV Template

The Master CV (`3 Atlas/Work/Master CV.md`) is the living document that accumulates the best achievements from yearly reviews. Standard professional format:

- Header (name, tagline, contact)
- Professional Summary (narrative paragraph)
- Areas of Focus
- Open Source
- Professional Experience (organized by company and role; each bullet uses problem → action → measurable result)
- Education
- Certifications
- Key Skills (Technical + Leadership)
- Speaking & Publications
- Awards & Volunteering
- Languages

**Key principles:**
- Accomplishment language only: "To [solve problem], I [action], which resulted in [measurable outcome]."
- Never list responsibilities — list results.
- Past tense for previous roles, present tense for the current role.
- Quantify everywhere; hedge approximate numbers with "~"; never invent.
- Every new bullet must trace back to a Top Achievement in the most recent Yearly Review.
