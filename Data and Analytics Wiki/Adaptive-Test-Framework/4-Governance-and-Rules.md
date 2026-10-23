# 4. Governance and Rules

[[_TOC_]]

These rules say when testing can start, what "good enough" looks like, and how a release decision is defended. The section numbers match the ATF governance rulebook. The live rulebook is the governance instruction file in the Adaptive-Test-Framework repository.

For the testing discipline these rules sit over, see [/Adaptive-Test-Framework/3-The-Methodology](/Adaptive-Test-Framework/3-The-Methodology). To run the rules with the agents, see [/Adaptive-Test-Framework/5-Using-the-Framework-with-the-Agents](/Adaptive-Test-Framework/5-Using-the-Framework-with-the-Agents). To apply them by hand, see [/Adaptive-Test-Framework/6-Using-the-Framework-Manually](/Adaptive-Test-Framework/6-Using-the-Framework-Manually).

## Readiness: the entry gate (section 5)

Readiness is a gate, not a guideline. It blocks testing from starting at all. The readiness checklist and the TBC register are owned by the Project Manager and Business Analyst. They are project controls, not test artefacts: you use them as input, you do not maintain them.

### Readiness checklist (section 5.1)

These conditions must be confirmed before execution begins. Their absence blocks testing. Typical items:

- Environment configured and accessible
- Reference data loaded
- Test accounts and security roles provisioned
- Training delivered to test participants
- Support and escalation paths confirmed for the test period
- Devices, hardware and peripherals allocated, where applicable
- Vendor contacts and SLAs confirmed
- Defect management tooling agreed

This is a baseline. A project may add conditions where its context demands. Removing a condition requires documented rationale. Anything that cannot be confirmed becomes a risk or moves to the TBC register.

### TBC register (section 5.2)

A living register of open dependencies that, once resolved, unlock more coverage. Reviewed at every project status meeting. When an item resolves, you design and add the scenarios it was blocking. Each entry records:

| Field | What it holds |
|---|---|
| TBC ID | Unique identifier |
| Item | What is unresolved |
| Dependency | Whose decision, confirmation or deliverable resolves it |
| Status | Awaiting confirmation, In progress, or Resolved |
| Impact if unresolved | Which scenarios are blocked or not yet designable |

## Change classification: regression scope (section 7)

Match the change type to the regression approach. No guesswork. Regression is not optional; what changes is the scope, and the scope is set by the change type.

| Change type | Regression approach |
|---|---|
| Platform update | Smoke-test all critical processes. Full regression on the components named in the release notes. |
| Vendor solution update | Full regression on the solution using the business process mappings. Validate all integration points. |
| Configuration change | Targeted regression on the affected process area. Use the automation inventory to identify the blast radius. |
| Data migration or import | Validate the imported data against the same rules as manual entry. Verify calculations and workflows trigger correctly. |
| Infrastructure change | Smoke-test access, authentication and connectivity. Compare against a performance baseline. |
| Integration change | Full integration test on the affected boundary. Validate both directions where applicable. |

## Domain criticality (section 8)

Not all systems carry the same risk. Criticality drives how P1 (critical) tests are defined and how stringent the no-go gates must be. There are four types.

| Criticality | Characteristics | Testing emphasis |
|---|---|---|
| Financial | Financial accuracy, regulatory reporting, billing, contract value | Calculation accuracy, audit-trail completeness, reconciliation |
| Operational | Day-to-day service delivery, workflow continuity | Process integrity, user experience, performance |
| Life-safety | Worker, client or public safety; duty of care | Response time, escalation reliability, failover, redundancy |
| Compliance | Legal, contractual or regulatory obligations | Evidence capture, auditability, completeness |

A project may carry several criticality dimensions. The dominant one drives the P1 definition and governance stringency.

Whether the conditional eighth gate (G8) applies is scoped separately from dominance. G8 applies whenever any in-scope capability carries Life-safety criticality — worker, client or public safety, or duty of care — whether or not Life-safety is the dominant dimension. A Required field, `life_safety_in_scope` (yes or no), records this and is confirmed for every engagement: a `yes` puts G8 in scope regardless of the dominant criticality. It ships `no` for the Emerge CM360 default, which carries no Life-safety-critical capability. For the gate itself, see the no-go gates (section 11).

