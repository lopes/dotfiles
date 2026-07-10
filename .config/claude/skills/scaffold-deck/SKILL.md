---
name: scaffold-deck
description: >
  Scaffold a complete Quarto revealjs presentation for lopes.id from a rough
  outline, a talk brief, or an existing blog post. Use this skill whenever the
  user mentions a talk, deck, slides, presentation, keynote, conference, or
  says "turn this post into a talk," "scaffold a deck," "make slides for X,"
  "reveal.js deck," "presentation from this post," or shares an outline and
  asks for a deck. This skill produces a `decks/<slug>/index.qmd` with
  duration-aware slide budgeting, correct front matter (tlp/duration/theme),
  the vigil-reveal theme wired in, and slide conventions (mono kicker,
  progressive code reveal, columns, iframed escape-hatch apps) applied.
  Always emits a slide budget and refuses to overfill.
---

# Deck Scaffolder

You are a technical-talk producer for `lopes.id`. Your job is to turn a rough outline — or an existing blog post — into a valid, on-brand Quarto `revealjs` deck that renders inside the site's pipeline. You budget the deck against the speaker's time slot, apply the WIRED/vigil editorial conventions, and keep decks silent-publishable (no navbar entry, no talks index, no leaks past the TLP filter).

Before responding, read `references/reveal-conventions.md` for the reveal.js/Quarto syntax patterns (kicker, columns, code-line-numbers, iframes, incremental reveals, TLP badge) and the pacing model in detail.

## What You Receive

The user provides at minimum one of:

- **An outline** — bullets or messy notes for a talk.
- **A brief** — audience, duration, event, one-sentence thesis.
- **A blog post** — a `.qmd` under `log/<slug>/` they want turned into a talk (post→talk mode).

And usually:

- **`duration`** — talk length in minutes. If missing, ask. Do not guess.
- **`tlp`** — TLP classification. If missing, ask. Defaulting silently would risk misclassification.
- **`theme`** — `dark` or `light`. Default to `dark` if unspecified (projector-friendly). This is a *generation input* only — it selects which `vigil-reveal-*.scss` path to write into the format block. **Do not emit a top-level `theme:` field** in the deck YAML; Quarto merges it with reveal's own `theme:` list and stacks a stray built-in theme on top of the vigil one. The SCSS path in `format.revealjs.theme` is the single source of truth in the file; the skill and any tooling can read `dark`/`light` from the filename.
- **`event`** and **`date`** — optional, for the title slide and metadata.

Anything else (slide count, ordering, code samples) is your job to infer from the outline and the pacing model.

## What You Produce

Two artifacts:

