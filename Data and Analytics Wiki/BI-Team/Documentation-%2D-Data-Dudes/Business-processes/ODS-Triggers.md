# Azure Synapse Analytics Triggers Report

  

**Generated:** 2025-10-10 10:37:05

**Synapse Workspace:** synapseausprod

**Synapse Endpoint:** https://synapseausprod.dev.azuresynapse.net

**Resource Group:** rg-prod-aus-svc-datareporting

**Total Triggers:** 19

  

## Triggers Overview

  

| Trigger Name | Type | Runtime State | Execution Times | Associated Pipelines |
|--------------|------|---------------|-----------------|---------------------|
| RB EAL Daily trigger | ScheduleTrigger | Started | 00:45 | RBEAL Load - all tables |
| RB MNB Daily trigger | ScheduleTrigger | Started | 01:30 | RBMNB Load - all tables |
| IntelliHR Daily Trigger | ScheduleTrigger | Started | 04:00 | IntelliHR Load - all tables |
| DataPay Daily Trigger | ScheduleTrigger | Started | 04:00 | DataPay Load - all tables |
| Emplive Daily Trigger | ScheduleTrigger | Started | 23:55 | Emplive Load - all tables, Emplive API Load - all tables |
| Snaphire Daily Trigger | ScheduleTrigger | Started | 06:00 | SnapHire Load - all Files |
| Akoranga Daily Trigger | ScheduleTrigger | Started | 04:00 | Akoranga Load - all tables |
| EDW Daily Load | ScheduleTrigger | Started | 05:00 | 10_Load_Master |
| PowerBI Daily Trigger | ScheduleTrigger | Started | 01:30 | PowerBI Load - all tables |
| Business Central Trigger | ScheduleTrigger | Started | 03:30 | Business Central Load - All and Single Tables |
| Six Degrees Extractions | ScheduleTrigger | Started | 07:00 | Six Degrees Extractions |
| EDW dim_date load | ScheduleTrigger | Started | 00:05 | ref_dim_date-TL |
| EDW Row Level Security Load | ScheduleTrigger | Started | 07:00 | ref_row_level_security |
| Weekly on Sunday | ScheduleTrigger | Started | 10:00 | adm_index_rebuild |
| Tapui Waka Daily Trigger | ScheduleTrigger | Started | 01:00 | TapuiWaka Load - all tables |
| KPI Daily Trigger | ScheduleTrigger | Started | 01:00 | KPI Load - all tables |
| Data quality checks | ScheduleTrigger | Started | 08:30 | Data quality run data dictionary |
| Run on PayCycle | ScheduleTrigger | Started | 09:00 | Proces DataPay Pay Runs Master |
| EcoPortal Daily Trigger | ScheduleTrigger | Started | 01:00 | EcoPortal Load - all tables |
  

## Detailed Trigger Information

  

### RB EAL Daily trigger

  

- **Type:** ScheduleTrigger

- **Runtime State:** Started

- **Frequency:** Day

- **Interval:** 1

- **Time Zone:** New Zealand Standard Time

- **Start Time:** 2022-03-03 03:48:00

- **Execution Times:** 00:45

- **Associated Pipelines:**
  - RBEAL Load - all tables

  

### RB MNB Daily trigger

  

- **Type:** ScheduleTrigger

- **Runtime State:** Started

- **Frequency:** Day

- **Interval:** 1

- **Time Zone:** New Zealand Standard Time

- **Start Time:** 2022-03-03 03:49:00

- **Execution Times:** 01:30

- **Associated Pipelines:**
  - RBMNB Load - all tables

  

### IntelliHR Daily Trigger

  

- **Type:** ScheduleTrigger

- **Runtime State:** Started

- **Frequency:** Day

- **Interval:** 1

- **Time Zone:** New Zealand Standard Time

- **Start Time:** 2022-03-01 03:02:00

- **Execution Times:** 04:00

- **Associated Pipelines:**
  - IntelliHR Load - all tables

  

### DataPay Daily Trigger

  

- **Type:** ScheduleTrigger

- **Runtime State:** Started

- **Frequency:** Day

- **Interval:** 1

- **Time Zone:** New Zealand Standard Time

- **Start Time:** 2022-12-08 02:48:00

- **Execution Times:** 04:00

- **Associated Pipelines:**
  - DataPay Load - all tables

  

### Emplive Daily Trigger

  

- **Type:** ScheduleTrigger

- **Runtime State:** Started

- **Frequency:** Day

- **Interval:** 1

- **Time Zone:** New Zealand Standard Time

- **Start Time:** 2023-01-26 01:16:00

- **Execution Times:** 23:55

- **Associated Pipelines:**
  - Emplive Load - all tables
  - Emplive API Load - all tables
  

### Snaphire Daily Trigger

  

- **Type:** ScheduleTrigger

- **Runtime State:** Started

- **Frequency:** Day

- **Interval:** 1

- **Time Zone:** New Zealand Standard Time

- **Start Time:** 2023-02-01 23:20:00

- **Execution Times:** 06:00

- **Associated Pipelines:**
  - SnapHire Load - all Files

  

