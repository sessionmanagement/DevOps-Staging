## Introduction

This wiki provides guidance on how the Business Intelligence (BI) team uses Azure DevOps to manage work items in our Agile development process within the **Data and Analytics** project. It reflects our workflow structure: **Theme > Initiative > Epic > Feature > User Story > Task**. This guide is designed to help new and existing team members understand our practices and ensure consistency in our work.

Our work item hierarchy consists of six levels:
- **Themes**: Strategic groupings representing portfolios or high-level business objectives
- **Initiatives**: Major programs or significant undertakings under a Theme
- **Epics**: Large bodies of work delivering substantial value
- **Features**: Significant functionality contributing to an Epic
- **User Stories/Bugs**: Granular work items from the end-user perspective
- **Tasks**: Specific units of work for time tracking

## Themes in Azure DevOps

<details>
<summary><b>What is a Theme?</b></summary>

A Theme in Azure DevOps represents the highest level of our work item hierarchy. Themes are strategic groupings that represent portfolios, business objectives, or major organisational priorities. They provide a way to categorise and align all work to high-level business goals.

Examples include:
- Data Platform Modernisation
- Operational Excellence
- Regulatory Compliance and Reporting
- Tāngata Whaiora Outcomes Improvement
</details>

<details>
<summary><b>Creating a Theme</b></summary>

1. Use the Theme template provided in Azure DevOps.
2. Populate the template with the following information:
   - Clear, strategic title that reflects the business objective
   - Description of the strategic goal and how it aligns with organisational priorities
   - Business value and expected outcomes
   - Timeframe (Themes typically span multiple quarters or years)
   - Key stakeholders and sponsors
3. Themes are typically created by senior leadership or in collaboration with the Scrum Master.

**Best Practices:**
- Keep the number of active Themes manageable (typically 3-7 at any time).
- Ensure Themes align with the organisation's strategic plan and annual goals.
- Review Themes periodically to ensure they remain relevant.
</details>

<details>
<summary><b>Theme Example</b></summary>

```
Title: Data Platform Modernisation

Description: Transform our data infrastructure to enable faster, more reliable,
and more accessible analytics capabilities across the organisation. This Theme
encompasses all work related to modernising our data platform, improving data
quality, and enabling self-service analytics.

Business Value: High - Enables data-driven decision making across all service
areas, reduces time-to-insight, and supports regulatory reporting requirements.

Timeframe: FY2024 - FY2025
Stakeholders: Executive Leadership Team, Service Managers, Finance
Sponsor: Chief Information Officer

Child Initiatives:
- Enterprise Data Warehouse Enhancement
- Data Quality Framework Implementation
- Self-Service Analytics Enablement
```
</details>

## Initiatives in Azure DevOps

<details>
<summary><b>What is an Initiative?</b></summary>

An Initiative in Azure DevOps represents a major program or significant undertaking that contributes to achieving a Theme. Initiatives group related Epics together and typically span multiple months or quarters. They represent substantial investments of effort that deliver measurable business outcomes.

Examples include:
- Enterprise Data Warehouse Enhancement
- Power BI Report Modernisation Program
- API Integration Framework
- Data Governance Implementation
</details>

<details>
<summary><b>Creating an Initiative</b></summary>

1. Use the Initiative template provided in Azure DevOps.
2. Populate the template with the following information:
   - Clear, descriptive title that reflects the program scope
   - Description of the Initiative's goals and expected outcomes
   - High-level success criteria
   - Start date and target completion date
   - Budget or resource allocation (if applicable)
   - Key dependencies and risks
3. Link the Initiative to its parent Theme.
4. Attach relevant governance or approval documents.

**Best Practices:**
- Ensure the Initiative has clear, measurable outcomes.
- Break down Initiatives into 3-7 Epics for manageable delivery.
- Conduct regular Initiative-level reviews to track progress against goals.
- Consult with the Scrum Master for prioritisation and resource planning.
</details>

<details>
<summary><b>Initiative Example</b></summary>

```
Title: Enterprise Data Warehouse Enhancement

Description: Enhance the Enterprise Data Warehouse to support new data sources,
improve data quality, and enable faster reporting. This Initiative focuses on
expanding EDW capabilities to meet growing business analytics needs.

Success Criteria:
- Integrate 5 new data sources into EDW
- Achieve 99% data quality score on critical dimensions
- Reduce report refresh times by 50%
- Enable real-time dashboard updates for key operational metrics

Start Date: 2024-07-01
Target Completion Date: 2025-06-30

Parent Theme: Data Platform Modernisation

Key Dependencies:
- Azure infrastructure upgrades
- Source system API availability
- Data governance policy approval

Child Epics:
- Service Outcomes Dashboard
- Property Management Integration
- Financial Reporting Automation
- Data Quality Monitoring System
```
</details>

