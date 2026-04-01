# Mycelium Rule Schema Reference

This document defines the Detection-as-Code rule format used by the team. Rules are written in YAML and abstract the underlying SIEM platform. The skill uses this schema as the authoritative source for validation.

## Schema Structure

A rule YAML file has five top-level sections, all required unless noted:

```yaml
metadata:     # Rule identity, ownership, and classification
logic:        # Detection logic (platform-specific query wrapped in YAML)
deployment:   # Operational state and scheduling
actions:      # Response integrations (optional)
guide:        # Human-readable investigation playbook
```

---

## Section: `metadata`

| Field           | Required | Type           | Description                                                      |
| --------------- | -------- | -------------- | ---------------------------------------------------------------- |
| `author`        | Yes      | string         | Team or individual who wrote the rule                            |
| `owner`         | Yes      | list[string]   | Slack handles or team aliases responsible for the rule            |
| `description`   | Yes      | string         | One-sentence summary of what the rule detects                    |
| `references`    | No       | list[string]   | URLs to source material, research, or upstream rules             |
| `severity`      | Yes      | enum           | `info`, `low`, `medium`, `high`, `critical`                      |
| `mitre_attack`  | Yes      | list[object]   | MITRE ATT&CK mappings                                           |
| `maturity`      | Yes      | enum           | `experimental`, `defined`, `refined`                             |

### `mitre_attack` object

```yaml
mitre_attack:
  - technique: "T1566"        # Technique ID (required)
    tactics: ["TA0001"]        # List of tactic IDs (required)
    subtechnique: "T1566.001"  # Sub-technique ID (optional)
```

### Severity Guidelines

| Severity   | Use When                                                                    |
| ---------- | --------------------------------------------------------------------------- |
| `info`     | Enrichment or awareness — not actionable on its own                         |
| `low`      | Suspicious but common — likely benign, worth logging                        |
| `medium`   | Warrants investigation — moderate confidence of malicious activity           |
| `high`     | Strong indicator of compromise — requires prompt investigation              |
| `critical` | Active threat with confirmed impact — requires immediate response           |

### Maturity Levels

| Maturity       | Meaning                                                                 |
| -------------- | ----------------------------------------------------------------------- |
| `experimental` | New rule, untested in production. Expected to generate noise.           |
| `defined`      | Tuned and validated. Stable in production with known FP patterns.       |
| `refined`      | Battle-tested. Low FP rate, well-documented, regularly reviewed.        |

---

## Section: `logic`

Contains the detection query as a multi-line string (using YAML `>` or `|`). The query is platform-specific (e.g., YARA-L for Chronicle) but wrapped in the universal YAML envelope.

### Common Logic Subsections (YARA-L)

```yaml
logic: >
  events:       # Event matching conditions and variable bindings
  match:        # Grouping and time window
  outcome:      # Enrichment fields attached to the alert
  condition:    # Which event variables must be present
```

### Logic Review Criteria

- **Variable naming:** Use descriptive prefixes (`$mail`, `$process`, `$dns`, `$whois`).
- **Comments:** Non-obvious logic should have inline comments explaining "why."
- **Time windows:** Must be justified. Shorter is better for performance. Common: `5m`, `10m`, `1h`.
- **Joins:** Multi-event joins are expensive. Each additional event variable multiplies cost.
- **Hardcoded values:** Magic numbers should have comments (e.g., `604800 // 7 days in seconds`).

---

## Section: `deployment`

| Field       | Required | Type    | Description                                       |
| ----------- | -------- | ------- | ------------------------------------------------- |
| `live`      | Yes      | bool    | Whether the rule is actively running               |
| `alerting`  | Yes      | bool    | Whether matches generate alerts                    |
| `frequency` | Yes      | enum    | `REAL_TIME`, `HOURLY`, `DAILY`                     |

### Frequency Guidelines

| Frequency   | Use When                                                              |
| ----------- | --------------------------------------------------------------------- |
| `REAL_TIME` | High-severity rules requiring immediate detection                     |
| `HOURLY`    | Standard detection rules with moderate urgency                        |
| `DAILY`     | Low-priority enrichment or compliance rules                           |

---

## Section: `actions`

Optional. List of response integrations triggered on alert.

```yaml
actions:
  - type: torq         # SOAR platform integration
  - type: slack         # Slack notification
    channel: "#alerts"
```

---

## Section: `guide`

The investigation playbook. Every alerting rule must have a guide.

| Field             | Required | Type   | Description                                              |
| ----------------- | -------- | ------ | -------------------------------------------------------- |
| `context`         | Yes      | string | What this rule detects and why it matters                 |
| `investigation`   | Yes      | string | Step-by-step investigation actions for the analyst        |
| `response`        | Yes      | string | Containment and remediation steps                         |
| `false_positives` | Yes      | string | Known FP scenarios and how to distinguish them            |

### Guide Quality Criteria

- **Context** should explain the threat model, not just restate the description.
- **Investigation** steps should be ordered by priority and include specific tools/queries.
- **Response** should have graduated actions (observe → contain → remediate).
- **False positives** should be specific and actionable ("approved marketing domains" not "legitimate activity").

---

## Naming Conventions

- Rule files: `snake_case.yaml` (e.g., `nrd_email_interaction.yaml`)
- Variable names in logic: `$descriptive_name` with event-type prefix
- MITRE references: Always include both technique and tactic IDs

## Example: Well-Formed Rule

```yaml
metadata:
  author: "Threat Detection Team"
  owner:
    - "@logs"
    - "@marciosouza"
  description: "Detects user interaction with email messages originating from newly registered domains"
  references:
    - "https://github.com/chronicle/detection-rules/blob/main/rules/..."
  severity: "info"
  mitre_attack:
    - technique: "T1566"
      tactics: ["TA0001"]
  maturity: "defined"
logic: >
  events:
    $mail.metadata.event_type = "EMAIL_TRANSACTION"
    ...
  match:
    $domain over 10m
  outcome:
    $risk_score = 25
    ...
  condition:
    $mail and $whois
deployment:
  live: true
  alerting: true
  frequency: "HOURLY"
actions:
  - type: torq
guide:
  context: |
    This rule detects user interaction with emails originating from recently
    registered domains...
  investigation: |
    - Analyze the email content, subject line, and headers...
    - Identify if the user clicked any embedded URLs...
  response: |
    - Purge the identified email...
    - Block the newly registered domain...
  false_positives: |
    - Legitimate communications from newly established business partners...
```
