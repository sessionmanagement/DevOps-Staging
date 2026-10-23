# EDW Property Tables Database Diagram

## Overview
This document provides a comprehensive database diagram for all tables in the EDW schema containing the word "property". The diagram shows relationships, primary keys, foreign keys, and key attributes for understanding the property data model structure.

## Table Categories

### Dimension Tables (dim_property_*)
- **dim_property** - Main property dimension
- **dim_property_arrears_arrangement** - Property arrears arrangements
- **dim_property_breach_type** - Breach type lookup
- **dim_property_detail** - Additional property details
- **dim_property_healthy_homes** - Healthy homes compliance data
- **dim_property_lease** - Property lease information
- **dim_property_maintenace_type** - Maintenance type lookup
- **dim_property_maintenance** - Property maintenance records
- **dim_property_program** - Property programs
- **dim_property_tenancy** - Property tenancy information

### Fact Tables (fact_property_*)
- **fact_property_arrears_transaction** - Property arrears transactions
- **fact_property_hazard** - Property hazards
- **fact_property_inspection** - Property inspections
- **fact_property_maintenance_task** - Maintenance tasks
- **fact_property_remedy_notice** - Remedy notices
- **fact_property_risk** - Property risks
- **fact_property_tenancy_breach** - Tenancy breaches
- **fact_property_tenancy_transaction** - Tenancy transactions
- **fact_property_tenant** - Property tenant information
- **fact_property_tribunal_order** - Tribunal orders

## Database Relationship Diagram

