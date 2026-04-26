# AI Tells Patterns Reference

This is the detailed taxonomy of AI-generated text patterns. SKILL.md handles the workflow; this file gives the full pattern inventory with rewrite strategies.

The patterns are grouped by category. Each entry has: what it is, why it's a tell, BEFORE/AFTER examples, and caveats.

---

## 1. Lexical / Word-Level Tells

### 1.1 Tier-1 vocabulary (peer-reviewed evidence; near-certain AI when clustered)

These have empirical post-2022 frequency spikes (Kobak 2025, Stanford Liang 2024, Gray 2024). Replace 1:1 using `references/replacements.md`.

| Word | Why it's a tell | Plain replacement |
|---|---|---|
| delve / delves / delving | Highest spike of any 2024 PubMed word (r=25.2). RLHF artifact. | look at, examine, dig into, study |
| showcase / showcasing | Filler verb for "show" | show, demonstrate (in formal contexts) |
| underscore / underscoring | Dramatizes ordinary statements | show, highlight, emphasize, mean |
| intricate | +117% in 2023 academic papers | complex, detailed, complicated |
| meticulous / meticulously | Top spike marker | careful, thorough, precise |
| commendable | Stanford peer-review marker | good, solid, well-done |
| pivotal | Stanford peer-review tell | key, important, central |
| comprehensive | PubMed top-10 high-δ word | complete, full, thorough |
| crucial | PubMed top-10 | important, key, central |
| notable / notably | Filler adverb | (often delete) or "worth noting" |
| enhance / enhancing | Latinate stand-in for "improve" | improve, make better |
| insights / actionable insights | PubMed top-10 | findings, lessons, takeaways |
| innovative | Liang/Gray peer-review spike | new, original |
| versatile | Liang/Gray marker | flexible, useful |
| noteworthy / invaluable / potent / ingenious | Gray adjective marker set | (often delete) |

**Caveat**: Many words have legitimate uses ("robust" in statistics, "comprehensive review" as a genre label, "delve" in literary criticism or West African English). The signal is **co-occurrence** — joint use of two markers rises 4–7× more than single use.

### 1.2 Tier-2 vocabulary (ornate metaphors and verbs)

**Ornate metaphor nouns**: tapestry, landscape (figurative), realm, journey (metaphorical), ecosystem, paradigm, synergy, holistic, testament, kaleidoscope, mosaic.

**Filler verbs**: leverage → use, harness → use, navigate (figurative) → handle/deal with, foster → encourage, embark → start, unleash/unlock/unveil → start/show, elevate → improve, empower → let, revolutionize/transform/reshape → change, streamline → simplify, resonate → match.

**Filler adjectives**: vibrant, bustling, rich, vital, multifaceted, dynamic, sophisticated, compelling, robust, seamless, cutting-edge, state-of-the-art, bespoke, tailored, nuanced, groundbreaking, transformative, ever-evolving, game-changing.

**Filler adverbs**: truly, indeed, undoubtedly, absolutely, certainly, remarkably, incredibly, quietly, deeply, fundamentally, arguably, effectively, efficiently, strategically, consistently.

**BEFORE**: "We leverage cutting-edge AI to harness data, empower teams, and revolutionize workflows."
**AFTER**: "We use AI on our data to make the team faster."

**BEFORE**: "Indeed, this is undoubtedly a truly transformative, quietly revolutionary moment."
**AFTER**: "This changes things."

### 1.3 Vague quantifiers and hedges

a myriad of, a plethora of, a multitude of, numerous, various, a wide range of, a variety of, manifold, substantial, considerable, significant.

**Pattern**: AI uses these to avoid committing to a count. The fix is almost always a number — but if the author can't supply one, "some" or "several" works.

**BEFORE**: "A myriad of various stakeholders raised numerous concerns."
**AFTER**: "Six stakeholders raised three concerns: cost, timeline, and access." (or "Several stakeholders raised concerns about cost, timeline, and access.")

### 1.4 Latinate / formal-register replacements

