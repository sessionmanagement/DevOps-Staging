# Standard Operating Procedure (SOP)
# Data and Report Issue Management
## Business Intelligence Team

### Document Control
- Document Owner: Business Intelligence Team
- Version: 1.1
- Last Updated: 22/07/2025
- Review Frequency: Quarterly

## 1. Purpose and Scope
This SOP provides structured guidelines for identifying, assessing, and resolving issues within the BI environment, encompassing:
- BI space (reports and semantic models)
- Data level (both EDW and ODS)
- Data pipelines and transformations
- Data quality and consistency issues

All processes and procedures in this document apply equally to both EDW and ODS environments.

## 2. Roles and Responsibilities

### Bug Master
- **Primary owner for initial communication to stakeholders**
- Rotating role for each sprint duration
- Reviews and triages all incoming issues
- Ensures proper assignment and classification
- Coordinates with Lead roles for issue resolution
- Maintains issue tracking and communication
- Participates in sprint handover meeting to transfer active issues
- Creates Pae Awhina tickets for issues not originating from existing tickets

### Scrum Master
- **Secondary communication owner (escalation from Bug Master)**
- Facilitates cross-team coordination
- Ensures sprint commitments are adjusted for critical issues
- Supports Bug Master in communication efforts

### BI Manager
- **Tertiary communication owner (escalation from Scrum Master)**
- Final escalation point for communication
- Approves external stakeholder communications
- Provides strategic direction for major incidents

### Lead Data Analyst
- Primary owner for report and semantic model issues
- Responsible for Power BI service investigation
- Provides technical updates to Bug Master for stakeholder communication
- Leads issue resolution for BI space problems

### Lead Data Engineer
- Primary owner for data pipeline, EDW, and ODS issues
- Responsible for Azure Data Factory and Synapse investigation
- Manages data quality and refresh processes
- Provides technical updates to Bug Master for stakeholder communication
- Leads issue resolution for data level problems

Note: While the Bug Master coordinates issue management, critical issues can and should be raised by any team member who identifies them.

## 3. Issue Severity Levels
### Level 1 (Critical)
- Complete system outage or data corruption
- Incorrect financial or client data affecting decision-making
- Security breaches or data privacy violations
- Business-critical reports unavailable during peak periods

### Level 2 (High)
- Partial system functionality issues
- Data quality issues affecting multiple reports
- Performance degradation impacting multiple users
- Delayed data refreshes affecting daily operations

### Level 3 (Medium)
- Minor data discrepancies
- Single report issues
- Non-critical performance issues
- Isolated data refresh delays

## 4. Initial Response and Investigation
### 4.1 Issue Receipt and Classification
1. Any team member who identifies an issue:
   - Posts initial notification in BI Teams Chat
   - Creates Pae Awhina ticket if issue did not originate from an existing ticket (e.g., pipeline failure alert)
   - Creates new work item in Azure DevOps:
     - Work Item Type: Bug
     - Title: Clear description of the issue
     - Repro Steps: Detailed steps to reproduce
     - Area Path: Data and Analytics\Business Intelligence
     - Iteration: Current sprint
     - Severity: Based on assessment
     - Priority: Based on business impact
     - Tags: Include relevant system components (e.g., "Power BI", "ADF", "Synapse", "EDW", "ODS")
     - Associated reports/pipelines: Links to affected components
     - Pae Awhina Ticket #

2. Bug Master (current sprint):
   - Reviews initial notification
   - Confirms issue classification
   - Ensures Pae Awhina ticket exists or creates one if needed
   - Assigns to appropriate lead:
     - BI Space Issue → Lead Data Analyst
     - Data Level Issue (EDW/ODS) → Lead Data Engineer
     - Combined Issue → Joint ownership

### 4.2 Initial Investigation
#### For BI Space Issues:
1. Verify report refresh status
2. Check semantic model processing
3. Validate DAX/M code
4. Review security settings

