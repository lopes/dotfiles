# Reveal / Quarto Conventions (for `scaffold-deck`)

The reveal.js + Quarto syntax the skill emits. Kept separate from `SKILL.md` so it can be updated without touching the inference rules.

## Slide structure

Each `##` heading starts a new slide. `#` at the very top is the deck title (rendered as the title slide by Quarto). One idea per slide; short declarative titles.

Title slide (opening `##`) uses `{.center}` to vertically center the content.

## Kicker (mono ALL-CAPS section label above a title)

The vigil-reveal theme defines `.kicker`. Usage:

```markdown
## The problem

[THREAT LANDSCAPE]{.kicker}

Alerts scale linearly with logs. Analysts do not.
```

Place the kicker *below* the `##` in the source; the theme's flow renders it as a mono uppercase label above the visual title through slide ordering. If you want it clearly above, put it on the title slide with the pattern:

```markdown
## Deck title {.center}

[TLP:CLEAR]{.tlp-badge}

[BSIDES SOMEWHERE · 2026-05-01]{.kicker}
```

Kickers should be 1–4 words, ALL-CAPS in source (they're already uppercased by CSS but caps in source read better in review).

## Composition primitives (theme utilities)

The vigil-reveal theme ships a set of composition primitives — reach for these instead of bullet lists on content slides. Each renders identically on `vigil-reveal-dark` and `vigil-reveal-light` (the accent color flips automatically).

All are Pandoc fenced divs (`::: {.class}`) with inline spans (`[text]{.class}`) — no raw HTML required.

### `.big-idea` — one huge sentence

```markdown
::: {.big-idea}
Alone we're both weaker.
:::
```

Use for the pivot line of the talk — the sentence the audience should remember from the section. One sentence, one slide.

### `.big-number` — one dominant metric

```markdown
::: {.big-number}
[9×]{.big-number-value}
[more lines written]{.big-number-label}
[~3,180 → ~29,204 lines · same person · not full-time]{.big-number-footnote}
:::
```

Use when the whole slide is about a single number. Larger and more assertive than `.stat` (which is designed for a corner-of-a-compound-slide metric).

### `.metric-delta` — before → after

```markdown
::: {.metric-delta}
::: {.metric-delta-before}
[6h]{.metric-delta-value}
[enrichment run]{.metric-delta-label}
:::
::: {.metric-delta-arrow}
→
:::
::: {.metric-delta-after}
[5 min]{.metric-delta-value}
[after the circuit breaker]{.metric-delta-label}
:::
:::
```

The after-side value takes the accent color; the eye lands on where the story went.

### `.stat-grid` — 2–4 categorical metrics

```markdown
::: {.stat-grid}
::: {.stat-cell}
[9×]{.stat-cell-value}
[more lines]{.stat-cell-label}
:::
::: {.stat-cell}
[5×]{.stat-cell-value}
[more commits]{.stat-cell-label}
:::
::: {.stat-cell}
[3.5×]{.stat-cell-value}
[more files touched]{.stat-cell-label}
:::
:::
```

Auto-fits: 2 items go 50/50, 3 thirds, 4 quarters. More than 4 overflows — cut or use a `{python}` chart.

### `.pull-quote` — attributed verbatim excerpt

```markdown
::: {.pull-quote}
> Is it feasible and easy to create a check like this: if the last N
> enrichment tries for that source failed due to rate_limit, skip the
> rest? It'd save much much time.

[— me, in Claude Code · 2026-05]{.pull-quote-attribution}
:::
```

Use INSTEAD of a screenshot of a chat conversation. Attribution is mandatory when quoting a person, a tool output, or yourself. Screenshot of the source goes in `::: notes`.

**`.pullquote` vs. `.pull-quote`.** Two similar classes coexist for historical reasons:

- `.pullquote` (no dash) — un-attributed italic Lora blockquote, sits inside a `<blockquote>`.
- `.pull-quote` (with dash) — attributed verbatim excerpt with a `.pull-quote-attribution` span.

**Rule:** if you're quoting anything — a person, yourself, a tool, a log line — use `.pull-quote` and attribute. Reserve `.pullquote` for stand-alone one-liners the speaker is authoring on-slide.

### `.chat-snippet` — styled monospace exchange

```markdown
::: {.chat-snippet}
::: {.chat-turn}
[me]{.chat-role}

> Is it feasible to skip a source after N rate_limit failures?
:::
::: {.chat-turn .chat-turn-agent}
[claude]{.chat-role}

Yes — ~20 lines, one function, plus tests. Implementing now.
:::
:::
```

Two turns is the sweet spot. Three is a warning sign that the slide is doing too much — split.

### `.aside-box` — on-brand callout replacement

```markdown
::: {.aside-box}
[CAVEAT]{.aside-label}

The 6h → 5min result assumes rate-limit is the dominant failure mode.
Other bottlenecks (network, DNS) would need different signals.
:::
```

The one boxed treatment the theme allows. Quarto callouts (`::: {.callout-note}` etc.) render with heavy borders, icon strips, and coloured header bars — that's blog markup, not slide design. Use `.aside-box` for what a callout would have carried; use it sparingly (a callout that could be a slide title is a slide title).

### `.takeaways` — grid of 2–4 parallel takeaway cards

```markdown
::: {.takeaways}
::: {.takeaway}
[Configure the AI]{.takeaway-label}

Keep `CLAUDE.md` lean. Bloat makes agents *worse*.
:::
::: {.takeaway}
[Plan first]{.takeaway-label}

Let Claude interview *you* before it writes code.
:::
::: {.takeaway}
[Manage context]{.takeaway-label}

`/clear` between tasks. Context rot is real.
:::
::: {.takeaway}
[Try again in 3 months]{.takeaway-label}

Models keep improving faster than intuition.
:::
:::
```

The multi-card sibling of `.aside-box`. Reach for `.takeaways` when several parallel takeaways / rules / caveats / steps land together on the closing slide of a section. Auto-fits: 2 items lay out 50/50, 3 in thirds, 4 as quarters or 2×2 depending on slide width. Do **not** hand-roll `<div style="display: grid; …">` — the theme owns the layout. Card labels are Source Sans 3 (bold, matching `strong` styling), body text is Lora at 0.9em. Keep card body to one sentence; two lines max at projection scale.

### `.timeline` — horizontal event strip

```markdown
::: {.timeline}
::: {.timeline-event}
[Alpha started]{.timeline-label}
[Feb 2026]{.timeline-date}
:::
::: {.timeline-event .timeline-event-accent}
[Claude onboarded]{.timeline-label}
[Apr 2026]{.timeline-date}
:::
::: {.timeline-event}
[v1 shipped]{.timeline-label}
[Jun 2026]{.timeline-date}
:::
:::
```

3–5 events. Add `.timeline-event-accent` to the pivot event — the eye lands there. More than 5 events overflows.

### `.contact-row` — icon+label chips for the Thank you closer

Wrap the raw HTML in a Pandoc `{=html}` fenced block. Without the fence, Pandoc parses the inline `<a>` chips as Markdown inline content and wraps them in a `<p>` — that `<p>` becomes the sole flex child of `.contact-row` and the chips stop laying out as direct flex items.

````
```{=html}
<div class="contact-row">
  <a href="https://lopes.id" class="contact-link">
    <svg class="contact-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
      <circle cx="12" cy="12" r="10"/>
      <path d="M2 12h20"/>
      <path d="M12 2a15 15 0 0 1 0 20"/>
      <path d="M12 2a15 15 0 0 0 0 20"/>
    </svg>
    <span class="contact-label">lopes.id</span>
  </a>
  <a href="https://linkedin.com/in/jlopesjr" class="contact-link">
    <svg class="contact-icon" viewBox="0 0 24 24" fill="currentColor">
      <path d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433c-1.144 0-2.063-.926-2.063-2.065 0-1.138.92-2.063 2.063-2.063 1.14 0 2.064.925 2.064 2.063 0 1.139-.925 2.065-2.064 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0z"/>
    </svg>
    <span class="contact-label">jlopesjr</span>
  </a>
  <a href="https://github.com/lopes" class="contact-link">
    <svg class="contact-icon" viewBox="0 0 24 24" fill="currentColor">
      <path d="M12 .297c-6.63 0-12 5.373-12 12 0 5.303 3.438 9.8 8.205 11.385.6.113.82-.258.82-.577 0-.285-.01-1.04-.015-2.04-3.338.724-4.042-1.61-4.042-1.61C4.422 18.07 3.633 17.7 3.633 17.7c-1.087-.744.084-.729.084-.729 1.205.084 1.838 1.236 1.838 1.236 1.07 1.835 2.809 1.305 3.495.998.108-.776.417-1.305.76-1.605-2.665-.3-5.466-1.332-5.466-5.93 0-1.31.465-2.38 1.235-3.22-.135-.303-.54-1.523.105-3.176 0 0 1.005-.322 3.3 1.23.96-.267 1.98-.399 3-.405 1.02.006 2.04.138 3 .405 2.28-1.552 3.285-1.23 3.285-1.23.645 1.653.24 2.873.12 3.176.765.84 1.23 1.91 1.23 3.22 0 4.61-2.805 5.625-5.475 5.92.42.36.81 1.096.81 2.22 0 1.606-.015 2.896-.015 3.286 0 .315.21.69.825.57C20.565 22.092 24 17.592 24 12.297c0-6.627-5.373-12-12-12"/>
    </svg>
    <span class="contact-label">lopes</span>
  </a>
</div>
```
````

Use on the **Thank you** closer, below the references bulleted list. Icons use `currentColor` so they take the accent on hover. Two or three chips is right; more crowds the row.

**Bottom-anchored automatically.** The theme detects any section containing a `.contact-row` (via a scoped `:has()` selector) and switches that section to `display: flex; flex-direction: column; min-height: 100%`. The row's `margin-top: auto` then pushes it to the bottom of the slide. No per-deck wrapper needed. All other slides are unaffected.

**Handles (labels) stay lowercase** — that's how humans read handles. Overriding to uppercase would misrepresent them. Contrast with kickers, TLP badge, and footer — those are structural labels, always uppercase.

**Icon sources.** The globe / LinkedIn / GitHub paths above are stable enough to paste as-is. Any icon that renders with `fill="currentColor"` or `stroke="currentColor"` will inherit the theme; do not introduce a second color.

### `.section-divider` — arc break

```markdown
## Section 2 of 4 {.section-divider .center}

::: {.section-divider-body}
[02 / 04]{.section-divider-number}

With a Little Help of My (Claude) Friend

[How the workflow changed]{.section-divider-hook}
:::
```

For talks with 4+ content sections (typically `duration >= 30`). The `.section-divider` class hides the `## Section N of M` heading; the body carries the label. Optional — emit only when the outline has clear arc breaks.

### Weight per slide (for the pacing model)

| Primitive | Weight (min per slide) | Notes |
|---|---:|---|
| `.big-idea` / `.big-number` / `.metric-delta` | 1 | One idea, land, next. |
| `.pull-quote` / `.chat-snippet` | 1.5 | Read aloud, unpack once. |
| `.stat-grid` / `.timeline` | 1.5 | Two-way glance: shape + labels. |
| `.aside-box` | 0.5 | A sidebar; don't spend a whole minute. |
| `.takeaways` | 1 | Closer-style summary; land each card in a beat, don't unpack. |
| `.section-divider` | 0.5 | Kick, orient, move on. |
| `.contact-row` | 0.5 | Closer chrome; audience is already reading references. |

## TLP badge

Framed mono chip for the title slide only. Do *not* repeat on every slide.

```markdown
[TLP:CLEAR]{.tlp-badge}
```

Values accepted in this repo: `TLP:CLEAR`, `TLP:WHITE`, `TLP:GREEN`. Anything more sensitive (`AMBER`, `AMBER+STRICT`, `RED`) is rejected by pre-commit — that material belongs in a separate private repo.

## Progressive code reveal

Reveal.js supports line-by-line highlighting. Use `code-line-numbers` in the code fence:

```markdown
```yaml{code-line-numbers="1|2-3|4"}
title: Suspicious Service Creation
detection:
  selection: { EventID: 7045 }
  condition: selection
```
```

Each `|`-separated segment is a reveal step. `1` highlights line 1, then `2-3` highlights lines 2–3, then `4` highlights line 4. The arrow key advances steps.

Common patterns:

- `"|1|2|3"` — start with none highlighted, reveal each line in turn.
- `"1-4|5-8"` — reveal in chunks.
- `"1,3,5"` — highlight non-contiguous lines at once.

Set `code-line-numbers: true` at the deck level (in `format.revealjs`) so line numbers are always shown.

## Columns

For side-by-side compare/contrast:

```markdown
:::: columns
::: {.column width="50%"}
**Raw event**

```json
{ "EventID": 7045 }
```
:::
::: {.column width="50%"}
**What we assert**

- Unsigned binary
- Non-standard path
- Off-hours
:::
::::
```

The outer `::::` is four colons; each inner `:::` is three. Width can be `50%`/`50%`, `40%`/`60%`, etc. Two columns is the sweet spot; three is a warning sign that the slide is doing too much.

## Fragments (progressive reveal for non-code)

At deck level, `incremental: true` in `format.revealjs` makes bulleted lists advance one bullet at a time.

For finer control, wrap arbitrary blocks:

```markdown
::: {.fragment}
This appears on the second step.
:::

::: {.fragment .fade-up}
This one fades in from below.
:::
```

Available styles: `.fade-in` (default), `.fade-out`, `.fade-up`, `.fade-down`, `.fade-left`, `.fade-right`, `.grow`, `.shrink`, `.strike`, `.highlight-red`, `.highlight-blue`.

Use sparingly. If every slide has three fragments, the audience learns to expect them and stops paying attention.

## Speaker notes

```markdown
## Slide title

Slide body.

::: notes
The plain-English "what you'd say here." Not shown on the slide; visible in speaker view (press `S`).
:::
```

Notes are for the speaker's cue, not the audience. If the note is the same as the slide body, delete the note or shorten the slide.

## Data-driven cells (`{python}` blocks)

For data-shaped content — charts, tables, distributions, counts, rankings — use Quarto's Jupyter integration. Cells render at build time; the audience sees the output, not the code (unless you say otherwise).

```markdown
```{python}
#| echo: false
#| fig-align: center
import matplotlib.pyplot as plt
hours = list(range(24))
counts = [12, 8, 4, 3, 2, 3, 5, 9, 15, 28, 41, 55,
          62, 60, 51, 43, 38, 32, 25, 21, 18, 16, 14, 13]
plt.bar(hours, counts, color="#4db8e0")   # theme accent (dark); use #057dbc on light
plt.xlabel("hour (UTC)")
plt.show()
```
```

Options that matter:

- `#| echo: false` — hide the code, show only the output. Default choice for chart slides.
- `#| echo: true` — show both. Use when the code IS the point (walkthroughs).
- `#| fig-align: center` / `#| fig-cap: "..."` — Quarto figure knobs.
- `#| output: false` — run the cell for side effects (data prep) without emitting anything.

Colors: same rule as SVG. `#4db8e0` on `vigil-reveal-dark.scss`, `#057dbc` on `vigil-reveal-light.scss`. Never introduce a third color unless the chart genuinely needs a categorical palette.

**Freeze.** `decks/_metadata.yml` sets `freeze: auto` — cells re-execute only when the source changes. Cached output lives in `_freeze/decks/<slug>/`. Commit that directory so CI reuses the cache and doesn't need every runtime dep. Override per-deck with `freeze: false` in the deck's front matter if the cell should always execute (live-data demos).

**Dependencies.** Every `import` must be in `requirements.txt`. Baseline is `jupyter`; add `matplotlib`, `pandas`, `polars`, `pyarrow` etc. as talks need them.

**Data files.** Convention is `decks/<slug>/assets/*.parquet` (or `.csv`, `.json`). Reference with a relative path: `pl.read_parquet("assets/foo.parquet")`.

## Inline SVG (illustrations without a third-party tool)

Drop SVG directly into the `.qmd` for diagrams. Two rules that keep it on-brand across both vigil themes:

**1. Inherit theme color via `currentColor`.**

```markdown
<svg viewBox="0 0 400 200" xmlns="http://www.w3.org/2000/svg"
     style="width: 70%; height: auto; color: inherit;"
     fill="none" stroke="currentColor" stroke-width="1.5">
  <rect x="10" y="10" width="180" height="80" />
  <text x="100" y="55" fill="currentColor"
        font-family="Source Sans 3, sans-serif"
        text-anchor="middle">before</text>
  <path d="M 200 50 L 380 50" stroke="#057dbc" stroke-width="2" />
</svg>
```

Strokes and text painted with `currentColor` pick up the theme's text color automatically — the same SVG renders correctly on `vigil-reveal-dark` and `vigil-reveal-light`.

**2. Accent color: the deck's single accent, nothing else.**

- On `vigil-reveal-light.scss`: `#057dbc`.
- On `vigil-reveal-dark.scss`: `#4db8e0`.

Read the deck's `format.revealjs.theme` path to know which. Never introduce a third color.

**Fonts allowed inside SVG:** `Source Sans 3` (labels), `JetBrains Mono` (code/mono kickers), `Playfair Display` (one big display element). No filters, no shadows, no gradients. Square corners.

**When to use Mermaid instead:** flowcharts, sequence diagrams, state diagrams, class diagrams. Quarto renders them natively:

```markdown
```{mermaid}
flowchart LR
  A[Log] --> B[Rule] --> C[Alert]
```
```

The vigil theme already sets the Mermaid font to `JetBrains Mono`. Only reach for hand-SVG when Mermaid's shape vocabulary is wrong for the idea.

**When to punt to a raster:** photo-realistic imagery, hero graphics, screenshots. Leave `![](assets/foo.webp)` referencing a file the human supplies (or an image-gen MCP produces).

## Iframe slide (escape hatch)

Two variants:

**Background iframe** — the app fills the slide edge-to-edge:

```markdown
## Live temperature check {background-iframe="assets/poll.html"}
```

The slide's title still renders on top; if you want a truly blank canvas, drop the title text or set `data-visibility="hidden"` on the header. For a poll app that has its own heading, leave the deck's `##` empty:

```markdown
##  {background-iframe="assets/poll.html"}
```

**Inline iframe** — a boxed embed inside a normal slide:

```markdown
## Diagram

<iframe src="assets/diagram.html" width="960" height="540" frameborder="0"></iframe>
```

Always prefer background-iframe for full-slide apps; use inline only when the app is one element of a compound slide.

The referenced HTML must live under `decks/<slug>/assets/<name>.html`. That directory is convention-enforced by pre-commit.

**Important — resource declaration.** Quarto's resource-scanner recognizes `![](path)` and `href="path"` but *not* `data-background-iframe="path"`. If a deck uses any iframe slides, the front matter MUST declare:

```yaml
resources:
  - assets/
```

Without this, the deck renders but `assets/*.html` files are absent from the output and the iframe 404s at runtime.

## Layout hints

- `{.center}` on a `##` centers content vertically. Use it whenever a slide's body is ≤ ~3 short items with no image/code/diagram — otherwise the content collapses to the top of the frame. The fixed frames Agenda / Q&A / Thank you all carry `.center` for this reason.
- `{background-color="#111111"}` overrides slide background — use rarely and only in the theme's palette.
- `{background-image="img.webp" background-size="cover"}` for a full-bleed image slide. Keep image under 300 KB (pre-commit gate).
- `{.smaller}` shrinks the slide's text (Quarto convenience).

## Reveal cadence

- `incremental: true` in front matter makes every bulleted / numbered list reveal one item at a time. Set at the top of the deck once.
- `::: {.nonincremental}` … `:::` wraps a list to override `incremental: true` — the list renders all items at once. Use for whoami (audience needs the full bio up front to make the credibility call), and anywhere else the reveal cadence would be a distraction rather than a device.
- `::: {.fragment}` … `:::` wraps arbitrary content (not just list items) to reveal on next-slide. Explicit, no top-level dependency.
- One cadence per slide. Don't mix partial-incremental bullets with an image or code block below.

## Pacing model (long form)

The weighted budget from `SKILL.md`, spelled out:

| Slide kind | Time to narrate | Notes |
|---|---:|---|
| Title / TLP / section-divider | 0.5–1 min | Kick, orient, move on. |
| Statement (single sentence, no reveal) | 1 min | One idea, land, next. |
| Prose / bulleted list | 1.5 min | Incremental reveal adds ~15s per bullet. |
| Diagram / image | 1.5–2 min | Point at things; narrate what's not on the slide. |
| Table | 2 min | Read it aloud takes real time. |
| Code walkthrough (progressive reveal) | 2.5–3 min | 1s per line highlight + narration. |
| Columns compare | 2 min | Two sides means twice the reading. |
| Iframe / demo | 3–5 min | Add extra buffer for network / audience interaction. |

Q&A buffer = `max(5, round(0.15 * duration))`. Never encroach on it; a talk ending at exactly the top of the hour with no questions is a bad talk.

Sanity anchors:

| Slot | Q&A | Content | Slides (mixed) | Slides (code-heavy) |
|-----:|----:|--------:|---------------:|--------------------:|
| 10 min | 5 | 5 | 4–6 | 3–4 |
| 20 min | 5 | 15 | 8–12 | 6–8 |
| 30 min | 5 | 25 | 12–16 | 10–12 |
| 45 min | 7 | 38 | 18–24 | 14–18 |
| 60 min | 9 | 51 | 24–30 | 18–24 |

If the outline exceeds the budget, cut before you shrink. Recovering trust after a rushed talk is expensive.

## What NOT to do

- **No `revealjs` plugin invocations you didn't verify.** Some plugins are bundled with Quarto (e.g., `menu`, `chalkboard`); reference only those.
- **No inline `<style>` or `<script>` tags in the `.qmd`.** If you need code, that's what `assets/*.html` (iframed) is for.
- **No PDF export design.** Decks are HTML mini-sites; no print stylesheet, no `.pdf` path in CI.
- **No `format: html` alongside `format: revealjs`.** One output per deck. The `_quarto.yml` site format is `html`; the deck's per-file format block overrides.
- **No navbar / index / deck-level TOC.** Silent publishing means the URL exists, nothing advertises it. `toc: false` in the deck format, no `decks/index.qmd`.

## Front-matter cheatsheet

```yaml
title: "Detection Engineering at Scale"        # ≤ 60 chars
description: "How to keep signal ahead of scale in a modern SOC pipeline."  # ≤ 160 chars, no trailing period.
                                                # Doubles as title-slide sub-line + OG card description
                                                # (via decks/_partials/title-slide.html). Do not emit `subtitle:`.
image: og-detection-at-scale.webp              # .webp, ≤ 300 KB, ≤ 70-char filename

tlp: clear                                     # clear|white|green only — sensitive material belongs in a private repo
duration: 30                                   # minutes

# Only needed if the deck uses `background-iframe` escape-hatch slides.
resources:
  - assets/
event: "BSides Somewhere 2026"
date: 2026-05-01

format:
  revealjs:
    # Theme is fully specified by the SCSS path. Never add a top-level
    # `theme:` field — Quarto merges it into this list and loads two themes.
    theme: [default, ../../static/styles/vigil-reveal-dark.scss]
    incremental: true
    code-line-numbers: true
    slide-number: c/t
    toc: false
    controls: true
    progress: true
    history: true
    hash-type: number
```

## Filesystem layout for one deck

```
decks/<slug>/
  index.qmd                # the deck
  og-<slug>.webp           # OG image (≤ 300 KB) — stays at deck root; metadata, not slide content
  assets/                  # everything else: slide images, iframe HTML, data files
    hero.webp
    poll.html              # iframe escape-hatch (only if used)
    metrics.parquet        # {python} data (only if used)
```

Everything the deck needs must sit inside `decks/<slug>/`. Cross-deck reuse (a shared app, a shared image) doesn't exist yet — copy, don't symlink.
