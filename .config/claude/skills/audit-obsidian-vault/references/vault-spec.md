# Nexus Vault Specification

This is the complete organizational specification for the author's Obsidian vault ("Nexus"). The Note Guardian skill uses this as the authoritative source of truth for all auditing decisions.

## Core Philosophy

"Log Less, Build More." — Topic-based knowledge building (evergreen notes), not time-based logging (journaling fatigue).

### Principles
- **Context over redundancy:** Never repeat the folder name in the tag.
- **Topic-Centricity:** Information lives where it belongs (topic), not when it happened (date).
- **Atomic & connected:** Notes should be small, single-concept units linked together.
- **Fail fast:** The perfect setup doesn't exist; iterate constantly.

---

## Physical Storage: The ACE Framework

Folders define the broad domain or state of the note.

| Directory    | Concept | State        | Description                                                        |
| ------------ | ------- | ------------ | ------------------------------------------------------------------ |
| `1 Efforts`  | Action  | **Active**   | Strategic tracks and projects. Containers for doing work.          |
| `2 Calendar` | Time    | **Temporal** | Meetings, weekly reviews, quarterly artifacts.                     |
| `3 Atlas`    | Truth   | **Permanent**| Core knowledge base. Reference knowledge, zettels, templates.      |
| `9 Archive`  | History | **Inactive** | Graveyard for old project tracks and deprecated notes.             |

### Atlas Sub-Folders
- `Atlas/Infosec` — Security domain
- `Atlas/AI` — Artificial intelligence domain
- `Atlas/DevOps` — Infrastructure & platforms
- `Atlas/Work` — Career & employer context
- `Atlas/Finance` — Money & assets
- `Atlas/Life` — Health, hobbies, house
- `Atlas/Food` — Recipes
- `Atlas/Blog` — Blog post drafts and notes
- `Atlas/Templates` — Note templates

---

## Logical Organization: The 4-Dimension Tagging System

### The Golden Rule of Granularity
A tag must be more specific than the folder it lives in.
- **Wrong:** Note in `Atlas/AI` tagged `topic/ai` (redundant)
- **Right:** Note in `Atlas/AI` tagged `topic/llm` (granular)

### Dimension 1: `kind/*` — The Format

**Rule: Every note must have exactly one kind. Kinds are mutually exclusive.**

| Tag                | Description                                                                    |
| ------------------ | ------------------------------------------------------------------------------ |
| `kind/concept`     | Theories, zettels, book notes, definitions, evergreen knowledge notes          |
| `kind/summary`     | Synthesized distillations (meeting summaries, reviews, book summaries)         |
| `kind/blueprint`   | Reusable/executable implementations (code, scripts, detection rules, configs)  |
| `kind/guide`       | SOPs, how-to guides, playbooks, cheatsheets                                   |
| `kind/project`     | Main track/index note for an effort (single source of truth)                   |
| `kind/map`         | Maps of content, TOCs, Dataview dashboards, navigational notes                 |

### Dimension 2: `topic/*` — The Subject

**Rule: Every note must have at least one topic.**

**Infosec topics:**
- `topic/detection` — Engineering rules, signals
- `topic/intel` — Actors, campaigns
- `topic/forensics` — IR, analysis
- `topic/compliance` — PCI, GDPR
- `topic/appsec` — Vulnerabilities, code review
- `topic/engage` — Adversary engagement, deception, delay

**AI topics:**
- `topic/llm` — Generative text, RAG
- `topic/agents` — Autonomous loops
- `topic/prompting` — Engineering prompts
- `topic/ml` — Core Machine Learning concepts

**DevOps topics:**
- `topic/infra` — Cloud, IaC, networking
- `topic/observability` — Logging, metrics, tracing
- `topic/dev` — Software engineering, algorithms, Git workflows, SDLC

