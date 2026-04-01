# Skills

Custom Claude Code skills for personal workflows. Invoke with `/skill-name`.

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
