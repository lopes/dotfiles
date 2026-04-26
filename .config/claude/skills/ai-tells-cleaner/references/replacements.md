# Replacement Lookup Tables

Fast 1:1 substitutions for the lexical sweep (Pass 1) and phrase sweep (Pass 2). Use these when context allows a clean swap. When context is technical or specialized, default to the original — see `patterns.md` § 7 for false-positive guidance.

The format is `AI word/phrase` → `plain alternative(s)`. When multiple alternatives are listed, pick the one that best fits the surrounding tone and rhythm.

---

## 1. Tier-1 vocabulary (peer-reviewed AI markers)

| AI word | Replacement |
|---|---|
| delve / delves / delving / delve into | look at, examine, dig into, study, get into |
| showcase / showcasing / showcases | show, demonstrate, present |
| underscore / underscores / underscoring | show, highlight, emphasize, mean, stress |
| intricate | complex, detailed, complicated, tangled |
| meticulous / meticulously | careful, thorough, precise, careful |
| commendable | good, solid, well-done, worth noting |
| pivotal | key, important, central, crucial (when not also flagged) |
| comprehensive | complete, full, thorough, detailed |
| crucial | important, key, central |
| notable | (often delete) or "worth noting" |
| notably | (often delete) or "in particular" |
| enhance / enhances / enhancing | improve, make better, strengthen |
| insights | findings, lessons, takeaways, points |
| actionable insights | useful findings, things you can act on |
| innovative | new, original, fresh |
| versatile | flexible, useful, adaptable |
| noteworthy | (often delete) or "worth noting" |
| invaluable | useful, helpful, valuable |
| potent | strong, powerful, effective |
| ingenious | clever, smart, creative |
| robust | (in stats: keep) (otherwise: strong, solid, reliable) |
| seamless | smooth, easy, frictionless |

---

## 2. Tier-2 ornate verbs (filler verbs)

| AI verb | Replacement |
|---|---|
| leverage / leveraging | use, apply |
| harness / harnessing | use, tap, draw on |
| navigate (figurative) | handle, deal with, work through, get through |
| foster / fosters / fostering | encourage, help, build, grow, support |
| embark on | start, begin |
| unleash | start, release, let loose |
| unlock | open up, give access to, release |
| unveil | show, reveal, present |
| elevate | improve, raise, lift |
| empower | let, enable, allow |
| revolutionize | change, remake, overhaul |
| transform | change, remake |
| reshape | change, redo |
| streamline | simplify, speed up, smooth out |
| resonate (figurative) | match, fit, click, land |
| spearhead | lead, run, drive |
| catalyze | spark, trigger, kick off |
| facilitate | help, ease, enable, allow |
| optimize | improve, tune, refine |
| galvanize | rally, mobilize, push |
| synthesize | combine, pull together |
| amplify | boost, increase, raise |
| illuminate (figurative) | show, clarify, explain |

---

## 3. Latinate → plain English

| Latinate | Plain |
|---|---|
| utilize / utilization | use |
| commence | start, begin |
| terminate | end, stop |
| ascertain | find out, learn, check |
| implement | do, put in place, set up |
| demonstrate | show |
| furnish | give, provide |
| provide | give (often) |
| regarding / pertaining to | about |
| aforementioned | this, that, the |
| subsequent / subsequently | later, after, then |
| prior to | before |
| in order to | to |
| accordingly | so |
| consequently | so |
| thus / hence | so, that's why |
| therefore | so |
| moreover | also |
| furthermore | also, plus |
| additionally | also, plus |
| nevertheless | but, still |
| notwithstanding | even so, still |
| heretofore | until now, before |
| henceforth | from now on |
| inasmuch as | since, because |
| in lieu of | instead of |
| in the event that | if |
| in the vicinity of | near, around |
| at this juncture | now, at this point |
| at the present time | now |
| due to the fact that | because |
| in spite of the fact that | even though, although |
| with regard to / with respect to | about, on |
| endeavor | try |
| endeavor to | try to |
| vis-à-vis | about, against, compared to |

