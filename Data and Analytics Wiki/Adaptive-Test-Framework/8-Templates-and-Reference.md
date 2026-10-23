# 8. Templates and Reference

[[_TOC_]]

The rules these artefacts apply are on [/Adaptive-Test-Framework/4-Governance-and-Rules](/Adaptive-Test-Framework/4-Governance-and-Rules). The thinking behind them is on [/Adaptive-Test-Framework/3-The-Methodology](/Adaptive-Test-Framework/3-The-Methodology). To work the framework step by step, see [/Adaptive-Test-Framework/2-How-the-Framework-Works](/Adaptive-Test-Framework/2-How-the-Framework-Works).

The live templates and registers ship in the Adaptive-Test-Framework repository. Blank schemas are under `templates/`; the frozen Emerge reference copies are under `examples/emerge-aotearoa/`.

## Artefact templates

Six core artefacts carry the work from requirement through to traceability. Each has a fixed ID format.

| Artefact | What it is | ID format |
|---|---|---|
| Requirement | A documented statement of expected behaviour, constraint or capability. The source of truth everything else traces back to. | `REQ-PROJ-NNNN` |
| Test plan | Defines scope, strategy, entry criteria and exit criteria. Groups cases by release, milestone, increment or feature. | `TP-PROJ-NNNN` |
| Test case | A repeatable procedure that verifies one or more requirements. Must link to at least one requirement, or it fails review as an orphan. | `TC-AREA-NNN` |
| Test run | A record of execution for a specific plan, environment and date. The pass / fail / blocked evidence for the cases it names. | `TR-PROJ-YYYYMMDD-NN` |
| Defect | A documented gap between actual and expected behaviour. Links to the requirement, case or run that exposed it. Severity is on the P1 to P4 scale. | `DEF-PROJ-NNNN` |
| Traceability row | One line in the matrix: requirement, status, acceptance criteria, cases, latest run and defects. Reads forwards (requirement to evidence) and backwards (defect to requirement). | (rows reference the IDs above) |

`PROJ` is the project code; it stays the literal `PROJ` placeholder until an engagement confirms its code. `AREA` is the process area in the test-case ID.

### The 10-column UAT workbook

The test case is written in a fixed 10-column structure. Do not add columns. If you need extra metadata, put it in the traceability matrix, not in the case.

| # | Column | What goes in it |
|---|---|---|
| 1 | Test Case ID | `TC-{AREA}-{NNN}`. Must be unique. |
| 2 | User Assigned | A persona from the persona register. Do not invent personas. |
| 3 | Test Case Name | Verb plus object, business-readable. Not a screen label. |
| 4 | Test Scenario | One sentence naming the business outcome, the lifecycle stage and the trigger type. |
| 5 | Pre-conditions | Bulleted: permissions, record state, reference data, dependencies. |
| 6 | Test Steps | BDD Given / When / Then, written for an end user. |
| 7 | Expected Results | Then-clauses, plus integration and data validation, plus a negative-path note. Never use "Save successful" as the only result. |
| 8 | Integration Points | The system boundaries the case touches. |
| 9 | Pass/Fail | Leave blank for execution. |
| 10 | Comments | Leave blank for execution. |

## Project data-layer registers

These registers hold the organisation and project specifics. They live under `project/` and are written by the Test Initialization agent. The agent is idempotent: re-run it any time and it reconciles rather than overwrites, topping up what has changed and reporting the gaps that remain. Each register is read by the agents that need it.

| Register | What it holds |
|---|---|
| Persona register | Authorised personas: id, role, system scope, permissions. The single source for the "User Assigned" column. ID family `PERS-`. |
| Integration register | Data flows: source, target, payload, direction, mechanism, trigger. The single source for what flows where. ID family `INT-`. |
| Risk patterns | Known failure modes: failure mode, trigger, typical severity, detection. A living cross-project register a defect can cross-reference. ID family `RISK-`. |
| Regression pack | The baseline cases that must still hold across releases. The evidence behind gate G2. Rows reuse the `TC-` test-case family. File ID family `REG-`. |
| Systems inventory | The systems, applications and automation catalogue used for blast-radius scoping. ID family `SYS-`. |
| Business process map | The process steps, triggers, integration points and risks the BA maps once. Each step plus trigger becomes a candidate scenario. ID family `BPM-`. |
| Readiness and TBC | The entry-gate pre-conditions and the open-dependency register. The evidence behind gates G5 and G6. ID family `RDY-`. |

### Business process map schema

The business process map has six columns.

| Column | What it holds |
|---|---|
| Step | The process step. |
| Actor/persona | Who performs it, from the persona register. |
| Trigger | Which of the 3 Triggers applies. A step can have more than one. |
| Integration point | Any system boundary the step crosses. |
| Risk | What could go wrong, and a risk-pattern reference where one applies. |
| Notes | Anything else worth recording. |

## ID conventions

