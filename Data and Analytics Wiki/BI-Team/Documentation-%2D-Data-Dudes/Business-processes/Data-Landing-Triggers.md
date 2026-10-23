# Azure Data Factory Triggers Report  

**Generated:** 2025-10-10 10:20:55

**Data Factory:** adf-prod-aus-datalanding-01

**Resource Group:** rg-prod-aus-svc-datalanding

**Total Triggers:** 13

  

## Triggers Overview

  

| Trigger Name | Type | Runtime State | Execution Times | Associated Pipelines |
|:--------------|:------|:---------------|:-----------------|:---------------------|
| Daily_Intellihr_Trigger | ScheduleTrigger | Started | 01:00 | Extract IntelliHr API Master |
| Daily_DataPay_Trigger | ScheduleTrigger | Started | 01:15 | Extract_DataPay_Data_by_Company, Datapay Report Cost Allocation |
| Daily_Emplive_Trigger | ScheduleTrigger | Started | 23:45 | Extract EmpLive files |
| Daily Trigger | ScheduleTrigger | Stopped | 03:15 | None |
| Daily_Akoranga_Trigger | ScheduleTrigger | Started | 03:15 | Extract_Master_Akoranga |
| Weekly on Friday | ScheduleTrigger | Started | 01:00 | DataPay Payslips_Bulk_Load |
| Daily_PowerBI_Trigger | ScheduleTrigger | Started | 23:00 | Extract PowerBI ActivityEvents |
| Daily_BusinessCentral_Trigger | ScheduleTrigger | Started | 01:00 | Extract_Master_BusinessCentral |
| Daily_Tapui_Waka_Trigger | ScheduleTrigger | Started | 00:30 | Extract_Master_Tapui_Waka |
| Emplive API | ScheduleTrigger | Started | 00:05 | Extract Emplive API Master |
| Daily_Midnight_Trigger | ScheduleTrigger | Started | 00:00 | Extract MS Graph Master, Extract EcoPortal GraphQL Pages Master |
| Weekly on Saturday | ScheduleTrigger | Started | 09:00 | Fetch Job Timeline Master |
| Pay Run Cycle Trigger | ScheduleTrigger | Started | 09:00 | DataPay PRR Report Processing |
  

## Detailed Trigger Information

  

### Daily_Intellihr_Trigger

  

- **Type:** ScheduleTrigger

- **Runtime State:** Started

- **Frequency:** Day

- **Interval:** 1

- **Time Zone:** New Zealand Standard Time

- **Start Time:** 2025-05-07 03:34:00

- **Execution Times:** 01:00

- **Associated Pipelines:**
  - Extract IntelliHr API Master

  

### Daily_DataPay_Trigger

  

- **Type:** ScheduleTrigger

- **Runtime State:** Started

- **Frequency:** Day

- **Interval:** 1

- **Time Zone:** New Zealand Standard Time

- **Start Time:** 2022-10-09 03:05:00

- **Execution Times:** 01:15

- **Associated Pipelines:**

  - Extract_DataPay_Data_by_Company
  - Datapay Report Cost Allocation

  

### Daily_Emplive_Trigger

  

- **Type:** ScheduleTrigger

- **Runtime State:** Started

- **Frequency:** Day

- **Interval:** 1

- **Time Zone:** New Zealand Standard Time

- **Start Time:** 2022-12-19 20:56:00

- **Execution Times:** 23:45

- **Associated Pipelines:**
  - Extract EmpLive files

  

### Daily Trigger

  

- **Type:** ScheduleTrigger

- **Runtime State:** Stopped

- **Frequency:** Day

- **Interval:** 1

- **Time Zone:** New Zealand Standard Time

- **Start Time:** 2023-05-30 04:00:00

- **Execution Times:** 03:15

- **Associated Pipelines:** None

  

### Daily_Akoranga_Trigger

  

- **Type:** ScheduleTrigger

- **Runtime State:** Started

- **Frequency:** Week

- **Interval:** 1

- **Time Zone:** New Zealand Standard Time

- **Start Time:** 2023-06-27 20:02:00

- **Execution Times:** 03:15

- **Days of Week:** Monday, Tuesday, Wednesday, Thursday, Friday, Saturday

- **Associated Pipelines:**
  - Extract_Master_Akoranga

  

### Weekly on Friday

  

- **Type:** ScheduleTrigger

- **Runtime State:** Started

- **Frequency:** Week

- **Interval:** 1

- **Time Zone:** New Zealand Standard Time

- **Start Time:** 2023-08-13 20:05:00

- **Execution Times:** 01:00

- **Days of Week:** Friday

- **Associated Pipelines:**
  - DataPay Payslips_Bulk_Load

  

### Daily_PowerBI_Trigger

  

- **Type:** ScheduleTrigger

- **Runtime State:** Started

- **Frequency:** Day

- **Interval:** 1

- **Time Zone:** New Zealand Standard Time

- **Start Time:** 2023-08-28 22:16:00

- **Execution Times:** 23:00

- **Associated Pipelines:**
  - Extract PowerBI ActivityEvents

  

### Daily_BusinessCentral_Trigger

  

- **Type:** ScheduleTrigger

- **Runtime State:** Started

- **Frequency:** Day

- **Interval:** 1

- **Time Zone:** New Zealand Standard Time

- **Start Time:** 2023-09-12 00:21:00

- **Execution Times:** 01:00

- **Associated Pipelines:**
  - Extract_Master_BusinessCentral

  

### Daily_Tapui_Waka_Trigger

  

- **Type:** ScheduleTrigger

- **Runtime State:** Started

- **Frequency:** Day

- **Interval:** 1

- **Time Zone:** New Zealand Standard Time

- **Start Time:** 2024-09-05 21:39:00

- **Execution Times:** 00:30

- **Associated Pipelines:**
  - Extract_Master_Tapui_Waka

  

### Emplive API

  

- **Type:** ScheduleTrigger

- **Runtime State:** Started

- **Frequency:** Day

- **Interval:** 1

- **Time Zone:** New Zealand Standard Time

- **Start Time:** 2025-01-07 22:30:00

- **Execution Times:** 00:05

- **Associated Pipelines:**
  - Extract Emplive API Master

  

### Daily_Midnight_Trigger

  

- **Type:** ScheduleTrigger

- **Runtime State:** Started

- **Frequency:** Day

- **Interval:** 1

- **Time Zone:** New Zealand Standard Time

- **Start Time:** 2025-03-20 23:05:00

- **Execution Times:** 00:00

- **Associated Pipelines:**
  - Extract MS Graph Master
  - Extract EcoPortal GraphQL Pages Master

  

### Weekly on Saturday

  

- **Type:** ScheduleTrigger

- **Runtime State:** Started

- **Frequency:** Week

- **Interval:** 1

- **Time Zone:** New Zealand Standard Time

- **Start Time:** 2025-08-10 19:30:00

- **Execution Times:** 09:00

- **Days of Week:** Saturday

- **Associated Pipelines:**
  - Fetch Job Timeline Master

  

### Pay Run Cycle Trigger

  

- **Type:** ScheduleTrigger

- **Runtime State:** Started

- **Frequency:** Week

- **Interval:** 2

- **Time Zone:** New Zealand Standard Time

- **Start Time:** 2025-08-28 00:00:00

- **Execution Times:** 09:00

- **Days of Week:** Saturday

- **Associated Pipelines:**
  - DataPay PRR Report Processing