### Akoranga Daily Trigger

  

- **Type:** ScheduleTrigger

- **Runtime State:** Started

- **Frequency:** Day

- **Interval:** 1

- **Time Zone:** New Zealand Standard Time

- **Start Time:** 2023-06-28 02:05:00

- **Execution Times:** 04:00

- **Associated Pipelines:**
  - Akoranga Load - all tables

  

### EDW Daily Load

  

- **Type:** ScheduleTrigger

- **Runtime State:** Started

- **Frequency:** Day

- **Interval:** 1

- **Time Zone:** New Zealand Standard Time

- **Start Time:** 2023-07-20 02:08:00

- **Execution Times:** 05:00

- **Associated Pipelines:**
  - 10_Load_Master

  

### PowerBI Daily Trigger

  

- **Type:** ScheduleTrigger

- **Runtime State:** Started

- **Frequency:** Day

- **Interval:** 1

- **Time Zone:** New Zealand Standard Time

- **Start Time:** 2023-09-19 00:47:00

- **Execution Times:** 01:30

- **Associated Pipelines:**
  - PowerBI Load - all tables

  

### Business Central Trigger

  

- **Type:** ScheduleTrigger

- **Runtime State:** Started

- **Frequency:** Day

- **Interval:** 1

- **Time Zone:** New Zealand Standard Time

- **Start Time:** 2023-10-18 21:49:00

- **Execution Times:** 03:30

- **Associated Pipelines:**
  - Business Central Load - All and Single Tables

  

### Six Degrees Extractions

  

- **Type:** ScheduleTrigger

- **Runtime State:** Started

- **Frequency:** Month

- **Interval:** 1

- **Time Zone:** New Zealand Standard Time

- **Start Time:** 2023-10-18 21:16:00

- **Execution Times:** 07:00

- **Days of Month:** 1

- **Associated Pipelines:**
  - Six Degrees Extractions

  

### EDW dim_date load

  

- **Type:** ScheduleTrigger

- **Runtime State:** Started

- **Frequency:** Day

- **Interval:** 1

- **Time Zone:** New Zealand Standard Time

- **Start Time:** 2024-03-17 22:07:00

- **Execution Times:** 00:05

- **Associated Pipelines:**
  - ref_dim_date-TL

  

### EDW Row Level Security Load

  

- **Type:** ScheduleTrigger

- **Runtime State:** Started

- **Frequency:** Day

- **Interval:** 1

- **Time Zone:** New Zealand Standard Time

- **Start Time:** 2024-06-06 00:21:00

- **Execution Times:** 07:00

- **Associated Pipelines:**
  - ref_row_level_security

  

### Weekly on Sunday

  

- **Type:** ScheduleTrigger

- **Runtime State:** Started

- **Frequency:** Week

- **Interval:** 1

- **Time Zone:** New Zealand Standard Time

- **Start Time:** 2024-06-10 21:21:00

- **Execution Times:** 10:00

- **Days of Week:** Sunday

- **Associated Pipelines:**
  - adm_index_rebuild

  

### Tapui Waka Daily Trigger

  

- **Type:** ScheduleTrigger

- **Runtime State:** Started

- **Frequency:** Day

- **Interval:** 1

- **Time Zone:** New Zealand Standard Time

- **Start Time:** 2024-09-08 23:46:00

- **Execution Times:** 01:00

- **Associated Pipelines:**
  - TapuiWaka Load - all tables

  

### KPI Daily Trigger

  

- **Type:** ScheduleTrigger

- **Runtime State:** Started

- **Frequency:** Week

- **Interval:** 1

- **Time Zone:** New Zealand Standard Time

- **Start Time:** 2025-03-13 00:56:00

- **Execution Times:** 01:00

- **Days of Week:** Monday, Tuesday, Wednesday, Thursday, Friday

- **Associated Pipelines:**
  - KPI Load - all tables

  

### Data quality checks

  

- **Type:** ScheduleTrigger

- **Runtime State:** Started

- **Frequency:** Week

- **Interval:** 1

- **Time Zone:** New Zealand Standard Time

- **Start Time:** 2025-06-11 22:41:00

- **Execution Times:** 08:30

- **Days of Week:** Monday, Tuesday, Wednesday, Thursday, Friday

- **Associated Pipelines:**
  - Data quality run data dictionary

  

### Run on PayCycle

  

- **Type:** ScheduleTrigger

- **Runtime State:** Started

- **Frequency:** Week

- **Interval:** 2

- **Time Zone:** New Zealand Standard Time

- **Start Time:** 2025-07-16 20:18:00

- **Execution Times:** 09:00

- **Days of Week:** Saturday

- **Associated Pipelines:**
  - Proces DataPay Pay Runs Master

  

### EcoPortal Daily Trigger

  

- **Type:** ScheduleTrigger

- **Runtime State:** Started

- **Frequency:** Day

- **Interval:** 1

- **Time Zone:** New Zealand Standard Time

- **Start Time:** 2025-10-07 23:11:00

- **Execution Times:** 01:00

- **Associated Pipelines:**
  - EcoPortal Load - all tables