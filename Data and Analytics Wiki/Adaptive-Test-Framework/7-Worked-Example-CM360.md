# 7. Worked Example CM360

[[_TOC_]]

One real engagement runs through the lifecycle below, step by step. The engagement is KIRIMANA CM360, Increment 1, for Ka Puta Ka Ora Emerge Aotearoa. Everything below is drawn from the worked-example record in the Adaptive-Test-Framework repository. It is a frozen "what good looks like" snapshot, not framework rules.

For the methodology behind the steps, see [/Adaptive-Test-Framework/3-The-Methodology](/Adaptive-Test-Framework/3-The-Methodology). For the gates and severities the example is judged against, see [/Adaptive-Test-Framework/4-Governance-and-Rules](/Adaptive-Test-Framework/4-Governance-and-Rules). For driving the AI through the same steps, see [/Adaptive-Test-Framework/5-Using-the-Framework-with-the-Agents](/Adaptive-Test-Framework/5-Using-the-Framework-with-the-Agents). For doing it by hand, see [/Adaptive-Test-Framework/6-Using-the-Framework-Manually](/Adaptive-Test-Framework/6-Using-the-Framework-Manually).

## 1. The engagement

| Field | Value |
|---|---|
| Organisation | Ka Puta Ka Ora Emerge Aotearoa |
| Project | KIRIMANA CM360 — Contract Management 360 |
| Increment | Increment 1 (UAT 1, then UAT 1.1 incorporating UAT 1.2) |
| Core platform | Microsoft Dynamics 365 (Dataverse / Power Platform), with Business Central, Power Automate, SharePoint Online and Azure DevOps |
| Vendor | Datacom Solutions Limited (delivery accountability only, not the gate decision) |
| Dominant criticality | Financial (with Operational and Compliance) |
| Business entities | 3 (Health & Disability, Housing Services, EAHT / Social Housing) |
| Contract types | 11 |

*Kirimana* is the te reo Māori system name for the CM360 contract solution. Dominant criticality Financial sets the P1 bar: the financial-integrity risk is a stale Total Contract Value (TCV) reaching the finance boundary. That single risk shapes most of what follows.

The two rounds fit together like this. UAT 1 was the broad foundational round across all 11 contract types. UAT 1.1 (incorporating UAT 1.2) was a focused round scoped to the 12 confirmed vendor change variations (C1 to C12) only, plus an end-to-end contract-variation process run per contract type. UAT 1.1 was not a full re-test of the system.

The Business Central finance integration was deferred to Increment 2 and held behind a no-go gate. No passing cases were designed against it.

## 2. /ba-briefing — unpack the process, tie it to acceptance criteria

`/ba-briefing` is the intake front end. It unpacks a business process, ties each step to acceptance criteria, frames trigger-tagged scenarios, then hands them to `/uat-case-generator`. It does not write the 10-column cases and does not set severity.

The worked walkthrough runs against one process, Contract Activation / Service Details (the Health & Disability variant), against example work item ADO 13642.

### The process steps it captured

The process map uses the six-column register schema: Step, Actor / persona, Trigger, Integration point, Risk, Notes. Three of the contract-lifecycle steps:

| Step | Actor / persona | Trigger | Integration point | Risk |
|---|---|---|---|---|
| `BPM-PROJ-0002` Service details — add / edit Service Detail line items on the subgrid | Contract Lead / Contract Manager (`PERS-PROJ-0002`); Data / Migration Lead via the import path (`PERS-PROJ-0006`) | Data Change | none — internal subgrid edit; values drive the recalculation at `BPM-PROJ-0003` and the deferred finance flow | Imported Service Details bypass the validation and recalculation the UI enforces (`RISK-PROJ-0002`) |
| `BPM-PROJ-0003` Volume & pricing — set volume, unit price, period and step-down / CPI; the Total Price to TCV recalculation fires | Contract Lead / Contract Manager (`PERS-PROJ-0002`) | Data Change | `INT-PROJ-0001` (to Business Central, deferred, Increment 2) | TCV recalculation not refired on a driver-field change, leaving a stale total (`RISK-PROJ-0001`; at the finance boundary `RISK-CM360-0001`, can escalate to P1) |
| `BPM-PROJ-0006` Approval / execution — advance the Business Process Flow (Draft to Negotiate to Final) and execute | Contract Lead / Contract Manager (`PERS-PROJ-0002`); least-privilege boundary checked by Read-Only Reviewer (`PERS-PROJ-0008`) | User Action | none directly; deferred finance flow would fire on execution once Increment 2 is provisioned | Execution proceeds on a stale TCV, propagating an unvalidated value to the finance boundary (`RISK-CM360-0001`, P1) |

`BPM-PROJ-0003` is the financial-integrity spine. The "critical to daily operations" answer is recorded as a prioritisation note, never as a severity.