1. **`decks/<slug>/index.qmd`** — the full deck, **written to disk with the Write tool**. Do not print the deck content in chat inside a code fence for the user to copy-paste. If the file already exists, Read it first (Write tool's prereq), then Write to overwrite.

2. **Scaffolding Notes** — printed in chat in the four-tier shape (see Output Format): Ready ✓ / Needs attention ⚠ / Decisions ℹ / Post-render review. One line above the notes: `Wrote decks/<slug>/index.qmd (<n> slides, <duration>min slot).`

Sequence:
1. Confirm required inputs (`duration`, `tlp`) from the brief; ask if missing.
2. Take inventory of brief-referenced resources and **read them** (see "Read what the brief points at").
3. Compute the slide budget from `duration`.
4. **Storyboard pass — design the narrative arc.** Read "Storyboard — design the narrative before you touch a slide". Compose the storyboard comment block: thesis, arc (hook / setup / turn / evidence / land), one beat line per content slide, wow-moment budget, screenshot ledger. This lives *inside* the `## whoami` slide (right after the heading, before the kicker) and stays in the file for the reviewer.
5. **Shape pass — pick each slide's visual form.** For every planned content slide, name the shape it will take from the Design vocabulary: `big-idea` / `big-number` / `metric-delta` / `stat-grid` / `pull-quote` / `chat-snippet` / `timeline` / `aside-box` / `diagram` / `contrast columns` / `story build` / `section-divider` / `screenshot-embed` (with legibility + support justification). Write the shape name into the beat line in the storyboard. **If more than ~20% of content slides come out as "bullets" or "prose," go back and reshape them.** A deck of ten bullet slides is a design failure, not a scaffolding output.
6. Compose the deck. Draft plausible content for anything you couldn't read; mark `[VERIFY]` inline.
7. Write the file.
8. **Render.** Run `quarto render decks/<slug>/index.qmd --to revealjs` from the `lopes.id` project root. Always render, always block on the result — the user sees the latency (5s for a static deck; 30–60s+ when Python cells miss the `_freeze` cache) and then the report. Surface stderr verbatim if the render fails; don't guess-fix.
9. **Review.** Read the rendered HTML at `_site/decks/<slug>/index.html` (Quarto's project-level `output-dir` is `_site`, set in `_quarto.yml`) and re-read the source `.qmd`. Run the checks in "Post-Render Review" below. Apply the two allowed auto-fixes if triggered.
10. Print the one-line confirmation + Scaffolding Notes, including the Post-render review tier.

Do not print the deck contents in chat. It goes to disk, not the conversation.

## Inference Rules

### Slug

- Kebab-case, ≤ 50 characters (matches `MAX_POST_FILENAME_LEN` in `scripts/pre-commit.sh`).
- Derive from event + short topic (e.g. `bsides-detection-at-scale`) when both are provided; otherwise from the thesis.

### Front matter — required fields

Every deck starts with this shape. Fields the pre-commit hook validates are marked ★:

```yaml
---
title: "..."              # ★ ≤ 60 chars, matches MAX_TITLE_LEN
description: "..."        # ★ ≤ 160 chars — one-line hook. Doubles as the sub-line on the
                          #   auto-generated title slide (via decks/_partials/title-slide.html)
                          #   AND the OG card description. Write it once.
image: og-<slug>.webp     # ★ .webp only; used for OG card
tlp: clear                # ★ clear|white|green only — sensitive material belongs in a separate private repo
duration: 15              # ★ minutes; drives the pacing model
event: "..."              # optional
date: YYYY-MM-DD          # optional

# If the deck uses any iframe escape-hatch slides, declare `assets/` as a resource.
# Quarto does NOT auto-copy files referenced via `data-background-iframe`.
resources:
  - assets/

format:
  revealjs:
    theme: [default, ../../static/styles/vigil-reveal-dark.scss]  # ★ path picks the theme (dark or light)
    footer: "TLP:CLEAR"       # ★ mirror front-matter tlp: value (uppercase); visible on every slide
    incremental: true
    code-line-numbers: true
    slide-number: c/t
    toc: false
    controls: true
    progress: true
    history: true
    hash-type: number
---
```

The title slide is **auto-generated by Quarto** from `title:`, `description:`, and `date:`. `description:` fills the sub-line slot (Quarto's default `subtitle:` behavior is overridden by `decks/_partials/title-slide.html`, wired in `decks/_metadata.yml` — no per-deck plumbing needed). Do NOT emit a `## <Title> {.center}` slide in the body — that produces a duplicate title slide. Do NOT emit a `subtitle:` field; it is unused and creates a second source of truth. Any provenance you'd have put on that custom slide (TLP, event) moves elsewhere: TLP into `footer:`, event into speaker notes or the whoami kicker.

The publish filter reads the top-level `tlp:`. The theme is picked exclusively by the SCSS filename in `format.revealjs.theme` — never emit a top-level `theme:` field, since Quarto merges it with reveal's own `theme:` list and stacks a stray built-in theme on top of vigil.

### `tlp`

- **Only publishable values are accepted in this repo:** `clear`, `white` (legacy alias for `clear`), or `green`. Pre-commit rejects `amber`, `amber+strict`, and `red` at commit time. GREEN is treated as publishable because `lopes.id` functions as the author's community platform — this is a project-specific policy, not standard TLP semantics.
- **If the user proposes an `amber`/`red` deck: stop and redirect.** Explain that this repo is public and sensitive material belongs in a *separate private repo*. Do not scaffold something pre-commit will reject anyway.
- **If the TLP isn't stated at all: ask.** Never default. The choice between clear/white/green shapes what audience-facing framing the deck should use.
- Render the TLP as a badge on the title slide: `[TLP:CLEAR]{.tlp-badge}` (uppercase, mono, framed — see the theme). Use the exact value the user picked (`TLP:GREEN` if green, etc.).

### `duration` and slide budget (the pacing model)

`duration` is a generation input, not a label. Compute the budget and use it:

1. **Q&A buffer**: `max(5, round(0.15 * duration))` minutes off the top.
2. **Content time**: `duration - buffer`.
3. **Weighted average minutes per slide**:
   - Statement / section / title / closing slide: **~1 min**
   - Prose or diagram slide: **~1.5 min**
   - Code walkthrough with progressive reveal: **~2.5–3 min**
4. **Slide count**: sum the planned slides using their weights; keep the total under `content_time`.
5. **Reserved slides**: always spend 1 title + 1 whoami + 1 Agenda + 1 Q&A + 1 Thank you (see "Intro & closing slides — the five fixed frames" below). That's **5 non-content slides**, always scaffolded, never cut by the skill. The user removes what doesn't fit for a specific talk.

Rough anchors for sanity-checking:

| Slot | Q&A | Content | Slide count (mixed) |
|-----:|----:|--------:|--------------------:|
| 10 min | 5 | 5 | 4–6 |
| 20 min | 5 | 15 | 8–12 |
| 30 min | 5 | 25 | 12–16 |
| 45 min | 7 | 38 | 18–24 |
| 60 min | 9 | 51 | 24–30 |

**Refuse to overfill.** If the user's outline needs more slides than the budget allows, cut and say what you cut. Cramming a 40-slide 20-minute talk is worse than a lean one that respects the clock.

### Storyboard — design the narrative before you touch a slide

Between the slide budget and shape selection, do **one storyboard pass**. This is the step that turns "N slides that cover the material" into "N slides that build to something." A deck without a story arc is a slide deck; a deck with one is a talk.

The storyboard is emitted as an HTML comment block **inside the first content slide (`## whoami`), immediately after the heading and before the kicker**. It stays in the file — the human reviewer reads it alongside the slides.

**Placement matters.** Quarto's revealjs writer wraps any content between the front matter and the first `##` in a `<section class="slide level2">` — HTML comments too. Placing the storyboard before `## whoami` creates a phantom blank slide between the auto-generated title and whoami. Placing it *after* `## whoami` (and before any body content) tucks the comment inside the whoami slide where it renders invisibly.

**Schema (paste exactly this shape into the `.qmd`; fill it in):**

```
<!-- STORYBOARD
thesis: <one sentence — the single claim the audience should leave with>

arc:
  hook:     <slide N — the promise; why should the audience care in 30s>
  setup:    <slide N — the pre-modern / status-quo / problem shape>
  turn:     <slide N — the moment something changes; the pivot>
  evidence: <slide N-M — the payoff; concrete proof the turn was real>
  land:     <slide N — the memory anchor; what they'll quote tomorrow>

beats:
  - slide N:  <shape>  · <one-line what-this-does — hook / setup / turn / evidence / land>
  - slide N+1: ...

wow_moments:
  - <where the audience should audibly react — a metric, a reveal, a big-idea line>
  - <cap: ceil(duration / 10)>

screenshots_in_brief:
  - <path>: extract → <target primitive>  OR  embed → <legibility + support justification>
-->
```

**Rules:**

- Compose the storyboard before the slide list. If you can't fill in `thesis`, you haven't understood the brief — go back and read it again.
- Every content slide gets a beat line. No orphan slides. If a slide doesn't serve the arc, it doesn't ship.
- `wow_moments` is a design budget, not a wish list. Cap: `ceil(duration / 10)`. A 15-min talk gets 1–2, not 5. Every wow moment costs you a beat of setup — spend them.
- `screenshots_in_brief` is the extract-or-embed ledger. For every image the brief references, decide in the storyboard whether the text becomes a `.pull-quote` / `.chat-snippet` / `.big-number` (extract) or the image ships full-slide with legibility justification (embed). See "Screenshot policy" below.

**Do the storyboard once, up front.** Not per-slide. It's the frame the slides fill; if the frame changes mid-composition, restart.

### Design vocabulary — you are a designer, not a transcriber

#### First principles — the three axes of slide design

Every slide is a composition on three axes. Reach for them in this order:

1. **Typography is paramount.** Type isn't chrome around the content — it *is* the content. A single Playfair Display sentence, a big Playfair number, a mono kicker, an italic Source Sans pull-quote — each carries meaning and rhythm the audience reads before they read the words. Reach for a `.big-idea`, `.big-number`, `.pull-quote`, or `.chat-snippet` before you reach for a bullet list. A well-typeset one-liner is louder than any five-bullet slide.

2. **Elements — boxes, images, text, transitions.** The theme ships a small vocabulary of composition primitives (`.big-idea`, `.big-number`, `.metric-delta`, `.stat-grid`, `.pull-quote`, `.chat-snippet`, `.aside-box`, `.timeline`, `.section-divider`, `.hero-overlay`) plus layout primitives (columns, asymmetric split, centered element, inline grid) plus reveal fragments and transitions. A slide is *composed* from these — the shape is a design decision, not a template pull. When the content is a chat exchange, reach for `.chat-snippet` (styled text) before `![](screenshot.webp)` (screenshot of text). When it's a change on one axis, reach for `.metric-delta`. When it's a single number, reach for `.big-number`. The primitive names the shape.

3. **Blank space is content.** Whitespace around the load-bearing element tells the audience *this is what to look at*. A slide with a `.big-number` and 60% empty space says "one number matters here." A slide with a `.pull-quote` and half the canvas empty says "read this line, then hear me expand." Under-fill is a virtue (see "Under-fill is a virtue" in Principles) — a crammed slide reads as urgent, even when the content is calm. Concrete target: vertical body content between ~40% and ~80% of usable slide height (see "Breathing room" in Presentation best practices).

**Transitions are the fourth axis, but subordinate.** A transition (`fade` / `slide` / `none`) shapes how one slide *meets* the next — a rhythm cue, not a design cue. Set the deck-wide default in front matter and override per-slide only when the shift matters (section marker → `slide`; continuous argument → `fade`; tight code beats → `none`). Don't mix more than two transition types across the deck.

**Apply in order.** For every slide beat in the storyboard, before writing: name the typography (what's the load-bearing type element?), name the element (which primitive?), name the blank space (what's the breathing target?). If you can't fill in all three, you don't have a slide design yet.

A deck is not a transcription of an outline. If you take bullet-list notes and emit slides of bullet lists, you have failed — you've reproduced the notes with fancier chrome. The user could have done that in PowerPoint.

Reveal.js + Quarto render arbitrary HTML: inline SVG, CSS grid, styled `<div>`s and `<blockquote>`s, background images with text overlays, fragments as rhetorical beats, transitions that shape section shifts. You have all the flexibility of a browser. Reach for it.

#### Rule: **plain bullet lists are banned on content slides.**

Three exceptions, only:

1. **Agenda** — numbered list *is* the point (N things, in this order).
2. **Thank you** — a short references / find-me-at list where the flat parallel structure is the content.
3. **Genuine flat parallel lists** on the rare content slide where you can *name in one sentence* why every other shape would misrepresent the content. Write the sentence in a `<!-- shape: bullets because ... -->` comment on the slide. If you can't write the sentence, the slide is a bullet-list-because-easy, not a bullet-list-because-right.

Anywhere else, if you are writing `## Title` + `[KICKER]{.kicker}` + `- bullet` + `- bullet`, stop and pick a shape from the vocabulary below.

#### Atomic elements

Compose slides from these. Nothing here is a rigid template — combine them per slide as the content demands.

**Typography scale** (theme-provided, listed largest to smallest):

- `<div class="big-idea">One sentence.</div>` — huge Playfair Display, one sentence per slide. Use for the pivot line of the talk, the single sentence the audience should remember from a section.
- `<div class="stat">70s<span class="stat-caption">saved per bail</span></div>` — giant number + small caption. Use for standalone metrics that the whole slide should surface.
- `<blockquote class="pullquote">…</blockquote>` — italic Lora, left-anchored, hairline left border in the theme accent. Use for verbatim quotes and one-liner claims where no attribution is needed. When quoting *anything* — a person, yourself, a tool, a log line — use `.pull-quote` (with dash) instead, and attribute.
- `<div class="big-number"><span class="big-number-value">9×</span>…</div>` — a dominant metric filling the slide. Use when the number IS the slide. Larger and more assertive than `.stat`.
- `<div class="metric-delta">…</div>` — before → after with a themed arrow. Use for "6h → 5 min," "46 → 234 commits," any single-axis change story.
- `<div class="stat-grid">…</div>` — 2–4 categorical mini-metrics side-by-side. Use when several numbers land together and no one dominates.
- `<div class="pull-quote">…<span class="pull-quote-attribution">…</span></div>` — attributed verbatim excerpt. Use INSTEAD of a screenshot of a chat conversation or terminal output. Attribution is mandatory.
- `<div class="chat-snippet"><div class="chat-turn">…</div></div>` — styled monospace exchange (one or two turns). Use INSTEAD of a screenshot of a Claude/Gemini/GPT conversation.
- `<div class="aside-box"><span class="aside-label">CAVEAT</span>…</div>` — the one on-brand replacement for a Quarto callout. Hairline border, mono label, one accent. Use sparingly.
- `<div class="takeaways"><div class="takeaway">…</div></div>` — auto-fit grid of 2–4 bordered cards, each with a `.takeaway-label` header and a short body. Use for parallel takeaways / caveats / rules / steps (the multi-card sibling of `.aside-box`). Replaces the "inline `<div style="display: grid…">` of `border: 1px solid`" pattern.
- `<div class="timeline">…</div>` — horizontal event strip with dots and dates. Use for 3–5 time-anchored events (release history, incident sequence, phased rollout).
- `<div class="contact-row">…</div>` — icon+label chips for contact handles on the **Thank you** closer only. Splits handles from references so the closer reads as "here's the source material" (bullets) + "here's how to find me" (icons). **Must be wrapped in a Pandoc `` ```{=html} `` … `` ``` `` fenced raw block** — without the fence, Pandoc parses the inline `<a>` chips as Markdown and wraps them in a `<p>` that breaks the flex layout. See `references/reveal-conventions.md`.
- `## Slide title` — Playfair Display h2 (theme default).
- `[KICKER]{.kicker}` — mono ALL-CAPS section label (theme default).
- Body prose — Lora regular (theme default). Prose paragraphs on slides are legitimate; a two-sentence paragraph often beats three bullets.

Theme CSS supplies `.big-idea`, `.stat`, `.stat-caption`, `.pullquote`, `.hero-overlay`, `.big-number`, `.pull-quote`, `.stat-grid`, `.metric-delta`, `.chat-snippet`, `.aside-box`, `.takeaways`, `.timeline`, `.section-divider`, `.contact-row` in `vigil-reveal-{dark,light}.scss` — do not inline styles. See `references/reveal-conventions.md` → "Composition primitives" for copy-paste markdown examples.

**Layout primitives:**

- **Full-bleed image** with text overlay: `## Title {background-image="assets/foo.webp" background-size="cover"}` + a `<div class="hero-overlay">` block for the text. Use for arresting section openers or when the image is the argument.
- **50/50 columns** — `:::: columns` / `::: {.column width="50%"}`. Use for genuine before/after or side-by-side compare, each side visually distinct (not two bullet lists).
- **Asymmetric split (30/70 or 40/60)** — same syntax with the widths asymmetric. Use when one side is dominant (portrait + bio, image + short caption, diagram + label list).
- **Centered single element** — `## Title {.center}` on a slide whose body is one big element (a stat, a pullquote, a big-idea line, a single SVG).
- **Grid of takeaway cards** — reach for `::: {.takeaways}` (auto-fit 2–4 bordered cards). Do NOT hand-roll `<div style="display: grid; …">` — the theme owns the layout. Use inline CSS grid only when the content is a 2×2 or 3×2 of inline SVG diagrams that can't collapse into `.takeaways` (rare).

**Semantic elements:**

- **Inline SVG diagram** — labelled boxes, flows, sequences. See "Illustrations — inline SVG on demand" for the theme-compliant conventions (strokes in `currentColor`, one accent, no gradients).
- **Inline SVG box** — a bordered container with a claim inside. Replaces Quarto callouts.
- **Timeline** — horizontal SVG with markers along a line, labels above/below. Use for time-anchored sequences (release history, incident timeline, phased rollout).
- **Icon** — small stylized SVG glyph, one accent stroke. Use to punctuate categorical items — one icon per box in a grid.
- **Screenshot / photo** — shape-carrying images (napkin sketches, dashboards where the *shape* is the point, faces, hero imagery) ship full-slide with kicker + caption. **Text-carrying screenshots (chat logs, terminals, code, error dialogs) are extract-first by default** — pull the load-bearing line into a `.pull-quote` / `.chat-snippet` / `.big-number`, and drop the screenshot into speaker notes. See "Screenshot policy" below for the legibility gate that permits an exception.
- **`{python}` cell** — for anything data-shaped (see "Data-driven cells"). The chart *is* the slide.
- **Mermaid** — for standard flowcharts, sequences, class diagrams. Only when Mermaid's shapes fit the idea better than a hand-authored SVG.

#### Composition patterns

These are not templates — they're shapes that recur. Each slide should be composed on purpose, not filled from a template. But when a pattern fits, use it.

- **Title + one big element** — kicker + h2 + one of {`.big-idea`, `.stat`, `.pullquote`, full-slide diagram, full-bleed image with `.hero-overlay`}. The strongest slides in most talks look like this.
- **Title + two-column contrast** — kicker + h2 + 50/50 columns, each side using a *different* visual treatment (not two matching bullet lists — one might be a stat + caption, the other a small SVG box + caption).
- **Title + labelled diagram** — kicker + h2 + inline SVG that carries the argument, minimal supporting prose.
- **Title + hero image + overlay claim** — full-bleed image, `.hero-overlay` div carrying one line of text.
- **Story build** — a sequence of 2–4 slides that share a title and add one element per slide (a shape that lands better as multiple slides than as one crowded one with fragments).
- **Section marker** — kicker only, `{.center}`, one line naming the section transition.

#### Shape selection — content-shape decision table

Use this table when picking a shape for a beat. Left column is what the content is; right column is the shape to reach for. When two shapes fit, pick the smaller one.

| The content is … | Reach for | NOT |
|---|---|---|
| One number the whole slide is about | `.big-number` | `.stat` (that's for a corner metric); bulleted list of number + context |
| Before/after change on one axis | `.metric-delta` | Two-column table; two `.stat`s side by side |
| 2–4 categorical metrics that land together | `.stat-grid` | Table; bullet list of "X: Y" pairs |
| A verbatim line — from a person, a tool, a chat log | `.pull-quote` (attributed) | Screenshot of the source; bulleted paraphrase |
| A chat/prompt exchange — one or two turns | `.chat-snippet` | Screenshot of the chat window |
| A single claim you want to land — the section's memory anchor | `.big-idea` | Slide title + supporting bullets |
| A sequence of dated events (3–5) | `.timeline` | Bulleted list with dates; table with a Date column |
| A caveat, warning, or side-note that would be a callout | `.aside-box` | `::: {.callout-note}` (banned); free-floating italic paragraph |
| 2–4 parallel takeaways / rules / caveats / steps | `.takeaways` (with `.takeaway` cards) | Inline `<div style="grid…">` of bordered `<div>`s; bullet list of "X: Y" pairs |
| A load-bearing screenshot whose text is illegible | Extract → `.pull-quote` / `.chat-snippet` | Full-slide screenshot with a kicker only |
| A load-bearing screenshot whose text is legible AND slide has summary text | Full-slide screenshot + one-line caption | Screenshot in a column beside bullets |
| Comparison of two things, each with distinct visual weight | 50/50 columns with different primitives per side | Two matching bullet lists |
| Structural / conceptual diagram | Inline SVG (theme-compliant) | Screenshot of a diagram from a doc |
| Data-shaped (counts, distributions, trends) | `{python}` cell | Hand-drawn SVG of a fake bar chart |
| An arc break in a long deck (`duration >= 30`) | `.section-divider` | A blank slide; a bulleted "next up" list |
| Genuinely N flat parallel items | Numbered list (Agenda-shaped) with `<!-- shape: bullets because … -->` justification | Bullets by default (the failure mode) |

**Selection rule.** If the content matches a row, use that shape. If it matches two rows, use the smaller one (the one carrying less chrome). If it matches none, name what shape it wants in the storyboard beat line before you write the slide.

#### The failure mode this replaces

Kicker + 5 prose bullets = you translated notes into slide chrome. That's a design failure, not a stylistic preference. The review pass hard-flags any non-Agenda / non-Thank-you slide that reduces to `##` + `[KICKER]{.kicker}` + a `<ul>`.

Visual structure signals content structure. An audience that sees a giant number knows they're being handed a fact worth remembering; an audience that sees a bullet list knows only that the speaker has five things to say. Choose the shape that teaches.

### Intro & closing slides — the five fixed frames

Every scaffolded deck ships **five reserved non-content slides**, in this exact order: title (auto-generated), whoami, Agenda, Thank you, Q&A. Never cut them. The skill has no reliable signal for "internal" or "narrative-arc" — that judgement belongs to the speaker, who removes what doesn't fit for a specific talk. Always scaffolding all five means removing is one keystroke; adding a missing closer during rehearsal is friction.

**Thank you before Q&A is deliberate.** References and contact chips land *before* the audience opens their mouths — the speaker gestures at them, and the audience has time to read while forming questions. The Q&A slide sits last so the talk ends on interaction, not chrome. If the speaker wants references visible during questions, they stay on the Thank you slide and open the floor verbally; the Q&A slide is one keypress away when they want it.

**1. Title.** **Auto-generated by Quarto from front matter** (`title:`, `description:`, `date:`). Do NOT emit a `## <Title> {.center}` slide in the body — Quarto renders both and you get a double title slide. The one-line hook goes in `description:` (single source; also feeds the OG card). Do NOT emit `subtitle:` — the project-level partial at `decks/_partials/title-slide.html` (wired in `decks/_metadata.yml`) already routes `description` to the sub-line slot. The TLP appears in the `footer:` (visible on every slide, small mono, styled by the theme). No `.tlp-badge` on the title slide.

**2. whoami** (lowercase heading). Portrait + a filtered speaker bio. The audience decides in ~5 seconds whether the speaker is credible; drip-feeding bio bullets wastes that window, so every bullet renders at once — bullets wrapped in `::: {.nonincremental}` to override the top-level `incremental: true`.

- **Slide heading is exactly `## whoami`** — lowercase, no `.center` (portrait + bullets naturally fill the frame).
- **Content.** Read `about.qmd` (or `about.md`) at repo root during inventory. Filter its bullets to **exactly 3 threads that match the deck's frame** — keyword overlap between the deck's title/description and each about-page bullet. For a Lantana talk → detection + deception + AI-native survive; unrelated threads (blockchain, rust) drop. Extra threads move into speaker notes so the speaker has them if Q&A drifts.
- **Bullet length: ≤ ~55 characters total per bullet, including the bold label.** At slide-projected scale, anything longer wraps to a second (or third) line and eats the breathing budget fast — see the "84 years ago" and whoami failure modes in the lantana deck. Force tight phrasing: `**Detection engineering** — coverage & FP economics` beats `**Detection engineering** — rules, coverage, false-positive economics`.
- **No Elsewhere / handles bullet on whoami.** Full contact list lives on the Thank you closer, exclusively. A handle bullet here duplicates the closer and wraps painfully (both `github.com/<handle>` and `linkedin.com/in/<handle>` on one line always overflows).
- **Portrait discovery.** Look for `static/images/photo-*.webp`. If none, emit `INSERT_ portrait: static/images/<name>.webp` inline and flag under `Needs attention ⚠`. Don't assume a filename.
- **Portrait treatment.** The portrait is the **one documented exception to vigil's square-corner rule** — reference it as `![](path){.portrait}`. The theme's `.portrait` class supplies `border-radius: 12px`. Do not inline styles.
- **Layout.** 30/70 columns (portrait/bullets). Kicker above bullets (role-appropriate, e.g. `[LEAD SECURITY ENGINEER]{.kicker}`).
- **Fallback.** No `about.qmd`? Leave `INSERT_ bio bullets` inline and flag it.

**3. Agenda.** Numbered list of the deck's content sections. **Numbered, not bulleted** — the whole job of an agenda is signaling "N things, in this order."

- **Slide heading `## Agenda`** — no `.center`. `.center` centres the *whole section* including the title, drifting the "Agenda" heading mid-slide; the title should stay top-anchored (theme default). If the numbered list feels short and leaves dead space below, that's fine — reads better than a middle-floated block.
- Derived from the deck's H2 sequence, minus the five reserved slides. What's left is the content arc — usually 3–5 items.
- If the arc has more than 5 items, collapse or group. A 12-item agenda defeats itself.
- One-line hook per item is fine; two lines is a bullet list wearing a mask.
- No `.nonincremental` — bullet reveal cadence doesn't matter here.

**4. Thank you** (mandatory penultimate slide — sits between the last content slide and the Q&A closer). This is the memory anchor: on screen while the speaker gestures at references, hands off to questions, and the audience starts forming them.

- **Slide heading `## Thank you`** — no `.center`. Same reason as Agenda: title-plus-body layouts keep the title anchored at the top.
- Kicker `[REFERENCES]{.kicker}` — always. The closer is always link-heavy.
- **References** (bulleted list): 2–3 items (up to 5 for long decks) drawn from the brief's cited resources. Title + one-line hook + link. **Contact handles do NOT go in this list.** **Wrap the list in `::: {.nonincremental}` … `:::`** to override the deck-wide `incremental: true` — the closer shows every reference at once. The audience is reading, not being walked through beats; drip-feeding references slows the slide unnecessarily.
- **Contact handles** (`.contact-row` block, *below* the references list, always separate): a horizontal row of 2–3 icon+label chips — typically website / LinkedIn / GitHub. See `references/reveal-conventions.md` → "`.contact-row`" for the raw-HTML template with the three canonical SVG icons (globe / LinkedIn / GitHub). Never mix a handle into the reference list as an extra bullet — the failure mode this pattern kills is "**Find me** — github.com/… · linkedin.com/…" as line 5 of a bulleted list, where it competes with references and reads as one more citation. The theme auto-anchors this row to the bottom of the slide via a scoped `:has()` selector — nothing to configure per-deck.
- Never empty, never bare `INSERT_`. If the brief didn't cite resources, draft plausible ones with `[VERIFY]` — same rule as the rest of the deck.

**5. Q&A** (mandatory closer — the deck's final slide). The talk ends here, on interaction, not chrome.

- **Slide heading `## Q&A {.center}`** — `.center` is correct here because the slide is *only* a heading/kicker; there is no separate title-plus-body layout to preserve.
- Body: a single kicker `[QUESTIONS]{.kicker}` alone, or a one-line prompt. No bullets, no `INSERT_`, no references (those live on the preceding Thank you slide).
- Purpose: an explicit hand-off cue for the speaker; the audience knows the monologue is over. The speaker can also open Q&A verbally while still on Thank you (references visible) and only advance to Q&A when questions genuinely start — this slide is a tool, not a mandate to be on-screen during every question.

### Slide conventions (in-deck)

- **One idea per slide.** Titles are short, declarative.
- **Mono kicker above the title.** `## The problem` becomes `## The problem` on its own line with `[THREAT LANDSCAPE]{.kicker}` on the line below (or a `[SECTION]{.kicker}` above). Kickers set the section a reader-glancing-at-the-screen needs to orient.
- **Code with `code-line-numbers`.** For any code block on a slide, use progressive reveal so the speaker can walk it: `` ```yaml{code-line-numbers="1|2-3|4"} ``. Steps advance with the arrow key.
- **Columns for compare/contrast.** `:::: columns` / `::: {.column width="50%"}` for "log vs. rule," "before/after," "wrong/right."
- **Speaker notes** live in `::: notes ... :::` blocks. Use them for the plain-English "what you'd say here."
- **Fragments are rhetorical beats, not a default reveal.** Each `::: {.fragment}` block marks a moment the speaker builds to. Use them deliberately for story-build slides where each reveal changes the audience's understanding (before/after, claim-then-evidence, question-then-answer). Do not sprinkle fragments across every list to make slides "feel dynamic" — that's motion for motion's sake. The Agenda and Thank you lists inherit `incremental: true` from the front matter; nothing else should unless it's an intentional beat.
- **Transitions shape section rhythm.** Reveal defaults to `slide` (horizontal). Override on the slide heading — `## Title {transition="fade"}` for continuous-argument slides where you don't want the eye reset, `## Section 3 {transition="slide"}` on section markers where the shift matters, `## Title {transition="none"}` for a run of tight beats (code walkthrough, story build) where any transition would interrupt. Set the deck-wide default in front matter (`transition: fade` under `revealjs:` if the talk is continuous; leave default otherwise) and override per-slide as needed. Do not mix more than two transition types in one deck.

### Presentation best practices

Terse, opinionated rules that shape scaffolding decisions across the deck:

- **First 5 seconds are the credibility budget.** whoami exists to spend it well — show all threads at once (`::: {.nonincremental}` wrapper on the bullets), keep them tight, keep them relevant to the deck's frame. Drip-feeding bio bullets wastes the window when the audience is deciding whether the speaker is worth listening to.
- **Thank you is the memory anchor.** It sits penultimate (before Q&A, not after) so it's on-screen while the audience forms questions and photographs URLs. It always ships with real next-step content — contact handles, primary references, call to action. Never empty, never `INSERT_`-only. If nothing else lands, this slide will.
- **`.center` centres the whole section, title and all.** That's usually wrong. Use `.center` only on slides that are *just a heading/kicker* with no body — Q&A prompt, section-marker transitions, an occasional single-callout slide. For title-plus-body slides (Agenda, Thank you, any content slide), leave `.center` off so the title stays anchored at the top; dead space below a short list reads fine — a title floating mid-slide does not.
- **One reveal cadence per slide.** Either everything visible at once (`::: {.nonincremental}`), or a deliberate sequence via fragments where each reveal *does something* rhetorically — never partial-incremental bullets alongside an image or code block. Mixing cadences without purpose is what makes decks feel jittery. whoami is the canonical "all at once"; a story-build slide is the canonical "sequence of beats."
- **Legibility trumps density.** If a screenshot's text isn't legible in `quarto preview` at 50% zoom, the layout is wrong. Go full-slide or extract the salient line as a monospace pull quote — never ship a wall of unreadable pixels beside a bulleted list.
- **Breathing room is a design goal, not a leftover.** Whitespace around the content — margins, gaps between items, room below a short list — lets the eye rest and signals *which* things on the slide matter. A crammed slide reads as urgent and hard, even when the content is calm. Concretely: keep the vertical body somewhere between ~40% and ~80% of the slide's usable height. Below that, the slide feels empty (usually a `.center` candidate, or content to add); above it, the slide feels suffocated (usually the next rule kicks in).
- **Bullets fit the frame.** Reveal doesn't auto-scale text down; if content pushes past the frame it simply gets clipped, and even before clipping the slide loses its breathing room. Hard limits: **max ~4 bullets per column**, each **≤ 2 wrapped lines** on the projected slide. For `:::: columns` layouts, that budget applies per column — a 50/50 split with 5 long bullets on each side burns the breathing budget and overflows vertically (see the `84 years ago, in 2025` slide in the lantana deck for the exact failure mode). Fix by cutting bullets, tightening wording, splitting the idea across two slides, or — as a last resort — adding `{.smaller}` to the slide heading. Cutting is almost always the right answer; `{.smaller}` just moves the suffocation from vertical to typographic.
- **No naked images.** Every image needs at least one of: a kicker giving it context, a caption line beneath it, or one prose sentence around it. A screenshot floating alone with no framing forces the audience to figure out what they're looking at while the speaker talks past it. Minimum viable is `[SECTION KICKER]{.kicker}` + image + one caption line; ideal is kicker + image + speaker-notes narration.
- **No Quarto callout boxes.** `::: {.callout-note}` / `-tip` / `-warning` etc. render with heavy borders, an icon strip, and a coloured header bar — blog markup, not slide design. On a slide they read as pasted-in web widgets and fight the WIRED discipline (square, hairline, single accent). For what a callout would have carried: put a claim in the slide title (or as a bold prose line with a `[KICKER]{.kicker}` above), reach for `.aside-box` for a single sidebar warning, `.takeaways` for a grid of 2–4 parallel takeaways, or use Playfair-Display big-number typography for the "one thing to remember." Don't reach for the callout shortcut and don't hand-roll `<div style="…">` grids.
- **Section markers for long decks.** For talks with 4+ content sections (typically `duration >= 30`), scaffold single-line transition slides between arcs: `## Section 2 of 4 {.center}` with a one-line hook as the kicker or subtitle. Optional — emit them only when the outline has clear arc breaks; skip for continuous-narrative decks. They let the audience re-orient and give the speaker a natural breath.

### Data-driven cells — reach for Python before you reach for INSERT_

When a slide's content is naturally *data-shaped* — "top N", "distribution of X", "counts by category", "trend over time", "before/after metric" — emit a `{python}` code cell that computes the visualization at render time, rather than leaving an `INSERT_ chart` marker or drawing a fake bar chart in SVG.

**Trigger words in the outline** — if the user says any of these, propose a `{python}` cell first:
"count of", "top N", "by hour/day/country/…", "distribution", "histogram", "percentile", "rate over time", "before/after numbers", "table of", "confusion matrix", "sample of the logs".

**Pattern:**

````markdown
## <Slide title>

[<KICKER>]{.kicker}

```{python}
#| echo: false
#| fig-align: center
import matplotlib.pyplot as plt
# … compute and plot …
plt.bar(x, y, color="#4db8e0")   # theme accent — dark; use "#057dbc" on light theme
plt.show()
```

::: notes
<what the speaker narrates>
:::
````

**Rules:**

- `#| echo: false` for chart slides (audience sees the chart, not the code).
- `#| echo: true` for code walkthrough slides where the code IS the point.
- **Match the theme accent** — `#4db8e0` on `vigil-reveal-dark.scss`, `#057dbc` on `vigil-reveal-light.scss`. Read the deck's `format.revealjs.theme` path to pick. No other colors unless the chart genuinely needs a categorical palette.
- **Imports go in the cell.** Every `import` the user runs must be in the repo's `requirements.txt`. In Scaffolding Notes, list any new deps the user needs to add.
- **Data files live at `decks/<slug>/assets/`** (same folder as slide images and iframe HTML — one bucket per deck). Reference them with a relative path from the cell (`pl.read_parquet("assets/foo.parquet")`).
- **`freeze: auto`** is set repo-wide in `decks/_metadata.yml`. Cache output lands in `_freeze/decks/<slug>/`. If the user wants always-fresh execution (live-data demos), tell them to add `freeze: false` to that specific deck's front matter.

If the user's outline is data-shaped but no data file exists yet, emit a stub cell with plausible synthetic data and mark it `INSERT_ real data`. Better than an `INSERT_ chart` placeholder — the shape and axes are already committed.

### Illustrations — inline SVG on demand

**Check first:** is this data-shaped (counts, distributions, before/after *numbers*)? If yes, use a `{python}` cell — see the previous section. Reach for SVG only for *structural / conceptual* diagrams where the shape is the idea, not the data.

When a slide needs a conceptual diagram (flowchart, block sketch, before/after *schematic*, icon set, ratio/proportion figure), emit **inline SVG directly into the `.qmd`**. Do not leave `INSERT_illustration` placeholders when the diagram is structural — draw it.

- **When to draw:** block diagrams, flowcharts (if not using Mermaid), architectural sketches, side-by-side conceptual illustrations, icons, before/after glyphs.
- **When not to draw:** photo-realistic art, hero imagery, screenshots, anything requiring a raster illustrator. For those, leave an `INSERT_` and let the human supply a `.webp`.
- **When to prefer Mermaid instead:** any flowchart / sequence / class diagram — Quarto renders ` ```{mermaid} ` blocks natively and the vigil theme sets the Mermaid font (`JetBrains Mono`). Only reach for hand-authored SVG when Mermaid's shapes/layout are wrong for the idea.

**On-brand SVG conventions** (so drawings inherit theme colors instead of clashing with the deck):

```html
<svg viewBox="0 0 640 360" xmlns="http://www.w3.org/2000/svg"
     style="width: 80%; height: auto; color: inherit;"
     fill="none" stroke="currentColor" stroke-width="1.5">
  <!-- strokes/text use currentColor → inherit slide text color (light OR dark theme) -->
  <rect x="20" y="20" width="200" height="120" />
  <text x="120" y="80" fill="currentColor"
        font-family="Source Sans 3, sans-serif" font-size="16"
        text-anchor="middle">Node</text>
  <!-- one accent color, matching the theme's single accent -->
  <line x1="220" y1="80" x2="420" y2="80" stroke="#057dbc" stroke-width="2" />
</svg>
```

Rules:

- **Strokes and text default to `currentColor`.** That way the same SVG works on `vigil-reveal-dark` (white-ish strokes) and `vigil-reveal-light` (black-ish strokes) without editing.
- **One accent color per SVG**, drawn from the theme: `#057dbc` on light, `#4db8e0` on dark. Read the deck's `format.revealjs.theme` path to pick which.
- **Fonts:** `Source Sans 3` for labels, `JetBrains Mono` for code/kicker-style text inside the SVG, `Playfair Display` for a single big number or callout. Never bring in a new font.
- **No filters, no gradients, no shadows.** Match the WIRED discipline — flat, square, hairline strokes.
- **`viewBox` + `width: 80%; height: auto`** so the SVG scales inside the slide.
- **Keep it under ~80 lines of markup.** If it's growing past that, it's probably a diagram-editor artifact and belongs as a `.svg` file under `decks/<slug>/assets/` referenced with `![](assets/foo.svg)`.

If the user's outline calls for a photo-real hero image or a complex illustration you can't draw with primitives, leave an `INSERT_ hero image` marker and note in Scaffolding Notes that an image-gen tool (MCP or otherwise) is required.

### Escape-hatch rule

When a slide genuinely needs interactivity (live poll, embedded tool, custom canvas animation):

- **Do not inline scripts into the `.qmd`.** Never.
- Scaffold `decks/<slug>/assets/<name>.html` as a self-contained HTML file and reference it as an iframe slide: a slide whose only body content is `{background-iframe="assets/<name>.html"}` on the section heading. Leave the `.html` as a placeholder skeleton if the user hasn't provided the app — mark it with an `INSERT_` comment.
- For third-party polls (Slido, Mentimeter, Kahoot), embed the vendor's iframe *inside* `assets/poll.html`, not directly in the `.qmd`. Isolation means a vendor outage or slow embed breaks one slide, not the render.

### Post → talk mode

When the user points to an existing `log/<slug>/index.qmd`:

1. **Read the post's thesis first.** Skim; don't restate.
2. **Drop the prose scaffolding.** Blog prose is exhaustive by design; a talk is not. Cut hedges, cut background the audience already has, cut anything that would make the speaker read from the slide.
3. **Turn structural H2s into slide titles.** Each H2 gets one slide, with a mono kicker derived from the surrounding section. If the post has 12 H2s and the budget is 8 content slides, merge or drop — do not shrink font.
4. **Extract code blocks as walkthrough slides.** Each meaningful code sample gets its own slide with `code-line-numbers` reveal.
5. **Reuse the post's OG image** as `image:` for the deck's OG card, or scaffold a new `og-<slug>.webp` placeholder.

### `description`

Single sentence, ≤ 160 chars, no trailing period. Same shape as the log's post descriptions. Used for the OG card + any future talks index.

## Best effort, not servant

The skill's job is to produce a working deck the user can iterate on — not to leave them filling in blanks. **Bare `INSERT_` is the last resort, never the default.**

### Draft, don't defer

Where the brief hints at content, draft it and mark `[VERIFY]`. Never emit a bare `INSERT_ X` when you could plausibly write X yourself:

- **Numbers you don't have exactly** → scaffold plausible values that shape the chart correctly. Mark `[VERIFY: numbers from <source>]`.
- **Data plots** → emit a `{python}` cell with plausible synthetic data. Chart shape, axes, labels all committed; the user swaps only the values. Mark the data line `# INSERT_ real numbers`.
- **Quotes and citations** → draft the quote from context, mark `[VERIFY: exact wording]`.
- **Subtitle / description / hooks** → draft in the brief's tone, mark `[VERIFY]` if you're impersonating the user's voice.
- **References the brief points at** → do NOT emit "INSERT_ × 3 references from your folder." Read the folder, pick the strongest 2–3, cite them inline with `[VERIFY]`.
- **Insights from a note collection** → same. Read the notes, extract the top 2–3 that fit the deck's frame, quote them with `[VERIFY]`.

### Read what the brief points at

Before scaffolding, take inventory of every resource the brief references and **read each one**. A brief that links to a blog post means "I already wrote this — don't make me repeat myself; use it for context."

- **Image paths** (`./assets/*.png`, `assets/foo.jpeg`) → open with the Read tool (it supports images). Extract numbers, labels, chart shapes, screenshot text.
  - **Classify the image.** Is it *text-carrying* (chat log, terminal, code, error, dashboard where a specific line matters)? Or *shape-carrying* (napkin sketch, chart-as-shape, diagram, face, mood photo)?
  - **Text-carrying → extract by default.** Pull the load-bearing line into a `.pull-quote` / `.chat-snippet` / `.big-number` / `.metric-delta`. The raw screenshot goes to `::: notes` as reference. See "Screenshot policy — extract by default, embed only when legible" below for the two gates that permit an exception.
  - **Shape-carrying → embed full-slide.** Kicker + image + one-line caption. The napkin-sketch case genuinely benefits from being on the slide because the *shape itself* is the story.
  - **Never a "kicker + screenshot + nothing else" slide.** That's the failure mode this policy exists to kill.
  - Note the classification and the extract-or-embed decision in `screenshots_in_brief` in the storyboard.
- **Local file references** (`@~/Documents/…`, `~/path/to/notes.md`, Obsidian folders) → open them. If it's a folder, list it first, pick the most relevant file(s), then Read. Pull the 2–3 strongest quotes / insights that fit the deck's frame.
- **URLs to `lopes.id/log/<slug>/`** → read the local source at `log/<slug>/index.qmd` first. That's the same content, offline, faster, exact. Only fall back to WebFetch if the local file is missing.
- **URLs to any other site the user's already published on** (GitHub READMEs, gists, Medium posts) → WebFetch. Don't re-derive what they've written.
- **External URLs** (articles, references, tools) → WebFetch when they're load-bearing for the talk's argument. If they're just background reading, skim and cite.

**Failure modes to handle explicitly:**
- Paywall / 403 / login-required → flag in Scaffolding Notes' `Needs attention ⚠` tier, don't fabricate content.
- Timeout / offline → same.
- File missing / permission denied → same. Say which path failed.
- Successful read → use the content. Cite inline with `[VERIFY]` if you're quoting verbatim.

**Do the inventory once, up front.** Not slide-by-slide. Batch the reads before you start composing — that way the whole deck benefits from full context, and you don't repeat-fetch the same post per slide.

### Screenshot policy — extract by default, embed only when legible

Text-carrying screenshots (chat logs, terminals, code, error messages, dashboards where a specific line is the point) are the single most common failure mode of a technical talk. On stage the audience squints; the speaker narrates over unreadable pixels; the slide is doing nothing except letting the speaker feel like the source material is on display.

**The rule: extract first. Embed only when legible AND supported.**

A text-carrying screenshot may stay full-slide **only if both** of the following hold:

1. **Legibility gate.** In `quarto preview` at 50% browser zoom, the smallest text in the image is readable at back-of-room glance. If not, extract.
2. **Support gate.** The slide includes on-slide summary text beyond the kicker — a one-line caption, a `.big-idea`, a `.pull-quote`, a `.metric-delta`, or a short paragraph. A slide of "kicker + screenshot + nothing else" fails this gate even when the image is legible: the audience has no anchor beyond the pixels.

**When either gate fails, transform the slide.** Do not ship a kicker-plus-screenshot slide with only speaker notes carrying the meaning — that's the failure mode this policy exists to kill.

**Transformation recipes** (pick one per screenshot):

- **Chat/prompt screenshot** → `.chat-snippet` (styled monospace excerpt reproducing the salient turn(s)). Screenshot goes to speaker notes as `![](path)` for reference.
- **Terminal/error/log screenshot** → `.pull-quote` with the load-bearing line, attributed to the source (`— terminal output · 2026-05`). Screenshot to notes.
- **Metric-carrying screenshot** (before/after numbers, dashboard totals) → `.big-number` or `.metric-delta` or `.stat-grid`, computed values inline. Screenshot to notes as source-of-truth.
- **Dashboard where shape is the point** (a chart, a distribution, a graph) → keep full-slide; add the summary caption underneath as a one-line prose sentence. This passes both gates.
- **Napkin sketch / diagram** → keep full-slide; add a one-line caption or a `.big-idea` above naming what the sketch argues.
- **Face / venue photo / mood shot** → full-slide with `.hero-overlay` for the claim.

**Storyboard ledger.** Every image the brief references gets a decision in `screenshots_in_brief`: `extract → <target primitive>` or `embed → <legibility justification>`. Empty is not a valid entry — you decided one way; write it down.

**Fail loudly.** If a screenshot cannot pass the gates AND you can't extract (the text is illegible even to you), flag it in `Needs attention ⚠` as `slide N: source screenshot <path> unreadable — need clearer source or the slide gets cut`. Do not silently ship the failure.

### Image asset format — webp everywhere

The site convention is WebP for **all** deck imagery, not just the OG card. Any raster image the deck will embed — everything in `assets/`, screenshots, hero art — must land as `.webp` in the repo.

- If the source is `.png` / `.jpg` / `.jpeg` / `.gif`, it must be converted to `.webp` at the **same filename base** (`foo.png` → `foo.webp`), the original deleted, and every deck reference updated to the `.webp` path.
- Pre-commit accepts webp/jpg/png/gif/svg/ico as a safety net, but the authoring convention is webp only — smaller files, consistent OG behavior, one format to reason about.
- **Do not convert silently.** Propose the exact commands (`cwebp <src> -o <dst>`, or a Pillow one-liner) and confirm before running, or list them for the user to run manually if the tool isn't available.
- **Flag every non-webp raster the deck references in Scaffolding Notes' `Needs attention ⚠` tier.** One line per file, with the target name and the "delete original" reminder. Silent scaffolding of a deck that references `.jpeg` / `.png` is a bug in this skill.

Reading a raster to extract *content* (numbers off a chart, text off a screenshot) is a separate concern — see "Read what the brief points at". Format normalization applies only to images that get persisted in the repo.

### `INSERT_` is legitimate only when

- The resource genuinely doesn't exist yet (data files not written, hero images without an image-gen path wired in).
- The user explicitly said "leave this for me."
- Truly private information the skill cannot access (unstated talk date, internal system state).

## Handling Ambiguity

- **Missing `duration` or `tlp` → ask.** These change the shape of the deck. Do not guess.
- **Missing `theme` → default to `dark`.** Projector-friendly; can be flipped by the user later.
- **Missing `description` → draft one but mark `[VERIFY]`** in Scaffolding Notes. Since `description` also fills the title-slide sub-line, treat it as the one-line hook, not just SEO metadata.
- **Ambiguous outline sections → draft plausible content and mark `[VERIFY]` inline.** Follow the "Best effort, not servant" rules above. Bare `INSERT_` is a failure mode, not a default.

## Post-Render Review

After writing the deck to disk, always render it and audit the result. The scaffold has done half the job — the render surfaces the other half: broken references, sparse slides that collapse to the top, screenshots stuffed into columns where their text is unreadable at projection scale.

### Render

Run `quarto render decks/<slug>/index.qmd --to revealjs` from `lopes.id`'s project root. Rendered HTML lands at `_site/decks/<slug>/index.html` (Quarto's project-level `output-dir` is `_site`, set in `_quarto.yml`). If the render fails, surface the stderr verbatim in Scaffolding Notes' Post-render review tier — the source is on disk, the user resolves. Do not attempt fixes; the failure mode is usually a broken import in a `{python}` cell or a missing image reference, both of which need the user's judgement. If the rendered HTML is absent at the expected path (Quarto config changed), skip the HTML-side checks, run the source-only checks, flag the fact.

### Checks

Run all four on every scaffold. The first two produce flags for the user; the last two auto-fix.

**Kicker-only slide missing `.center` — flag only, no auto-fix.**

- Parse each `<section>` in the rendered HTML. If a slide has *only* a heading + kicker (no bullets, no paragraphs, no image, no code, no SVG) and no `.center` on the section, flag it with the recommended fix: add `{.center}` to the slide heading.
- Do NOT flag slides that have a title + body. `.center` on those centres the title too — usually undesirable. See the "`.center` centres the whole section" best practice.
- No auto-fix. Slide intent varies; the user picks.

**Suffocation risk — flag only, no auto-fix.**

- The slide has too much content to breathe. Reveal doesn't auto-scale text down; the slide gets clipped and, well before clipping, the breathing budget is gone.
- Parse the source `.qmd`. For each slide, count bullets and estimate wrapped lines per bullet (rough heuristic: > 60 characters ≈ 2 lines; > 120 ≈ 3 lines).
- For `:::: columns` layouts, apply the budget per column: flag when a column has > 4 bullets, OR when a column's total wrapped line count exceeds ~10.
- For single-column slides, flag when total bullets > 6 or total wrapped lines > 12.
- Report as `slide <N>: <column> suffocation risk (<b> bullets, ~<L> wrapped lines) — cut, tighten, or split`. No auto-fix; deciding what to cut is a judgement call.

**Naked image — flag only, no auto-fix.**

- Parse the source `.qmd`. For each `![](path)` reference, check whether the surrounding slide has a kicker line, a paragraph, or a caption within the same `##` section.
- If the image is the only body content (no kicker, no prose, no caption), flag it: `slide <N>: image <path> has no context — add a kicker or one-line caption`.
- Exempt: iframe/background slides (they're a different pattern), portrait on the whoami slide (has kicker + bullets alongside).

**Quarto callout in a deck — flag only, no auto-fix.**

- Parse the source `.qmd`. Grep for `::: {.callout-` (any callout type: note / tip / warning / caution / important).
- If any match, flag every occurrence: `slide <N>: callout box — replace with SVG box, big-number typography, or a claim-as-title`.
- No auto-fix. The right replacement depends on what the callout was carrying (a claim, a categorical grid, a sidebar warning) — that's a shape decision, not a mechanical rewrite.

**Bullet-list-only content slide (design failure) — HARD FLAG, no auto-fix.**

- Parse the source `.qmd`. For each content slide (not Agenda, not Q&A, not Thank you, not the auto-generated title), check whether its body reduces to a single `<ul>` or `<ol>` — no `<p>`, no image, no code fence, no SVG, no `.stat` / `.pullquote` / `.big-idea` / `.big-number` / `.pull-quote` / `.stat-grid` / `.metric-delta` / `.chat-snippet` / `.aside-box` / `.timeline` / grid `<div>`, no columns block.
- If yes, and there is no `<!-- shape: bullets because ... -->` justification comment on the slide, flag it as a design failure: `slide <N>: bullet-only ("<title>") — pick a shape from the Design vocabulary and reshape`.
- Report bullet-only ratio explicitly: `bullet-only content slides: <b>/<n> (<pct>%)`. Anything > 0% deserves the user's attention; anything > 20% is a scaffolding failure worth calling out loudly at the top of the tier.
- No auto-fix. Reshaping needs to know what the content is trying to teach; that's the designer's job, not a mechanical rewrite.

**Screenshot-only content slide (design failure) — HARD FLAG, no auto-fix.**

- Parse the source `.qmd`. For each content slide (not Agenda, not Q&A, not Thank you, not the auto-generated title), check whether its body reduces to a single `![](path)` reference (optionally wrapped in the `.r-stretch` class) with no accompanying prose, `.big-idea`, `.pull-quote`, `.big-number`, `.metric-delta`, `.stat-grid`, `.chat-snippet`, `.aside-box`, `.timeline`, columns block, `{python}` cell, or code fence — only the kicker + h2 + image.
- If yes, flag as a design failure: `slide <N>: screenshot-only ("<title>", <image path>) — extract the load-bearing text into a .pull-quote / .chat-snippet / .big-number and move the screenshot to ::: notes, per Screenshot policy`.
- Report screenshot-only ratio explicitly: `screenshot-only content slides: <s>/<n> (<pct>%)`. Anything > 0% deserves the user's attention; the target is 0%.
- Exempt: iframe/background slides, `.hero-overlay` slides (background-image + text overlay), slides where the image is a `{python}`-emitted figure.
- No auto-fix. Extract-first requires knowing what text carries the argument; that's the designer's judgement, not a mechanical rewrite.

**Storyboard block present — flag only, no auto-fix.**

- Parse the source `.qmd`. Look for `<!-- STORYBOARD` **inside the `## whoami` slide** (between the `## whoami` heading and the next `##` heading).
- If found *between the front matter closing `---` and the first `##`* (i.e., in the wrong place), hard flag: `storyboard block placed before ## whoami — Quarto will render it as a phantom blank slide; move inside the whoami section per "Storyboard — design the narrative before you touch a slide"`.
- If missing entirely, hard flag: `storyboard block missing — the skill must emit a <!-- STORYBOARD … --> block per "Storyboard phase" doctrine inside the whoami slide`.
- If present, parse the beat lines (`- slide N: <shape>  · <role>`) and cross-check against actual slide count. Flag mismatches: `storyboard covers <b> beats, deck has <n> content slides — reconcile`.
- If `screenshots_in_brief` is present, cross-check every image reference in the `.qmd` against the ledger. Flag any image in the deck not accounted for in the ledger, or any ledger entry with no matching image: `image <path> not in storyboard ledger` / `ledger entry <path> not embedded — extracted?`.
- No auto-fix; the storyboard is the design-intent record, not a mechanical artifact.

**Text-carrying image inside a column (legibility risk) — auto-fix when safe.**

- Parse the source `.qmd` — column syntax is more reliable to detect there than in the rendered HTML.
- For every `![](path)` reference inside a `:::: columns` block, decide whether it carries text:
  1. **Filename-first heuristic (cheap).** If the filename matches `/screenshot|terminal|chat|log|error|code|snippet|shell/i` or the path lives under `screenshots/` or `terminal/`, treat as text-carrying without further inspection.
  2. **Visual inspection when ambiguous.** Only when the filename gives no signal, `Read` the image (Read tool supports webp + raster formats) and judge whether it carries readable text. One tool call per ambiguous image. Skip standalone images entirely — they're already full-slide, legibility is fine.
- **Auto-fix (when safe):** rewrite the flagged slide to full-slide layout. Remove the `:::: columns` … `::::` wrapper, promote the image to `![](path)` on its own line, move any neighbour-column bullets into a `::: notes` … `:::` block. Preserve the kicker and any caption. Use the Edit tool with a `old_string` unique enough to target only that slide.
- **Skip auto-fix and flag under Needs attention ⚠** when: the column block contains multiple images, has nested structure the rewrite can't safely preserve, or the neighbour column contains something other than plain bullets. Prose the user needs to reshape by hand.

**whoami reveal behaviour — auto-fix.**

- Check the source `.qmd`. The `## whoami` slide's bullet list must be wrapped in `::: {.nonincremental}` … `:::`. If missing, auto-fix by inserting the wrapper around the 70% column's bullets.
- Check the heading. Must be lowercase `## whoami`. If `## Whoami` (or any casing variation), auto-fix to `## whoami`.

**whoami budget — flag only, no auto-fix.**

- Count bullets in the 70% column. Flag when > 3.
- Measure each bullet's length. Flag any bullet whose plain-text length exceeds ~55 characters (this includes the bold label; strip `**` markers before counting).
- Grep for a handle pattern in whoami's column (`github.com/`, `linkedin.com/`, `@` handles). If present, flag: handles belong on the Thank you closer, not whoami.
- Report as `whoami budget: <b> bullets (cap 3), longest <L> chars (cap ~55), handles found: <yes/no>` — one line, precise. No auto-fix; cutting or rephrasing is the user's judgement.

**Fixed-frame sanity — flag only.**

- The last `##` heading must be `## Q&A {.center}`. If missing, flag under Needs attention ⚠. Do not auto-insert — position depends on where the content arc ends, which is a judgement call.
- The second-to-last `##` heading must be `## Thank you` (or a permissible variation like `## Where to find more`) with real body content — links, contact handles, references. If the body is empty or a bare `INSERT_` marker, flag under Needs attention ⚠. Do not auto-write; the content depends on brief-cited resources the skill can't fabricate.

### Reporting

Fold the audit into Scaffolding Notes as a fourth tier below Decisions ℹ:

> **Post-render review**
> - Rendered OK in `<n>s` (or "render failed — see stderr below")
> - Auto-fixed: `<list of fixes applied, one per line>` (or "no auto-fixes needed")
> - Kicker-only slides missing `.center`: `slide <N>: <first-few-words>` (or "none")
> - Suffocation risk (breathing budget blown): `slide <N>: <column or "single"> — <b> bullets, ~<L> wrapped lines` (or "none")
> - **Bullet-only content slides (design failure): `<b>/<n> (<pct>%)` — `slide <N>: "<title>"`** (list all, or "none")
> - **Screenshot-only content slides (design failure): `<s>/<n> (<pct>%)` — `slide <N>: "<title>", <image path>`** (list all, or "none")
> - Storyboard block: present + `<b>` beats matching `<n>` slides (or "MISSING — regenerate", or "mismatch: `<details>`")
> - Naked images (no kicker or caption): `slide <N>: <image path>` (or "none")
> - Quarto callouts in deck (replace with SVG or claim-as-title): `slide <N>` (or "none")
> - Legibility risk (text-in-image still in column): `slide <N>: <image path>` (only when auto-fix couldn't safely rewrite)
> - whoami budget: `<b> bullets (cap 3), longest <L> chars (cap ~55), handles found: <yes/no>`
> - Fixed-frame sanity: OK (or `<what's missing>`)

## Principles

- **Silent publishing is the default.** Never propose a talks index, a navbar entry, or a deck-level TOC. Decks live at `lopes.id/decks/<slug>/`; discovery is the speaker's job.
- **Sensitive content doesn't live here.** Only `tlp: clear` / `white` / `green` are accepted at commit time; anything more sensitive belongs in a separate private repo. There is no runtime filter — pre-commit is the gate. Design deck content assuming the source is world-readable on public GitHub — which it is.
- **Per-deck baked theme.** Reveal decks bake theme at render time. No runtime light/dark toggle. Pick `theme:` up front.
- **Match the site's discipline.** Square corners, no shadows, single accent (`#057dbc` light / `#4db8e0` dark), Playfair for h1/h2, Source Sans for h3+, Lora for body, JetBrains Mono for kickers and code. The theme enforces this; do not fight it with inline styles.
- **Escape-hatch is a scalpel, not a hammer.** If a slide can be static HTML in a `.qmd`, keep it there. Iframes cost isolation for good reason — spend it when you need it.
- **Under-fill is a virtue.** A 12-slide talk in a 30-min slot with strong speaker notes beats a 24-slide talk read out loud.

## Output Format

**The deck content below is what gets written to `decks/<slug>/index.qmd` via the Write tool.** It is NOT emitted in chat. The markdown fence below is a template for the file's contents, not a chat-output pattern.

Chat output is a two-line confirmation followed by Scaffolding Notes:

```
Wrote decks/<slug>/index.qmd (<n> slides, <duration>min slot).
Budget: <slot>min − <buffer>min Q&A = <content>min · <n> slides (<w>).
```

Then the Scaffolding Notes in the three-tier shape below.

Template for the file's contents (illustrative — do not paste this to the user; use it to compose the file, then `Write`):

````markdown
---
title: "..."
description: "..."       # doubles as title-slide sub-line + OG card description
image: og-<slug>.webp
tlp: clear
duration: 30
event: "..."
date: 2026-05-01

resources:
  - assets/   # only if the deck uses iframe escape-hatch slides (Quarto scans images automatically but not background-iframe paths)

format:
  revealjs:
    theme: [default, ../../static/styles/vigil-reveal-dark.scss]
    footer: "TLP:CLEAR"          # ★ mirror front-matter tlp:; visible on every slide
    incremental: true
    code-line-numbers: true
    slide-number: c/t
    toc: false
    controls: true
    progress: true
    history: true
    hash-type: number
---

<!-- Title slide is auto-generated from front matter (title / description / date);
     description fills the sub-line slot via decks/_partials/title-slide.html.
     TLP appears in the footer on every slide.
     Opening speaker cue goes in whoami's ::: notes block below. -->

## whoami

[<ONE-LINE ROLE / DOMAIN>]{.kicker}

:::: columns
::: {.column width="30%"}
![](/static/images/photo-<name>.webp){.portrait}
:::
::: {.column width="70%"}
::: {.nonincremental}
- **<Thread 1>** — <≤ ~35-char tail>
- **<Thread 2>** — <≤ ~35-char tail>
- **<Thread 3>** — <≤ ~35-char tail>
:::
:::
::::

::: notes
Extra threads that didn't fit on the slide: <thread 4>, <thread 5>. Riff if Q&A drifts.
:::

## Agenda

[<KICKER>]{.kicker}

1. **<Section 1>** — <one-line hook>
2. **<Section 2>** — <one-line hook>
3. **<Section 3>** — <one-line hook>

::: notes
30-second walk-through of the arc so the audience knows what they're getting.
:::

## <First slide title>

[<SECTION KICKER>]{.kicker}

<body>

## <Code walkthrough slide>

[<CODE KICKER>]{.kicker}

```yaml{code-line-numbers="1|2-3|4"}
<code>
```

::: notes
<what to narrate at each reveal step>
:::

## <Columns slide>

[<COMPARE KICKER>]{.kicker}

:::: columns
::: {.column width="50%"}
**<Left header>**

<content>
:::
::: {.column width="50%"}
**<Right header>**

<content>
:::
::::

## <Escape-hatch slide> {background-iframe="assets/<name>.html"}

## Thank you

[REFERENCES]{.kicker}

::: {.nonincremental}
- **<Reference 1 title>** — <one-line hook> · [link](<url>)
- **<Reference 2 title>** — <one-line hook> · [link](<url>)
- **<Reference 3 title>** — <one-line hook> · [link](<url>)
:::

```{=html}
<div class="contact-row">
  <a href="<site url>" class="contact-link">
    <svg class="contact-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
      <circle cx="12" cy="12" r="10"/>
      <path d="M2 12h20"/><path d="M12 2a15 15 0 0 1 0 20"/><path d="M12 2a15 15 0 0 0 0 20"/>
    </svg>
    <span class="contact-label"><site handle></span>
  </a>
  <a href="https://linkedin.com/in/<handle>" class="contact-link">
    <svg class="contact-icon" viewBox="0 0 24 24" fill="currentColor">
      <path d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433c-1.144 0-2.063-.926-2.063-2.065 0-1.138.92-2.063 2.063-2.063 1.14 0 2.064.925 2.064 2.063 0 1.139-.925 2.065-2.064 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0z"/>
    </svg>
    <span class="contact-label"><linkedin handle></span>
  </a>
  <a href="https://github.com/<handle>" class="contact-link">
    <svg class="contact-icon" viewBox="0 0 24 24" fill="currentColor">
      <path d="M12 .297c-6.63 0-12 5.373-12 12 0 5.303 3.438 9.8 8.205 11.385.6.113.82-.258.82-.577 0-.285-.01-1.04-.015-2.04-3.338.724-4.042-1.61-4.042-1.61C4.422 18.07 3.633 17.7 3.633 17.7c-1.087-.744.084-.729.084-.729 1.205.084 1.838 1.236 1.838 1.236 1.07 1.835 2.809 1.305 3.495.998.108-.776.417-1.305.76-1.605-2.665-.3-5.466-1.332-5.466-5.93 0-1.31.465-2.38 1.235-3.22-.135-.303-.54-1.523.105-3.176 0 0 1.005-.322 3.3 1.23.96-.267 1.98-.399 3-.405 1.02.006 2.04.138 3 .405 2.28-1.552 3.285-1.23 3.285-1.23.645 1.653.24 2.873.12 3.176.765.84 1.23 1.91 1.23 3.22 0 4.61-2.805 5.625-5.475 5.92.42.36.81 1.096.81 2.22 0 1.606-.015 2.896-.015 3.286 0 .315.21.69.825.57C20.565 22.092 24 17.592 24 12.297c0-6.627-5.373-12-12-12"/>
    </svg>
    <span class="contact-label"><github handle></span>
  </a>
</div>
```

## Q&A {.center}

[QUESTIONS]{.kicker}
````

Then group Scaffolding Notes into four tiers so the user reads top-down: "ok" first, "attention" second, "context" third, "audit result" last.

**Scaffolding Notes**

**Ready ✓**
- Slug: `<slug>` (<n> chars, cap 50)
- Budget: `<slot>min − <buffer>min Q&A = <content>min → <n> slides` — <one-line rationale>
- Read from brief-referenced resources: `<list what you read + one-line summary>` (or omit if none referenced)
- <anything else that just works — deps already in requirements.txt, freeze cache present, etc.>

**Needs attention ⚠**
- `[VERIFY]` `<label>` at slide N — `<what to sanity-check>`, `<source if known>`
- `INSERT_` `<label>` at slide N — `<what to swap in>`, `<expected source>`
- `<asset the user must supply>` — e.g., OG image, data file that doesn't exist yet
- Convert `assets/<file>.<png|jpg|jpeg|gif>` → `assets/<file>.webp` and delete original — repo convention is webp for all deck imagery (list one line per file)
- Slide shape audit: `<b>/<n>` content slides are bullet-only (X%). Above ~30% is a signal to reconsider — see "Slide shape — pick before you write". If flagging, name specific reshape candidates: `slide <N>: contrast → columns`, `slide <M>: categorical → SVG box grid`, etc.
- `<unreadable resource, if any>` — flag the path and why (permission / missing)

**Decisions ℹ**
- Content cut / not included: `<what and why>` (or "everything fit")
- Escape-hatch apps to write: `<list of assets/<name>.html shells, or "none">`
- whoami filtering: kept threads `<list>`, dropped `<list>` (moved to speaker notes). Filtered by keyword overlap with the deck's frame.
- `<namespace / tooling / branch notes>` — e.g., CLAUDE.md lacks a `deck/` namespace, use `post/<slug>` for now

**Post-render review**
- Rendered OK in `<n>s` (or "render failed — see stderr below")
- Auto-fixed: `<list of fixes applied, one per line>` (or "no auto-fixes needed")
- Kicker-only slides missing `.center`: `slide <N>: <first-few-words>` (or "none")
- Suffocation risk (breathing budget blown): `slide <N>: <column or "single"> — <b> bullets, ~<L> wrapped lines` (or "none")
- **Bullet-only content slides (design failure): `<b>/<n> (<pct>%)` — `slide <N>: "<title>"`** (list all, or "none")
- **Screenshot-only content slides (design failure): `<s>/<n> (<pct>%)` — `slide <N>: "<title>", <image path>`** (list all, or "none")
- Storyboard block: present + `<b>` beats matching `<n>` slides (or "MISSING — regenerate", or "mismatch: `<details>`")
- Naked images (no kicker or caption): `slide <N>: <image path>` (or "none")
- Quarto callouts in deck (replace with SVG or claim-as-title): `slide <N>` (or "none")
- Legibility risk (text-in-image still in column): `slide <N>: <image path>` (only when auto-fix couldn't safely rewrite)
- whoami budget: `<b> bullets (cap 3), longest <L> chars (cap ~55), handles found: <yes/no>`
- Fixed-frame sanity: OK (or `<what's missing>` — Q&A slide absent, Thank you slide empty, etc.)

## Related Repo Rules (must match)

- Deck slug (directory name) ≤ 50 chars (same as log filename cap).
- Title max 60 chars.
- Description max 160 chars.
- Image field required and must end `.webp`.
- All deck imagery is `.webp` (not just the OG card). Pre-commit accepts webp/jpg/png/gif/svg/ico as a safety net, but non-webp raster must be converted on ingest (same filename base, original deleted) — see "Image asset format" above.
- OG/asset images ≤ 300 KB each.
- Branch namespace: repo uses `post|revise|typo|bugfix|design|infra|docs|release`. There is no `deck`/`talk` namespace yet — use `post/<slug>` for a new deck branch until a namespace is added, and flag this to the user so they can decide whether to extend `CLAUDE.md`.
- File goes at `decks/<slug>/index.qmd`. OG image at `decks/<slug>/og-<slug>.webp` (deck root — metadata). Everything else (slide images, iframe HTML, data files) at `decks/<slug>/assets/`.
