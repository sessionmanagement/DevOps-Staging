# AGENTS.md

## Scope

This repository is an Azure DevOps wiki content repo, not an application codebase. Treat most tasks here as markdown and information architecture edits.

- Start with [CLAUDE.md](CLAUDE.md) for the repo overview and wiki-specific markdown conventions.
- Follow the governance rules in [BI-Team/Documentation-%2D-Data-Dudes/Development-Standards/Development-of-github-copilot-md-files-and-agent.md-files.md](BI-Team/Documentation-%2D-Data-Dudes/Development-Standards/Development-of-github-copilot-md-files-and-agent.md-files.md) when creating or editing custom agents.
- Reuse existing documentation by linking to it. Do not copy large sections of wiki content into new instruction files.

## Repo Facts

- Main branch for the wiki is `wikiMaster`.
- There is no repo build, test, or lint pipeline to validate content changes.
- Navigation is controlled by directory-local `.order` files.
- Many file and folder names use `%2D` in paths. Preserve existing names exactly.
- Azure DevOps wiki directives and HTML are expected here: `[[ _TOSP_ ]]`, `[[ _TOC_ ]]`, `<details>`, and `::: mermaid` blocks.

## Editing Rules

- When you add, move, rename, or delete a page, update the nearest parent `.order` file in the same change.
- Do not normalize encoded paths, punctuation-heavy file names, or Unicode dash characters. Match the existing file names exactly.
- Keep existing wiki markup intact unless the task requires changing it.
- Keep edits small and local. Do not rewrite whole pages for style alone.
- Only change wiki content pages when the user asked for a documentation change. For chat customization work, limit edits to instruction, prompt, or agent files.

## Task Routing

- For general wiki structure and authoring rules, start with [CLAUDE.md](CLAUDE.md).
- For BI analyst workflows, start under [BI-Team/Documentation-%2D-Analysts.md](BI-Team/Documentation-%2D-Analysts.md) and the pages beneath that section.
- For data engineering, ETL, deployment, and troubleshooting, start under [BI-Team/Documentation-%2D-Data-Dudes.md](BI-Team/Documentation-%2D-Data-Dudes.md).
- For shared standards and reusable reference material, start with [BI-Team/Documentation-%2D-Cumulative/Business-Intelligence-Resources-Hub.md](BI-Team/Documentation-%2D-Cumulative/Business-Intelligence-Resources-Hub.md).
- For domain terms, check [BI-Team/Glossary-of-acronyms.md](BI-Team/Glossary-of-acronyms.md) before expanding abbreviations.
- For incident triage, Pae Awhina tickets, and BI bug coordination, reuse [.github/agents/bug-master.agent.md](.github/agents/bug-master.agent.md) with supporting material in [.github/agents/bug-master-reference.md](.github/agents/bug-master-reference.md).
- For reusable Power BI role prompts, check [Agent-Header.md](Agent-Header.md) and the pages under [Agent-Header](Agent-Header).

## Validation

- Validate markdown edits by checking links, headings, and parent `.order` entries.
- Since there is no automated test suite, prefer a narrow review of the touched markdown over broad repo scans.
- If a task changes navigation, verify that the page appears in the correct `.order` file and that any related hub page still points to the right location.