### A couple of framed scenarios tied to acceptance criteria

The acceptance criteria pasted with ADO 13642 included AC-1 (on execution, TCV equals the sum of every Service Detail Total Price) and AC-2 (Total Price and TCV recalculate when any driver field changes, so no stale total is carried forward). Two of the framed scenarios:

**Scenario A — TCV correct on execution.**
- Business objective: an executed H&D contract carries a financially correct TCV.
- Trigger type: User Action (advance the BPF / execute).
- Expected outcome: on execution, TCV equals the sum of every Service Detail Total Price.
- AC line protected: AC-1.
- Negative / boundary: execute with no Service Detail lines; a line with zero volume.
- Business-criticality signal: Yes (a prioritisation signal, not a P1).

**Scenario B — recalculation fires on every driver-field change.**
- Business objective: no stale total survives a change to a price-driving field.
- Trigger type: Data Change.
- Expected outcome: when volume, unit price, period or step-down / CPI changes, Total Price and TCV refire and the prior total is replaced.
- AC line protected: AC-2.
- Negative / boundary: change step-down / CPI and confirm the old TCV is not retained; CPI uplift at a period boundary.
- Business-criticality signal: Yes (not a P1).

The severity firewall holds here. The business-criticality signal on every scenario was Yes. None of that sets a severity. A BA's "critical to daily operations" is business criticality; a tester's P1 is severity. They are never collapsed. The signal informs the later P1 judgement; it does not make it.

Where a downstream outcome had no settled acceptance criterion, the gap was named rather than silently covered. The deferred finance propagation to Business Central was flagged TBC-1 and carried as a dependency, held behind the finance no-go gate.

`/ba-briefing` then handed the framed scenarios to `/uat-case-generator`. It frames; it does not build the cases.

## 3. /uat-case-generator — write the 10-column cases

`/uat-case-generator` expands each framed scenario into the canonical 10-column UAT workbook. Here is one real case from the worked record. It comes from the Copy-Contract recalculation pack, which turned a single Critical defect (ADO 13709) into a targeted retest and regression suite.

| Column | Content |
|---|---|
| Test Case ID | TC-CC-001 |
| User Assigned | Contract Lead |
| Test Case Name | Recalculate copied service Total Price when contract period changes in Draft |
| Test Scenario | Copying a contract then changing its period in Draft recalculates each copied service detail's Total Price for the new period (lifecycle: Draft; trigger: Data Change). P1. |
| Pre-conditions | A source contract exists (Executed/Active) with at least one service detail and a known Total Price; tester holds the Contract Lead role in UAT; Copy Contract feature available |
| Test Steps | Given a contract is copied to a new variation and its service details are copied with the original period's Total Price, When the user changes the new contract's Start and Expiry Date while status is Draft and saves, Then each copied service detail's Total Price is recalculated for the new period. |
| Expected Results | Total Price for every copied service detail reflects the new period (Volume-per-period x Unit Price); no original-period value remains; values persist after save. |
| Integration Points | cm360_contract; Service Details subgrid; Total Price calculation rule; contract-period fields; Volume-per-contract-period logic |
| Pass/Fail | (blank for execution) |
| Comments | (blank for execution) |

- The Test Scenario names the business outcome, the lifecycle stage and the trigger type, and carries the P1 tag.
- The steps are Given/When/Then, written for an end user, not a screen script.
- The Expected Results assert the data outcome and that values persist after save. They do not stop at "save successful".
- The Integration Points column is populated, not left blank.

The pack also shows the framework principles in action. One case is the integrated-data twin: an imported contract must recalculate on a period change exactly as manual or copied data does (principle 5). One case asserts the source contract is unaffected by the copy's recalculation (data integrity). Three cases (`Yes` regression-flagged) protect previously passing TCV behaviour so the fix does not regress it.

## 4. Run the tests, then /defect-triage — raw Azure DevOps bug to P1 to P4

You and the test team run the cases and record pass or fail. Defects come out of Azure DevOps with the tool's own Severity field (Critical / High / Medium / Low). `/defect-triage` maps that to the framework's P1 to P4, but severity is a testing judgement on business impact, never the vendor's convenience.

The mapping, from the dominant-criticality Financial bar:

| Azure DevOps severity | Framework severity | Meaning |
|---|---|---|
| 1 - Critical | P1 | Blocks a core business outcome; data-integrity, safety or financial correctness at risk. No carry-forward across the gate. |
| 2 - High | P2 | Significant impact with a workaround, or a serious issue off the critical path. Carry-forward needs Sponsor plus user-representative endorsement. |
| 3 - Medium | P3 | Limited impact, usability or minor functional. Tracked and prioritised. |
| 4 - Low | P4 | Cosmetic or trivial. Tracked and prioritised. |

