# 6. Using the Framework Manually

[[_TOC_]]

Run the framework by hand: work straight in Azure DevOps Test Plans, or in a spreadsheet, and do the writing, organising and reporting yourself. The agents on [/Adaptive-Test-Framework/5-Using-the-Framework-with-the-Agents](/Adaptive-Test-Framework/5-Using-the-Framework-with-the-Agents) automate exactly these steps; you can run a step by hand, run the next with an agent, then come back.

Work the steps in order. The thinking behind them is on [/Adaptive-Test-Framework/3-The-Methodology](/Adaptive-Test-Framework/3-The-Methodology); the rules they apply are on [/Adaptive-Test-Framework/4-Governance-and-Rules](/Adaptive-Test-Framework/4-Governance-and-Rules).

If you are new to the test analyst role, read [/How-to-become-a-Test-Analyst-in-Emerge](/How-to-become-a-Test-Analyst-in-Emerge) and the [/Test-Analyst-Onboarding-Guide](/Test-Analyst-Onboarding-Guide) first.

These same eleven steps are what you follow when the AI assistants are unavailable. For a no-AI walk-through with phase diagrams, the 3-Triggers, gate and regression decision trees, and a manager view, see [Manual Fallback Runbook](/Adaptive-Test-Framework/6-Using-the-Framework-Manually/Manual-Fallback-Runbook).

## The manual workflow at a glance

The eleven steps group into five phases. Work them top to bottom.

<details>
<summary><b>Flow chart</b></summary>

::: mermaid
flowchart TD
  subgraph Prepare
    A["1 Understand the change"] --> B["2 Confirm readiness"]
  end
  subgraph Design
    C["3 Map the process"] --> D["4 Derive scenarios"]
    D --> E["5 Write cases"]
    E --> F["6 Traceability"]
  end
  subgraph Execute
    G["7 Run the tests"] --> H["8 Triage defects"]
  end
  subgraph Decide
    I["9 Gate decision"] --> J["10 Report"]
  end
  subgraph Improve
    K["11 Maintain regression"]
  end
  B --> C
  F --> G
  H --> I
  J --> K
:::

</details>

## 1. Understand the change

Before you scope anything, classify the change. The change type sets the regression scope. No guesswork.

| Change type | Regression scope |
|---|---|
| Platform update | Smoke-test all critical processes. Full regression on the components named in the release notes. |
| Vendor solution update | Full regression on the solution using the business process map. Validate all integration points. |
| Configuration change | Targeted regression on the affected process area. |
| Data migration or import | Validate imported data against the same rules as manual entry. Verify calculations and workflows trigger correctly. |
| Infrastructure change | Smoke-test access, authentication and connectivity. Compare against a performance baseline. |
| Integration change | Full integration test on the affected boundary. Validate both directions where applicable. |

Then note the dominant domain criticality: Financial, Operational, Life-safety or Compliance. A project can carry several. The dominant one drives how P1 is defined and how stringent the gates are. Separately, record whether any in-scope capability is Life-safety-critical: that puts the conditional G8 (Life-safety) gate in scope, whether or not Life-safety is the dominant dimension. See [/Adaptive-Test-Framework/4-Governance-and-Rules](/Adaptive-Test-Framework/4-Governance-and-Rules).

## 2. Confirm readiness

Readiness is an entry gate, not a guideline. Do not start testing until it is met. The checklist and the TBC register are owned by the Project Manager and Business Analyst; you use them as input, you do not maintain them.

Work the readiness checklist. Typical items:

- Environment configured and accessible
- Reference data loaded
- Test accounts and security roles provisioned
- Training delivered to test participants
- Support and escalation paths confirmed for the test period
- Devices, hardware and peripherals allocated, where applicable
- Vendor contacts and SLAs confirmed
- Defect management tooling agreed

Anything you cannot confirm becomes a risk or goes on the TBC register. Each TBC entry records:

| Field | What it holds |
|---|---|
| TBC ID | Unique identifier |
| Item | What is unresolved |
| Dependency | Whose decision, confirmation or deliverable resolves it |
| Status | Awaiting confirmation, In progress, or Resolved |
| Impact if unresolved | Which scenarios are blocked or not yet designable |

An open TBC item does not stop you designing the scenarios it does not block. When the item resolves, design and add the scenarios it was holding up.

## 3. Map the business process

Coverage follows the business process, not the screen. The Business Analyst maps the process once; you turn each step that has a trigger into a test scenario.

Capture the process in the six-column business process map:

