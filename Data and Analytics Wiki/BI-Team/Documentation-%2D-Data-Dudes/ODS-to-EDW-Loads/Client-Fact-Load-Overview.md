# Client Fact Load Overview

[[_TOC_]]

The client fact tables integrate operational client activities, referrals, assessment outcomes, account activities, incidents, personal plans, goals, relationships, and PRIMHD reviews across **Recordbase** (`rbeal` and `rbmnb`), **IntelliHR**, and related systems.

This page covers all **15 client fact loads**.

## Execution order

`10_Load_Master` runs load phases sequentially in `DataLoadPhaseNo` order. Within a phase, `20_Load_Phase` runs loads **in parallel**, up to 5 concurrently.

| Phase | Client fact loads |
| --- | --- |
| `200 Facts` | `fact_client_account_activity`, `fact_client_activity_breakdown`, `fact_client_address_history`, `fact_client_assessment_outcome`, `fact_client_incident`, `fact_client_incident_category`, `fact_client_incident_person`, `fact_client_interaction`, `fact_client_person_relationship`, `fact_client_primhd_service_review`, `fact_client_referral`, `fact_client_referral_goal`, `fact_client_referral_V2`, `fact_client_relationship` |
| `201 Facts` | `fact_client_personal_goal` |

> **Note.** `fact_client_personal_goal` is configured in phase `201 Facts` while all other client facts run in phase `200 Facts`.

## Load inventory

| DataLoadId | Target table | Source system(s) | Load type | Phase | Primary dimensions / entities |
| --- | --- | --- | --- | --- | --- |
| 482 | [fact_client_address_history](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_client_address_history) | Recordbase (rbeal, rbmnb) | `ODSFLLMRGIRV` | 200 | Client, Company |
| 483 | [fact_client_referral_goal](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_client_referral_goal) | Recordbase (rbeal, rbmnb) | `ODSFLLMRGIRV` | 200 | Client, Client Referral, Company |
| 485 | [fact_client_referral](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_client_referral) | Recordbase, IntelliHR | `ODSFLLMRGIRV` | 200 | Client, Client Referral, Employee, Team, Service, Company |
| 486 | [fact_client_personal_goal](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_client_personal_goal) | Recordbase, IntelliHR | `ODSFLLMRGIRV` | 201 | Client, Client Referral, Employee, Personal Goal Status, Personal Goal Action Status |
| 587 | [fact_client_referral_V2](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_client_referral_V2) | Recordbase, IntelliHR | `ODSFLLMRGIRV` | 200 | Client, Client Referral, Employee, Team, Service, Company |
| 588 | [fact_client_person_relationship](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_client_person_relationship) | Recordbase, IntelliHR | `ODSFLLMRGIRV` | 200 | Client, Employee, Client Referral, Team, Service, Company |
| 635 | [fact_client_activity_breakdown](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_client_activity_breakdown) | Recordbase, IntelliHR | `ODSFLLMRGIRV` | 200 | Client, Activity Breakdown Type, Employee, Client Referral, Team, Service |
| 660 | [fact_client_assessment_outcome](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_client_assessment_outcome) | Recordbase (rbeal, rbmnb) | `ODSFLLMRGIRV` | 200 | Client, Client Referral, Team, Company |
| 661 | [fact_client_account_activity](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_client_account_activity) | Recordbase (rbeal, rbmnb) | `ODSFLLMRGIRV` | 200 | Client Team, Service, Company, Participated Employee, Created Employee |
| 735 | [fact_client_incident](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_client_incident) | Recordbase (rbeal, rbmnb) | `ODSFLLMRGIRV` | 200 | Client Incident, Incident Category Type, Incident Severity, Incident Status Type, Owner/Investigator/Reporter Employee |
| 737 | [fact_client_incident_category](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_client_incident_category) | Recordbase (rbeal, rbmnb) | `ODSFLLMRGIRV` | 200 | Client Incident, Incident Category Type, Company |
| 739 | [fact_client_relationship](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_client_relationship) | Recordbase (rbeal, rbmnb) | `ODSFLLMRGIRV` | 200 | Primary Client, Related Client, Company |
| 743 | [fact_client_incident_person](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_client_incident_person) | Recordbase (rbeal, rbmnb) | `ODSFLLMRGIRV` | 200 | Client Incident, Client, Company |
| 780 | [fact_client_primhd_service_review](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_client_primhd_service_review) | Recordbase (rbeal, rbmnb) | `ODSFLLMRG` | 200 | Client, Client Referral, Created By Employee, Review Date |
| 802 | [fact_client_interaction](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_client_interaction) | Recordbase (unconfirmed) | `ODSFLLMRG` | 200 | Client, Client Interaction Type, Employee, Company |

## Direct business key join pattern

To join a client fact table to an SCD Type 2 dimension (such as `dim_client`, `dim_client_referral`, `dim_employee`, `dim_client_team`, or `dim_client_incident`) using business `_id` fields, match the ID directly and filter `DWHIsCurrent = 1`:

```sql
FROM edw.fact_client_referral AS fact
INNER JOIN edw.dim_client AS c
    ON fact.client_id = c.client_id
    AND c.DWHIsCurrent = 1
```

```sql
FROM edw.fact_client_activity_breakdown AS fact
INNER JOIN edw.dim_client_activity_breakdown_type AS t
    ON fact.client_activity_breakdown_type_id = t.client_activity_breakdown_type_id
    AND t.DWHIsCurrent = 1
```

## Load types used in this group

| Code | Description | Behaviour |
| --- | --- | --- |
| `ODSFLLMRGIRV` | ODS: Full row-versioned merged | Full extract from ODS; MERGE updates target with SCD Type 2 row versioning |
| `ODSFLLMRG` | ODS: Full non-versioned merged | Full extract from ODS; MERGE updates target in-place (Type 1) |

## Verification basis

Checked against EDW table DDL, stored procedures, and Framework metadata.
