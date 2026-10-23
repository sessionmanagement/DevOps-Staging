# Guidelines for Writing `.agent.md` Files

[[_TOC_]]

## Purpose

This page sets the minimum rules for writing custom `.agent.md` files for GitHub Copilot custom agents used in our Azure DevOps, repository, and SQL development workflows.

The goal is to keep agents useful, safe, and reviewable without exposing organisational data to the LLM or allowing uncontrolled changes to repositories, DevOps, or databases.

This guidance also aligns to the AI Agent Governance Framework, especially the principles of:

- least privilege
- human oversight
- auditability and traceability
- data protection
- lifecycle governance

---

## Core Rules

### 1. Use Approved MCP Connections Only

Agents must only use MCP connections that have been explicitly approved.

Rules:

- Only include MCP servers the agent actually needs.
- Do not add broad or unknown MCP access.
- Do not use new external connections without approval.
- Where possible, keep the tool list minimal.

Why this matters:

This aligns with the governance principle of least privilege and the requirement that external connections must be explicitly approved.

---

### 2. Never Expose Our Data to the LLM

Agents must not expose live business, operational, customer, or personal data to the language model.

Rules:

- Do not query live row-level data and return it to chat.
- Do not summarise sensitive database contents into prompts or responses.
- Do not retrieve live records just to inspect them.
- Prefer generating scripts or instructions for the user to run securely.
- If a task can be done without database access, do not connect to the database.

Safe default:

Generate SQL, markdown, validation scripts, or instructions. Do not run them. Do not return live data.

Why this matters:

This aligns with data protection, access control, and personal information minimisation requirements in the governance framework.

---

### 3. Only Write or Execute on Development Databases

If an agent is allowed to execute or write to a database, it must only do so on confirmed Development environments.

Rules:

- Never write to or execute against Test or Production databases.
- Never assume an environment is safe based on naming alone.
- If the environment cannot be confirmed as Development, stop and ask the user.
- If the work relates to Test or Production, generate scripts only and let the user run them under a secure connection.

Safe default:

If there is any doubt, do not execute.

Why this matters:

This supports proportionate governance, human oversight, and reduction of operational risk.

---

### 4. Never Write to Protected Branches

Agents must not directly change shared or protected branches.

Rules:

- Never write to `main`
- Never write to `Test`
- Never write to `Production`
- Only write to user-created development branches
- If the current branch is protected, stop and ask the user to switch branches first

Safe default:

Agents may read protected branches for comparison or review, but must never write to them.

Why this matters:

This supports human oversight, integrity, and change control.

---

### 5. Use the DevOps Wiki Only When Explicitly Instructed

The DevOps wiki is not the default place for agents to write content.

Rules:

- Only update the DevOps wiki when the user explicitly asks
- Prefer a cloned wiki or repo-backed markdown source where possible
- Prefer returning markdown in chat for review before publishing
- Direct wiki publishing should be the exception, not the default

Why this matters:

This keeps documentation changes reviewable and auditable.

---

### 6. Ask for Confirmation Before Significant Changes

Agents must ask for confirmation before making significant changes to Development databases or Azure DevOps state.

Confirmation is required before:

- running DDL
- running mass `INSERT`, `UPDATE`, `DELETE`, or `MERGE`
- changing pipelines
- changing branch policies
- publishing or overwriting wiki content
- changing permissions, service connections, or credentials
- making significant Development database changes
- making significant Azure DevOps changes

Recommended confirmation prompt:

> This action will change Development resources or Azure DevOps state. Confirm before I proceed.

Why this matters:

This aligns with human oversight and lifecycle governance.

---

## Practical Authoring Rules for `.agent.md`

Every `.agent.md` file should be simple, explicit, and narrow in scope.

### Minimum Expectations

Each agent should include:

- a clear `name`
- a specific `description`
- a minimal `tools` list
- a `Constraints` section
- an `Approach` section
- a role that is focused on one job

### Tooling Guidance

Use the minimum tool surface required.

Examples:

- read-only review agent: `read`, `search`, `todo`
- script-generation agent: `read`, `search`, `todo`, approved DevOps MCP only
- development-only execution agent: `read`, `search`, `execute`, `todo`, plus approved MCP tools only if execution is necessary

If execution is not essential, do not include execution tools.

### Constraint Guidance

Every agent should clearly say what it must not do.

At minimum, the constraints should cover:

- no unapproved MCP connections
- no live data exposure to the LLM
- no execution outside Development
- no writes to protected branches
- no direct wiki updates unless explicitly instructed
- confirmation before significant changes

---

## Governance Additions to Include

To keep this practical while still aligning to the AI Agent Governance Framework, each active custom agent should also have the following lightweight governance controls:

### Ownership

Each active agent should have a clearly identified owner.

This does not need to be in the frontmatter, but it should be documented somewhere in the repo, wiki, or agent register.

### Reviewability

Agent definitions should be stored in version control wherever possible.

Changes should be reviewable through normal branch and pull request processes.

### External Connection Approval

If an agent uses MCP or any external connection, that connection should be explicitly approved before the agent is used.

### Periodic Review

Agents should not remain active indefinitely without review.

As a practical minimum:

- low-risk agents should be reviewed periodically
- higher-risk agents should be reviewed more often
- agents with write capability or external connections should receive stronger scrutiny

### Risk Awareness

Not all agents need the same level of governance.

As a practical rule:

- read-only agents are lower risk
- agents that write code or documentation are medium risk
- agents that execute SQL, change DevOps state, or use external MCP connections are higher risk

---

## Recommended Safe Template

```yaml
---
name: Secure DevOps Agent
description: "Use when reviewing code, generating scripts, or preparing safe development-only changes without exposing live data to the model."
tools:
  - read
  - search
  - todo
  - ado/*
user-invocable: true
---