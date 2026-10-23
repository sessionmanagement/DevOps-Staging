# Standard Operating Procedure for Power BI Report Release

This SOP outlines the process for releasing Power BI reports, ensuring quality, compliance, and effective communication throughout the release cycle. It is designed to be followed by new starters and experienced team members alike, providing clear steps and guidance for each stage of the release process.

Throughout this document, we use a "T-day" notation to standardize the release timeline:
- T-day represents the actual day of release
- Negative numbers (e.g., T-4 weeks) indicate time before the release
- Positive numbers (e.g., T+1 week) indicate time after the release

This system helps team members quickly understand where they are in the process and what needs to be done next, regardless of specific calendar dates for a particular release.

<details>
<summary><b>Pre-Release Planning (T-4 weeks)</b></summary><br>

a. Identify Subject Matter Expert (SME)
- This should already be identified during report creation/Requirements Gathering steps.

b. Develop communications plan with SME/data owner
- Draft email templates for different audience levels.
- Create presentation materials for hui/meetings.

c. Determine release schedule and audience levels
- Identify initial audience (SME, Regional Managers, Exec).
- Plan staggered release schedule if applicable (RM → DM → SM).
- Allow up to 4 weeks between each level of release (decided with SME/RM).

d. Set up test audience with it's own test dashboard within Te Pātaka (delete after testing)
- Identify key individuals for soft release.
- A test audience can be created in the Te Pātaka app/workspace, set up purely for testing a particular report and dataset with a particular set of people at different levels to ensure Row-Level Security (RLS) works before it goes into the main/wider audience.
- Test the visuals in a copy of a dashboard with the new KPI's if needed.

</details>

<details><summary><b>Soft Release and Testing (T-3 weeks)</b></summary><br>

a. Release to test audience
- Grant access to test environment in the Te Pātaka app/workspace.
- Provide clear instructions and feedback channels.

b. Verify report functionality, KPI visuals, and RLS
- Test all interactive elements and filters.
- Confirm RLS is working as intended for different user roles.
- Verify KPI visuals display correctly on dashboards.

c. Make necessary adjustments based on feedback
- Collate and prioritize feedback.
- Implement changes and retest as needed.
- Document sign-off from the test audience (process to be determined).
</details>

<details><summary><b>CAB Approval (T-2 weeks)</b></summary><br>