**Finance topics:**
- `topic/tax` — IRPF, declaring
- `topic/assets` — Real estate, vehicles
- `topic/investing` — Stocks, strategy
- `topic/budget` — Cashflow, spending
- `topic/crypto` — Blockchain assets

**Life topics:**
- `topic/immigration` — Visa, life abroad
- `topic/culture` — Living, language
- `topic/health` — Workout, mental
- `topic/hobbies` — Books, games, fun
- `topic/recipes` — Food, drink

**Work topics:**
- `topic/career` — Growth, promotions, interviews
- `topic/creation` — Blog, talks, open source

**Meta:**
- `topic/meta` — The system itself: dashboards, readmes, templates, Dataview queries

### Dimension 3: `stack/*` — The Entities

Concrete tools, technologies, or organizations.

- **Cloud:** `stack/aws`, `stack/k8s`, `stack/gcp`
- **Data Pipeline:** `stack/pipeline` (Cribl, ObservIQ, Vector, Fluentd)
- **Code:** `stack/python`, `stack/rust`, `stack/shell`, `stack/sql`
- **Tools:** `stack/git`, `stack/terraform`, `stack/docker`, `stack/macos`, `stack/linux`
- **Security:** `stack/chronicle`, `stack/splunk`, `stack/elastic`, `stack/falco`, `stack/cortex`, `stack/misp`
- **Frameworks:** `stack/mitre` (ATT&CK, Engage)
- **Context:** `stack/nubank` (employer ecosystem)

### Dimension 4: `status/*` — The Garden (Optional)

Used only for knowledge notes to track maturity.

- `status/seed` — Stub, draft, "to do"
- `status/sapling` — In progress, evolving
- `status/evergreen` — Polished, trusted reference

---

## Key Rules & Patterns

### The Concept vs. Tool Distinction
- `topic/*` = abstract discipline, methodology, theory (exists independently of any tool)
- `stack/*` = concrete tool, vendor, product used to implement the concept

Examples:
- "Branching strategies" → `topic/dev`
- "Git cherry pick command" → `stack/git`
- "Gitflow workflow" → `topic/dev` + `stack/git`
- "Sigma rule logic" → `topic/detection`
- "Writing Sigma rules for Splunk" → `topic/detection` + `stack/splunk`

### Blueprints (Code Handling)
1. Small queries → Embed in concept note
2. Reusable scripts → Blueprint note in Atlas/Infosec or Atlas/DevOps
3. Complex projects → Store in GitHub, link from Blueprint note

### Performance Reviews
All use `kind/summary` + `topic/career` and live in `2 Calendar/Reviews/`.
- Weekly: `YYYY-WNN`
- Quarterly: `YYYY-QN`
- Yearly: `YYYY`
- Master CV: `3 Atlas/Work/Master CV.md`

### Meeting Notes
Live in `2 Calendar/Meetings/` with format `YYYYMMDD Title.md`.

### Project Tracks
Live in `1 Efforts/<Year Project Name>/` with a `Track - <name>.md` index note.

---

## Folder-to-Topic Mapping (for Redundancy Detection)

These folder-topic combinations are REDUNDANT and should be flagged:

| Folder             | Redundant Tag       | Use Instead (examples)                        |
| ------------------ | ------------------- | --------------------------------------------- |
| `Atlas/Infosec`    | `topic/infosec`     | `topic/detection`, `topic/intel`, etc.         |
| `Atlas/AI`         | `topic/ai`          | `topic/llm`, `topic/agents`, etc.             |
| `Atlas/DevOps`     | `topic/devops`      | `topic/infra`, `topic/dev`, etc.              |
| `Atlas/Finance`    | `topic/finance`     | `topic/tax`, `topic/investing`, etc.          |
| `Atlas/Life`       | `topic/life`        | `topic/health`, `topic/hobbies`, etc.         |
| `Atlas/Work`       | `topic/work`        | `topic/career`, `topic/creation`, etc.        |
| `2 Calendar`       | `topic/calendar`    | `topic/career` (for reviews), etc.            |