## Test modes (section 9)

A project selects the modes that fit its scope. Depth and formality scale with risk and mode: a configuration change in an operational system is not governed like a financial migration.

| Mode | Purpose |
|---|---|
| UAT | Business users confirm the solution supports their real work. |
| Pilot | Limited live or near-live run with a controlled user group before full rollout. |
| Parallel Run | New and old processes run side by side; outputs compared. |
| Regression | Confirm previously working behaviour still works after a change. |
| Integration | Validate data flows correctly across system boundaries. |

## Defect severity (section 10)

Severity is a testing judgement based on business impact. It is not the vendor's convenience. If a vendor disputes a severity, that is a triage conversation; the decision remains the organisation's.

| Severity | Meaning | Closure governance |
|---|---|---|
| P1 Critical | Blocks a core business outcome; data integrity, safety or financial correctness at risk. | Must be resolved or formally re-classified before the gate. No carry-forward. |
| P2 High | Significant impact with a workaround, or a serious issue on a non-critical path. | Carry-forward requires Sponsor plus user-representative endorsement at the gate. |
| P3 Medium | Limited impact; usability or minor functional issue. | Tracked and prioritised in the defect tool. |
| P4 Low | Cosmetic or trivial. | Tracked and prioritised in the defect tool. |

A downward P1 re-classification is not a gate-dodge. A P1 is resolved or formally re-classified before the gate, never carried forward. A downward re-classification is legitimate only where a genuine re-assessment of business impact changes the severity, and it is recorded in the defect record's Resolution with three things: (a) the business-impact evidence, tested against the severity definitions above; (b) an explicit statement that it is not motivated by the gate or the ship date; and (c) the named Test Management owner who approves it. Never downgrade a defect to keep a gate green or to hit a date.

### Framework labels versus tool labels

The framework uses P1 to P4. Defect tooling such as Azure DevOps, and some vendor exports, use the words Critical, High, Medium and Low. Same scale, different names. Translate to the framework label before applying the closure rules above, so nobody triages off the wrong label.

| Framework | Tool (Azure DevOps or vendor) |
|---|---|
| P1 | Critical |
| P2 | High |
| P3 | Medium |
| P4 | Low |

A "Critical" in the defect tool is a P1 here: no carry-forward, no exceptions. For how Emerge runs triage, see [/BI-Team/Documentation-%2D-Analysts/Bug-Prioritisation-Process](/BI-Team/Documentation-%2D-Analysts/Bug-Prioritisation-Process).

## The no-go gates (section 11)

These conditions must be met before any change goes to production. They are gates, not guidelines. Seven core gates (G1 to G7) always apply. A conditional eighth gate (G8) applies whenever any in-scope capability is Life-safety-critical (`life_safety_in_scope` = yes), whether or not Life-safety is the dominant dimension.

| Gate | Criteria |
|---|---|
| G1 | All P1 test cases pass. Zero P1 defects open. |
| G2 | Regression pack executed. No new defects in previously passing areas. |
| G3 | Data integrity validated: calculations correct, audit trails complete, integration payloads verified. |
| G4 | Integration points validated: data flows correctly between all connected systems. |
| G5 | Readiness checklist confirmed complete for the production environment. |
| G6 | TBC register has no unresolved items that block production operation. |
| G7 | Business sign-off obtained from the process owner for every affected process. |

Conditional eighth gate, in scope whenever any in-scope capability is Life-safety-critical (`life_safety_in_scope` = yes), dominant or not:

| Gate | Criteria |
|---|---|
| G8 | Safety response SLAs validated under realistic conditions, including failover paths. |

The absolute rule: any P1, the data-integrity gates (G1, G3), or — when any in-scope capability is Life-safety-critical (`life_safety_in_scope` = yes) — the in-scope Life-safety gate (G8), not met is a no-go, no exceptions. So when G8 is in scope, the seven core gates being green is not enough on its own. Other gates may support a Conditional Exit only under named ownership and agreed conditions, and never with an open P1 nor an in-scope unmet G8.

