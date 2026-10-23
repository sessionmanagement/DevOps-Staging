# Manual Fallback Runbook

[[_TOC_]]

## When to use this

The AI assistants can be unavailable. An outage, a licensing or access problem, a restricted or air-gapped environment, or a policy block all stop you using the Copilot agents and the slash-command prompts. Testing still has to move.

This runbook keeps the framework running by hand. The same steps, the same artefacts, the same gates, done by a person.

Who runs it: a test analyst, or a manager standing in for one.

It complements the parent page. The full eleven-step playbook, with every table written out, is on [/Adaptive-Test-Framework/6-Using-the-Framework-Manually](/Adaptive-Test-Framework/6-Using-the-Framework-Manually). This runbook is the diagram-led short form: who does what, the decisions to make, and what you must not skip. For the detail of any step, follow the link to the parent.

## What changes without the AI

The agents write, organise and report. None of them runs the tests. Take over the writing and organising by hand and the framework is unchanged.

| Normally the agent does this | With no AI, you do this by hand | Detail |
|---|---|---|
| **Test Initialization** sets up the project data layer | Read the data-layer registers yourself: persona, integration, risk patterns, regression pack, systems inventory, business process map, readiness and TBC | Under the RACI, the PM and BA own readiness, the TBC register, scope and traceability. You read the registers as input. See parent steps 2 and 3, and [/Adaptive-Test-Framework/8-Templates-and-Reference](/Adaptive-Test-Framework/8-Templates-and-Reference) for the blank schemas. |
| **Test Analyst** sets strategy and scope | Classify the change with the change-type table, then scope coverage with the 3 Triggers | Parent step 1 (change type sets regression scope) and parent step 4 (derive scenarios). See [/Adaptive-Test-Framework/3-The-Methodology](/Adaptive-Test-Framework/3-The-Methodology). |
| `/test-plan-generator` writes the Test Plan | Fill the Test Plan template by hand | Parent steps 1 to 3 feed it. Template on [/Adaptive-Test-Framework/8-Templates-and-Reference](/Adaptive-Test-Framework/8-Templates-and-Reference). |
| `/ba-briefing`, the intake front end, unpacks the process | Run the brief-a-tester capture with the BA: tie each step to its acceptance criteria, frame happy, negative and boundary scenarios per step | Parent step 3. The intake front end, not a sixth lifecycle prompt. Capture the operational workflow, not the screen. One captured step yields a happy-path, a negative and a boundary test. |
| `/uat-case-generator` writes the cases | Write the 10-column UAT cases by hand | Parent step 5 holds the full 10-column table and the BDD format. Template on [/Adaptive-Test-Framework/8-Templates-and-Reference](/Adaptive-Test-Framework/8-Templates-and-Reference). |
| (no agent) running the tests | No change. You and the team run the cases | Parent step 7. The agents never click buttons in the system under test; neither does this runbook. A human job. |
| `/defect-triage` rules severity | Map each defect to P1 to P4 by hand | Parent step 8 holds the severity table. See [/BI-Team/Documentation-%2D-Analysts/Bug-Prioritisation-Process](/BI-Team/Documentation-%2D-Analysts/Bug-Prioritisation-Process). |
| `/traceability-builder` keeps the matrix | Keep the requirement-to-case-to-run-to-defect matrix by hand | Parent step 6. Maintain it as a separate sheet using the ID conventions. |
| `/uat-reporter` writes the report | Write the UAT report by hand | Parent step 10 holds the report shape. Lead with the decision. |

## The fallback flow, end to end

Same eleven steps as the parent, annotated by who does each one. The Test Analyst does the design and execution, and keeps the traceability matrix. The Project Manager and Business Analyst own readiness, the TBC register, the process map, scope and traceability. The Manager or Sponsor makes the gate decision, governs severity and signs off. For per-step detail, follow [/Adaptive-Test-Framework/6-Using-the-Framework-Manually](/Adaptive-Test-Framework/6-Using-the-Framework-Manually).

<details>
<summary><b>Flow chart</b></summary>

::: mermaid
flowchart TD
  A["Test Analyst: classify the change, set regression scope"] --> B["PM and BA: confirm readiness gate and TBC register"]
  B --> C["BA: map the business process"]
  C --> D["Test Analyst: derive scenarios (3 Triggers), write the 10-column cases"]
  D --> E["Test Analyst: keep the traceability matrix (owned by PM and BA)"]
  E --> F["Test Analyst and team: run the tests (humans)"]
  F --> G["Test Analyst: triage defects P1 to P4"]
  G --> H{"Manager or Sponsor: gate decision"}
  H -->|"Go or Conditional Exit"| I["Manager or Sponsor: sign-off per process owner"]
  H -->|"No-go"| NG["No-go: gates unmet, no acceptable conditional path"]
  I --> J["Test Analyst: write the UAT report"]
  J --> K["Maintain regression, update the registers"]
:::

</details>

## Decision aids

### 3 Triggers coverage for one process step

Work each process step through the three triggers. Coverage is not complete until every applicable trigger on every step has at least one scenario. Add an end-to-end chain where the process has one.

<details>
<summary><b>Flow chart</b></summary>

::: mermaid
flowchart TD
  S["One process step"] --> UA{"User Action applies?"}
  UA -->|"Yes: add a scenario"| DC{"Data Change applies?"}
  UA -->|"No"| DC
  DC -->|"Yes: add a scenario"| TWIN{"Record can also arrive by import, sync, API or ETL?"}
  DC -->|"No"| SE
  TWIN -->|"Yes: add an integrated-data twin"| SE{"System Event applies?"}
  TWIN -->|"No"| SE
  SE -->|"Yes: add a scenario"| CH{"User Action to Data Change to System Event chain exists?"}
  SE -->|"No"| CH
  CH -->|"Yes"| CHS["Add one end-to-end scenario"]
