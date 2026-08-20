# Skills

Custom Claude Code skills for personal workflows. Invoke with `/skill-name`.

---

## refine-text

Refine my own writing (blog post, .qmd, LinkedIn post, email, notes) so it reads as natural, native English while staying unmistakably mine. Two jobs: fix grammar and unnatural (Portuguese-influenced) phrasing, and strip AI tells — then teach the recurring mistakes. Edits in place; leaves emoji alone. Replaces the old review-blog-post, review-linkedin-post, and refine-ai-text skills.

**Passes:** Grammar & naturalness → Lexical → Phrase → Structural → Tonal → Punctuation → Specificity flag.

**Output:** the text edited in place (file) or returned inline (paste), then an on-screen tutor summary — recurring English patterns (wrong → right + rule), voice/AI-tell notes, and items flagged for my judgment.

**Voice anchor:** `references/author-profile.md` holds real "this is you / this is drift" samples.

**Examples:**
```
/refine-text
[point at a .qmd/.md file or paste a draft]

/refine-text
Make this sound natural and more like me: [paste draft]

/refine-text
Fix my English and de-slop this: [paste post]
```

---

## scaffold-detection-rule

Scaffold a complete DaC YAML rule from minimal input. Provide logic + context; everything else is inferred.

**Minimum input:** detection query (YARA-L or similar) + a brief context note.
**Output:** ready-to-use YAML + scaffolding notes listing assumptions and fields that need review.
**Defaults:** `maturity: experimental`, `alerting: false`, `frequency: HOURLY`.

**Examples:**
```
/scaffold-detection-rule
Logic: [paste YARA-L query]
Context: Detects users accessing suspicious OAuth apps for the first time.

/scaffold-detection-rule
Fill in this partial rule: [paste incomplete YAML]
```

---

## analyse-chronicle-delays

Diagnose ingestion and detection latency across one or more Chronicle (Google SecOps) SOAR cases. Pulls each case's alerts and computes deltas between `event_timestamp` → `ingested_timestamp` (ingestion delay) and `ingested_timestamp` → `detection_timestamp` (SIEM/rule-engine delay). Flags `DETECTION_TIMING_DETAILS_*` tags (e.g. `REPROCESSING`, `BACKFILL`).

**Input:** numeric case IDs or full Chronicle case URLs (mixed is fine).
**Read-only:** never closes cases, never posts comments.

**Examples:**
```
/analyse-chronicle-delays 17945
/analyse-chronicle-delays 17945 17946 18002
Why is case 17945 slow?
```

---

## Moved to the Obsidian vault

These vault-coupled skills now live **inside the vault repo** (`~/Documents/notes/.claude/skills/`) so they travel and version with the notes they operate on. They load automatically when working inside the vault:

- **audit-obsidian-vault** — vault organizational health (tags, placement, naming, orphans). Bundled script: `~/Documents/notes/.claude/skills/audit-obsidian-vault/scripts/vault-summary.py`.
- **review-checkpoint** — weekly / quarterly / yearly / CV checkpoint reviews.
- **review-cv** — brutally honest CV / résumé review against `Master CV.md`.

## Moved to lopes.id

- **scaffold-deck** now lives in `~/Projects/lopes.id/.claude/skills/scaffold-deck` — it only makes sense inside that repo, and loads automatically when working there.