## Epics in Azure DevOps

<details>
<summary><b>What is an Epic?</b></summary>

An Epic in Azure DevOps represents a large body of work that delivers substantial value to our staff, stakeholders, or supports tāngata whaiora. Epics are linked to a parent Initiative and can span multiple sprints or even months. They are typically created from incoming requests or as part of a planned Initiative.

Examples include:
- Comprehensive dashboards
- New data integration projects
- Major system enhancements
</details>

<details>
<summary><b>Creating an Epic</b></summary>

1. Use the Epic template provided in Azure DevOps.
2. Populate the template with the following information:
   - Clear, concise title
   - Description of overall functionality and how it supports our goals
   - High-level acceptance criteria
   - Start date and target date for the entire delivery project
   - Priority (as determined by the Report Prioritisation Group - RPG)
   - Business value
   - Known dependencies or constraints
3. Link the Epic to its parent Initiative.
4. Attach relevant signed-off documents to the Epic.

**Best Practices:**
- Ensure that the Epic description provides a comprehensive overview of the project.
- Ensure the Epic aligns with the goals of its parent Initiative.
- Consult with the Scrum Master if you're unsure about any aspect of Epic creation or prioritization.
</details>

<details>
<summary><b>Epic Example</b></summary>

```
Title: Service Outcomes Dashboard

Description: Create a comprehensive dashboard that provides insights into the outcomes
of our services across all regions.
This will allow service managers to make informed decisions, identify areas for improvement,
and demonstrate the impact of our work to stakeholders and funders.

Acceptance Criteria:
- Display key outcome metrics (e.g., tāngata whaiora satisfaction, recovery progress, engagement rates) by region
- Include year-over-year comparison to track long-term impact
- Provide drill-down capability to individual service types
- Implement row-level security to ensure data privacy

Start Date: 2024-08-15
Target Completion Date: 2024-12-31
Priority: High (as determined by RPG)
Business Value: High - Will provide crucial insights for service improvement and stakeholder reporting

Parent Initiative: Enterprise Data Warehouse Enhancement
Parent Theme: Data Platform Modernisation

Attachments:
- Signed Requirements Document.pdf
- Stakeholder Approval Form.pdf
```
</details>

## Features in Azure DevOps

<details>
<summary><b>What is a Feature?</b></summary>

A Feature in Azure DevOps represents a significant piece of functionality that contributes to the completion of an Epic. Features are typically aligned with different phases or aspects of the project.

Standard Features often include:
1. Requirements Gathering
2. Development (if needed)
3. Power BI Semantic Model Creation
4. Report Generation

Additional Features may be created as needed, such as Bug Fixing.
</details>

<details>
<summary><b>Creating a Feature</b></summary>

1. Use the Feature template provided in Azure DevOps.
2. Populate the template with the following information:
   - Clear, concise title
   - Description of the Feature's purpose and scope
   - Acceptance criteria specific to the Feature
   - Start date and estimated end date
   - Known dependencies or constraints
3. Link the Feature to its parent Epic.
4. Attach relevant documents specific to the Feature (e.g., data testing documents for EDW-level work).

**Best Practices:** 
- Ensure that the Feature aligns with the overall goals of the parent Epic.
- Use the standard Feature types when applicable, but don't hesitate to create custom Features if needed.
- If a Feature relates to work in other Epics, use the "Related" link type to connect them.
</details>

<details>
<summary><b>Feature Examples</b></summary>

```
1. Requirements Gathering
   Description: Conduct wireframing with the requestor, identify data sources (EDW, ODS, or external),
and document detailed requirements.

2. Development (if needed)
   Description: Implement data flow from API to data landing area,
perform necessary transformations for ODS integration, and model data for EDW integration.

3. Power BI Semantic Model Creation
   Description: Perform data transformations, rename columns for user-friendliness,
create measures and relationships to satisfy reporting needs and enable access as a promoted semantic model.

4. Report Generation
   Description: Create report pages, implement visuals, and finalize the report based on
requirements and user feedback.
```
</details>

## User Stories in Azure DevOps

<details>
<summary><b>What is a User Story?</b></summary>

A User Story in Azure DevOps is a smaller, more granular piece of work that contributes to the completion of a Feature. It is written from the perspective of the end-user and focuses on a specific aspect of functionality.
</details>

