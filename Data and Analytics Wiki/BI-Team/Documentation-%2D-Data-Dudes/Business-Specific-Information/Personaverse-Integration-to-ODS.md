# Personaverse Overview
**Personaverse** is a Power Platform solution implemented by Emerge Aotearoa to centralize information necessary for security and access control. This system streamlines the process of collecting key persona responses to automatically assign appropriate system access to users.

## Current Data Feeds and Limitations
Personaverse receives data from multiple systems; however, it currently does not integrate with IntelliHR and RecordBase. This lack of synchronization could lead to discrepancies between these systems and Personaverse.
## Integration with Business Intelligence (BI) System
Personaverse plays a crucial role in the BI system by classifying tables based on record counts:
### •	Table Classification by Records Count:
****
Range	Number of Tables
Between 1 and 10	71
Between 10 and 100	60
Between 100 and 1000	32
More than 1000	27
No records	211
Grand Total	401

Most tables are system tables, with Kamahi data identifiable by the inclusion of “ast” in the table name, referred to as ‘asset’ in Power Apps.

## Operational Data Store (ODS) Tables
ODS tables are a part of the Personaverse ecosystem, contributing to the overall data management and access control
## Row-Level Security
The current staff hierarchy system relies on IntelliHR’s People Hierarchy data. However, IntelliHR does not account for scenarios where a Kamahi is part of multiple teams. To address this, there is a need for Row-Level Security with Multiple Conditions to ensure accurate access control

## Enterprise Data Warehouse (EDW) Tables
The EDW tables, specifically [edw].[dim_personaverse], are integral to the Personaverse structure, providing a dimensional view of the data for reporting and analysis. #5399 #6188