AI defaults to the longer Latinate word over the Anglo-Saxon plain English. Use the table in `references/replacements.md`.

**Caveat**: Latinate words are appropriate in legal, medical, and some scientific genres where precision is the convention. Don't strip "utilize" from a methods section if the surrounding text is similarly formal.

### 1.5 Filler phrases (delete on sight)

- "It's worth noting that…" / "It's important to note…" / "It bears mentioning…"
- "In today's fast-paced / digital / ever-evolving world"
- "In conclusion / In summary / To summarize / To sum up / Ultimately"
- "At its core / At the heart of / Fundamentally"
- "Whether you're a beginner or an expert"
- "Unlock the power of / Harness the power of"
- "Let's dive in / Let's break this down / Let's unpack this"
- "Despite its challenges, [optimistic conclusion]"
- "That said / That being said"
- "I hope this email finds you well"
- "Stands as a testament / Serves as a reminder of"
- "Shed light on" / "Deep dive into"

---

## 2. Syntactic / Sentence-Construction Tells

### 2.1 Negation–affirmation antithesis

The single most-discussed structural tell. Variants: "It's not X, it's Y"; "X isn't just Y, it's Z"; "More than just X"; "Not X. Not Y. Just Z."

**Mechanism**: RLHF rewards pithy/profound-sounding phrasing.

**Rewrite strategy**: Flatten to a direct claim. Pick the affirmative side and drop the negation frame.

**BEFORE**: "Credit-card fraud isn't just evolving — it's accelerating. We're not just building a product, we're creating an experience."
**AFTER**: "Credit-card fraud is getting faster every quarter. We're building a product, and we want it to feel good to use."

**Caveat**: One masterfully placed instance is rhetoric (JFK, King James Bible). Flag only when stacked (≥2 in same passage).

### 2.2 Tricolon / rule of three

Three balanced parallel items in a row. AI is "comforted by saying three things in a sentence."

**Rewrite strategy**: Break the parallelism. Drop one item, or vary the clause length.

**BEFORE**: "Optimized through training and alignment to project authority, clarity, and inoffensiveness."
**AFTER**: "Trained to sound authoritative — and uncannily inoffensive."

**Caveat**: A single well-placed tricolon is rhetoric. Back-to-back tricolons across paragraphs is the tell.

### 2.3 "From X to Y" sweeping range

**BEFORE**: "From startups to Fortune 500s, everyone is using AI."
**AFTER**: "Three-person startups and Fortune 500 firms alike are using AI."

**Caveat**: Legitimate when there's a real continuum ("from kindergarten to grad school"). The tell is fake continuums where X and Y aren't on the same axis.

### 2.4 "Whether you're X or Y" inclusive framing

**BEFORE**: "Whether you're a beginner or a seasoned developer, this guide has you covered."
**AFTER**: "This guide assumes you've used Python before. If you haven't, start here instead."

### 2.5 Sentence-initial mechanical transitions

"Moreover," "Furthermore," "Additionally," "However," "Nevertheless," "Consequently," "Indeed."

**BEFORE**: "Furthermore, the system improves performance. Moreover, it's secure. Additionally, it's scalable."
**AFTER**: "It's faster. It's also secure, and it scales."

**Caveat**: Single uses are normal in academic writing. The tell is when *every* paragraph opens with one.

### 2.6 Participial-phrase openers stacked

"Building on this, …" "Drawing from decades of research, …" "Leveraging the new framework, …"

**BEFORE**: "Building on this foundation, the team developed a robust pipeline."
**AFTER**: "The team took that foundation and built a working pipeline on top."

### 2.7 Trailing participial hedge

A participial coda tacked on to inject vague significance: "highlighting its importance," "underscoring its role," "making it ideal for X."

**BEFORE**: "The protocol uses end-to-end encryption, making it a powerful tool for privacy."
**AFTER**: "The protocol is end-to-end encrypted. Privacy is the whole point."

### 2.8 Symmetrical sentence pairs / chiasmus drumbeat

**BEFORE**: "Innovation without execution is hallucination; execution without innovation is stagnation."
**AFTER**: "You need both — ideas and shipping. Skip either and you're stuck."