a. Submit detailed CAB request
- Include results from soft release and testing.
- Provide risk assessment and rollback plan.
- [New change | Pae Āwhina (Service Desk)](https://servicedesk.emergeaotearoa.org.nz/a/changes/new)

b. Present to CAB if required.

c. Obtain formal CAB approval before proceeding.
</details>

<details><summary><b>Release Preparation (T-1 week to T-day)</b></summary><br>
a. Set and recheck RLS for the target audience(s)
- Configure RLS in Power BI.
- Test RLS with sample users from each role.

b. Pin relevant KPIs to dashboards
- Add new KPI visuals to appropriate dashboard sections from the Te Pātaka report added into the Te Pātaka app.
- Ensure visuals are pinned from the same workspace the report and app are contained in.

c. Update Te Pataka app with new pinned visuals
- Ensure all new visuals are correctly displayed.

d. Check mobile view of dashboards
- Verify layout and functionality on mobile devices.

e. Update "What's New?" page in Te Pataka
- Add concise description of new report and features.
- Include any necessary user instructions.
- Update through GIT in the same fashion as any other report.

f. Check report to ensure data is masked or obscured where necessary
- Ensure no unnecessary data is shown.
- Verify all data is properly locked down.
</details>

<details><summary><b>Communication and Training (T-1 week to T-day)</b></summary><br>

a. Send initial communication one week before release
- Use pre-approved email template (Example in OneDrive - Data and Analytics\_New Structure\Documentation\Processes and Procedures).
- Include date and time of upcoming hui/meeting.
- Coordinate with SME on who will send the communication.

b. Schedule and conduct hui/meeting with affected users
- Prepare demonstration of new report.
- Allow time for Q&A.

c. For SM level audience, schedule two 45-60 minute sessions
- Coordinate times to accommodate 200+ attendees.
- Record session for those unable to attend live.
</details>

<details><summary><b>Pre release checklist</b></summary><br>

- [ ] All testing completed, any issues resolved, and signed off by the report owner.
- [ ] Update Reporting Catalogue.
- [ ] Ensure all measures are included in the Measures Definition, or linked to another location, with an owner/role assigned, adding link and page into the report.
- [ ] Create article and video supporting how to use the report, preferably within Pae Awhina, add link into report.
- [ ] RLS configured and tested, including ensuring any Additional Access functionality and/or kaimahi have been added.
- [ ] Create a release plan with the report owner and any SME's to ensure the report is rolled out to the Business with adequate support.
- [ ] CAB approval obtained.
- [ ] Reports added to correct audiences.
- [ ] KPIs pinned to dashboards.
- [ ] Mobile view checked.
- [ ] "What's New?" page updated.
- [ ] Privacy Act compliance confirmed.
- [ ] Initial communication sent (Example in OneDrive - Data and Analytics\_New Structure\Documentation\Processes and Procedures)
- [ ] Hui/meeting scheduled/conducted.
- [ ] Gain sign off from Stakeholder and document in DevOps user story/feature.
- [ ] Ensure the Support Desk have sufficient information to help them triage tier 1 support queries.
- [ ] Develop handover documentation for sharing with other Data & Analytics members to enable the Team to provide ongoing support, and review within the team.
</details>

<details>
<summary><b>Official Release (T-day)</b></summary><br>

a. Publish the report to Production
- Ensure the report is from the main area in GIT.
- Download a copy of the PBIX file from the production workspace.
- Ensure the downloaded file has exactly the same name as the original.
- Upload the PBIX report into Te Pātaka, approving overwrite when prompted.
- Go into the app and click on "Update app".

b. If a new report is uploaded:
- Enable content and set for relevant audiences within the Te Pātaka app.

c. If an existing report is uploaded:
- Verify that the Mobile app view is still set correctly.
- Confirm that pinned visuals are still the same in any dashboards.

d. Grant access to the target audience
- Update user permissions in Power BI and Te Pātaka.

e. Conduct final checks on live environment
- Ensure all pinned visuals and RLS are functioning correctly.
- If an issue or bug is found prioritize and refer to the testing/bug prioritization documentation

f. Send release confirmation email
- Include links to new report and support resources.
</details>

<details><summary><b>Post-Release Monitoring (T+1 week to T+4 weeks)</b></summary><br>

a. Monitor for any issues or feedback
- Utilize existing feedback channels:
  - Report feedback page within the Te Pātaka app.
  - Email/Pae Awhina.
- Actively monitor usage statistics.
- Address any urgent issues immediately.

b. Plan for next level of release (if applicable)
- Begin process for next audience level.
- Maintain a 4-week gap between sequential releases.
- Use this time for monitoring, adjustments, and preparation.
</details>
<details><summary><b>Version Control and Documentation</b></summary><br>

a. Document lessons learned and process improvements
- Compile feedback and observations from the release process.

b. Update SOP if necessary based on experience
- Discuss potential SOP improvements during quarterly analyst catch-up meetings.
- Review and approve changes before implementing.
</details>
<details><summary><b>Scheduling and Tracking System</b></summary><br>

To manage the schedule and track progress, use a combination of a the white board near our B.I space and a project management tool:

a. White Board (Currently being developed):
- Keep updated on back side of white board upcoming/current releases with dates.
- Go over during regular standups.
- Tie-in with Sprints/Scrum Master.

b. DevOps Board (Currently being developed)
- Create a board with swimlanes for each stage of the process.
- Use cards for each report, moving them through the lanes as they progress.
- Include checklists on cards for key tasks within each stage.
- Assign

</details>

## SOP Workflow Diagram

<details>
<summary>Click to expand</summary>

::: mermaid
graph TD
    classDef default fill:#f9f9f9,stroke:#333,stroke-width:2px;
    classDef highlight fill:#e1f5fe,stroke:#01579b,stroke-width:3px;
    classDef milestone fill:#fff59d,stroke:#fdd835,stroke-width:3px;

    A[Report Development and Initial Review] -->|T-4 weeks| B(Pre-Release Planning)
    B --> C(Soft Release and Testing)
    C -->|T-2 weeks| D{CAB Approval}
    D -->|Approved| E(Release Preparation)
    D -->|Not Approved| C
    E --> F(Communication and Training)
    F -->|T-day| G[Official Release]
    G --> H(Post-Release Monitoring)

    class A,G milestone;
    class B,C,D,E,F,H highlight;

    subgraph "Continuous Processes"
        I(Version Control and Documentation)
        J(Scheduling and Tracking System)
    end

    style I fill:#e8f5e9,stroke:#43a047,stroke-width:2px
    style J fill:#e8f5e9,stroke:#43a047,stroke-width:2px

    G --> I
    G --> J
:::
</details>