:::mermaid
erDiagram
    %% Core Property Dimension
    dim_property {
        int dim_property_key PK
        uniqueidentifier property_id UK
        varchar property_name
        varchar property_status
        varchar property_type
        varchar property_full_address
        varchar property_program
        varchar property_suburb
        varchar property_postcode
        int DWHBatchId
        datetime DWHEffectiveFrom
        datetime DWHEffectiveTo
        bit DWHIsCurrent
    }

    %% Property Detail Dimension
    dim_property_detail {
        int dim_property_detail_key PK
        uniqueidentifier property_detail_id UK
        varchar property_detail_no_of_bedrooms
        varchar property_detail_no_of_bathrooms
        varchar property_detail_construction_type
        varchar property_detail_roof_type
        varchar property_detail_accessibility
        numeric property_detail_floor_area
        int DWHBatchId
        datetime DWHEffectiveFrom
        datetime DWHEffectiveTo
        bit DWHIsCurrent
    }

    %% Property Tenancy Dimension
    dim_property_tenancy {
        int dim_property_tenancy_key PK
        int dim_property_key FK
        uniqueidentifier property_tenancy_id UK
        uniqueidentifier property_id FK
        varchar property_tenancy_tenancy_name
        varchar property_tenancy_customer_name
        date property_tenancy_tenancy_start_date
        date property_tenancy_actual_close_date
        numeric property_tenancy_rent
        varchar property_tenancy_tenancy_type
        varchar property_tenancy_program_name
        int DWHBatchId
        datetime DWHEffectiveFrom
        datetime DWHEffectiveTo
        bit DWHIsCurrent
    }

    %% Property Program Dimension
    dim_property_program {
        int dim_property_program_id PK
        nvarchar property_program_id UK
        nvarchar property_subprogram_id UK
        nvarchar property_program_name
        nvarchar property_subprogram_name
        nvarchar property_program_owner_name
        int DWHBatchId
        datetime DWHEffectiveFrom
        datetime DWHEffectiveTo
        bit DWHIsCurrent
    }

    %% Property Maintenance Dimension
    dim_property_maintenance {
        int dim_property_maintenance_key PK
        uniqueidentifier property_maintenance_id UK
        varchar property_maintenance_type
        varchar property_maintenance_task_status
        varchar property_maintenance_task_urgency
        varchar property_maintenance_property_status
        datetime property_maintenance_created_datetime
        int DWHBatchId
        datetime DWHEffectiveFrom
        datetime DWHEffectiveTo
        bit DWHIsCurrent
    }

    %% Property Healthy Homes Dimension
    dim_property_healthy_homes {
        int dim_property_healthy_homes_key PK
        uniqueidentifier property_healthy_homes_id UK
        varchar property_healthy_homes_compliance_statement
        varchar property_healthy_homes_insulation_ceiling_status
        varchar property_healthy_homes_insulation_under_floor_status
        varchar property_healthy_homes_main_heatsource
        datetime property_healthy_homes_compliance_date
        int DWHBatchId
        datetime DWHEffectiveFrom
        datetime DWHEffectiveTo
        bit DWHIsCurrent
    }

    %% Property Lease Dimension
    dim_property_lease {
        int dim_property_lease_id PK
        nvarchar property_lease_details_id UK
        nvarchar property_lease_details_name
        nvarchar property_lease_details_lease_type
        date property_lease_details_from_date
        date property_lease_details_to_date
        numeric property_lease_details_bond_amount
        int DWHBatchId
        datetime DWHEffectiveFrom
        datetime DWHEffectiveTo
        bit DWHIsCurrent
    }

    %% Property Arrears Arrangement Dimension
    dim_property_arrears_arrangement {
        int dim_property_arrears_arrangement_key PK
        uniqueidentifier property_arrears_arrangement_id UK
        int dim_property_tenancy_key FK
        int dim_property_key FK
        varchar arrears_arrangement
        varchar arrears_arrangement_type
        numeric amount
        date start_date_id
        date end_date_id
        int DWHBatchId
        datetime DWHEffectiveFrom
        datetime DWHEffectiveTo
        bit DWHIsCurrent
    }

    %% Property Maintenance Type Dimension
    dim_property_maintenace_type {
        int dim_property_maintenace_type_id PK
        nvarchar property_maintenance_type_id UK
        nvarchar property_maintenance_type
        nvarchar property_maintenance_priority
        int property_maintenance_service_agreement_flag
        int DWHBatchId
        datetime DWHEffectiveFrom
        datetime DWHEffectiveTo
        bit DWHIsCurrent
    }

    %% Property Breach Type Dimension
    dim_property_breach_type {
        int dim_property_breach_type_key PK
        int breach_type_id UK
        nvarchar breach_type
        int DWHBatchId
        datetime DWHEffectiveFrom
        datetime DWHEffectiveTo
        bit DWHIsCurrent
    }

    %% FACT TABLES

    %% Property Tenant Fact
    fact_property_tenant {
        int fact_property_tenant_key PK
        int dim_property_key FK
        int dim_property_tenancy_key FK
        int dim_property_program_key FK
        uniqueidentifier property_tenancy_id FK
        varchar property_tenant_id
        varchar property_tenant_first_name
        varchar property_tenant_last_name
        varchar property_tenant_full_name
        datetime property_tenancy_tenant_date_of_birth
        numeric property_tenancy_total_rent_amount
        int property_tenant_primary_tenant_flag
        int DWHBatchId
        datetime DWHCreatedAt
        datetime DWHModifiedOn
    }

    %% Property Tenancy Transaction Fact
    fact_property_tenancy_transaction {
        int fact_property_tenancy_transaction_id PK
        uniqueidentifier property_tenancy_transaction_id UK
        int dim_property_key FK
        int dim_property_tenancy_key FK
        int dim_property_program_key FK
        varchar property_tenancy_transaction_name
        varchar property_tenancy_transaction_type
        numeric property_tenancy_transaction_amount
        datetime property_tenancy_transaction_created_datetime
        int DWHBatchId
        datetime DWHCreatedAt
        datetime DWHModifiedOn
    }

    %% Property Inspection Fact
    fact_property_inspection {
        int fact_property_inspection_key PK
        uniqueidentifier property_inspection_id UK
        int dim_property_key FK
        int dim_property_tenancy_key FK
        int dim_property_maintenance_key FK
        varchar property_inspection_name
        varchar property_inspection_type
        varchar property_inspection_status
        varchar property_inspection_summary
        int property_inspection_tenant_present_flag
        int DWHBatchId
        datetime DWHCreatedAt
        datetime DWHModifiedOn
    }

    %% Property Maintenance Task Fact
    fact_property_maintenance_task {
        int fact_property_maintenance_task_key PK
        uniqueidentifier property_maintenance_task_id UK
        uniqueidentifier property_maintenance_id FK
        int dim_property_key FK
        int dim_property_maintenance_key FK
        int dim_property_program_key FK
        varchar property_maintenance_task_work_task_name
        varchar property_maintenance_task_maintenance_type_name
        numeric property_maintenance_task_amount
        datetime property_maintenance_task_created_datetime
        int DWHBatchId
        datetime DWHCreatedAt
        datetime DWHModifiedOn
    }

    %% Property Risk Fact
    fact_property_risk {
        int fact_property_risk_key PK
        uniqueidentifier property_risk_id UK
        int dim_property_key FK
        int dim_property_tenancy_key FK
        varchar property_risk_name
        varchar property_risk_category_name
        varchar property_risk_subcategory_name
        varchar property_risk_comments
        datetime property_risk_date_registered
        int DWHBatchId
        datetime DWHEffectiveFrom
        datetime DWHEffectiveTo
        bit DWHIsCurrent
    }

    %% Property Hazard Fact
    fact_property_hazard {
        int fact_property_hazard_key PK
        uniqueidentifier property_hazard_id UK
        int dim_property_key FK
        varchar hazard_name
        varchar hazard_type_label
        varchar hazard_classification_label
        varchar hazard_risklevel_label
        varchar hazard_location_label
        datetime hazard_date_identified
        int DWHBatchId
        datetime DWHEffectiveFrom
        datetime DWHEffectiveTo
        bit DWHIsCurrent
    }

    %% Property Arrears Transaction Fact
    fact_property_arrears_transaction {
        int fact_property_arrears_transaction_key PK
        uniqueidentifier transaction_id UK
        int dim_property_key FK
        int dim_property_tenancy_key FK
        int dim_property_arrears_arrangement_key FK
        varchar transaction_name
        varchar transaction_description
        numeric arrear_amount
        numeric paid_amount
        datetime transaction_date
        int DWHBatchId
        datetime DWHEffectiveFrom
        datetime DWHEffectiveTo
        bit DWHIsCurrent
    }

    %% Property Tenancy Breach Fact
    fact_property_tenancy_breach {
        int fact_property_tenancy_breach_key PK
        uniqueidentifier tenancy_breach_id UK
        int dim_property_tenancy_key FK
        uniqueidentifier property_tenancy_id FK
        varchar breach
        varchar tenancy_breach
        varchar breach_status
        datetime breach_date
        datetime breach_start_date
        datetime breach_end_date
        int DWHBatchId
        datetime DWHCreatedAt
        datetime DWHModifiedOn
    }

    %% Property Remedy Notice Fact
    fact_property_remedy_notice {
        int fact_property_remedy_notice_key PK
        uniqueidentifier property_remedy_notice_id UK
        int dim_property_key FK
        int dim_property_tenancy_key FK
        varchar remedy_notice
        varchar remedy_path
        varchar notes
        datetime remedy_notice_start_date
        varchar remedy_notice_status
        int DWHBatchId
        datetime DWHEffectiveFrom
        datetime DWHEffectiveTo
        bit DWHIsCurrent
    }

    %% Property Tribunal Order Fact
    fact_property_tribunal_order {
        int fact_property_tribunal_order_key PK
        uniqueidentifier property_tribunal_order_id UK
        int dim_property_key FK
        int dim_property_tenancy_key FK
        varchar tribunal_order
        varchar tribunal_outcome
        varchar tribunal_outcome_reason
        varchar notes
        datetime tribunal_order_start_date
        varchar tribunal_order_status
        int DWHBatchId
        datetime DWHEffectiveFrom
        datetime DWHEffectiveTo
        bit DWHIsCurrent
    }

    %% RELATIONSHIPS

    %% Core Property Relationships
    dim_property ||--o{ dim_property_tenancy : "property_id"
    dim_property ||--o{ fact_property_tenant : "dim_property_key"
    dim_property ||--o{ fact_property_inspection : "dim_property_key"
    dim_property ||--o{ fact_property_maintenance_task : "dim_property_key"
    dim_property ||--o{ fact_property_tenancy_transaction : "dim_property_key"
    dim_property ||--o{ fact_property_risk : "dim_property_key"
    dim_property ||--o{ fact_property_hazard : "dim_property_key"
    dim_property ||--o{ fact_property_arrears_transaction : "dim_property_key"
    dim_property ||--o{ fact_property_remedy_notice : "dim_property_key"
    dim_property ||--o{ fact_property_tribunal_order : "dim_property_key"

    %% Property Tenancy Relationships
    dim_property_tenancy ||--o{ fact_property_tenant : "dim_property_tenancy_key"
    dim_property_tenancy ||--o{ fact_property_inspection : "dim_property_tenancy_key"
    dim_property_tenancy ||--o{ fact_property_tenancy_transaction : "dim_property_tenancy_key"
    dim_property_tenancy ||--o{ fact_property_risk : "dim_property_tenancy_key"
    dim_property_tenancy ||--o{ fact_property_arrears_transaction : "dim_property_tenancy_key"
    dim_property_tenancy ||--o{ fact_property_tenancy_breach : "dim_property_tenancy_key"
    dim_property_tenancy ||--o{ fact_property_remedy_notice : "dim_property_tenancy_key"
    dim_property_tenancy ||--o{ fact_property_tribunal_order : "dim_property_tenancy_key"

    %% Property Program Relationships
    dim_property_program ||--o{ fact_property_tenant : "dim_property_program_key"
    dim_property_program ||--o{ fact_property_tenancy_transaction : "dim_property_program_key"
    dim_property_program ||--o{ fact_property_maintenance_task : "dim_property_program_key"
    dim_property_program ||--o{ fact_property_arrears_transaction : "dim_property_program_key"

    %% Property Maintenance Relationships
    dim_property_maintenance ||--o{ fact_property_inspection : "dim_property_maintenance_key"
    dim_property_maintenance ||--o{ fact_property_maintenance_task : "dim_property_maintenance_key"

    %% Property Arrears Arrangement Relationships
    dim_property_arrears_arrangement ||--o{ fact_property_arrears_transaction : "dim_property_arrears_arrangement_key"
    dim_property_tenancy ||--o{ dim_property_arrears_arrangement : "dim_property_tenancy_key"
    dim_property ||--o{ dim_property_arrears_arrangement : "dim_property_key"

:::



## Key Relationships Summary

### Primary Entity Flows
1. **Property ? Tenancy ? Transactions/Events**
   - `dim_property` is the core entity
   - `dim_property_tenancy` represents tenancy agreements for properties
   - Various fact tables capture events and transactions

2. **Property Programs**
   - `dim_property_program` links to properties through various fact tables
   - Tracks program and subprogram associations

3. **Property Maintenance**
   - `dim_property_maintenance` captures maintenance requests
   - `fact_property_maintenance_task` records specific maintenance tasks
   - `fact_property_inspection` tracks property inspections

4. **Property Financial Transactions**
   - `fact_property_tenancy_transaction` - All tenancy-related financial transactions
   - `fact_property_arrears_transaction` - Specific arrears-related transactions
   - `dim_property_arrears_arrangement` - Arrears payment arrangements

5. **Property Compliance & Safety**
   - `dim_property_healthy_homes` - Healthy homes compliance
   - `fact_property_hazard` - Property hazards
   - `fact_property_risk` - Risk assessments

6. **Property Legal & Enforcement**
   - `fact_property_tenancy_breach` - Tenancy breaches
   - `fact_property_remedy_notice` - Remedy notices issued
   - `fact_property_tribunal_order` - Tribunal orders

## Key Business Rules

### Data Warehouse Standards
- All tables include standard DWH audit columns: `DWHBatchId`, `DWHEffectiveFrom`, `DWHEffectiveTo`, `DWHIsCurrent`
- Dimension tables use SCD Type 2 (Slowly Changing Dimensions)
- Fact tables typically include creation and modification timestamps

### Key Constraints
- Primary keys are surrogate keys (integers)
- Business keys use GUIDs for most entities
- Foreign key relationships maintain referential integrity
- Soft deletes implemented via `is_delete_flag` columns

### Common Patterns
- **Lookup Tables**: `dim_property_breach_type`, `dim_property_maintenace_type`
- **Core Entities**: `dim_property`, `dim_property_tenancy`
- **Extended Attributes**: `dim_property_detail`, `dim_property_healthy_homes`
- **Transactional Facts**: `fact_property_tenancy_transaction`, `fact_property_arrears_transaction`
- **Event Facts**: `fact_property_inspection`, `fact_property_maintenance_task`

## Usage Notes

### For Developers
- Use `dim_property_key` for joins to the main property dimension
- Property business key is `property_id` (GUID)
- Tenancy business key is `property_tenancy_id` (GUID)
- Check `DWHIsCurrent = 1` for current records in dimensions

### For Analysts
- Join fact tables to dimensions using the `_key` fields
- Use `property_full_address` for property location analysis
- Check `property_tenancy_tenancy_start_date` and `property_tenancy_actual_close_date` for tenancy periods
- Financial amounts have both transaction currency and base currency versions

### Performance Considerations
- Primary keys are clustered indexes
- Consider partitioning large fact tables by date
- Use appropriate indexes on commonly filtered columns
- Be aware of SCD Type 2 implications when querying historical data

---

*This diagram represents the property-related tables in the EDW schema as of August 2025. For the most current schema information, refer to the database metadata or contact the data architecture team.*