      

The proposed rules about client data obfuscation
================================================

           
1. Overall principles for prioritising dates
When multiple dates exist for the same type of interaction, use them in this order:
1.  **Use the “end/closure” date first** (discharge/end/relationship end), if it exists.
    *   This is usually the latest and most meaningful date for when that episode of care or interaction finished.
2.  **If no end/closure date, use the actual event or start date** (incident date, activity start date, referral received date, etc.).
    *   This shows when something genuinely happened with the client.
3.  **If neither end nor event/start date is available, use the created date** (when the record was entered).
    *   This is weaker evidence, but still an indication that some work was done.
4.  **Ignore purely planned dates (like “next review”) as interaction dates** unless your policy explicitly says otherwise.
    *   They are expectations, not proof an interaction occurred.
5.  **For each client, take the latest date across all interaction types**.
    *   That becomes their overall “Last Interaction Date” for obfuscation decisions.

* * *

2. Priority rules by interaction type
2.1 Activities (appointments, sessions, contacts)
For each activity:
**Priority order:**
1.  **Activity end date**
    *   If present, this is the best indicator of when the activity actually finished.
2.  **Activity start date**
    *   Use if there is no end date.
3.  **Activity created date / breakdown created date**
    *   Use only if both start and end dates are missing.

**Reasoning:**  
End > Start > Created. The end date is normally the latest; start is a real interaction if no end; created is a fallback.

* * *

2.2 Referrals and Goals
2.2.1 Referral episodes
For each referral, consider the full lifecycle:
**Priority order:**
1.  **Referral discharge date**
    *   Formal discharge from service.
2.  **Referral end date**
    *   Closure of that referral episode.
3.  **Responsible person/team relationship end date**
    *   End of responsibility for that client under this referral.
4.  **Referral accepted / declined date**
    *   Accepted: service took the case.
    *   Declined: decision made not to take the case.
5.  **Referral waitlist / pending date**
    *   Administrative states indicating the client was “in the system” but not necessarily being actively seen.
6.  **Referral received date**
    *   Initial receipt of the referral, if none of the above are present.
7.  **Referral created date**
    *   Fallback; used only if no other referral dates exist.

**Reasoning:**
*   End and discharge dates are the clearest “completion” points.
*   Relationship end indicates the end of active responsibility.
*   Accepted/declined and waitlist/pending indicate significant decisions or status changes.
*   Received and created are earlier, less definitive but still meaningful.
When computing a referral’s last interaction date, you would typically take the **latest date among discharge, end, relationship end, accepted/declined, waitlist/pending, received, created**.

* * *

2.2.2 Goals within referrals
For each goal:
**Priority order:**
1.  **Goal end date**
    *   When work on the goal finished.
2.  **Goal start date**
    *   When work on the goal started.
3.  **Goal created date**
    *   When the goal was set up in the system.
4.  **Goal next review date**
    *   Only include if your policy explicitly treats planned reviews as extending interaction; otherwise treat as informational only.

**Reasoning:**  
A completed goal may be the latest sign of active case work.

* * *

2.3 Assessment outcomes
For each assessment outcome:
**Priority order:**
1.  **Assessment response date**
    *   When the assessment was actually completed or recorded.

_(No other dates are defined in your scripts for assessments.)_
**Reasoning:**  
A completed assessment is always an interaction; use this directly.

* * *

2.4 Incidents involving clients
For each incident:
**Priority order:**
1.  **Current incident status date**
    *   When the current status was set (often a closure or major status change).
2.  **Incident date**
    *   When the incident occurred.
3.  **Incident record created date**
    *   When it was entered in the system.

**Reasoning:**
*   Status date can be later than the incident date (e.g. investigation closes months later).
*   Incident date is the actual event.
*   Created date is fallback if the others are missing.
_The separate incident‑person link is used to connect clients to incidents, but does not add new dates._

* * *

2.5 Relationships between clients (whānau, carers etc.)
For each recorded relationship:
**Priority order:**
1.  **Relationship end date**
    *   When we recorded that the relationship ended.
2.  **Relationship start date**
    *   When the relationship was first recorded.

**Reasoning:**  
These dates show context rather than direct service in most cases. Only include them in last‑interaction calculations if policy says that particular relationship types are relevant to service delivery.

* * *

3. Putting this into a calculation: high‑level logic
For each client:
1.  **From Activities**:
    *   For each activity: choose end > start > created.
    *   Take the latest chosen date across all activities.
2.  **From Referrals/Goals**:
    *   For each referral: choose latest of discharge, end, relationship end, accepted/declined, waitlist/pending, received, created.
    *   For each goal: choose end > start > created (and optionally next review).
    *   Take the latest of all referral and goal dates.
3.  **From Assessments**:
    *   Take the latest assessment response date.
4.  **From Incidents**:
    *   For each incident: choose status date > incident date > created date.
    *   Take the latest across all incidents.
5.  **From Relationships (if applicable)**:
    *   For each relationship: end > start.
    *   Take the latest across relationships (only if policy says they count).
6.  **Client’s Last Interaction Date** =  
    The **maximum** (most recent) date across all the groups above.
7.  Compare this Last Interaction Date to the policy threshold (e.g. 7 years) to decide if the client’s data should be obfuscated (subject to any legal/clinical exceptions).


::: mermaid
    flowchart TD
    
    A[Start: For each client] --> B[Collect all activity records]
    B --> C[For each activity choose date 1. Activity end date 2. Else activity start date 3. Else activity created date]
    C --> D[Latest activity date for client]
    
    A --> E[Collect all referral records]
    E --> F[For each referral choose latest of Discharge date Referral end date Responsible person or team end date Accepted or declined date Waitlist or pending date Received date Created date]
    F --> G[Latest referral date for client]
    
    A --> H[Collect all goal records]
    H --> I[For each goal choose date 1. Goal end date 2. Else goal start date 3. Else goal created date]
    I --> J[Latest goal date for client]
    
    A --> K[Collect all assessment outcome records]
    K --> L[Latest assessment response date for client]
    
    A --> M[Collect all incident records]
    M --> N[For each incident choose date 1. Current status date 2. Else incident date 3. Else incident created date]
    N --> O[Latest incident date for client]
    
    A --> P[Collect relationship records if policy says they count]
    P --> Q[For each relationship choose date 1. Relationship end date 2. Else relationship start date]
    Q --> R[Latest relationship date for client]
    
    D --> S[Combine latest dates Activity Referrals Goals Assessments Incidents Relationships if used]
    G --> S
    J --> S
    L --> S
    O --> S
    R --> S
    
    S --> T[Last interaction date Most recent of all chosen dates]
    
    T --> U{Is last interaction date older than retention threshold}
    U -->|Yes| V[Mark client as candidate for obfuscation Apply legal and clinical exceptions]
    U -->|No| W[Retain identifiable data Client still within retention period]
    
    V --> X[End]
    W --> X[End]
:::
