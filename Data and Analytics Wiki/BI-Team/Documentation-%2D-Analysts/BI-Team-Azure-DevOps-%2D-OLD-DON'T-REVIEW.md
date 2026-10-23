## Introduction

This wiki provides guidance on how the Business Intelligence (BI) team uses Azure DevOps to manage Features and User Stories in our Agile development process. It is designed to help new and existing team members understand our practices and ensure consistency in our work.

## Features in Azure DevOps

<details>
<summary><b>What is a Feature?</b></summary>

A Feature in Azure DevOps represents a significant piece of functionality that delivers value to our staff, stakeholders, or indirectly supports tāngata whaiora (service users). Features can span multiple sprints and are composed of related User Stories and tasks.

Examples include:
- Comprehensive reports
- Datasets
- Dashboards that support service delivery or operational efficiency
</details>

<details>
<summary><b>Creating a Feature</b></summary>

1. Use the Feature template provided in Azure DevOps.
2. Populate the template with the following information:
   - Clear, concise title
   - Description of overall functionality and how it supports our goals
   - High-level acceptance criteria
   - Start date and estimated end date
   - Known dependencies or constraints
3. Use the itemized description section in the Feature template as a guide for creating User Stories. This section will contain pre-populated items that can be used as ideas to create User Stories or as prompts to use existing User Story templates.
4. Work with the Scrum Master to parent the Feature to the appropriate Epic. This ensures proper organization and alignment with broader strategic objectives.

**Best Practices:** 
- Ensure that the Feature description is comprehensive enough to give a clear overview of the project without needing to refer to external documents.
- When discussing the Epic with the Scrum Master, make sure you understand how your Feature fits into the larger strategic context.
- If you're unsure which Epic your Feature should be parented to, always consult with the Scrum Master for guidance.
- Use the itemized description in the Feature template as a starting point, but feel free to add, modify, or remove items to best fit the specific needs of your Feature.
</details>

<details>
<summary><b>Feature Example</b></summary>

```
Title: Service Outcomes Dashboard

Description: Create a comprehensive dashboard that provides insights into the outcomes of our services across all regions. This will allow service managers to make informed decisions, identify areas for improvement, and demonstrate the impact of our work to stakeholders and funders.

Acceptance Criteria:
- Display key outcome metrics (e.g., tāngata whaiora satisfaction, recovery progress, engagement rates) by region
- Include year-over-year comparison to track long-term impact
- Provide drill-down capability to individual service types
- Implement row-level security to ensure data privacy

Start Date: [Date] Estimated End Date: [Date]

Itemized Description (for User Story creation):
1. Data Integration
2. Data Modeling
3. Visualization Development
4. Security Implementation
5. Performance Optimization
6. User Training and Documentation

Epic: [To be determined with Scrum Master]
```
</details>

## User Stories in Azure DevOps

<details>
<summary><b>What is a User Story?</b></summary>

A User Story in Azure DevOps is a smaller, more granular piece of work that contributes to the completion of a Feature. It is written from the perspective of the end-user (e.g., support worker, service manager) and focuses on a specific aspect of functionality that supports our mission.
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
5. Create tasks within the User Story to capture specific work items. These tasks are where actual time spent will be recorded.

**Best Practice:** Ensure that User Stories are small enough to be completed within a single sprint, but large enough to deliver tangible value. While User Stories may have high-level estimates, detailed time tracking occurs at the task level.
</details>

<details>
<summary><b>User Story Example</b></summary>

```
Title: Regional Outcome Metrics Display

As a service manager,
I want to see a breakdown of tāngata whaiora outcomes by program type and region
so that I can identify which interventions are most effective in supporting recovery journeys across different areas.

Acceptance Criteria:
- Display a bar chart of outcomes by program type for each region
- Allow filtering by date range and service region
- Show percentage of tāngata whaiora achieving positive outcomes in each program
- Implement tooltips with detailed information on hover
- Ensure all data is anonymized to protect tāngata whaiora privacy

Tasks:
1. Design bar chart layout
2. Create filtering functionality
3. Develop tooltip information display
4. Implement data anonymization process
5. Perform unit testing

Note: Estimated time and actual time spent will be recorded for each task.
```
</details>

## Best Practices for Using Azure DevOps

<details>
<summary><b>Linking Work Items</b></summary>

- Always link User Stories to their parent Feature.
- Link related User Stories to each other when there are dependencies.
- Use the "Related" link type for general associations and "Predecessor-Successor" for sequential dependencies.

**Why it's important:** Proper linking provides a clear hierarchy and helps in tracking overall project progress.
</details>

<details>
<summary><b>Using Tags</b></summary>

- Use tags to categorize work items for easy filtering and reporting.
- Establish a consistent set of tags across the team (e.g., "high-priority", "technical-debt", "quick-win").

**Why it's important:** Tags facilitate quick identification of work item types and aid in generating reports.
</details>

<details>
<summary><b>Estimating Work and Tracking Time</b></summary>

- Provide high-level estimates for Features in hours, considering the total effort required for completion.
- Break down User Stories into specific tasks.
- Estimate each task in hours, representing the expected effort to complete the work.
- Record actual time spent on tasks. This is where detailed time tracking occurs.
- Regularly update the remaining work on tasks to reflect progress.

**Why it's important:** Accurate task-level estimations and time tracking help in sprint planning, capacity management, and provide insights for future estimations. It also allows for more precise project tracking and reporting.
</details>

<details>
<summary><b>Updating Work Item Status</b></summary>

- Regularly update the status of Features, User Stories, and tasks to reflect their current state.
- Use the following statuses consistently:
  - New: Work item has been created but not yet started
  - Active: Work is currently in progress
  - Resolved: Work is completed and ready for review
  - Closed: Work has been reviewed and accepted

**Why it's important:** Up-to-date statuses provide real-time visibility into project progress and help identify bottlenecks.
</details>

<details>
<summary><b>Documenting Work Done</b></summary>

- Use attachments to add relevant documents to Features and User Stories. For example, attach signed-off acceptance criteria documents that enable the start of work on a Feature.
- Use the Description field in Features and User Stories to provide comprehensive information about the work to be done, progress, and any important notes.
- Use the Discussion section for important decisions, clarifications, or updates on the work's progress.
- When closing a Feature or User Story, ensure all relevant documentation is attached or linked, including final reports, test results, or user guides as appropriate.

**Why it's important:** Proper documentation ensures that all team members have access to necessary information and context, facilitates knowledge transfer, and provides a clear record of decisions and deliverables.
</details>

## Need Help?

If you have any questions about using Azure DevOps, need clarification on our processes, or have suggestions for improvement, please contact our Scrum Master. They are here to support you and ensure we're using Azure DevOps effectively to deliver value to our stakeholders and tāngata whaiora.