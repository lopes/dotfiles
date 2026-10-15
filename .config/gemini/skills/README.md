# Skills

Custom Gemini skills for personal workflows.

---

## refine-text

Refine my own writing (blog post, .qmd, LinkedIn post, email, notes) so it reads as natural, native English while staying unmistakably mine. Two jobs: fix grammar and unnatural (Portuguese-influenced) phrasing, and strip AI tells — then teach the recurring mistakes. Edits in place; leaves emoji alone.

**Passes:** Grammar & naturalness → Lexical → Phrase → Structural → Tonal → Punctuation → Specificity flag.

**Output:** the text edited in place (file) or returned inline (paste), then an on-screen tutor summary — recurring English patterns (wrong → right + rule), voice/AI-tell notes, and items flagged for my judgment.

**Voice anchor:** `references/author-profile.md` holds real "this is you / this is drift" samples.

---

## analyse-chronicle-delays

Diagnose ingestion and detection latency across one or more Chronicle (Google SecOps) SOAR cases. Pulls each case's alerts and computes deltas between `event_timestamp` → `ingested_timestamp` (ingestion delay) and `ingested_timestamp` → `detection_timestamp` (SIEM/rule-engine delay). Flags `DETECTION_TIMING_DETAILS_*` tags (e.g. `REPROCESSING`, `BACKFILL`).

**Input:** numeric case IDs or full Chronicle case URLs (mixed is fine).
**Read-only:** never closes cases, never posts comments.
**Requirements:** SecOps MCP server configured in `mcp_config.json`.

---

## analyse-chronicle-case

Analyse a Chronicle (Google SecOps) SOAR case and produce a tight, IR/SOC-grade summary with three sections: Analysis, Evidences, References.

**Input:** numeric case ID or full Chronicle case URL.
**Read-only:** never closes cases, never posts comments.
**Requirements:** SecOps MCP server configured in `mcp_config.json`.

---

## checkpoint

Synthesize weekly, quarterly, and annual career impact checkpoints for a Senior Security Customer Engineer and Platform Architect. Automatically harvests footprint (recent Drive edits, tasks, calendar alignments, issue tracker tickets, Git commits, and code review changelists), prompts only for qualitative context, applies temporal grounding and negative caching, and produces structured recaps (Key Moves, Artifacts, Blockers) with a Chief of Staff executive assessment.

**Triggers:** `/checkpoint [weekly|quarterly|annual]` or "run checkpoint weekly", "weekly recap", "checkpoint quarterly", "checkpoint annual".
**Cadences:**
- `weekly`: 3-part Weekly Recap + Chief of Staff feedback → feeds weekly snippets and quarterly doc tab.
- `quarterly`: 4-Track STAR synthesis across 13 weeks + Role Expectation Check + triggers strategy refresh.
- `annual`: Year-end synthesis of top 5–7 wins into Master CV Delta format.