#### For Data Level Issues:
1. Review Azure Data Factory pipeline runs
2. Check Synapse query logs
3. Validate source data in EDW/ODS
4. Verify data pipeline transformation logic
5. Check Azure service health status
6. Verify data consistency between ODS and EDW
7. Check for any blocked or long-running queries

### 4.3 Time-Based Trigger
- If issue remains unresolved by 8:30 AM:
  1. Initiate communication process
  2. Begin escalation procedures
  3. Post status update in BI Teams Chat

## 5. Communication and Escalation

### 5.1 Communication Ownership Chain
Bug Master → Scrum Master → BI Manager

Each level is responsible for ensuring appropriate communication occurs. Escalation to the next level occurs when:
- Communication requires broader organizational reach
- Issue severity increases
- Resolution timeline extends beyond initial estimates
- Strategic decisions are required

### 5.2 Communication Process
#### Initial Issue Notification Email Template
```
Subject: [Report/System Name] – [Issue Status]

[Report/System Name] – [Brief Issue Description]

Description
We have been alerted [when discovered] that [clear description of the issue and root cause if known]. As a result, [specific impact on users/reports/data].

We are actively working on a solution and expect this issue to be resolved by [realistic timeframe]. We will provide an update as soon as we know more.

Thank you for your patience, and we apologise for any inconvenience this may cause.

When did it start?
[Specific date and time]

Who is impacted?
[Specific user groups, reports, or systems affected]
```

#### Resolution Notification Email Template
```
Subject: [Report/System Name] – Data Accurate Again

[Report/System Name] – Data Up To Date

Description
We have resolved the issue impacting [specific reports/systems affected], and [reports/systems] are now showing the expected data.

When did it occur?
[Start time], [Date] - [End time], [Date]

Who was impacted?
[Specific user groups, reports, or systems that were affected]
```

#### Update Notification Email Template (if needed)
```
Subject: UPDATE: [Report/System Name] – [Current Status]

[Report/System Name] – Status Update

Description
This is an update regarding the [issue description] reported earlier.

Current Status:
[Clear description of current state and progress made]

Next Steps:
[What is being done next]

Expected Resolution:
[Updated timeframe if changed]

Who is impacted?
[Any changes to impact scope]

We appreciate your continued patience as we work to resolve this issue.
```

### 5.3 Escalation Triggers
For all levels:
1. Post initial notification in BI Teams Chat
2. Update Teams Chat with investigation findings
3. Maintain regular status updates
4. Bug Master sends initial stakeholder communication
5. Escalate communication ownership as needed

Additional triggers:
- Level 1: Immediate escalation to BI Manager
- Level 2: Escalation to BI Manager after 2 hours without resolution
- Level 3: Escalation to BI Manager if unresolved within 1 business day

### 5.4 Escalation Path
Technical Escalation:
1. BI Analyst/Developer
2. Lead Data Analyst/Engineer
3. BI Manager

Communication Escalation:
1. Bug Master
2. Scrum Master
3. BI Manager

## 6. Resolution Process
### 6.1 Implementation Steps
1. Develop solution plan
2. Create backup if needed
3. Test fix in development environment
4. Implement solution
5. Verify resolution
6. Document all changes
7. Update Pae Awhina ticket with resolution

### 6.2 Validation Steps
1. Data Fixes Testing:
   - Verify data accuracy in both EDW and ODS
   - Check data consistency across systems
   - Validate transformation logic
   - Confirm pipeline completion
   - Verify downstream impact

2. Report Fixes Testing:
   - Test with sample data
   - Verify calculations
   - Check parameter functionality
   - Validate security roles
   - Test performance under load

3. General Validation:
   - Verify data accuracy
   - Test affected reports
   - Confirm with end users
   - Monitor for recurring issues
   - Document test results in Azure DevOps