### 2.9 "In today's [adjective] world" / "In an era of…" opener

**BEFORE**: "In today's fast-paced digital landscape, AI has emerged as a game changer."
**AFTER**: "AI rewrote a lot of marketing departments in 18 months."

Almost no legitimate use in modern non-fiction — flag aggressively.

### 2.10 "At its core / At the heart of" zoom-in

**BEFORE**: "At its core, machine learning is about pattern recognition."
**AFTER**: "Machine learning is, basically, statistical pattern matching."

### 2.11 "Imagine a world where…" opener

**BEFORE**: "Imagine a world where every tool you use has a quiet intelligence behind it."
**AFTER**: "Picture this: your inbox triages itself overnight. That's already shipping."

### 2.12 Low burstiness / uniform sentence shape

Human prose alternates 5-word fragments with 34-word embedded clauses; LLM prose clusters in a narrow 15–22 word band with similar SVO shape.

**BEFORE**: "AI is a powerful technology. It can transform business operations. It enables faster decision-making. It improves customer experience."
**AFTER**: "AI is genuinely useful. The clearest wins so far? Faster decisions, mostly — and (sometimes) better customer support, when the rollout is careful."

**Rewrite strategy**: Vary sentence length. Shorten one sentence to 3–5 words; lengthen another to 25+. Don't force this on technical content where uniform clauses are correct.

### 2.13 Demonstrative-subject stacking ("This [noun] is…")

**BEFORE**: "This approach is innovative. This concept is groundbreaking. This system is scalable."
**AFTER**: "It's a fresh way to attack the problem — and it scales, which most fixes don't."

### 2.14 "Not X. Not Y. Just Z." dramatic countdown

**BEFORE**: "Not a bug. Not a feature. A fundamental design flaw."
**AFTER**: "It's neither a bug nor a feature — it's a design flaw, full stop."

### 2.15 Self-posed rhetorical question + one-word answer

**BEFORE**: "The result? Devastating." / "Here's the kicker: most teams never measure it."
**AFTER**: "The fallout was severe." / "Most teams don't measure it — that's the actual problem."

A staple of feature journalism. Tell is repetition.

### 2.16 "Despite its challenges…" concession-then-optimism beat

**BEFORE**: "Despite these challenges, the initiative continues to thrive."
**AFTER**: "It's still working — but the funding cliff hits in March."

### 2.17 Anaphora abuse (repeated openers)

**BEFORE**: "They could expose APIs. They could offer SDKs. They could provide tooling. They could create marketplaces."
**AFTER**: "They could open up — APIs, SDKs, marketplaces. They haven't."

### 2.18 "Not only X, but also Y" rigid balance

**BEFORE**: "AI not only saves time but also enhances creativity."
**AFTER**: "AI saves time. (Sometimes it sparks ideas, too.)"

### 2.19 Listicle-in-a-trench-coat paragraphs

When told not to use bullets, the model produces "First, … Second, … Third, …" prose with mechanical parallel openings.

**Rewrite strategy**: Vary the openers. Use "Then," "Also," "Meanwhile," or just drop the markers entirely.

---

## 3. Structural / Formatting Tells

### 3.1 Bullet-point overuse where prose belongs

RLHF treats bullets as "scannable = helpful." Models default to lists even for narrative or emotional content.

**Caveat**: Bullets are correct for genuine parallel items (ingredients, comparison specs, action steps). The tell is bullets for narrative or argument.

### 3.2 The "bold term: explanation" list shape

Bullets where each starts with a bolded keyword followed by a colon and a one-sentence restatement.

**BEFORE**:
- **Speed**: It's fast.
- **Security**: It's secure.
- **Scalability**: It scales.

**AFTER**: "It's fast and secure, and it scales to millions of users."

### 3.3 Bolded phrases sprinkled mid-paragraph

**BEFORE**: "**Consistency** is key. You need **strong habits** and a **growth mindset** for **lasting success**."
**AFTER**: "Showing up matters more than feeling motivated."

