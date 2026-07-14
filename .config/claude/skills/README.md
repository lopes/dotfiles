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

## audit-obsidian-vault

Audit an Obsidian vault's organizational health: tags, folder placement, naming conventions, and structural integrity.

**Modes:**
- **Vault Audit** — full health report from a tree listing or vault summary file
- **Single Note Review** — where should this note go? how should it be tagged?
- **Taxonomy Evolution** — add/merge tags, restructure folders

**Examples:**
```
/audit-obsidian-vault
Here's my vault summary: [paste vault-summary.txt]

/audit-obsidian-vault
Where does this note belong? [paste frontmatter]

/audit-obsidian-vault
I want to add a tag for "threat modeling" — where does it fit?
```

**Tip:** Generate vault input with the bundled script:
```bash
python ~/.config/claude/skills/audit-obsidian-vault/scripts/vault-summary.py ~/Documents/Nexus -o vault-summary.txt
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

## scaffold-deck

Scaffold a Quarto revealjs deck for lopes.id from a rough outline, a talk brief, or an existing blog post. Emits `decks/<slug>/index.qmd` with the vigil-reveal theme, correct front matter (`tlp`, `duration`, `theme`), and slide conventions applied. Duration-aware — budgets against the speaker's time slot and refuses to overfill.

**Inputs:** outline, talk brief, or blog post path.
**Output:** `decks/<slug>/index.qmd` — silent-publishable (no navbar entry, no talks index, TLP badge applied).

**Examples:**
```
/scaffold-deck
25-min conference talk on Chronicle DaC. Outline: [paste]

/scaffold-deck
Turn this blog post into a talk: [path to .qmd]

/scaffold-deck
Scaffold a 10-minute internal deck on our SIEM ingestion pipeline.
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

## review-checkpoint

Review and improve periodic career checkpoint notes — weekly, quarterly, yearly, and CV updates.

**Hierarchy:** Weekly → Quarterly → Yearly → CV. Each level filters the one below.

**Examples:**
```
/review-checkpoint
Here's my weekly note: [paste note]

/review-checkpoint
Which of these weekly items should be promoted to quarterly?

/review-checkpoint
Review my CV with this year's wins: [paste CV]
```

---

## review-cv

Brutally honest CV / résumé review for a Lead Security Engineer. Format-agnostic — handles LaTeX, Typst, Markdown, or plain text. Cross-references against `Master CV.md` when available.

**Four-pass review:**
1. Credibility — future-dated claims, label honesty (CEFR/ILR), Master CV mismatches, risky framing
2. Structure & Positioning — first-screen anchor, section order, role density, people-leadership evidence
3. Bullet Quality — problem→action→result, quantification, first-person ownership, length
4. Format & Polish — duplicates, location specificity, tense consistency, page count

**Output:** Severity-tiered review (Critical / Important / Minor) with file:line citations. Author triages → skill applies fixes on request.

**Examples:**
```
/review-cv
[point at a CV file or paste content]

/review-cv
Review my CV against best practices: [path to CV]

/review-cv
Is everything OK?
```
