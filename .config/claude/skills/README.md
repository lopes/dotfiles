# Skills

Custom Claude Code skills for personal workflows. Invoke with `/skill-name`.

---

## ai-tells-cleaner

Review text and remove AI-generated patterns — overused vocabulary, formulaic structures, em-dash drench, sycophantic openers, hedging filler, and closing offers — while preserving the original meaning, opinions, structure, and voice.

**Passes:**
1. Lexical Sweep — Tier-1/Tier-2 vocabulary substitution
2. Phrase Sweep — filler phrases deleted or flattened
3. Structural Sweep — "It's not X, it's Y" reframes, rule-of-three, anaphora abuse
4. Tonal Sweep — hedging frames, sycophancy, closing offers
5. Punctuation Sweep — em-dash density, decorative emoji, semicolons
6. Specificity Flag — unsourced claims flagged for author (not auto-fixed)

**Output:** cleaned text + change log + manual review items.

**Examples:**
```
/ai-tells-cleaner
[paste text from ChatGPT/Claude/Gemini]

/ai-tells-cleaner
Humanize this: [paste draft]

/ai-tells-cleaner
De-slop this LinkedIn post: [paste post]
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

## review-linkedin-post

Draft, review, or polish LinkedIn posts. Enforces zero-fluff, technically credible voice — no teasers, no bro-etry, exactly 3 hashtags.

**Modes:**
- **Ideation** — notes or topic → 3 post options (Tooling, Philosophy, Quick Win)
- **Review & Polish** — draft → critique + ready-to-post rewrite
- **Blog → LinkedIn** — blog post → standalone LinkedIn post (no URL in body)

**Examples:**
```
/review-linkedin-post
Post idea about our SIEM migration: [paste notes]

/review-linkedin-post
Review this draft: [paste post]

/review-linkedin-post
Turn this blog post into a LinkedIn post: [paste draft or link]
```

---

## review-blog-post

Review and polish technical blog post drafts for lopes.id (Quarto).

**Three-pass review:**
1. Language & Fluency — grammar, flow, tense
2. Structure & Readability — headings, section length, code blocks
3. Technical Accuracy — infosec terminology, tool names, code validity

**Output:** full revised article in a Markdown code block + editorial notes with recurring patterns and improvement tips.

**Examples:**
```
/review-blog-post
[paste .md or .qmd draft]

/review-blog-post
Proofread and check MITRE references: [paste draft]
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