### 3.4 Headers / subheaders on short pieces

A four-paragraph email broken into "## Background ## Issue ## Recommendation ## Next Steps" is almost always AI.

### 3.5 Emoji as bullet markers or section dividers

✅ 🚀 💡 ✨ — direct artifact of LinkedIn-trained data.

**BEFORE**: "✅ Boost productivity 🚀 Save time 💡 Get smarter ✨ Transform your workflow."
**AFTER**: "It saves about an hour a week."

### 3.6 Tables forced onto content that flows better as prose

A 2×3 "Pros | Cons" table with one phrase per cell, or "Aspect | Description" for three sentence-length concepts.

### 3.7 Predictable scaffolding (intro → 3–5 bullets → conclusion)

The five-paragraph essay structure RLHF rewards.

### 3.8 "Here's a breakdown" / "Let me break this down" structural meta-commentary

**BEFORE**: "Great question! Let me break it down for you. Here's a comprehensive overview:"
**AFTER**: "Three things matter here. The first is…"

### 3.9 Section-divider (`---`) overuse

A 600-word piece with five `---` dividers separating two-paragraph sections.

### 3.10 "Key takeaways" / TL;DR boxes appended unnecessarily

Genuine on 2,000+ word pieces, dense proposals, or threads. Suspect on a 300-word note.

### 3.11 Numbered structure with parallel openings

"First, … Second, … Third, …" applied mechanically.

### 3.12 Unsolicited Pros/Cons tables

When asked "should I quit my job?" AI returns a 5-row two-column table instead of an opinion.

### 3.13 Title with colon + subtitle template

"Mastering Productivity: A Comprehensive Guide to Reclaiming Your Time"

### 3.14 Formulaic openers and closers

**Openers (delete on sight):**
- "Let's dive in / Let's explore / Buckle up / Strap in"
- "Great question! / What a fascinating topic / I love that you're thinking about this"
- "Certainly! / Absolutely! / Of course! / Sure thing!"
- "In today's fast-paced world / In an era of unprecedented change"

**Closers (delete on sight):**
- "In conclusion / In summary / Ultimately / To sum up / All in all"
- "I hope this helps! / Hope this clarifies things"
- "Let me know if you'd like me to elaborate / Happy to help further / Feel free to ask"
- "Want me to turn this into a table?"

---

## 4. Rhetorical / Tonal Tells

### 4.1 Sycophantic openings

**BEFORE**: "Great question! That's actually a really insightful thing to ask."
**AFTER**: Just answer.

### 4.2 Over-hedging and qualifying

"It's important to note," "It's worth mentioning," "Keep in mind that," "That said," "It should be noted."

**BEFORE**: "It's important to note that, while it's true that exercise is generally beneficial, individual results may vary."
**AFTER**: "Exercise works for almost everyone."

**Caveat**: Hedging is appropriate for genuine uncertainty (medical, legal, scientific edge cases). The tell is hedging on uncontroversial claims.

### 4.3 Forced both-sides-ism

**BEFORE**: "Some argue X is best, while others contend Y has merits. Ultimately, the right choice depends on your situation."
**AFTER**: "X is better for almost everyone. Pick Y only if [specific case]."

**Caveat**: Don't strip the author's opinions if they were in the original. Only flatten when the original *had* an opinion that AI then "balanced" away.

### 4.4 Over-explaining / restating the question

**BEFORE**: "You're asking how to make better coffee. Coffee is a beverage made from roasted beans…"
**AFTER**: "Use less water than you think. Most home coffee is over-extracted."

### 4.5 Empathy theater

**BEFORE**: "I completely understand how you feel. That sounds really difficult, and your feelings are completely valid."
**AFTER**: "That's a hard situation. Here's what I'd actually do: …"

### 4.6 Closing offers

"Let me know if you'd like me to elaborate," "Happy to help further," "Want me to turn this into a handy table?"

End the response. The reader can ask if they want more.

### 4.7 Disclaimer stacking

