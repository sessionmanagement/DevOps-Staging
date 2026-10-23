# 3. The Methodology

[[_TOC_]]

The methodology covers the six framework principles, the 3 Triggers coverage model, business-process-led coverage, BDD scenario writing, the 10-column UAT workbook, cumulative validation, integrated-data twins, and regression.

## The six framework principles

These six govern how every test is designed and run. The numbering is canonical; cite a principle by its number.

1. **Business process led, not UI led.** Coverage follows the business process, not the screen layout. Start from the BA-mapped process and name the business outcome each test protects. Example: you test that a record is activated and its downstream total is recalculated, not that a status picklist shows a particular value.
2. **End-to-end validation, not component checking.** Validate the whole outcome, not just UI-level correctness. Test the trigger chain through to the business endpoint: record state, integration receipt, notification arrival, audit trail, or recalculated value.
3. **Data integrity is non-negotiable.** Explicitly validate calculations, audit fields, integration payloads, aggregated totals, and migrated or imported records. Example: confirm the total equals the sum of the child values, and that the audit fields captured who changed what and when.
4. **Cumulative validation.** A record must satisfy every mandatory check up to its current lifecycle stage. A record must not reach a late stage with earlier-stage checks unmet. Test it by deliberately trying to skip a stage (see [Cumulative validation](#cumulative-validation)).
5. **Imported and integrated data must behave like manual data.** Data arriving by import, sync, API or ETL must fire the same validations, calculations and workflows as a manually entered record. Where a manual record has a test, create an integrated-data twin (see [Integrated-data twins](#integrated-data-twins)).
6. **Regression is not optional.** Every change requires regression. Scope is set by the change type (see [Regression](#regression)).

## The 3 Triggers

Every action in any system is one of three triggers. The model is system-agnostic; it works for any vendor platform. At each process step ask three questions: who starts it, what should happen, and what data moves.

| Trigger | What it is | Test focus |
|---|---|---|
| 1 User Action | A person does something: submits a form, approves a record, uploads a document, presses a button, assigns a resource. | When the user performs the action, does the expected outcome occur? |
| 2 Data Change | Data crosses a system boundary or updates in a way that affects downstream behaviour: recalculations, cascades, notifications, imports, sync between integrated systems. | When data changes, do the right recalculations, validations and downstream effects fire? |
| 3 System Event | The system acts on its own: scheduled jobs, API callbacks, background automation, workflows, time triggers, notifications. | When the event fires, or should fire, does the correct automated outcome happen? |

A short example of each:

- **User Action.** A contract owner submits a contract for approval. The expected outcome is the record moving to the next stage and the approver being notified.
- **Data Change.** A child line is added to a contract and the contract total recalculates. The downstream total must reflect the new line.
- **System Event.** A reminder fires before an expiry date with no person touching the record.

### The coverage rule

Every applicable trigger on every process step needs at least one scenario. Coverage is not complete until each applicable trigger has a scenario.

For each business process, include at least one end-to-end chain scenario that walks User Action to Data Change to System Event, where the process has that chain.

Anchor every scenario to one trigger. When a defect, gap or risk maps to a trigger, name it.

## Business-process-led coverage

Start from the process, not the screen. The Business Analyst maps the business process once, and Test Management turns each process step that has a trigger into a test scenario. The 3 Triggers model produces the coverage.

Name the business outcome each test protects. A test protects "the contract is activated and the total is recalculated", not "the Save button works". A picklist value may change with the next release; the business process of activating a contract does not.

Do not write one test per field on a form, and do not accept UI-only expected results.

## BDD: Given / When / Then

Write Test Steps in BDD form. One scenario per script, present tense, written for a non-technical UAT user unless the audience is technical.

- **Given** the preconditions in plain language.
- **When** the actions the user or integration performs.
- **Then** the observable outcomes: system behaviour, integration receipt, data result, and audit confirmation.

Numbered procedural steps may sit under When for technical or integration tests, but the BDD frame stays.

Each captured process step produces three scenarios: a happy-path test that the step gives the correct business outcome, a negative test drawn from what could go wrong, and a boundary test for edge cases such as zero values, maximum volumes and empty fields. Each scenario is anchored to one trigger, and integration-boundary steps also get an integrated-data twin. The `/ba-briefing` intake front end frames these trigger-tagged happy, negative and boundary scenarios from the business process map before cases are written; see [/Adaptive-Test-Framework/5-Using-the-Framework-with-the-Agents](/Adaptive-Test-Framework/5-Using-the-Framework-with-the-Agents).

A short worked example for a Data Change scenario:

```
Given an active contract with one line item of 1,000
When a second line item of 500 is added
Then the contract total recalculates to 1,500
And the new total is sent to the finance system for billing
And the audit trail records the change, the user and the timestamp
```

## The 10-column UAT workbook

Use the framework UAT workbook structure. Do not add columns to the test case sheet. If you need extra metadata, put it in a separate traceability matrix.

| # | Column | Requirement |
|---|---|---|
| 1 | Test Case ID | `TC-{AREA}-{NNN}`. Must be unique. |
| 2 | User Assigned | The persona running the test, from the persona register. Do not invent personas. |
| 3 | Test Case Name | Short, business-readable verb plus object. Not a screen label. |
| 4 | Test Scenario | One sentence naming the business outcome, the lifecycle stage and the trigger type. |
| 5 | Pre-conditions | Bulleted: permissions, record state, reference data and dependencies. |
| 6 | Test Steps | BDD Given / When / Then, written for an end user. |
| 7 | Expected Results | Then-clauses, plus integration and data validation, plus a negative-path note where applicable. |
| 8 | Integration Points | Systems, business rules, flows, jobs, APIs, subgrids, workflows, external systems, or process area plus lifecycle stage. |
| 9 | Pass/Fail | Leave blank for execution. |
| 10 | Comments | Leave blank for execution. |

Expected Results (column 7) has a fixed order:

1. The Then outcomes from the scenario.
2. Integration or data validation: what crossed a boundary, recalculated, changed state, or was captured in the audit trail.
3. A negative-path note where applicable: what must not happen, such as a save not allowed, a notification not sent, a partial record not created, or a total not updated.

Never use "Save successful" as the only expected result.

For the step-by-step of building cases this way, see [/Adaptive-Test-Framework/6-Using-the-Framework-Manually](/Adaptive-Test-Framework/6-Using-the-Framework-Manually). For a populated example, see [/Adaptive-Test-Framework/7-Worked-Example-CM360](/Adaptive-Test-Framework/7-Worked-Example-CM360).

## Cumulative validation

A record must satisfy every mandatory check up to its current lifecycle stage. Records must not reach a late stage with earlier-stage checks unmet.

Test it directly: include at least one test per lifecycle where users can skip or jump a stage, to confirm the earlier required checks still hold. Deliberately try to push a record to a late stage with an earlier mandatory field unset, and confirm the system blocks it.

Without this test, a record can slip past a required check and land at, say, an executed stage with mandatory earlier data missing.

## Integrated-data twins

Where the same record can arrive both by manual entry and by import, sync, API or ETL, the imported version must behave like the manual one (principle 5).

Create an integrated-data twin: where a manually entered record has a test, write a matching scenario for when that record arrives by integration. The twin is anchored to the Data Change trigger and validates that the same calculations, validations and workflows fire on the imported record.

Create a twin when, and only when, the record can also arrive by a non-manual route. A purely manual step does not need one.

## Regression

Regression is not optional. Every change requires it. What changes is the scope, and the scope is set by the change type, not by guesswork.

Each script must declare whether it belongs in the regression baseline, and regression scripts must be re-runnable on a fresh environment.

The change-type-to-scope mapping (platform update, vendor solution update, configuration change, data migration or import, infrastructure change, integration change) is part of governance. See [/Adaptive-Test-Framework/4-Governance-and-Rules](/Adaptive-Test-Framework/4-Governance-and-Rules).

*Grounded in the Adaptive Test Framework (ATF) v1.0 and the Enterprise Testing Framework v2.0. The live agents and prompts live in the Adaptive-Test-Framework repository.*
