# EDW.DIM_EMPLOYEE Table Documentation

## Overview

The `edw.dim_employee` table is a dimension table in the Enterprise Data Warehouse (EDW) that stores comprehensive employee information. This table implements Slowly Changing Dimension (SCD) Type 2 methodology to track changes to employee data over time.

## Table Details

| Property | Value |
|----------|-------|
| **Schema** | edw |
| **Table** | dim_employee |
| **Description** | Contains current and historical employee information with complete attributes for HR analytics and reporting |
| **Primary Source** | IntelliHR.people |
| **Warehouse Role** | Dimension Table (SCD Type 2) |
| **Primary Key** | dim_employee_key (Identity column) |

## Table Structure

The table contains 100 columns organized into the following logical groups:

### Keys and Identifiers
| Column Name | Data Type | Length | Nullable | Description |
|-------------|-----------|--------|----------|-------------|
| dim_employee_key | int | - | No | Primary surrogate key (identity column) |
| employee_id | int | - | No | Business key identifier for the employee |

### Personal Information
| Column Name | Data Type | Length | Nullable | Description |
|-------------|-----------|--------|----------|-------------|
| employee_name | nvarchar | 100 | No | Full name of the employee |
| employee_first_name | nvarchar | 75 | Yes | First name |
| employee_middle_name | nvarchar | 75 | Yes | Middle name |
| employee_last_name | nvarchar | 100 | Yes | Last name |
| employee_title | nvarchar | 10 | Yes | Title (e.g., Mr., Ms., Dr.) |
| employee_preferred_name | nvarchar | 75 | Yes | Preferred name |
| employee_preferred_last_name | nvarchar | 500 | Yes | Preferred last name |
| employee_date_of_birth | datetime2 | - | Yes | Date of birth |
| employee_age_in_year | int | - | Yes | Current age in years |
| employee_age_group | nvarchar | 10 | Yes | Age group category |
| employee_gender | nvarchar | 50 | Yes | Gender identity |
| employee_previous_gender | nvarchar | 50 | Yes | Previous gender (if changed) |
| employee_previous_gender_valid_to_date | datetime2 | - | Yes | Date until which previous gender was valid |

### Employment Information
| Column Name | Data Type | Length | Nullable | Description |
|-------------|-----------|--------|----------|-------------|
| employee_employment_status | nvarchar | 50 | Yes | Current employment status (e.g., Current Staff, Past Staff) |
| employee_job_name | nvarchar | 100 | Yes | Job title or position |
| employee_job_status | nvarchar | 50 | Yes | Current status of the job |
| employee_company_name | nvarchar | 200 | Yes | Company or organization name |
| employee_is_primary_Job_flag | int | - | Yes | Indicates if this is the primary job (1=Yes, 0=No) |
| employee_full_time_equivalent | numeric | - | Yes | FTE value |
| employee_work_type | nvarchar | 50 | Yes | Type of work arrangement (e.g., Full-time, Part-time) |
| employee_work_class | nvarchar | 50 | Yes | Work classification |
| employee_current_status | nvarchar | 20 | Yes | Current employment status |
| employee_concurrent_job | nvarchar | 500 | Yes | Information about concurrent jobs |

### Dates and Tenure
| Column Name | Data Type | Length | Nullable | Description |
|-------------|-----------|--------|----------|-------------|
| employee_start_date | datetime2 | - | Yes | Employment start date |
| employee_company_start_date | datetime2 | - | Yes | Start date with the company |
| employee_end_date | datetime2 | - | Yes | End date of employment |
| employee_company_end_date | datetime2 | - | Yes | End date with the company |
| employee_position_start_date | datetime2 | - | Yes | Start date in the current position |
| employee_termination_date | datetime2 | - | Yes | Date of termination |
| employee_leaving_date | datetime2 | - | Yes | Date employee left |
| employee_leaving_reason | nvarchar | 255 | Yes | Reason for leaving |
| employee_leaving_turnover_type | nvarchar | 255 | Yes | Type of turnover (voluntary/involuntary) |
| employee_longevity | datetime2 | - | Yes | Service duration measure |
| employee_long_service_recognition_date | varchar | 10 | Yes | Date for long service recognition |