| Artefact | Format | Notes |
|---|---|---|
| Requirement | `REQ-PROJ-NNNN` | Four-digit number. |
| Test plan | `TP-PROJ-NNNN` | Four-digit number. |
| Test case | `TC-AREA-NNN` | `AREA` is the process area; three-digit number; must be unique. |
| Test run | `TR-PROJ-YYYYMMDD-NN` | Date plus a two-digit run number. |
| Defect | `DEF-PROJ-NNNN` | Four-digit number. |
| Persona | `PERS-PROJ-NNNN` | Register row. |
| Integration | `INT-PROJ-NNNN` | Register row. |
| Risk pattern | `RISK-PROJ-NNNN` | Register row. |
| Regression pack | `REG-PROJ-NNNN` | File id; rows reuse `TC-`. |
| Systems inventory | `SYS-PROJ-NNNN` | File and row id. |
| Business process map | `BPM-PROJ-NNNN` | File and row id. |
| Readiness and TBC | `RDY-PROJ-NNNN` | File and row id. |

`PROJ` is replaced by the project code when it is set (for example `CM360`).

## The data contract

The data contract is the framework's completeness manifest: one file that lists every data item the project data layer can hold. Each row records the item, the data-layer file that holds it, which agents consume it, whether it is required or optional, and the one line of coverage that item unlocks.

It is the shared interface between the two agents. The Test Initialization agent walks it section by section to drive its interview and to report remaining gaps. The Test Analyst and the task prompts read it to check whether the data a task needs is present; on a gap they name the missing item and advise running the initializer. The data-item list lives in the contract and nowhere else. Rules resolve from governance by section number, identity from the project profile.

## trace-check

`trace-check` is the framework's artefact validator: a zero-dependency Node.js tool that checks the Markdown artefacts. It runs seven check families:

- **FM** — frontmatter present, required keys filled, id grammar, recognised type and status.
- **ID** — unique ids, and that referenced ids exist.
- **LINK** — relative links and anchors resolve.
- **GOV** — every `§N` governance citation resolves to a real numbered heading, parsed live from the rulebook.
- **TRACE** — active cases link to a requirement; defects and runs link back.
- **COV** — approved requirements have a linked, active case.
- **INIT** — cold-start reinforcement: it mirrors in the tooling the cold-start gate the agents apply before any test work. It warns when the workspace is uninitialised (`engagement_initialised` is false or unset in the profile), when the sentinel reads true but the profile stamp fields (`initialised_org`, `initialised_project`, `initialised_date`) are unset or still placeholders (a tampered or half-written sentinel, since the boolean is necessary but not sufficient), and when the sentinel reads true but the profile or any project register still carries a shipped Emerge or KIRIMANA CM360 marker (an incomplete re-skin). It is WARN-only and never fails a strict run. It mirrors the cold-start gate the agents apply (see [/Adaptive-Test-Framework/2-How-the-Framework-Works](/Adaptive-Test-Framework/2-How-the-Framework-Works)).

ERROR findings fail a strict run; WARN findings are advisory. Run it from the repository root:

```bash
# Strict run: exit 1 if any ERROR finding is present. This is what CI uses.
node tools/trace-check/trace-check.js --strict --report

# Self-test the engine itself.
node tools/trace-check/selftest.js
```

The default run without `--strict` is advisory and always exits 0. The project registers validate as live artefacts too, not skipped: they carry real four-digit ids, required frontmatter and valid section citations.

## Glossary

| Term | Meaning |
|---|---|
| 3 Triggers | The coverage model. User Action (a person submits, approves, uploads, presses or assigns), Data Change (data crosses a boundary or updates), System Event (the system acts on its own). Every applicable trigger on every process step needs at least one scenario. |
| Gates (G1 to G8) | The no-go conditions checked before production. G1 to G7 always apply; the conditional G8 applies whenever any in-scope capability is Life-safety-critical, dominant or not. Any unmet P1, data-integrity gate (G1, G3), or in-scope Life-safety gate (G8) is a no-go. |
| P1 to P4 | The defect severity scale. P1 Critical, P2 High, P3 Medium, P4 Low. A P1 cannot be carried forward. |
| Domain criticality | The risk profile that drives the P1 definition and gate stringency: Financial, Operational, Life-safety or Compliance. |
| Test modes | UAT, Pilot, Parallel Run, Regression, Integration. A project selects the modes that fit its scope. |
| Cumulative validation | A record must satisfy every required check up to its lifecycle stage. Include a test that skips or jumps a stage to prove the earlier checks still hold. |
| Integrated-data twin | Where a manual record has a test, the twin case proves the same record behaves identically when it arrives by import, sync, API or ETL. Anchored to the Data Change trigger. |
| Regression pack | The saved set of baseline cases that must still pass next time. The evidence behind gate G2. |
| TBC register | The living register of open dependencies that, once resolved, unlock more coverage. Each entry: TBC ID, Item, Dependency, Status, Impact if unresolved. |

For the Emerge acronym list, see [/BI-Team/Glossary-of-acronyms](/BI-Team/Glossary-of-acronyms).

## Where the source lives

The live framework is the Adaptive-Test-Framework repository.

- The agents are under `.github/agents/`, the task prompts under `.github/prompts/`, and the instruction files (the governance rulebook, the project profile, the data contract) under `.github/instructions/`.
- The artefact templates are under `templates/`; the project register schemas are under `templates/project/`.
- The validator is under `tools/trace-check/`.
- The `docs/` folder holds the orientation reading: `getting-started.md` (the happy path), `architecture.md` (the three-layer model), and the FAQs for new projects and for increments.

*Grounded in the Adaptive Test Framework (ATF) v1.0 and the Enterprise Testing Framework v2.0. The live agents and prompts live in the Adaptive-Test-Framework repository.*