**BEFORE**: "To get more sleep, try going to bed earlier. However, sleep is complex and individual results may vary. Always consult a healthcare professional. This information is not a substitute for medical advice."
**AFTER**: "Go to bed earlier. If that doesn't work after two weeks, see a doctor."

Keep one disclaimer if relevant; delete the rest.

### 4.8 Generic "thought-leader" / LinkedIn voice

**BEFORE**: "I learned a powerful lesson last week. As leaders, we need to embrace failure, lean into discomfort, and unlock our full potential. ✨"
**AFTER**: "I missed a deadline last week. The thing I screwed up was assuming the spec was final — it wasn't. Lesson: ask twice."

### 4.9 "Remember," / "Keep in mind," advice openers

**BEFORE**: "Remember, consistency is more important than intensity."
**AFTER**: "Consistency beats intensity."

### 4.10 Platitudes ("It's a journey, not a destination")

**BEFORE**: "Remember, success is a journey, not a destination."
**AFTER**: "It takes about three years. Most people quit at month four."

### 4.11 Didactic "you" overuse

**BEFORE**: "You need to understand that you are the captain of your own ship. You decide what you want, and you take action."
**AFTER**: "Most people who change careers wait too long. The ones who jump earlier usually land better."

### 4.12 Conditional politeness

"If you'd like, I can also draft a follow-up email." "Should you choose to proceed…" Service-bot tone hardcoded by RLHF.

---

## 5. Semantic / Content-Level Tells

### 5.1 Empty profundity / pseudo-deep aphorism

**BEFORE**: "Cooking isn't just preparing food — it's a way of being present with the moment."
**AFTER**: "Cooking is the only time of day my hands stop checking my phone."

This pattern often combines with the "It's not X, it's Y" reframe — attack both at once.

### 5.2 Restating the prompt before answering

**BEFORE**: "You asked about the best way to learn Spanish as an adult. Great question! There are several effective approaches…"
**AFTER**: "Cancel Duolingo. Find a tutor on iTalki for $12/hr."

### 5.3 Symmetrical / overly tidy summaries

**BEFORE**: "While critics argue X has hurt the industry, supporters note it has also brought new opportunities. Ultimately, the truth lies somewhere in between."
**AFTER**: "Critics are right: streaming gutted mid-budget films."

### 5.4 Listing without committing

When asked for advice, AI returns a five-option taxonomy instead of a recommendation.

### 5.5 False binaries / clean buckets

**BEFORE**: "There are two types of writers: planners and pantsers."
**AFTER**: "Most writers I know plan the first 30 pages, panic at page 60, outline frantically, then claim at parties they're 'pantsers.'"

### 5.6 Vague generalities (FLAG, don't fix)

"Many experts believe X." "Studies show Y." Generic numbers like "approximately 73%."

These need real specifics from the author. Flag in Part 3 of the output.

### 5.7 Generic examples ("Company X," "John Smith")

**BEFORE**: "Imagine a company — let's call it ABC Corp — that wants to expand to a new market."
**AFTER**: Flag for the author to add a real example, or rewrite in the abstract.

### 5.8 Cosmic significance inflation

**BEFORE**: "The introduction of the new municipal recycling program represents a pivotal moment in the city's ongoing journey toward sustainability."
**AFTER**: "Starting Monday, Cleveland charges $4 for trash bags."

### 5.9 Sensory metaphors detached from referents