## Gate decisions (section 11.1)

A gate decision is one of three.

| Decision | When it applies |
|---|---|
| Go | All gates met. |
| Conditional Exit | Core gates met, but defined residual items remain under named ownership and agreed conditions. A P1 can never be a residual item, and neither can an in-scope but unmet G8 — it sits in the unconditional no-go tier with G1 and G3. P2 carry-forward requires Sponsor plus user-representative endorsement. |
| No-go | One or more gates unmet, with no acceptable conditional path. |

On vendor endorsement: a vendor may endorse that delivery is complete to specification. That reflects delivery accountability only. It is not a gate decision and does not substitute for the organisation's. Vendor non-endorsement is a flag to investigate, never a veto. The gate decision is the organisation's alone.

<details>
<summary><b>Flow chart</b></summary>

::: mermaid
flowchart TD
  A[All gates assessed] --> B{G1 and G3 met, and G8 met if in scope?}
  B -->|No| N[No-go]
  B -->|Yes| C{All other applicable gates met?}
  C -->|Yes| G[Go]
  C -->|No| D{Residual items under named ownership and agreed conditions?}
  D -->|Yes, no open P1 and no in-scope unmet G8| E[Conditional Exit]
  D -->|No| N
:::

</details>

## Ownership: RACI (section 12)

Ownership is context-driven, but the decision ownership is always the organisation's.

| Role | Typical owner | Owns |
|---|---|---|
| Govern | Test Management plus Sponsor | Gates, standards, severity rules and release decisions. The decision authority. Cannot be delegated to a vendor. |
| Manage | Project Manager plus Business Analyst | Readiness, the TBC register, scope and traceability. Owns whether testing can start. |
| Execute | Test Analysts and execution teams | Design cases, run tests, raise defects, within the gates and severity rules defined here. |
| Consult | Vendor | Technical detail and build internals. Consulted, never accountable. Does not sign off the organisation's decisions. |
| Inform | Senior leadership and business owners | Receive release-readiness and residual-risk framing. |

Test-data ownership sits specifically with the Project Manager and Business Analyst, with input from the data team on privacy, masking and refresh.

## Test data and sensitive-data handling (section 12.1)

Test data is synthetic or de-identified by default. Real production data must never be pasted into or persisted in any git-tracked artefact — not the data layer, the registers, the test cases, the defects, the reports, or the evidence. This covers personal information (names, contact details, dates of birth), health information (NHI numbers, clinical notes), financial and cardholder PCI data, and any other regulated or identifying data. Where a scenario genuinely needs production-like data, that data is masked or de-identified first, under a plan approved by the Project Manager and Business Analyst with the data team. "No real production or personal data in test artefacts" is an entry-gate pre-condition (section 5.1) and forms part of the evidence behind gates G5 and G6. This is engagement-agnostic framework IP. It is never relaxed per engagement.

Māori data is taonga. Iwi, hapū, whakapapa and other Māori data carry data-sovereignty obligations under Te Mana Raraunga principles. They require informed consent and de-identification before any use as test data, and are never persisted into shared artefacts as real values. This is a distinct duty over and above the general rule above.

An agent asked to ingest or record real sensitive or Māori data declines, explains the rule, and asks for a synthetic or de-identified equivalent. It does not echo the data back: it refers to values by category ("the pasted names", "the NHI numbers", "the iwi"), never by quoting them. When such data enters a session by any means — pasted, attached, mentioned, or read from a workspace or in-repo document — that is itself a disclosure event. The agent flags that it may be a notifiable privacy breach under the Privacy Act 2020, or a Te Mana Raraunga data-sovereignty concern, and advises following the organisation's breach or near-miss process. The agent surfaces the risk; it does not adjudicate the breach. The agents that apply this rule are described on [/Adaptive-Test-Framework/5-Using-the-Framework-with-the-Agents](/Adaptive-Test-Framework/5-Using-the-Framework-with-the-Agents).

*Grounded in the Adaptive Test Framework (ATF) v1.0 and the Enterprise Testing Framework v2.0. The live agents and prompts live in the Adaptive-Test-Framework repository.*
