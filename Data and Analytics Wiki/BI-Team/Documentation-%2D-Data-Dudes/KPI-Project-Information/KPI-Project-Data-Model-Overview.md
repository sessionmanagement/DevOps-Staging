### 📌 Purpose

This document outlines the architecture and data flow of the KPI Project Data Model used for generating **Organisational Performance KPI Reports and Audit**. It includes source layers, transformation logic, and snapshot fact tables.

* * *

### 📊 1. Data Layer Overview

#### 🧍 People

*   `fact_employee_certification_progress`
    
*   `fact_employee_course_progress`
    
*   `fact_employee_hours_worked`
    
*   `fact_employee_leave`
    
*   `fact_employee_program_progress`
    
*   `fact_employee_remuneration`
    

#### 🏠 Property

*   `fact_property_inspection`
    
*   `fact_property_maintenance_task`
    
*   `fact_property_tenancy_transaction`
    
*   `fact_property_tenant`
    

#### 👥 Client

*   `fact_client_account_activity`
    
*   `fact_client_activity_breakdown`
    
*   `fact_client_address_history`
    
*   `fact_client_assessment_outcome`
    
*   `fact_client_person_relationship`
    
*   `fact_client_personal_goal`
    
*   `fact_client_referral`
    
*   `fact_client_referral_goal`
    

#### 💰 Finance

*   `fact_finance_budget`
    
*   `fact_finance_customer_ledger`
    
*   `fact_finance_general_ledger`
    
*   `fact_finance_vendor_ledger`
    

* * *

### 🔄 2. KPI ETL Logic

#### 🔹 Create KPI Procedures (KPI Source Procedures)

Each KPI has a source procedure using the naming convention:

php-template

CopyEdit

`kpi_sp_<subject_area>_<kpi_id>_<description>`

**Example Views:**
*   `kpi_sp_kaiamah_leave_balance_200hrs`
    
*   `kpi_sp_client_g2_goal_plan_status`
    
*   `kpi_sp_property_62_property_status_is_occupied`
    

* * *

#### 🔹 Merge into Master Views

All individual KPI procedures are merged into subject-specific master views:
*   `kpi_snapshot_subject_area`

    *   `kpi_snapshot_kaiamah`
        
    *   `kpi_snapshot_client`
        
    *   `kpi_snapshot_property`
        
    *   `kpi_snapshot_finance`

    *   `kpi_snapshot_tenancy`
        

* * *

### 🧱 3. Snapshot and Fact Layers

#### 📆 Daily Snapshots

*   `ds_kpi_snapshot_client_current`
    
*   `ds_kpi_snapshot_kaiamah_current`
    
*   `ds_kpi_snapshot_property_current`
.....
    
*   Load daily snapshot data to `fact_kpi_current`
    

#### 📅 Monthly Snapshots
    
*   Load into `fact_kpi_history` (Month-end snapshot table)
    

* * *

### 📘 4. Dimension Table

*   `dim_kpi`: Maintains SCD Type 2 history for each KPI
    

* * *

### 📈 5. Output

*   **fact_kpi_current**: Daily current KPI data
    
*   **fact_kpi_history**: Historical (month-end) KPI data
    
*   **Organisational Performance KPI Report**: Final output for audit/reporting
    

* * *

### 🔐 6. Notes

*   Ensure daily overwrite for current snapshot.
    
*   Monthly jobs should be scheduled around month-end processing.
    
*   Consider alerting or data quality checks on major KPI sources.