Two real bugs from the UAT 1.1 export show how this plays out:

- **ADO 13709** — "Copy Contract -Service Details Total Price is not recalculated when the Contract Period added or updated after a service detail is created". Azure DevOps severity 1 - Critical, so P1. It hits the financial-integrity spine: a stale Total Price flows up into TCV. As a P1 it could not be carried across the gate. It became the 15-case TC-CC retest and regression pack, was fixed, and was Closed.
- **ADO 13683** — "Transitional Hsg - Total Contract Value". Azure DevOps severity 2 - High, so P2. TCV integrity on one contract type, with a manual workaround (the value recalculates when status is progressed). It was carried forward as the single open P2.

The triage reads the raw export and confirms the field, but the framework severity is set on business impact. Vendor endorsement of a fix is delivery accountability, recorded as a flag; it is not the gate decision.

## 5. /uat-reporter — the exit report and gate recommendation

`/uat-reporter` then consolidates execution into a formal exit report and a gate recommendation. The Increment 1 report is structured like this:

| Section | What it holds |
|---|---|
| Document control | Owner, project, vendor, status, version history, the review and endorsement list |
| 1. Test summary and objectives | Purpose for the Steering Board, how the rounds fit together, objectives, scope (in and out) |
| 2. Environment and participants | Test environment, integrations tested, integrations out of scope, the tester list |
| 3. Execution metrics and coverage | Coverage at a glance, per-round pass/fail tables, the variation process matrix, go-live readiness indicators |
| 4. Defect summary and carried-forward items | Defect position, carry-forward table, closed defects by area, deferred-to-Increment-2 items |
| 5. Carried-forward items and residual risks | R1 to R5 with current handling and residual position |
| 6. Recommendations, deferred scope and gate decision | Increment 2 focus, deferred scope, the pre-condition gate, exit-criteria assessment, the gate decision |
| 7. Endorsement record | Sign-off rows for the gate |

The metrics it reports are facts, presented before any interpretation. The Increment 1 coverage headline:

| Test activity | Executed | Pass rate |
|---|---|---|
| UAT 1 — contract lifecycle scripts (all 11 types) | 371 / 371 (100%) | 82.2% where pass/fail recorded |
| UAT 1.1 — change-variation test cases (C1 to C12) | 170 / 170 (100%) | 86.5% |
| UAT 1.1/1.2 — contract variation process matrix | 99 process runs | 95% (5 of 99 failed; 4 from one bug now closed) |
| Service Details Volume & Pricing pack | 83 cases | 91.6% |

The report also breaks results down by trigger type (the 3 Triggers model), so coverage is visible against User Action, Data Change and System Event, not just against screens. The Service Details / Volume & Pricing pack that was planned but not executed in UAT 1 was fully executed in UAT 1.1, closing the largest UAT 1 coverage gap.

## 6. The gate decision

At the gate, the applicable no-go gates were assessed. The dominant criticality is Financial, and no in-scope capability is Life-safety-critical, so the Life-safety gate (G8) is out of scope and the seven core gates (G1 to G7) are the applicable set. The decisive facts:

- Zero open P1 defects. The Copy-Contract Critical (ADO 13709) was closed.
- One open P2 (ADO 13683, Transitional Housing TCV), with a workaround.
- The Business Central finance integration deferred behind a firm pre-condition no-go gate. No finance / BC work could start until contract and Service Detail data quality is validated and signed off.
- Five contained carry-forward items (R1 to R5), each with named ownership into Increment 2.

The recommendation was **Conditional Exit**.

| Field | Detail |
|---|---|
| Recommendation | Conditional Exit |
| Basis | The data-integrity gates G1 and G3 are met (zero open P1; calculations correct, audit trails complete); G2 (regression — the `TC-CC-015` import-validation case is Not run) and G7 (business sign-off still Pending) remain open and are carried as named conditions; coverage extensive and end-to-end across every contract type and lifecycle stage |
| Conditions | Sponsor plus user-representative endorsement of the open P2 (ADO 13683) carry-forward with its workaround; R1 to R5 tracked with named owners into Increment 2; finance / step-down / integration held behind the pre-condition no-go gate |
| Decision owner | Emerge Test Management plus the Workstream Sponsor (the decision remains Emerge's) |
| Vendor position | Datacom delivered and endorsed the change variations, recorded as delivery accountability only, not the gate decision |

A P1 can never be a residual item, so a Conditional Exit was only available because there were no open P1 defects. The deferred finance functionality stays behind the no-go gate until its pre-conditions are met. The decision authority is the organisation's alone.

---

*Grounded in the Adaptive Test Framework (ATF) v1.0 and the Enterprise Testing Framework v2.0. The live agents and prompts live in the Adaptive-Test-Framework repository.*