**BEFORE**: "The restaurant had a warm, inviting atmosphere with delicious food and friendly service."
**AFTER**: Flag for the author to add real sensory detail (the sound, the smell, what the bartender's tattoo looked like).

### 5.10 Wikipedia voice applied to opinion

**BEFORE**: "The film, released in 2024, has received a range of critical responses, with some praising its cinematography while others have noted concerns about its pacing."
**AFTER**: "The movie is 40 minutes too long. The cinematography is gorgeous and the editor should be fired." (Only if the author's original had an opinion. Don't invent opinions.)

### 5.11 Definition-first openers

**BEFORE**: "Procrastination is the act of delaying or postponing tasks despite knowing there may be negative consequences."
**AFTER**: "I started writing this two weeks ago. The deadline was yesterday."

### 5.12 "Broader implications" zoom-out conclusion

**BEFORE**: "Ultimately, this debate reflects deeper questions about what we value as a society."
**AFTER**: "If the bill passes, my landlord can raise rent 12% next year. That's the whole story."

### 5.13 False precision

Suspiciously round percentages presented as exact. "Studies show that approximately 73% of millennials prefer experiences over material goods" — usually traceable to one survey, never replicated. Flag for verification.

### 5.14 Hallucinated specifics

When AI commits to detail, it often invents. Hallucinated case names, statute numbers, DOIs, and dates are dangerous. **Always flag named sources, statutes, dates, and statistics for verification — never trust them.**

### 5.15 "Quiet hum" / spectral vocabulary in fiction

A 1,100-word demo story might use "quiet," "hum," "humming," "echo," "liminal," "ghosts" repeatedly. Asked to write a *party* scene, AI still produces "the soft hum of distant conversation."

**BEFORE**: "She walked through the quiet hum of the empty hallway, where memory clung like a ghost to the walls."
**AFTER**: "The hallway smelled like the floor wax they'd used in 2003."

### 5.16 Cliché density / aphorism stacking

"At the end of the day, in today's rapidly evolving landscape, it's important to think outside the box and embrace change." Strip aggressively.

### 5.17 "Can only write hot" — emotional escalation

AI escalates language at emotional moments; skilled humans restrain it.

**Rule**: When the action is hot, write cold. If a paragraph piles on intensifiers at a dramatic moment, cut them. The drama lands harder without them.

---

## 6. Punctuation Tells

### 6.1 Em dashes (—)

The most-discussed punctuation tell. Sub-pattern: **mid-sentence em-dash pairs** (— like this —) used as parenthetical replacement. AI inconsistently spaces them.

**Density rule**: Don't flag a single em-dash. Flag >3 per 500 words, or repeated `word—word` unspaced parentheticals stacked back-to-back.

**Rewrite strategy**: Replace half with commas, parentheses, or periods. Keep the most rhetorically useful ones. Don't strip them all.

**BEFORE**: "The protocol — which has been in development for years — finally shipped. Forget commas — too quiet. Colons — too formal."
**AFTER**: "The protocol, which had been in development for years, finally shipped. Forget commas: too quiet. Colons: too formal."

**Caveats**: Em-dashes are legitimate, beloved by Dickinson, McCarthy, Nabokov, Faulkner, Plath. The tell is *rate*, not presence. GPT-5.1 reportedly suppresses em-dashes; absence in 2026 text doesn't prove human authorship.

### 6.2 Curly / smart quotes (" " ' ')

LLMs reliably emit curly typographic quotes even when the user types straight.

**Caveat**: Word, Pages, Substack, Medium, and most CMSes auto-convert. Diagnostic only in plaintext-native contexts (Slack, Reddit, code/docs, raw email). **Strongest signal: inconsistent mixing** of curly and straight in the same document.

### 6.3 Eerily consistent Oxford comma

Essentially zero signal alone. Many style guides require it.

### 6.4 Excessive colons introducing lists / expansions

**BEFORE**: "There are three benefits: speed, accuracy, and cost. The framework provides: scalability, security, and reliability."
**AFTER**: "Three benefits — it's faster, more accurate, and cheaper."

### 6.5 Semicolons for rhythm rather than meaning

AI is increasingly using the semicolon as the em-dash gets suppressed.

**BEFORE**: "The system is fast; it's also secure."
**AFTER**: "The system is fast — and it's secure too."

### 6.6 Hyphen vs. en-dash confusion

AI uses em-dashes everywhere but skips en-dashes entirely, often using hyphens for ranges (`1990-2000`) where an en-dash (`1990–2000`) belongs. Subtle inverse signal.

### 6.7 Unicode ellipsis (…) instead of three dots (...)

Auto-applied by many editors; weak signal alone.

### 6.8 Unicode arrows and special characters (→, ✓, •)

Claude in particular loves the → arrow. Real writers in text editors produce `->` or `=>`. Replace with regular characters.

### 6.9 Tool-output artifacts

Smoking-gun residue: `citeturn0search0`, `iturn0image1`, "knowledge cutoff in September 2021," "As an AI language model," visible markdown asterisks where rendering failed. Always strip.

---

## 7. False Positives — Don't Touch

These patterns AI uses heavily but humans also use legitimately. Bias toward leaving them alone unless they cluster with Tier-1 tells.

| Pattern | Legitimate human use | Disambiguator |
|---|---|---|
| Em-dash | Dickinson, McCarthy, Nabokov, Plath, Vonnegut. Word/macOS auto-substitute `--`. | Density: >3 per 500 words, or unspaced `word—word` stacked |
| Tricolon | Cicero, Lincoln, Churchill, JFK | Single triplet ≠ AI; sustained pattern across paragraphs = signal |
| Oxford comma | Style choice (Chicago, Oxford require it) | Zero signal alone |
| "However," / "Moreover," / "Furthermore," | Standard academic English; ESL essay scaffolding | Look for combination with Tier-1 vocabulary, not single use |
| Bullet points | Genuine list content (recipes, specs, action items) | AI bullets *narrative*; humans bullet enumerable items |
| "It's important to note" | Real legal/scientific/medical caveats | Frequency >1 per ~500 words is suspect |
| Curly quotes | Auto-converted by many platforms | Only diagnostic when *inconsistent* in same passage |
| Headers | Long-form journalism, technical docs, reports | Tell is uniformity — every output gets headers regardless of length |
| Five-paragraph structure | Taught in schools; standard student form | Look for vocabulary + punctuation tells alongside |
| Passive voice | Standard in scientific/methods writing | Genre-adjusted; not a tell in academic abstracts |
| "Utilize" / Latinate register | Corporate, legal, medical genre conventions | Density and clustering with other Latinate substitutions |
| Pristine grammar / no typos | Skilled editors, professional writers | Combinatorial only — never standalone |

### Demographic considerations

- **Non-native English speakers** are systematically over-flagged. Words like "delve" are common in West African and South Asian formal English. Bias toward leaving them.
- **Heavily edited / Grammarly-polished writing** can look AI. Apply higher thresholds.
- **Formal academic / legal genres** — passive voice, Latinate register, structural symmetry overlap with AI. Don't strip.
- **Corporate marketing copy** — Tier-2 vocabulary (leverage, robust, seamless) is *native* to genre. Apply judgment.
- **Short text (<200 words)** — detection unreliable. Bias toward leaving things alone.

---

## 8. Combinatorial heuristics

- **2 Tier-2 tells in same paragraph** → upgrade to "likely AI"; fix.
- **1 Tier-1 + any Tier-2** → strong AI verdict; fix all of them.
- **3+ Tier-3 tells alone** → still inconclusive; likely a polished human writer; leave alone.

The strongest signal is **clustering**. If a paragraph has only Tier-3 markers, leave it. If it has one Tier-1 marker and the rest of the paragraph reads naturally, fix only that marker — don't touch the rest.

---

## 9. Model-specific signatures (informational)

If the user mentions which model produced the text, calibrate slightly:

- **Claude**: heavy em-dashes (pre-4.x), "You're absolutely right!", "I'd be happy to", contrastive reframes ("not just X, it's Y"), bold-term:explanation lists, → arrows.
- **GPT-4 / 4o**: "delve," "tapestry," "Certainly!", "I hope this helps!", heavy bullets, rule-of-three. The April 2025 GPT-4o sycophancy episode added "amazing," "absolutely pivotal," "a game-changer."
- **Gemini**: heaviest markdown, emoji-rich, ✅ ❌ markers, highest sycophancy rate, rigid five-paragraph structure.
- **Llama / Mistral**: substrate of most "humanizer" tools — patterns appear inside evasion-rewritten text.

Newer models (GPT-5, Claude 4+) actively suppress classic tells via system prompts. Absence of em-dashes or "delve" doesn't indicate human authorship in 2026-vintage text.