| Column | What it holds |
|---|---|
| Step | The process step |
| Actor/persona | Who performs it, from the persona register |
| Trigger | Which of the 3 Triggers applies (a step can have more than one) |
| Integration point | Any system boundary the step crosses |
| Risk | What could go wrong, and a risk-pattern reference if one applies |
| Notes | Anything else worth recording |

Name the business outcome each step protects, not the screen label. Tests written to the outcome survive an upgrade; tests written to the screen break.

## 4. Derive scenarios across the 3 Triggers

For each step, work through the 3 Triggers and write a scenario for each one that applies. Coverage is not complete until every applicable trigger on every step has at least one scenario.

| Trigger | Ask |
|---|---|
| 1 User Action | A person submits, approves, uploads, presses or assigns. When they do, does the expected outcome occur? |
| 2 Data Change | Data crosses a boundary or updates: import, sync, API, recalculation, cascade. Do the right downstream effects fire? |
| 3 System Event | The system acts on its own: a scheduled job, callback, workflow, time trigger or notification. Does the correct automated outcome happen? |

Then add what the trigger sweep alone will miss:

- **An end-to-end chain.** For each process, include at least one scenario that walks User Action to Data Change to System Event, where the process has that chain.
- **A cumulative-validation skip test.** Include at least one test per lifecycle where a user can skip or jump a stage. Deliberately try to push a record to a late stage with an earlier mandatory field unset, and confirm the system blocks it.
- **Integrated-data twins.** Where the same record can arrive both by hand and by import, sync, API or ETL, write a twin of the manual case for the integrated arrival. The twin is anchored to the Data Change trigger and proves the imported record fires the same validations, calculations and workflows.

## 5. Write the cases

Write each case in the 10-column UAT structure. Do not add columns; extra metadata belongs in the traceability matrix (step 6).

| # | Column | What goes in it |
|---|---|---|
| 1 | Test Case ID | `TC-{AREA}-{NNN}`. Must be unique. |
| 2 | User Assigned | The persona running the test, from the persona register. Do not invent personas. |
| 3 | Test Case Name | Short, business-readable verb plus object. Not a screen label. |
| 4 | Test Scenario | One sentence naming the business outcome, the lifecycle stage and the trigger type. |
| 5 | Pre-conditions | Bulleted: permissions, record state, reference data and dependencies. |
| 6 | Test Steps | BDD Given / When / Then, written for an end user. |
| 7 | Expected Results | Then-clauses, plus integration and data validation, plus a negative-path note where applicable. |
| 8 | Integration Points | Systems, business rules, flows, jobs, APIs, workflows, external systems, or process area plus lifecycle stage. |
| 9 | Pass/Fail | Leave blank for execution. |
| 10 | Comments | Leave blank for execution. |

Write Test Steps (column 6) in BDD form, one scenario per case:

```
Given the preconditions in plain language
When the actions the user or integration performs
Then the observable outcomes: system behaviour, integration receipt, data result, audit confirmation
```

Expected Results (column 7) has a fixed order: the Then outcomes, then the integration or data validation, then a negative-path note where applicable. Never use "Save successful" as the only expected result.

For the Azure DevOps Test Plan mechanics, that is, how to create the test plan, suites, test cases and steps in the tool, follow [/How-to-create-Test-Plan,-Test-Case,-Test-Steps](/How-to-create-Test-Plan,-Test-Case,-Test-Steps).

## 6. Set up traceability

Keep a matrix that links requirement to case to run to defect, as a separate sheet.

A workable matrix has: Test Case ID, Requirement ID, Trigger Type, Lifecycle Stage, Variant Scope, Regression Flag, and Risk Pattern Addressed. Use the ID conventions so links resolve: requirements `REQ-PROJ-NNNN`, cases `TC-AREA-NNN`, runs `TR-PROJ-YYYYMMDD-NN`, defects `DEF-PROJ-NNNN`, where `PROJ` is the project code.

The matrix earns its keep at the gate: it shows every requirement has a case, every case has a result, and every defect traces back to a requirement.

## 7. Run the tests

You and the test team run the cases. The agents never click buttons in the system under test; running the tests is a human job.

For each case, record the outcome:

- **Pass** — the expected results all held.
- **Fail** — an expected result did not hold. Raise a defect (step 8) and link it to the case.
- **Blocked** — you could not run the case, for example a dependency was unresolved. Note why and link it to the TBC item.

Capture evidence as you go: screenshots, exported records, calculated totals, integration payloads, audit-trail entries. Evidence is what backs the data-integrity gate later.

## 8. Triage defects

For every failed case, raise a defect and set its severity. Severity is your judgement, based on business impact, not the vendor's convenience. If a vendor disputes a severity, that is a triage conversation; the decision stays with the organisation.