---

## 4. Vague quantifiers

These usually need a number. If the author can't supply one, use a smaller, less inflated word.

| AI quantifier | Replacement |
|---|---|
| a myriad of | (use a number) or "many," "several" |
| a plethora of | (use a number) or "many," "lots of" |
| a multitude of | (use a number) or "many" |
| numerous | several, many, [a number] |
| various | (often delete) or "different" |
| a wide range of | (use a number) or "many," "several types of" |
| a variety of | (use a number) or "different" |
| manifold | many |
| countless | many, "more than [number]" |
| substantial | big, large, significant |
| considerable | big, sizeable |
| significant (when meaning "big") | big, large, important |
| significant (when meaning "statistically significant") | (keep — technical term) |

---

## 5. Filler adjectives

Many of these can be deleted entirely. The replacement column gives a fallback when the adjective is doing real work.

| AI adjective | Replacement (or delete) |
|---|---|
| vibrant | (often delete) or "lively," "active" |
| bustling | busy, packed |
| rich (figurative) | full, deep |
| vital | important, key, needed |
| multifaceted | many-sided, complex |
| dynamic | changing, active, fast-moving |
| sophisticated | complex, advanced, refined |
| compelling | strong, convincing, persuasive |
| robust | (stats: keep) (other: strong, solid, reliable) |
| seamless | smooth, easy |
| cutting-edge | new, recent, advanced |
| state-of-the-art | latest, current |
| bespoke | custom, tailored, made-to-order |
| tailored | (often: custom, specific) |
| nuanced | subtle, detailed, careful |
| groundbreaking | new, important, major |
| transformative | big, major, deep |
| ever-evolving | (delete) or "changing" |
| game-changing | major, big, important |
| paradigm-shifting | (delete) or "major" |
| holistic | whole, full, complete |
| myriad (adj.) | many |
| plethora (adj.) | many |

---

## 6. Filler adverbs

Most of these can be deleted. They're decorative.

| AI adverb | Replacement (default: delete) |
|---|---|
| truly | (delete) |
| indeed | (delete) |
| undoubtedly | (delete) or "clearly" |
| absolutely | (delete) |
| certainly | (delete) |
| remarkably | (delete) or "very" |
| incredibly | (delete) or "very" |
| quietly (figurative, e.g., "quietly revolutionary") | (delete) |
| deeply | (delete) or "really" |
| fundamentally | (delete) or "basically" |
| arguably | (delete) — usually adds nothing |
| effectively | (delete) — often adds nothing |
| efficiently | (delete or replace with specifics) |
| strategically | (delete) |
| consistently | (delete) or "always," "usually" |
| meaningfully | (delete) |
| notably | (delete) or "in particular" |
| essentially | (delete) or "basically" |
| seamlessly | (delete) or "easily" |

---

## 7. Filler phrases (delete or flatten)

| AI phrase | Action |
|---|---|
| It's worth noting that X | → X |
| It's important to note that X | → X |
| It bears mentioning that X | → X |
| It should be noted that X | → X |
| Keep in mind that X | → X (or "Remember:" if useful) |
| That said, X | → X (or "But X") |
| That being said, X | → X (or "But X") |
| In today's fast-paced world | (delete entire phrase) |
| In today's digital landscape | (delete) |
| In an era of unprecedented X | (delete) |
| In conclusion, X | → X |
| In summary, X | → X |
| To sum up, X | → X |
| All in all, X | → X |
| Ultimately, X | → X (or "In the end, X") |
| At its core, X | → X (or "Basically, X") |
| At the heart of X | → "X is fundamentally about" or delete |
| Fundamentally, X | (delete the adverb) |
| Whether you're X or Y | (delete or replace with the actual audience) |
| Unlock the power of X | → "Use X" |
| Harness the power of X | → "Use X" |
| Tap into the power of X | → "Use X" |
| Let's dive in | (delete) |
| Let's break this down | (delete) |
| Let's unpack this | (delete) |
| Buckle up | (delete) |
| Strap in | (delete) |
| Despite its challenges, X | → "X is still working" or just X |
| I hope this email finds you well | (delete) |
| Stands as a testament to X | → "shows X" |
| Serves as a reminder of X | → "reminds us of X" or delete |
| Shed light on X | → "show X," "explain X" |
| Deep dive into X | → "look closely at X" |
| At the end of the day | (delete) |
| When all is said and done | (delete) |
| Think outside the box | (delete or replace with specifics) |
| Move the needle | (delete or replace with specifics) |
| Low-hanging fruit | (delete or replace with specifics) |
| Take it to the next level | (delete or replace with specifics) |
| Best practices | (often delete; or "what works") |
| Going forward | (delete or "from now on") |
| Circle back | (delete or "follow up") |
| Touch base | (delete or "talk") |

