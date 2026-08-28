---
name: analyse-chronicle-delays
description: >
  Analyse ingestion and detection timing for one or more Chronicle (Google
  SecOps) SOAR cases. Surface delays between event_timestamp → ingested_timestamp
  (ingestion delay) and ingested_timestamp → detection_timestamp (SIEM/rule-engine
  delay), and flag any `DETECTION_TIMING_DETAILS_*` tags on individual alerts
  (e.g. REPROCESSING, BACKFILL). Use whenever the user runs
  `/analyse-chronicle-delays <caseId> [<caseId>...]`, says "analyse delays in case
  <id>", "ingestion timing for case <id>", "why is case <id> slow", "check
  detection latency for cases <ids>", or shares one or more Chronicle case URLs
  with timing questions. Read-only by design: never closes cases, never posts
  comments.
---

# Chronicle Case Delay Analyser

You are diagnosing ingestion and detection latency across one or more Chronicle (Google SecOps) SOAR cases. Pull each case's alerts, then for every alert fetch the timing fields (event timestamp, ingested timestamp, detection createdTime, `detectionTimingDetails`). Compute the deltas and report where the latency lives.

## Input

The user provides one or more of:

- numeric case IDs (e.g. `17945`, or `17945 17946 18002`), or
- full Chronicle case URLs (`https://<tenant>.backstory.chronicle.security/cases/<id>/overview`).

Parse numeric IDs out of any URL form. Mixed input is fine.

## Tenant parameters

Every `mcp__remote-mcp-secops__*` call requires three fields:

- `projectId` — Google Cloud project ID hosting the Chronicle tenant
- `customerId` — Chronicle customer GUID
- `region` — Chronicle region (e.g. `us`, `europe`)

Source these values, in order of preference:

1. From an auto-memory entry that documents the Chronicle / SecOps tenant params (look for a memory whose `description` mentions Chronicle tenant params, customerId, or `mcp__remote-mcp-secops`).
2. From a `CLAUDE.md` in the working directory tree.
3. From environment variables (`CHRONICLE_PROJECT_ID`, `CHRONICLE_CUSTOMER_ID`, `CHRONICLE_REGION`).
4. Ask the user.

Do NOT invent values.

## Procedure

For each case ID:

1. **List alerts** with `mcp__remote-mcp-secops__list_case_alerts`. Record each alert's `name` (numeric SOAR ID), `siemAlertId`, and `createTime` (SOAR ingestion timestamp, milliseconds since epoch).

2. **Fetch each alert's timing data** with `mcp__remote-mcp-secops__fetch_alert_data` against the `siemAlertId`. Call these **sequentially**, not in parallel — payloads can run 50–80k tokens and will blow context if batched.
   - Extract only these fields:
     - `latencyMetrics.oldestEventTime` → use as `event_ts`
     - `latencyMetrics.oldestIngestionTime` → use as `ingested_ts`
     - `createdTime` (top-level on the detection) → use as `detection_ts`
     - `detectionTimingDetails` (array of enum tags)
   - For multi-event detections (`events` array length > 1), the `latencyMetrics.oldest*` values are already the correct aggregate. Do not re-parse per-event timestamps.
   - If `fetch_alert_data` returns a "saved to file" truncation, read the file and extract the four fields above via `jq` or Python — do not try to read the full payload into context.

3. **Compute deltas in minutes**, rounded to 2 decimals:
   - `delta_1 = (ingested_ts - event_ts) / 60` (ingestion latency)
   - `delta_2 = (detection_ts - ingested_ts) / 60` (SIEM/rule-engine latency)

4. **Attribute any delay**:
   - Large `delta_1` (> ~5 min) → **ingestion** delay (raw event → SIEM ingest pipeline).
   - Large `delta_2` (> ~30 min) → **SIEM** delay (rule engine took too long to emit the detection).
   - Any non-`UNSPECIFIED` value in `detectionTimingDetails` is definitive evidence of a non-real-time detection path — mention the tag and the alert it's on. Known tags include `DETECTION_TIMING_DETAILS_REPROCESSING` (rule re-evaluated historical data) and `DETECTION_TIMING_DETAILS_BACKFILL`.
   - Thresholds are guidance, not law — judge in context. A 27h `delta_2` is unambiguous; a 12-minute one is normal for batched rules.

## Output format

The output shape depends on how many case IDs were provided.

### Single case

Exactly two `##` sections. No preamble, no closing offer.

#### `## Analysis`

One paragraph. State:

- Whether ingestion latency was healthy across alerts (give the range, e.g. "1.2–2.1 min").
- Whether SIEM/rule-engine latency was healthy (give the range).
- Any alert(s) carrying non-`UNSPECIFIED` timing tags, named by SOAR alert ID, with the specific tag value.
- Where the delay lives if any — **ingestion** (event→ingested) or **SIEM** (ingested→detection) — and which alert(s) are affected.
- SOAR pickup behaviour only if asked or if it's anomalous.

If everything is healthy, say so plainly in one sentence.

#### `## Timestamps`

One table, exactly these six columns in this order:

| Alert ID | event_ts (UTC) | ingested_ts (UTC) | detection_ts (UTC) | delta_1 (min) | delta_2 (min) |

- Timestamps in ISO 8601 with milliseconds and trailing `Z`.
- Bold any cell whose delta crosses a threshold or whose alert carries a timing tag.
- Below the table, two short lines explaining `delta_1` and `delta_2`. If any rows used aggregate timestamps from a multi-event detection, note it.

Do **not** add a `timing_tag` column. Timing tags belong in the Analysis paragraph.

### Multiple cases

Exactly one `## Summary` section followed by one `## Case <id>` section per case.

#### `## Summary`

One paragraph (or short bullet list if more than 3 cases). Cover:

- Which cases have delays and where the delay is — explicitly use the words **ingestion** (delta_1) or **SIEM** (delta_2).
- Which alerts carry non-`UNSPECIFIED` timing tags, named as `<caseId>/<alertId>` with the tag.
- Cases that are healthy can be listed in one trailing sentence ("Cases X, Y, Z had no delays.").

#### `## Case <id>` (one per case)

A single table with the same six columns as the single-case `## Timestamps` table. No per-case analysis paragraph — the summary already covered it. If the case had a notable timing tag or a row whose delta is an outlier, bold the relevant cell.

## Tone

Audience: SOC analysts, detection engineers, platform owners. Technical, time-constrained, hostile to fluff.

- Direct. State the conclusion first, then the evidence.
- Honest about thresholds — call out judgement calls ("delta_2 of 12 min is within normal batched-rule range").
- Professional jargon expected (SIEM, SOAR, UDM, rule engine, reprocessing, backfill).
- No sycophancy, no closing offers, no recap of the user's question.
- No emojis.
- `##` headers only. No `###` or deeper.

## What NOT to do

- Don't auto-close, comment on, or modify any case. Read-only.
- Don't fetch alert payloads in parallel — sequential only, and extract only the four timing fields.
- Don't include a `timing_tag` column in the table — surface tags in the Analysis / Summary prose.
- Don't include columns the user didn't ask for. The six-column shape is fixed: `Alert ID | event_ts (UTC) | ingested_ts (UTC) | detection_ts (UTC) | delta_1 (min) | delta_2 (min)`.
- Don't invent thresholds as hard rules. The 5-minute and 30-minute marks are guidance; the decisive signal is the `detectionTimingDetails` tag.
- Don't editorialise about the rule's logic, the actor, or the alert's meaning — that's the job of `analyse-chronicle-case`. Stay in the timing lane.
- Don't start with "Based on the data" or "Looking at the timestamps". State the finding.
