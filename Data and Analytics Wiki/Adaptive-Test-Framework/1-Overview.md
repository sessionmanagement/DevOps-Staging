# 1. Overview

[[_TOC_]]

The Adaptive Test Framework (ATF) v1.0 is a configurable, project-agnostic way to plan, design, support, report on and govern testing of vendor-delivered solutions. It is the productisation of the Enterprise Testing Framework (ETF) v2.0 methodology. The methodology supplies the rules; ATF makes them reusable across organisations and projects.

## What it is, and what it is not

ATF is a set of GitHub Copilot agents and task prompts, a governance rulebook, and a project data layer. You run it inside VS Code. It helps you plan the work, write the artefacts, organise coverage, and report on results.

What it does:

- Plans test strategy and coverage.
- Writes test plans, UAT cases, traceability matrices, reports and defect records.
- Organises the work against the business process.
- Reports go/no-go against the gates.

What it does not do:

- It does not run the tests. You and the test team do that. The agents do not click buttons in the system under test.
- It does not test vendor internals. It tests the business outcomes of a vendor-delivered solution: does the end-to-end process produce the right result, with the data correct and the integrations intact.

The AI plans, writes, organises and reports. Humans run the tests.

## The problem it solves

Vendors deliver solutions. You have to prove they work for the business before you go live. Done ad hoc, that testing is inconsistent: coverage depends on who designed it, severity depends on who is in the room, and the release decision is hard to defend.

ATF gives you one governed way to test vendor solutions, anchored to the business process rather than the screens. Coverage is decided by a repeatable model, severity by published rules, and the release decision by explicit gates. The same approach works for the next project because the methodology is fixed and only the project data changes.

## The big ideas in brief

**The 3 Triggers.** Coverage is driven by three triggers: a User Action (a person submits, approves, uploads, presses or assigns), a Data Change (data crosses a system boundary or updates - import, sync, API, recalculation or cascade - and downstream behaviour must follow), and a System Event (the system acts on its own, such as a scheduled job, callback or notification). Every applicable trigger on every process step needs at least one scenario. See [/Adaptive-Test-Framework/3-The-Methodology](/Adaptive-Test-Framework/3-The-Methodology).

**Business-process-led coverage.** You test the business process end to end, not the UI screen by screen. Data integrity is non-negotiable, imported data must behave like manually entered data, and a record must satisfy every required check up to its lifecycle stage. See [/Adaptive-Test-Framework/3-The-Methodology](/Adaptive-Test-Framework/3-The-Methodology).

**The no-go gates.** Go-live is decided by explicit gates covering P1 pass rate, regression, data integrity, integration, readiness, open dependencies and business sign-off. Any unmet P1 or data-integrity gate is a no-go, no exceptions. The decision authority is the organisation's, never the vendor's. See [/Adaptive-Test-Framework/4-Governance-and-Rules](/Adaptive-Test-Framework/4-Governance-and-Rules).

**P1 to P4 severity.** Defects are rated P1 Critical, P2 High, P3 Medium or P4 Low by business impact. A P1 blocks a core outcome or puts data integrity, safety or financial correctness at risk and cannot be carried forward. Severity is a testing judgement, never the vendor's convenience. See [/Adaptive-Test-Framework/4-Governance-and-Rules](/Adaptive-Test-Framework/4-Governance-and-Rules).

**Domain criticality.** Each engagement has a dominant criticality: Financial, Operational, Life-safety or Compliance. It drives the P1 definition and how stringent the gates are. The conditional Life-safety gate applies whenever any capability under test is Life-safety-critical, whether or not Life-safety is the dominant one. See [/Adaptive-Test-Framework/4-Governance-and-Rules](/Adaptive-Test-Framework/4-Governance-and-Rules).

**Test modes.** Testing runs in one or more modes: UAT, Pilot, Parallel Run, Regression or Integration. The plan selects the modes that fit the change. See [/Adaptive-Test-Framework/4-Governance-and-Rules](/Adaptive-Test-Framework/4-Governance-and-Rules).

**The project data layer.** Everything organisation- and project-specific lives in one place: the project profile and the `project/` registers (personas, integrations, risks, regression pack, systems, business process map, readiness and TBC). The methodology never changes per engagement; only this data does. See [/Adaptive-Test-Framework/2-How-the-Framework-Works](/Adaptive-Test-Framework/2-How-the-Framework-Works).

## The three-layer model

ATF keeps three layers separate. Layer 1 is the framework IP: the governance rulebook, the agents, the task prompts, the instruction files, the artefact templates and the tooling, carrying zero organisation or project specifics. Layer 2 is the project data layer: the project profile, the `project/` registers and the brand assets, written by the Test Initialization agent and the only place specifics live. Layer 3 is behaviour: the agents themselves, which read the data layer and obey the rulebook. The IP never changes per engagement, the data layer carries every specific, and the agents read the data rather than hardcoding it. See [/Adaptive-Test-Framework/2-How-the-Framework-Works](/Adaptive-Test-Framework/2-How-the-Framework-Works).

## Where it comes from

ATF v1.0 is the configurable productisation of the Enterprise Testing Framework v2.0. The methodology supplies the gates, the severity scale, the 3 Triggers model, the readiness rules and the principles. ATF packages them as agents, prompts and a data layer so a new organisation or project becomes testable by populating the data layer, with no edits to the framework IP. The framework ships populated with Ka Puta Ka Ora Emerge Aotearoa as a worked reference; the project KIRIMANA CM360 (Contract Management 360, vendor Datacom, platform Microsoft Dynamics 365 / Power Platform with Business Central, dominant criticality Financial) is the example. See [/Adaptive-Test-Framework/7-Worked-Example-CM360](/Adaptive-Test-Framework/7-Worked-Example-CM360).

## Related Emerge testing pages

For the existing test-analyst material in this wiki:

- [/How-to-create-Test-Plan,-Test-Case,-Test-Steps](/How-to-create-Test-Plan,-Test-Case,-Test-Steps)
- [/BI-Team/Documentation-%2D-Analysts/Testing-and-Sign%2DOff-process](/BI-Team/Documentation-%2D-Analysts/Testing-and-Sign%2DOff-process)
- [/BI-Team/Documentation-%2D-Analysts/Bug-Prioritisation-Process](/BI-Team/Documentation-%2D-Analysts/Bug-Prioritisation-Process)
- [/BI-Team/Glossary-of-acronyms](/BI-Team/Glossary-of-acronyms)

*Grounded in the Adaptive Test Framework (ATF) v1.0 and the Enterprise Testing Framework v2.0. The live agents and prompts live in the Adaptive-Test-Framework repository.*