### Contact Information
| Column Name | Data Type | Length | Nullable | Description |
|-------------|-----------|--------|----------|-------------|
| employee_primary_email_address | nvarchar | 100 | Yes | Primary email address |
| employee_primary_email_address_ispersonal | int | - | Yes | Flag indicating if email is personal (1=Yes, 0=No) |
| employee_primary_phone_number | nvarchar | 200 | Yes | Primary phone number |
| employee_primary_phone_number_fullnumber | nvarchar | 200 | Yes | Full phone number with country code |
| employee_primary_phone_number_ispersonal | int | - | Yes | Flag indicating if phone is personal (1=Yes, 0=No) |

### Address Information
| Column Name | Data Type | Length | Nullable | Description |
|-------------|-----------|--------|----------|-------------|
| employee_full_address | nvarchar | 150 | Yes | Complete address |
| employee_street_value | nvarchar | 50 | Yes | Street address |
| employee_suburb_value | nvarchar | 50 | Yes | Suburb |
| employee_city_value | nvarchar | 100 | Yes | City |
| employee_postcode_value | nvarchar | 10 | Yes | Postal code |
| employee_address_Type | nvarchar | 10 | Yes | Type of address |
| employee_is_primary_address_flag | int | - | Yes | Flag indicating if this is the primary address (1=Yes, 0=No) |

### Emergency Contact Information
| Column Name | Data Type | Length | Nullable | Description |
|-------------|-----------|--------|----------|-------------|
| employee_emergency_contact_name | nvarchar | 150 | Yes | Name of emergency contact |
| employee_next_of_whanau_relationship | nvarchar | 100 | Yes | Relationship to employee |
| employee_next_of_whanau_phone | nvarchar | 200 | Yes | Phone number of emergency contact |
| employee_next_of_whanau_email | nvarchar | 100 | Yes | Email of emergency contact |

### Remuneration Information
| Column Name | Data Type | Length | Nullable | Description |
|-------------|-----------|--------|----------|-------------|
| employee_pay_grade_name | nvarchar | 50 | Yes | Pay grade |
| employee_remuneration_annual_package | float | - | Yes | Total annual package |
| employee_remuneration_base_annual_salary | float | - | Yes | Base annual salary |
| employee_remuneration_base_hourly_rate | float | - | Yes | Base hourly rate |
| employee_remuneration_hourly_package | float | - | Yes | Hourly package value |
| employee_remuneration_schedule_currency | nvarchar | 3 | Yes | Currency code (e.g., NZD) |
| employee_remuneration_hours_per_cycle | float | - | Yes | Working hours per pay cycle |
| employee_remuneration_pay_cycle | nvarchar | 50 | Yes | Pay cycle (e.g., weekly, fortnightly) |
| employee_salary_sacrifice | nvarchar | 50 | Yes | Salary sacrifice arrangements |
| employee_bank_details | nvarchar | 50 | Yes | Banking information |

### Demographic and Cultural Information
| Column Name | Data Type | Length | Nullable | Description |
|-------------|-----------|--------|----------|-------------|
| employee_ethnicity | nvarchar | 4000 | Yes | Ethnicity information |
| employee_identified_ethnicity | nvarchar | 500 | Yes | Self-identified ethnicity |
| employee_hapu_affilitation | nvarchar | 500 | Yes | Māori hapū affiliation |
| employee_nationality | nvarchar | 500 | Yes | Nationality information |
| primary_ethnicity_id | int | - | Yes | ID for primary ethnicity |
| secondary_ethnicity_id | int | - | Yes | ID for secondary ethnicity |
| tertiary_ethnicity_id | int | - | Yes | ID for tertiary ethnicity |
| fourth_ethnicity_id | int | - | Yes | ID for fourth ethnicity |
| primary_iwi_id | int | - | Yes | ID for primary iwi |
| identified_ethnicity_id | int | - | Yes | ID for identified ethnicity |