## 7. Documentation Requirements
### 7.1 Issue Record (Azure DevOps)
- Bug ID and full description
- Pae Awhina ticket reference
- Timeline in discussion comments
- Actions taken (documented in updates)
- Root cause analysis attachment
- Resolution details
- Affected systems (tagged)
- Business impact assessment
- Related work items or pull requests
- Communication log (who was notified, when, and by whom)

### 7.2 Post-Resolution Documentation
- Complete resolution summary
- Updated documentation if needed
- Recommendations for prevention
- Lessons learned
- Follow-up actions
- Close Pae Awhina ticket with resolution details

## 8. Post-Incident Review
### 8.1 Review Meeting
- Schedule within 48 hours for Level 1
- Within 1 week for Level 2
- Monthly review for Level 3

### 8.2 Review Components
1. Incident timeline
2. Root cause analysis
3. Resolution effectiveness
4. Communication assessment
5. Process improvement opportunities
6. Preventive measures
7. Communication ownership effectiveness

## 9. Quality Assurance
### 9.1 Regular Audits
- Monthly review of issue logs
- Quarterly process assessment
- Annual SOP review
- Pae Awhina ticket compliance check

### 9.2 Metrics Tracking
- Resolution time by severity
- First response time
- Escalation frequency
- Recurring issues
- User satisfaction
- Communication timeliness and effectiveness

## 10. Pae Awhina Ticket Management
### 10.1 When to Create a Ticket
Create a Pae Awhina ticket when:
- Issue is discovered outside of existing ticket work
- User reports an issue directly
- Monitoring alerts identify a problem
- During routine checks or audits

### 10.2 Ticket Information Required
- Clear issue description
- Business impact
- Affected systems/reports
- Priority/Severity
- Azure DevOps Bug ID (once created)
- Expected resolution timeframe

## 11. Change Log

<details>
<summary><b>Version 1.1 - July 22, 2025</b></summary>

#### Major Changes

**1. Communication Ownership Structure**
- Added formal communication ownership chain: Bug Master → Scrum Master → BI Manager
- Defined clear escalation criteria for communication ownership
- Made Bug Master the primary owner for initial stakeholder communication

**2. Pae Awhina Ticket Management**
- Added new Section 10 for comprehensive Pae Awhina ticket management
- Defined when to create tickets for issues not originating from existing tickets
- Added requirement to include Pae Awhina ticket reference in Azure DevOps bugs
- Specified ticket information requirements and closure procedures

**3. Email Communication Templates**
- Replaced generic notification templates with specific, detailed templates based on actual business communications
- Added three comprehensive templates:
  - Initial Issue Notification Email Template
  - Resolution Notification Email Template  
  - Update Notification Email Template (new)
- Updated templates to use more professional formatting and clear structure

**4. Escalation Process Updates**
- Removed CIO from all escalation paths
- Simplified Level 1 escalation to go directly to BI Manager
- Updated technical escalation path to end at BI Manager level

#### Role Updates

**5. Bug Master Role**
- Elevated as primary communication owner
- Added responsibility for creating Pae Awhina tickets
- Added responsibility for ensuring Pae Awhina ticket compliance

**6. Scrum Master Role**
- Defined as secondary communication owner
- Added specific communication escalation responsibilities

**7. BI Manager Role**
- Defined as tertiary communication owner
- Clarified as final escalation point for all severity levels

#### Process Improvements

**8. Documentation Requirements**
- Added requirement to track communication log in Azure DevOps
- Added Pae Awhina ticket reference as mandatory field
- Enhanced post-resolution documentation requirements

**9. Quality Assurance Updates**
- Added Pae Awhina ticket compliance check to regular audits
- Added communication timeliness and effectiveness to metrics tracking

**10. Post-Incident Review**
- Added communication ownership effectiveness as review component

#### Minor Updates
- Updated document version to 1.1
- Added current date (22/07/2025) to document control
- Improved formatting consistency throughout document
- Clarified language around issue discovery and reporting
- Enhanced clarity of investigation steps for both BI Space and Data Level issues

#### Removed Elements
- CIO role completely removed from escalation procedures
</details>