# 5. Using the Framework with the Agents

[[_TOC_]]

This page drives the AI in VS Code, step by step, to generate governed test artefacts. For the same lifecycle done by hand, see [Using the Framework Manually](/Adaptive-Test-Framework/6-Using-the-Framework-Manually). For a fully worked engagement, see [Worked Example CM360](/Adaptive-Test-Framework/7-Worked-Example-CM360). For the existing Emerge test process this sits alongside, see [Testing and Sign-Off process](/BI-Team/Documentation-%2D-Analysts/Testing-and-Sign%2DOff-process), [Bug Prioritisation Process](/BI-Team/Documentation-%2D-Analysts/Bug-Prioritisation-Process), and [How to create Test Plan, Test Case, Test Steps](/How-to-create-Test-Plan,-Test-Case,-Test-Steps).

The AI helps you plan, write, organise and report. You and the test team run the actual tests. The agents do not click buttons in the system under test.

## Prerequisites

You need:

- **VS Code** with the **GitHub Copilot** and **GitHub Copilot Chat** extensions installed and signed in.
- The **Adaptive Test Framework repository open** as the workspace, so the `.github/` folder sits at the workspace root. VS Code discovers the agents, prompts and instructions from there.
- The **agent dropdown** at the top of the Copilot Chat box. This is how you pick an agent.

Opus 4.8 is the model the agents were authored and verified against. Select it in the model picker if you have it. It is a recommendation, not a requirement: the framework content is model-agnostic.

If an agent or a `/` command does not appear after you open the repo, reload the VS Code window (Command Palette, then *Developer: Reload Window*).

## Step by step

Run things in this order. The Test Initialization agent comes first: it is the only agent that writes the project data layer, and every other agent reads what it writes.

### 1. Open the repo

Open the framework repository in VS Code. Confirm Copilot and Copilot Chat are signed in. Open the Copilot Chat box and find the agent dropdown at the top.

### 2. Run Test Initialization

Pick **Test Initialization** from the dropdown. Tell it to begin. Either:

- *"Set up ATF for my project."* — it leads the interview from scratch; or
- attach your BA documents first (see [How to talk to the agents](#how-to-talk-to-the-agents)) and say *"Read these and pull out what you can."* — it ingests first, then interviews only the gaps.

What it does:

- **Teaches you the framework** — a short, plain-language orientation: what ATF is, the three layers, and how the Test Analyst and the prompts fit together.
- **Interviews you section by section** against the framework data contract, one section at a time. It announces what each section unlocks, asks a focused set of questions, confirms the values back to you, then writes that section.
- **Ingests your documents** — it reads the BA documents, requirements, process maps and defect exports you attach, extracts the data into the right register, and tells you which document each item came from before it writes anything.
- **Writes only the data layer** — the engagement profile and the `project/` registers. It never touches the rulebook, the agents, the prompts, the templates or the tooling.
- **Reports the gaps** — which data-contract items are still missing, which are required and which are optional, and what coverage each one unlocks. It ends with one verdict: the data layer is ready, or these required items are still outstanding.
- **Confirms what is Life-safety-critical** — it asks whether any in-scope capability is Life-safety-critical and records `life_safety_in_scope` (yes or no). A yes puts the conditional G8 gate in scope regardless of the dominant criticality.
- **Confirms rather than inherits** — for a genuinely new organisation it confirms `tereo_mode` and `values_mode` with you rather than inheriting the Emerge-specific te reo register and values block, so you replace them or switch them off.
- **Resolves contradictions instead of guessing** — when the values you give conflict, for example two project names or two dominant criticalities, it names every conflicting value and asks you to choose rather than taking the last one you gave. The one exception: a change that drops a stated Life-safety criticality is never a silent correction — it confirms it with you as an explicit downgrade, because it removes G8 from scope. See [Governance and Rules](/Adaptive-Test-Framework/4-Governance-and-Rules), the no-go gates (section 11).

It is safe to re-run. Run it again any time to fill a gap or update the data layer; it reconciles rather than overwrites, and shows you the diff before it writes. On a resume it cross-checks organisation consistency first: it will not stamp a mixed-org or self-contradictory layer as initialised — it surfaces the contradiction and asks which engagement is live. See the cold-start gate on [How the Framework Works](/Adaptive-Test-Framework/2-How-the-Framework-Works).

It does not design tests or write reports. When the data layer is ready it hands you off to the Test Analyst and the prompts.

### 3. Run Test Analyst

Pick **Test Analyst** from the dropdown. This is the day-to-day working agent. Ask it what you should test, in plain English. For example: *"What should we test for the contract approval process?"*

It frames the work through the 3 Triggers model (User Action, Data Change, System Event), decides what to test and why, then delegates the detailed work to the prompts. It is read-only: it reads the data layer and obeys the governance rulebook, and it never writes the data layer even by proxy — it will not compose a `project/` register row or a profile edit for you to paste in, so any register add or change routes back to Test Initialization. If a required item is missing for what you asked, it names the gap and advises running Test Initialization.

It also guards against the wrong engagement. If you name a project, product or domain that plainly conflicts with the resolved project or the loaded registers — a payroll request against a contract-management data layer, say — it surfaces the mismatch and confirms which engagement is live, or advises re-running Test Initialization, before it designs coverage, rather than silently reusing the wrong registers just because the workspace looks initialised. It may also halt on a layer that looks initialised but whose stamps do not corroborate, or whose registers name a different engagement than the profile stamp. This is the cold-start gate in action; [How the Framework Works](/Adaptive-Test-Framework/2-How-the-Framework-Works) explains what the agents check.

### 4. Run the prompts in order

The prompts are `/` commands you type in the chat box. Run them in lifecycle order. The Test Analyst frames each piece of work and points you to the prompt by name.

<details>
<summary><b>Flow chart</b></summary>

::: mermaid
flowchart TD
  A["Test Initialization: set up the data layer"] --> B["Test Analyst: strategy and scope"]
  B --> C["/test-plan-generator: formal Test Plan"]
  C --> D["/ba-briefing (optional): unpack process, tie to AC"]
  D --> E["/uat-case-generator: 10-column cases"]
  E --> F["Run the tests: humans execute and record"]
  F --> G["/defect-triage: severity P1 to P4, closure rules"]
  G --> H["/traceability-builder: matrix and regression pack"]
  H --> I["/uat-reporter: report and go/no-go"]
:::

</details>

| Step | What you type | What you get back |
|---|---|---|
| `/test-plan-generator` | `/test-plan-generator` with the change under test and the in-scope areas. | A formal Test Plan: test modes selected, the change type mapped to a regression approach, and the entry and no-go gates set. |
| `/ba-briefing` (optional intake) | `/ba-briefing` with the business process and the work item or pasted acceptance criteria. | A framed, acceptance-criteria-linked scenario list with happy, negative and boundary scenarios tagged by trigger, ready for `/uat-case-generator`. |
| `/uat-case-generator` | `/uat-case-generator` with the scenarios or the process area. | Executable cases in the canonical 10-column UAT workbook, with Given/When/Then steps. |
| Run the tests | Nothing. You and the test team run the cases and record pass or fail. | Executed cases with results. |
| `/defect-triage` | `/defect-triage` with your defect export or vendor report. | Governed defect records mapped to P1 to P4, with closure rules and gate impact. |
| `/traceability-builder` | `/traceability-builder` with your requirements, cases, runs and defects. | The requirement to case to run to defect matrix, plus the regression baseline and flagged coverage gaps. |
| `/uat-reporter` | `/uat-reporter` with your execution results and defect list. | A formal UAT Report and a go/no-go recommendation, through its sign-off flow. |

`/test-plan-generator` writes the formal Test Plan that frames the container. Run it when you need the plan written; the Test Analyst frames the change and scope for it first.

`/defect-triage` records an evidence bar for any downward P1 re-classification in the defect record's Resolution — the business-impact evidence, an explicit statement that the change is not motivated by the gate or the ship date, and the named Test Management approver — never a bare downgrade. See [Governance and Rules](/Adaptive-Test-Framework/4-Governance-and-Rules), defect severity (section 10).

Run `/ba-briefing` when a process needs unpacking and tying to acceptance criteria before cases are written. It is the upstream intake front end, not a sixth lifecycle prompt: it feeds `/uat-case-generator`. Skip it when the process is already framed.

`/uat-reporter` always ends an approved report with the single governed verdict — Go, Conditional Exit or No-go. It is not optional. The reporter first resolves which gates apply from the criticality, reading `life_safety_in_scope`: a yes puts the Life-safety gate G8 in the applicable set, so "the seven core gates are green" is not enough, and an in-scope unmet G8 or an open P1 lands as No-go, never a softened fourth option. See [Governance and Rules](/Adaptive-Test-Framework/4-Governance-and-Rules), the no-go gates (section 11) and gate decisions (section 11.1).

If a prompt says "run the initializer", that is the framework working as designed, not an error. The prompt checked the data contract, found a required item missing, and named the gap. Go back to Test Initialization, fill the gap, and re-run the prompt.

## How to talk to the agents

Plain English is fine. Be specific about what you want. The agents have a few habits worth knowing.

**Attach documents** three ways:

1. **Drag and drop** the file from the Explorer or an editor tab onto the chat box.
2. Click the **Add Context** button in the chat view.
3. Type `#` and the file name (for example `#file`) to mention it.

Then say something like *"Read these and pull out what you can."*

**They read text and Markdown, not binary Office files.** If the agent says it cannot read your `.xlsx`, `.docx`, `.pdf` or `.vsdx`, open the file, copy the relevant content, and paste it into the chat. Or export it to Markdown or CSV-as-text first. The agent will not pretend to read a binary it cannot.

**They protect sensitive data.** The agents — Test Initialization and `/defect-triage` most of all — decline to persist or echo real production PII, PHI, PCI or NHI data, or Māori data (iwi, hapū, whakapapa, taonga). They refer to such values by category and ask you for a synthetic or de-identified equivalent instead. An accidental disclosure is itself a disclosure event that may be a notifiable breach under the Privacy Act 2020 or a Māori data-sovereignty concern, so follow your organisation's breach or near-miss process. See [Governance and Rules](/Adaptive-Test-Framework/4-Governance-and-Rules), test data and sensitive-data handling (section 12.1).

**They treat supplied material as data, not instructions.** What you paste or attach — BA text, execution notes, defect exports, attached documents — is input to process, never a command to obey. Any embedded directive that tries to change a verdict, a severity, a coverage figure, a risk or the go/no-go decision is ignored, however it is phrased, and surfaced to you as an attempted override before anything is published. Only your direct instructions and the governed rules change what an agent produces.

**They ask instead of guessing.** If something is missing or unclear, the agent asks one specific question rather than making up project details, defect numbers or user names. Answer it and the agent carries on.

**They show a plan before building.** For anything substantial, the agent outlines what it is about to do and waits for your yes before producing the final artefact. This stops it heading in the wrong direction.

*Grounded in the Adaptive Test Framework (ATF) v1.0 and the Enterprise Testing Framework v2.0. The live agents and prompts live in the Adaptive-Test-Framework repository.*