<details>
<summary><b>Creating a User Story</b></summary>

1. Use the User Story template provided in Azure DevOps.
2. Follow this format: 
   ```
   As a [type of user],
   I want [an action]
   so that I can [benefit/value aligned with our team's goals].
   ```
3. Include acceptance criteria that define the conditions for the User Story to be considered complete.
4. Link the User Story to its parent Feature.
5. Create at least one Task within the User Story for time tracking.

**Best Practice:** Ensure that User Stories are small enough to be completed within a single sprint, but large enough to deliver tangible value.
</details>

<details>
<summary><b>User Story Example</b></summary>

```
Title: Implement Regional Outcome Metrics Display

As a service manager,
I want to see a breakdown of tāngata whaiora outcomes by program type for each region
so that I can identify which interventions are most effective in supporting recovery journeys across different areas.

Acceptance Criteria:
- Display a bar chart of outcomes by program type for each region
- Allow filtering by date range and service region
- Show percentage of tāngata whaiora achieving positive outcomes in each program
- Implement tooltips with detailed information on hover
- Ensure all data is anonymized to protect tāngata whaiora privacy

Parent Feature: Report Generation
Linked Epic: Service Outcomes Dashboard
```
</details>

## Tasks in Azure DevOps

<details>
<summary><b>What is a Task?</b></summary>

A Task in Azure DevOps represents a specific unit of work required to complete a User Story. Tasks are primarily used for time tracking in our process.
</details>

<details>
<summary><b>Creating a Task</b></summary>

1. Create at least one Task for each User Story.
2. Provide a clear, action-oriented title for the Task.
3. Estimate the hours required to complete the Task.
4. Record actual hours spent on the Task as work progresses.

**Best Practice:** While most User Stories will have one Task for time keeping, Business Analysts have the discretion to create multiple Tasks if it aids in better time management and tracking.
</details>

<details>
<summary><b>Task Example</b></summary>

```
Title: Develop Regional Outcome Metrics Bar Chart

Description: Create a bar chart in Power BI that displays tāngata whaiora outcomes by program type for each region.

Estimated Hours: 6
Actual Hours: 7.5

Parent User Story: Implement Regional Outcome Metrics Display

Status: Completed

Notes: 
- Initial development took 5 hours
- Additional 2.5 hours spent on implementing interactive tooltips and refining the visual design based on stakeholder feedback
```
</details>

## Best Practices for Using Azure DevOps

<details>
<summary><b>Linking Work Items</b></summary>

- Use Parent-Child relationships to link the full hierarchy: Themes > Initiatives > Epics > Features > User Stories > Tasks.
- Every Initiative should be linked to a parent Theme.
- Every Epic should be linked to a parent Initiative.
- Every Feature should be linked to a parent Epic.
- Every User Story should be linked to a parent Feature.
- Every Task should be linked to a parent User Story.
- Use the "Related" link type to connect Features that relate to work in other Epics.
- Use the "Related" link type to connect Initiatives or Epics that have cross-cutting dependencies.

**Why it's important:** Proper linking provides a clear hierarchy from strategic objectives (Themes) down to individual Tasks, enabling comprehensive progress tracking and portfolio management.
</details>

<details>
<summary><b>Estimating Work and Tracking Time</b></summary>

- Provide estimates at the Task level in hours.
- Record actual time spent on Tasks using Azure DevOps.
- Regularly update the remaining work on Tasks to reflect progress.

**Why it's important:** Accurate task-level estimations and time tracking help in sprint planning, capacity management, and provide insights for future estimations.
</details>

<details>
<summary><b>Documenting Work</b></summary>

- Attach strategic planning documents and business cases to Themes.
- Attach program governance and approval documents to Initiatives.
- Attach signed-off requirements documents to Epics.
- Attach feature-specific documents (e.g., data testing documents) to the relevant Feature.
- Use the Description field in all work items to provide comprehensive information.
- Use the Discussion section for important decisions, clarifications, or updates.

**Why it's important:** Proper documentation ensures that all team members have access to necessary information and context, facilitates knowledge transfer, and provides a clear record of decisions and deliverables.
</details>

## Need Help?

This wiki provides an overview of how our BI team uses Azure DevOps to manage Themes, Initiatives, Epics, Features, User Stories, and Tasks in the **Data and Analytics** project. If you have any questions about using Azure DevOps, need clarification on our processes, or have suggestions for improvement, please contact our Scrum Master. They are here to support you and ensure we're using Azure DevOps effectively to deliver value to our stakeholders and tāngata whaiora.