:::

</details>

### Gate decision

Seven core gates (G1 to G7) always apply. The conditional eighth (G8) applies whenever any in-scope capability is Life-safety-critical, dominant or not. Any P1, an unmet data-integrity gate (G1, G3), or an in-scope unmet G8 is a no-go, no exceptions.

<details>
<summary><b>Flow chart</b></summary>

::: mermaid
flowchart TD
  A{"G1 or G3 unmet, or an in-scope G8 unmet? (P1 open, data integrity not validated, or safety SLAs not validated)"} -->|"Yes"| NG["No-go"]
  A -->|"No"| B{"All core gates G1 to G7 met, plus G8 if any in-scope capability is Life-safety-critical?"}
  B -->|"Yes"| GO["Go"]
  B -->|"No"| C{"Only non-P1 residual items, under named ownership and agreed conditions, P2 carry-forward endorsed?"}
  C -->|"Yes"| CE["Conditional Exit"]
  C -->|"No"| NG2["No-go"]
:::

</details>

### Change type to regression scope

The change type sets the regression scope. No guesswork. The full wording is in parent step 1 and on [/Adaptive-Test-Framework/4-Governance-and-Rules](/Adaptive-Test-Framework/4-Governance-and-Rules).

<details>
<summary><b>Flow chart</b></summary>

::: mermaid
flowchart TD
  CT["Classify the change"] --> P["Platform update: smoke critical, regress release-note components"]
  CT --> V["Vendor solution update: full regression, all integration points"]
  CT --> CF["Configuration change: targeted regression on the affected area"]
  CT --> DM["Data migration or import: validate against manual-entry rules"]
  CT --> IN["Infrastructure change: smoke access, auth, connectivity, performance"]
  CT --> IG["Integration change: full integration test on the boundary, both directions"]
:::

</details>

## The manager's part

Some calls are not the analyst's to make. Under the ownership model, the Manager or Sponsor governs the gate and the release.

- **The gate decision and go/no-go.** Go, Conditional Exit or No-go, on the evidence. The decision is the organisation's alone.
- **Severity governance.** A P2 carry-forward into a Conditional Exit needs Sponsor plus user-representative endorsement at the gate. A P1 can never be carried; it is resolved or formally re-classified before the gate, no exceptions.
- **Business sign-off.** Obtained from the process owner for every affected process. See [/BI-Team/Documentation-%2D-Analysts/Testing-and-Sign%2DOff-process](/BI-Team/Documentation-%2D-Analysts/Testing-and-Sign%2DOff-process).

Questions a manager should ask the team:

1. Are all P1 test cases passing with zero P1 defects open, and is data integrity validated? If not, it is a no-go.
2. Has the regression pack been executed, and are the integration points validated?
3. Is the readiness checklist complete for production, and does the TBC register hold anything that blocks production?
4. Do we have sign-off from every affected process owner?

A vendor may endorse that delivery is complete to specification. That is delivery accountability only. It is never the gate decision, and vendor non-endorsement is a flag to investigate, not a veto. The gate decision is the organisation's.

## Run checklist

Work top to bottom. Each line names the step and the gate or decision it feeds. The detail of each step is on [/Adaptive-Test-Framework/6-Using-the-Framework-Manually](/Adaptive-Test-Framework/6-Using-the-Framework-Manually).

- [ ] 1. Understand the change: classify it, note the dominant criticality. Sets regression scope and gate stringency.
- [ ] 2. Confirm readiness: work the checklist, log open items on the TBC register. Entry gate; feeds G5 and G6.
- [ ] 3. Map the business process: six-column map, outcome not screen. Feeds scenario coverage.
- [ ] 4. Derive scenarios across the 3 Triggers: every applicable trigger covered, plus the end-to-end chain, the skip-a-stage test and integrated-data twins.
- [ ] 5. Write the cases: 10-column UAT structure, BDD steps. Do not add columns.
- [ ] 6. Set up traceability: requirement to case to run to defect, separate sheet. Evidence at the gate.
- [ ] 7. Run the tests: record Pass, Fail or Blocked, capture evidence. Human job.
- [ ] 8. Triage defects: map to P1 to P4 on business impact. Feeds G1.
- [ ] 9. Decide the gate: check G1 to G7 (plus G8 if any in-scope capability is Life-safety-critical), then Go, Conditional Exit or No-go.
- [ ] 10. Report: UAT report, lead with the decision, evidence traced to the matrix.
- [ ] 11. Maintain regression and continuous improvement: add key cases to the regression pack, update the registers in order. Feeds G2 next time.

## What you must not skip, even without AI

The AI is not what makes these non-negotiable. They hold whether an agent or a person does the work.

- **The readiness entry gate before you start.** It is a gate, not a guideline. It blocks testing from starting.
- **Data integrity.** Calculations correct, audit trails complete, integration payloads verified. This is gate G3.
- **Cumulative validation.** Include the skip-a-stage test: deliberately try to push a record to a late stage with an earlier mandatory check unmet, and confirm the system blocks it.
- **Integrated-data twins for imported data.** Where a record can also arrive by import, sync, API or ETL, write a twin of the manual case. Imported data must behave like manual data.
- **Regression scoped by change type.** Regression is not optional; the change type sets the scope.
- **P1 means no carry-forward.** A P1 is resolved or formally re-classified before the gate.
- **Any P1, an unmet data-integrity gate (G1, G3), or an in-scope unmet Life-safety gate (G8) is a no-go.** No exceptions, no conditional path.

*Grounded in the Adaptive Test Framework (ATF) v1.0 and the Enterprise Testing Framework v2.0. The live agents and prompts live in the Adaptive-Test-Framework repository.*
