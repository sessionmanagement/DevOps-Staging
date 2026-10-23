# Report Creation Process from start to "Ready to release"

This article aims to provide an overview for how we develop a new report from start to finish.

<details><summary><b>Beginning a New Report</b></summary><br>

In our Main repository within GIT, there is a "Template" file containing our most up-to-date theme, preferred visuals, and example pages. We aim to update this regularly to serve as a starting point for new reports.

- Start by creating a branch and linking it to your new user story for the new report.
- [Click here to read about our GIT process](/BI-Team/Documentation-%2D-Analysts/Git-Workflow-for-Power-BI-Development)
</details>

<details><summary><b>Connecting to a Dataset</b></summary><br>

- If not changing the dataset:
  - Connect to the relevant dataset in our Production workspace.
- If working with a dataset developer who is altering the dataset or you need to add measures:
  - Publish the dataset to your personal dataset testing workspace (e.g., Greg H Datasets).

**Note**: Repointing to a new workspace may break many visuals in the template. You'll need to:
- Add measures and fields to replace broken ones.
- Delete unnecessary elements.
- Retain additional pages until report completion, hiding them in case they become relevant but delete when finished.
</details>

<details><summary><b>Initial Report Development</b></summary><br>

- Refer to the [Reporting Guidelines and Standards](https://dev.azure.com/EmergeAotearoa/Data%20and%20Analytics/_wiki/wikis/Data-and-Analytics.wiki/8/Reporting-Standards)
- Aim to meet the [Requirements and Acceptance Criteria](https://dev.azure.com/EmergeAotearoa/Data%20and%20Analytics/_wiki/wikis/Data-and-Analytics.wiki/64/Requirements-Gathering)
- Development process:
  - Create one page at a time.
  - When confident about delivering customer requirements:
    - Set up a meeting to discuss, or
    - Send a Teams message with a link to the report.
  - For testing:
    - Upload your report to your specific Testing workspace (e.g., Greg H Reports).
</details>

<details><summary><b>Iterative Development and Feedback</b></summary><br>

- Regularly update stakeholders on progress.
- Schedule periodic review sessions to:
  - Demonstrate new features.
  - Gather feedback.
  - Discuss any challenges or roadblocks.
- Implement changes based on feedback.
- Document all significant changes and decisions.


<div style="background-color: #f5f5f5; padding: 10px; border-radius: 5px;">
  <strong>⚠️ NOTE</strong>
  <p><br>
Beware of <b><i>scope creep</i></b>. Projects can spiral out of control if changes significantly increase effort beyond initial requirements. While flexibility matters, be ready to refuse or defer major new requests to the backlog. Maintain focus on agreed-upon criteria.
  </p>
</div>
<br>
</details>

<details><summary><b>Quality Assurance and Testing</b></summary>

- Conduct thorough testing of the report:
  - Check all visuals for accuracy.
  - Verify data consistency across pages.
  - Test interactive elements and filters.
  - Ensure performance is optimized.
- Have a peer review the report for:
  - Adherence to [Reporting Guidelines and Standards](/BI-Team/Documentation-%2D-Analysts/Report-Creation/Reporting-Standards)
  - Compliance with [Requirements and Acceptance Criteria](/BI-Team/Documentation-%2D-Analysts/Requirements-Gathering)
  - Overall user experience and intuitiveness.
</details>

<details><summary><b>Pre-Release Preparations</b></summary><br>

- Finalize all visuals and data connections.
- Ensure all measures and calculations are correct.
- Review and update any necessary documentation.
- Prepare a changelog if updating an existing report.
- Create or update user guides if needed.
</details>

<details><summary><b>Stakeholder Sign-Off</b></summary><br>

- Present the final version to key stakeholders.
- Address any last-minute concerns or change requests.
- Obtain formal approval from the project owner or designated approver.
</details>

<details><summary><b>Preparing for Release</b></summary><br>

- Conduct a final review of the report in the Testing workspace.
- Ensure all data refreshes correctly.
- Verify that security and access settings are configured properly.
- Prepare the release notes detailing new features, changes, and any known issues.
</details>

<details><summary><b>Report Creation Process Checklist</b></summary><br>

- [ ] Create a GIT branch for the new report.
- [ ] Connect to the Production dataset or publish to your testing workspace.
- [ ] Develop the report, following guidelines and criteria.
- [ ] Update stakeholders and gather feedback.
- [ ] Conduct quality assurance and peer review.
- [ ] Finalize visuals, measures, and documentation.
- [ ] Obtain stakeholder approval.
- [ ] Perform final review, check data refresh and security.
- [ ] Ensure the report is ready for release.

</details>

<details><summary><b>Ready to Release</b></summary><br>

At this point, your report should be fully tested, approved, and ready for the [report release process](https://dev.azure.com/EmergeAotearoa/Data%20and%20Analytics/_wiki/wikis/Data-and-Analytics.wiki/72/Report-Release-Standard-Operating-Procedure).
</details>


<details><summary><b>Report Creation Process Flow</b></summary><br>

::: mermaid
graph TD
    A(Start New Report<br>Use GIT Template) --> B[Connect to Dataset]
    B --> C[Initial Report Development]
    C --> D[Iterative Development and Feedback]
    D --> E[Quality Assurance and Testing]
    E --> F[Pre-Release Preparations]
    F --> G[Stakeholder Sign-Off]
    G --> H[Preparing for Release]
    H --> I(Ready to Release)

    %% Feedback Loops
    D -->|Feedback Received| C
    E -->|Issues Found| D
    F -->|Major Issues| C
    G -->|Not Approved| D
    H -->|Last-Minute Changes| F

    %% Dataset Changes
    B -.->|Dataset Changes| C

    %% Colors
    style A fill:#32CD32,stroke:#000,stroke-width:1px
    style I fill:#1E90FF,stroke:#000,stroke-width:1px
    style B fill:#FFFAE3,stroke:#000,stroke-width:1px
    style C fill:#FFFACD,stroke:#000,stroke-width:1px
    style D fill:#FAFAD2,stroke:#000,stroke-width:1px
    style E fill:#FFEFD5,stroke:#000,stroke-width:1px
    style F fill:#FFDAB9,stroke:#000,stroke-width:1px
    style G fill:#FFDEAD,stroke:#000,stroke-width:1px
    style H fill:#FFB6C1,stroke:#000,stroke-width:1px
:::

</details>
