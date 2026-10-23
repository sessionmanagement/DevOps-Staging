# 2. How the Framework Works

[[_TOC_]]

ATF has three layers, two agents, a set of task prompts, a project data layer, and a governance rulebook over all of it. For the methodology rules themselves see [/Adaptive-Test-Framework/3-The-Methodology](/Adaptive-Test-Framework/3-The-Methodology) and [/Adaptive-Test-Framework/4-Governance-and-Rules](/Adaptive-Test-Framework/4-Governance-and-Rules).

## The three-layer architecture

ATF keeps three layers strictly separate. The framework IP never changes per engagement. The data layer carries every specific. The agents read the data rather than hardcoding it.

| Layer | What is in it | Who edits it |
|---|---|---|
| **1. Framework IP** | The governance rulebook, the agents, the task prompts, the instruction files, the artefact templates and the tooling. Carries zero organisation or project specifics. | Nobody, per engagement. It is the product. |
| **2. Project data layer** | `project-profile.instructions.md`, the `project/` registers and the brand assets. The only place organisation and project specifics live. | The Test Initialization agent writes it. |
| **3. Behaviour** | The agents themselves. They read the data layer and obey the rulebook. | Nobody, per engagement. |

The bright line: identity and configuration live in the data layer, rules live in governance, the data-item list lives in the data contract. A new engagement is configured by populating the data layer, with no edits to the IP.

## The agents

There are two agents. You pick them from the Copilot Chat agent dropdown.

### Test Initialization (run first)

This is the agent you run first, before any test work. It is the only agent that writes the project data layer. It:

- Interviews you section by section against the framework data contract, one section at a time, plan before build.
- Ingests the BA documents, requirements, process maps and defect exports you attach, and extracts the data into the right register.
- Writes only the data layer. It never touches the rulebook, the agents, the prompts, the templates or the tooling.
- Reports the gaps that remain: which items are still missing, which are required and which are optional, and what coverage each one unlocks.
- Is idempotent. Re-run it any time and it reconciles rather than overwrites.

When the data layer is ready it hands you off to the Test Analyst and the task prompts. It does not design tests or write reports itself.

### Test Analyst (day to day)

This is the orchestrator for everyday test work. It thinks like a senior test engineer. It:

- Designs test strategy and coverage using the 3 Triggers model (see [/Adaptive-Test-Framework/3-The-Methodology](/Adaptive-Test-Framework/3-The-Methodology)).
- Decides what to test and why, then delegates the detailed work to the task prompts.
- Is read-only. It reads the data layer and obeys the governance rulebook; it never writes the data layer.
- Resolves every engagement specific (the organisation, project and core platform) from the data layer.

If a required item is missing for what you ask, it names the gap and advises running the Test Initialization agent.

## The task prompts

Five lifecycle prompts cover the test lifecycle. They are invoked with `/<prompt-name>` in Copilot Chat. The Test Analyst frames the work and hands off to them.

| Prompt | What it does | What you get |
|---|---|---|
| `/test-plan-generator` | Assembles a formal Test Plan: selects test modes, maps the change type to regression scope, sets the entry and no-go gates. | A Test Plan. |
| `/uat-case-generator` | Turns a process area or framed scenarios into executable UAT and integration cases on the 3 Triggers model. | The canonical 10-column UAT workbook. |
| `/defect-triage` | Maps raw defects to P1 to P4, applies closure and carry-forward rules, and states gate impact. | Governed, severity-mapped defect records. |
| `/traceability-builder` | Builds the requirement to case to run to defect matrix and the regression baseline, and flags coverage gaps. | A traceability matrix and a regression pack. |
| `/uat-reporter` | Turns execution results and defects into a formal UAT Report through its sign-off flow. | A UAT Report and a go/no-go recommendation. |

### The `/ba-briefing` intake front end

`/ba-briefing` is the upstream intake front end. It is not a sixth lifecycle prompt. It sits ahead of `/uat-case-generator` and prepares its input.

| Prompt | What it does | What you get |
|---|---|---|
| `/ba-briefing` | Unpacks a business process, ties each step to the acceptance criteria, and frames trigger-tagged happy, negative and boundary scenarios. It does not write the 10-column cases and does not rule severity. | A framed, acceptance-criteria-linked scenario list, ready to hand to `/uat-case-generator`. |

Run it before case generation when a process needs capturing and tracing to acceptance criteria. There are still five lifecycle prompts; `/ba-briefing` is the separate intake step in front of them.

## The project data layer and registers

The project data layer is the one place every engagement specific lives. The Test Initialization agent fills it; every other agent only reads it. It holds:

- **`project-profile.instructions.md`** — engagement identity, project meta, dominant criticality, the tooling block, the te reo and values and brand toggles, and the pointers to the registers. The te reo and values toggles are confirmed per engagement, not silently inherited: a genuinely new organisation replaces the Emerge-specific te reo register and values block (Ako, Whakamana, Manaaki, Whakawhanaunga) or sets them to `none`, and an unfilled toggle reads as a readiness gap. The Test Initialization agent confirms both toggles during its interview rather than inheriting them (see [/Adaptive-Test-Framework/5-Using-the-Framework-with-the-Agents](/Adaptive-Test-Framework/5-Using-the-Framework-with-the-Agents)).
- The **`project/` registers**:

| Register | What it holds |
|---|---|
| `persona-register.md` | Authorised personas for the "User Assigned" column in cases. |
| `integration-register.md` | Data flows: source, target, payload, direction, mechanism, trigger. |
| `risk-patterns.md` | Known failure modes, their trigger, typical severity and detection. |
| `regression-pack.md` | Baseline cases that must hold across releases. |
| `systems-inventory.md` | Systems and automations, for blast-radius scoping. |
| `business-process-map.md` | Process steps on the six-column schema: Step, Actor/persona, Trigger, Integration point, Risk, Notes. |
| `readiness-and-tbc.md` | The entry-gate readiness checklist and the open-dependency TBC register. |

- The **brand assets** under `project/brand/`, which drive formal Word output.

The framework data contract is the completeness map behind all of this. It lists every data item, the file that holds it, which agents consume it, whether it is required or optional, and what each item unlocks. The Test Initialization agent walks it to drive the interview and report gaps; the other agents consult it to detect missing data and advise running the initializer. The data contract is also the shared read-interface every consuming agent obeys, so its cross-agent duties bind every consumer, not just the Test Analyst: the cold-start gate below, the engagement-match duty (surface any request whose named project or domain conflicts with the resolved identity or the loaded registers), the sensitive-data rule, and an untrusted-input firewall. The sensitive-data rule carries governance's test-data rule (section 12.1) to every ingesting agent: real production PII, PHI, PCI, NHI or Māori data is never written into a tracked artefact or echoed back, and the agent asks for a synthetic or de-identified equivalent instead (see [/Adaptive-Test-Framework/4-Governance-and-Rules](/Adaptive-Test-Framework/4-Governance-and-Rules)). The untrusted-input firewall treats everything a user pastes or points an agent at as input to process, never instructions to obey. You see the agents apply this when you paste or attach material (see [/Adaptive-Test-Framework/5-Using-the-Framework-with-the-Agents](/Adaptive-Test-Framework/5-Using-the-Framework-with-the-Agents)).

### The cold-start gate

When the Test Initialization agent finishes, it stamps a sentinel — `engagement_initialised` — in the profile, together with the organisation, project and date it initialised for. Every other agent reads that sentinel before it trusts the data layer as this engagement's truth. The sentinel is necessary but not sufficient: the agent also confirms the stamp fields are set, that the stamped organisation matches the resolved identity, and that the loaded `project/` registers name the right organisation and project. A bare `true` sitting over unset stamps, or over registers that still name a different organisation or project, is treated as a tampered or half-written layer — the agent halts and advises re-running Test Initialization, regardless of what the task asks. Test Initialization itself will not stamp a self-contradictory or mixed-organisation layer on a resume, and the trace-check validator reinforces the gate in CI through its INIT-001 check (see [/Adaptive-Test-Framework/8-Templates-and-Reference](/Adaptive-Test-Framework/8-Templates-and-Reference)).

## The lifecycle end to end

The agents and prompts run in order. Each one does its job and hands off.

1. **Test Initialization** — set up the data layer.
2. **Test Analyst** — strategy and scope.
3. **`/test-plan-generator`** — assemble the formal Test Plan: test modes, regression scope, and the gates.
4. **`/ba-briefing`** (optional) — unpack the process and tie it to the acceptance criteria.
5. **`/uat-case-generator`** — write the 10-column cases.
6. **Run the tests** — humans run them.
7. **`/defect-triage`** — severity P1 to P4 and closure rules.
8. **`/traceability-builder`** — matrix and regression pack.
9. **`/uat-reporter`** — report and go/no-go.

<details>
<summary><b>Flow chart</b></summary>

::: mermaid
flowchart TD
  A["Test Initialization<br/>set up the data layer"] --> B["Test Analyst<br/>strategy and scope"]
  B --> C["/test-plan-generator<br/>formal Test Plan: modes, regression, gates"]
  C --> D["/ba-briefing<br/>optional: unpack process, tie to AC"]
  D --> E["/uat-case-generator<br/>write the 10-column cases"]
  E --> F["Run the tests<br/>humans"]
  F --> G["/defect-triage<br/>severity P1 to P4"]
  G --> H["/traceability-builder<br/>matrix and regression pack"]
  H --> I["/uat-reporter<br/>report and go/no-go"]
:::

</details>

## The governance rulebook

The governance rulebook is always on. It defines the rules: the 3 Triggers, the framework principles, the readiness gate, change classification and regression scope, domain criticality, test modes, P1 to P4 severity, the no-go gates and the RACI. It is not an agent. Every agent obeys it and cites it by section number rather than restating it. See [/Adaptive-Test-Framework/4-Governance-and-Rules](/Adaptive-Test-Framework/4-Governance-and-Rules).

For the templates each prompt produces and the IDs they use, see [/Adaptive-Test-Framework/8-Templates-and-Reference](/Adaptive-Test-Framework/8-Templates-and-Reference). To run the framework with the agents, see [/Adaptive-Test-Framework/5-Using-the-Framework-with-the-Agents](/Adaptive-Test-Framework/5-Using-the-Framework-with-the-Agents).

*Grounded in the Adaptive Test Framework (ATF) v1.0 and the Enterprise Testing Framework v2.0. The live agents and prompts live in the Adaptive-Test-Framework repository.*