| Severity | Meaning | Closure rule |
|---|---|---|
| P1 Critical | Blocks a core business outcome; data integrity, safety or financial correctness at risk. | Must be resolved or formally re-classified before the gate. No carry-forward. |
| P2 High | Significant impact with a workaround, or a serious issue on a non-critical path. | Carry-forward requires Sponsor plus user-representative endorsement at the gate. |
| P3 Medium | Limited impact; usability or minor functional issue. | Tracked and prioritised. |
| P4 Low | Cosmetic or trivial. | Tracked and prioritised. |

If the defect tool uses Critical, High, Medium and Low, map those to P1 to P4 before you apply the closure rules. A "Critical" in the tool is a P1 here: no carry-forward, no exceptions.

For the Emerge bug-raising and prioritisation detail, follow [/BI-Team/Documentation-%2D-Analysts/Bug-Prioritisation-Process](/BI-Team/Documentation-%2D-Analysts/Bug-Prioritisation-Process).

## 9. Decide the gate

Check the gates before any change goes to production. They are gates, not guidelines. Seven core gates (G1 to G7) always apply. The conditional eighth (G8) applies whenever any in-scope capability is Life-safety-critical, whether or not Life-safety is the dominant dimension.

| Gate | Criteria |
|---|---|
| G1 | All P1 test cases pass. Zero P1 defects open. |
| G2 | Regression pack executed. No new defects in previously passing areas. |
| G3 | Data integrity validated: calculations correct, audit trails complete, integration payloads verified. |
| G4 | Integration points validated: data flows correctly between all connected systems. |
| G5 | Readiness checklist confirmed complete for the production environment. |
| G6 | TBC register has no unresolved items that block production operation. |
| G7 | Business sign-off obtained from the process owner for every affected process. |
| G8 (Life-safety in scope) | Safety response SLAs validated under realistic conditions, including failover paths. |

Then make the call:

| Decision | When it applies |
|---|---|
| Go | All gates met. |
| Conditional Exit | Core gates met, but defined residual items remain under named ownership and agreed conditions. A P1 can never be a residual item. P2 carry-forward requires Sponsor plus user-representative endorsement. |
| No-go | One or more gates unmet, with no acceptable conditional path. |

The absolute rule: any P1, the data-integrity gates (G1, G3), or — when any in-scope capability is Life-safety-critical — the in-scope Life-safety gate (G8) not met is a no-go, no exceptions. An in-scope unmet G8 can never be a Conditional Exit residual. A vendor may endorse that delivery is complete to specification, but that is delivery accountability only. It is not the gate decision. The gate decision is the organisation's alone.

For how sign-off is recorded at Emerge, see [/BI-Team/Documentation-%2D-Analysts/Testing-and-Sign%2DOff-process](/BI-Team/Documentation-%2D-Analysts/Testing-and-Sign%2DOff-process).

## 10. Report

Write up the result as a UAT report. The shape:

| Section | What it covers |
|---|---|
| Summary | What was tested and the headline outcome. |
| Environment | Which environment, build or version was tested. |
| Metrics | Cases run, passed, failed, blocked; defects by severity. |
| Defects | The defect list with severity and status, mapped to P1 to P4. |
| Risks | Open risks and residual items, including anything still on the TBC register. |
| Recommendations | What should happen next, and any conditions attached. |
| Gate decision | Go, Conditional Exit or No-go, with the evidence behind it. |

Lead with the decision. Keep the evidence behind it tight and traceable to the matrix.

## 11. Maintain regression and continuous improvement

After the increment or change, fold the work back in so the next round starts ahead.

Add the key cases from this round to the regression pack. The pack is the saved set of cases that must still pass next time. Regression cases must be re-runnable on a fresh environment.

Then update the registers, in this order:

```
Business process map -> Systems inventory -> Integration register -> Risk patterns -> Regression pack
```

A defect that matches a known risk pattern should cross-reference the pattern. A defect that reveals a new pattern is a candidate to add to the risk patterns register, so the next project benefits.

## Mixing manual and agent work

Run any step by hand and any other step with an agent, in either direction. Map the process by hand, then ask `/uat-case-generator` for the cases. Or write the cases by hand and ask `/uat-reporter` for the report. The artefacts share the same shape, so a hand-built one feeds an agent step and an agent-built one feeds a hand step. See [/Adaptive-Test-Framework/5-Using-the-Framework-with-the-Agents](/Adaptive-Test-Framework/5-Using-the-Framework-with-the-Agents).

*Grounded in the Adaptive Test Framework (ATF) v1.0 and the Enterprise Testing Framework v2.0. The live agents and prompts live in the Adaptive-Test-Framework repository.*