---

## 8. Sycophantic openers (DELETE)

| Phrase | Action |
|---|---|
| Great question! | (delete) |
| What a fascinating topic | (delete) |
| I love that you're thinking about this | (delete) |
| That's a really insightful question | (delete) |
| Certainly! | (delete) |
| Absolutely! | (delete) |
| Of course! | (delete) |
| Sure thing! | (delete) |
| You're absolutely right! | (delete) |
| You're absolutely correct! | (delete) |
| Excellent point! | (delete) |
| I'd be happy to | (delete) or "I'll" |
| I'd love to help with that | (delete) |
| What a great idea | (delete) |

---

## 9. Closing offers (DELETE)

| Phrase | Action |
|---|---|
| Let me know if you'd like me to elaborate | (delete) |
| Let me know if you have any questions | (delete) |
| Happy to help further | (delete) |
| Feel free to ask | (delete) |
| Want me to turn this into a [table/email/etc.]? | (delete) |
| Want me to expand on any of this? | (delete) |
| Should you have any questions | (delete) |
| Don't hesitate to reach out | (delete) |
| I hope this helps! | (delete) |
| Hope this clarifies things | (delete) |
| Please let me know your thoughts | (delete) |

---

## 10. Tool artifacts (ALWAYS DELETE)

| Artifact | Action |
|---|---|
| As an AI language model | (delete entire sentence) |
| As of my last knowledge update | (delete entire sentence) |
| knowledge cutoff in [date] | (delete entire sentence) |
| `citeturn0search0`, `iturn0image1`, etc. | (delete) |
| visible markdown asterisks where rendering failed | (clean up formatting) |
| `[INST]`, `</s>`, other model tokens | (delete) |
| "I cannot browse the internet" | (delete) |

---

## 11. Punctuation substitutions

| AI character | Plain replacement (when context warrants) |
|---|---|
| → (Unicode arrow) | -> or "to" |
| ✓ ✗ ✅ ❌ (used as bullet markers) | regular bullets (-) or remove |
| 🚀 💡 ✨ (used as section markers) | (delete) |
| `word—word` (unspaced em-dash, when stacked) | `word, word` or `word (word)` |
| ; before "however" / "but" / "and" | replace with `.` |
| Decorative `:` introducing a 3-item list when stacked | rephrase as prose |

Keep curly quotes alone unless mixed with straight quotes in the same document. Keep en-dashes (–) for ranges.

---

## 12. Patterns that take judgment (NOT 1:1)

Some patterns can't be substituted via lookup — they need contextual rewriting. See `patterns.md` for full guidance:

- "It's not X, it's Y" reframes (§ 2.1)
- Rule of three / tricolon (§ 2.2)
- Trailing participial hedges ("…, making it ideal for…") (§ 2.7)
- Bold-term:explanation list rows (§ 3.2)
- Hedging frames where the hedge is doing real work
- Empathy theater and disclaimer stacking
- Hallucinated specifics (FLAG, never substitute)
- Vague generalities like "studies show" (FLAG, never substitute)