### Compliance & Documentation
| Column Name | Data Type | Length | Nullable | Description |
|-------------|-----------|--------|----------|-------------|
| employee_nhi_number | varchar | 1 | Yes | National Health Index number (masked) |
| employee_ird_number | varchar | 1 | Yes | Inland Revenue Department number (masked) |
| employee_workrights_name | nvarchar | 100 | Yes | Work rights document name |
| employee_workrights_country | nvarchar | 50 | Yes | Country of work rights |
| employee_workrights_expiration_date | datetime2 | - | Yes | Expiration date of work rights |
| employee_annual_practising_cert_expiry_date | datetime2 | - | Yes | Expiry date for practising certificate |
| employee_exception_police_vetting_expiry | datetime2 | - | Yes | Expiry date for police vetting |
| employee_ot_vetting | nvarchar | 500 | Yes | Oranga Tamariki vetting information |
| employee_exemption_granted | nvarchar | 500 | Yes | Exemptions granted |
| employee_mask_exemption | nvarchar | 500 | Yes | Mask exemption status |
| employee_vaccine_status | nvarchar | 4000 | Yes | Vaccination status |

### Management Information
| Column Name | Data Type | Length | Nullable | Description |
|-------------|-----------|--------|----------|-------------|
| employee_people_manager_id | nvarchar | 100 | Yes | ID of the manager |
| employee_people_manager_name | nvarchar | 100 | Yes | Name of the manager |
| employee_people_manager_Job_name | nvarchar | 100 | Yes | Job title of the manager |
| employee_people_manager_job_status | nvarchar | 100 | Yes | Job status of the manager |

### Additional Information
| Column Name | Data Type | Length | Nullable | Description |
|-------------|-----------|--------|----------|-------------|
| employee_smoking_status | nvarchar | 500 | Yes | Smoking status |
| employee_incidents | nvarchar | 100 | Yes | Incident information |
| employee_latest_incident_date | nvarchar | 100 | Yes | Date of latest incident |
| employee_disciplinary_status | nvarchar | 100 | Yes | Disciplinary status |
| employee_specific_needs | nvarchar | 100 | Yes | Special or specific needs |
| employee_qualification_level | nvarchar | 100 | Yes | Qualification level |
| employee_referral_source | nvarchar | 100 | Yes | Source of employee referral |

### Warehouse Audit Columns
| Column Name | Data Type | Length | Nullable | Description |
|-------------|-----------|--------|----------|-------------|
| DWHSourceSystem | nvarchar | 500 | No | Source system for the data (e.g., "IntelliHR.people") |
| DWHBatchId | int | - | No | Batch ID for ETL process |
| DWHDMLOperation | char | 1 | No | Data manipulation operation type |
| DWHEffectiveFrom | datetime | - | No | Start date for the row's validity |
| DWHEffectiveTo | datetime | - | No | End date for the row's validity |
| DWHIsCurrent | int | - | No | Flag indicating if this is the current record (1=Current, 0=Historical) |

## Indexes

| Index Name | Type | Columns | Description |
|------------|------|---------|-------------|
| PK_EDW_dim_employee | NONCLUSTERED | dim_employee_key | Primary key constraint |
| idx1_dim_employee | NONCLUSTERED | employee_id, DWHIsCurrent (including dim_employee_key) | Performance index for looking up current employee records |

## Data Lineage

The primary source of data for this table is the IntelliHR HR management system. Data is extracted from the source system, transformed, and loaded into the data warehouse as part of the regular ETL process.

## Slowly Changing Dimension (SCD) Type 2 Implementation

This table implements SCD Type 2 methodology to track historical changes to employee data. Key features of this implementation include:

1. **Historical Tracking**: When employee attributes change, a new row is created with the updated values.
2. **Validity Period**: Each row has `DWHEffectiveFrom` and `DWHEffectiveTo` dates that define when the record was valid.
3. **Current Flag**: The `DWHIsCurrent` column indicates the most current version of each employee record (1=Current, 0=Historical).
4. **Operation Tracking**: The `DWHDMLOperation` column indicates what type of operation created the record.

## Common Usage Patterns

This dimension table is typically used to:

1. **Join with Fact Tables**: Links with fact tables for employee-related metrics
2. **HR Analytics**: Supports workforce analytics and reporting
3. **Point-in-Time Analysis**: Enables analysis of employee data as it was at any point in time
4. **Compliance Reporting**: Supports regulatory and compliance reporting requirements

## Query Examples

### Get Current Employee Records
