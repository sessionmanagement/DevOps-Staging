CREATE PROC [staging].[insert_staging_fact_property_risk]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_fact_property_risk]
PURPOSE:  Insert data from landing table to staging table for fact_property_risk

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2025-04-16    Greg Nuthall		Initial version
1.1		 2026-02-26    GitHub Copilot	Updated header - 8 total columns removed
****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLfact_property_risk]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLfact_property_risk]
    (
    [property_risk_id]
    ,[riskregister_row_id]
    ,dim_property_key
    ,dim_property_tenancy_key
    ,[property_id]
    ,[property_tenancy_id]
    ,[property_household_id]
    ,[property_householdmember_id]
    ,[property_risk_contact_id]
    ,[property_risk_application_id]
    ,[property_risk_category_id]
    ,[property_risk_category_name]
    ,[property_risk_subcategory_id]
    ,[property_risk_subcategory_name]
    ,[risk_status_label]
    ,[property_risk_name]
    ,[property_risk_comments]
    ,[property_risk_contact_name]
    ,[property_risk_householdmember_name]
    ,[property_risk_household_name]
    ,[property_risk_tenancy_name]
    ,[property_risk_property_name]
    ,[property_risk_application_name]
    ,[property_risk_chintaro_id]
    ,[property_risk_date_registered]
    ,[property_risk_date_next_review]
    ,[risk_state_code]
    ,[risk_status_code_crm]
    ,[risk_is_delete_flag]

    )
SELECT
    [property_risk_id] 
	, [riskregister_row_id] 
	, isnull(p.dim_property_key,case when pr.property_id is null then 0 else -1 end) as dim_property_key
	, isnull(pt.dim_property_tenancy_key,case when pr.property_tenancy_id is null then 0 else -1 end) as dim_property_tenancy_key
	, pr.[property_id] 
	, pr.[property_tenancy_id]
	, [property_household_id] 
	, [property_householdmember_id] 
	, [property_risk_contact_id] 
	, [property_risk_application_id] 
	, [property_risk_category_id] 
	, [property_risk_category_name] 
	, [property_risk_subcategory_id] 
	, [property_risk_subcategory_name] 
	, [risk_status_label] 
	, [property_risk_name] 
	, [property_risk_comments] 
	, [property_risk_contact_name] 
	, [property_risk_householdmember_name] 
	, [property_risk_household_name] 
	, [property_risk_tenancy_name] 
	, [property_risk_property_name] 
	, [property_risk_application_name] 
	, [property_risk_chintaro_id] 
	, [property_risk_date_registered] 
	, [property_risk_date_next_review] 
	, [risk_state_code] 
	, [risk_status_code_crm] 
	, [risk_is_delete_flag]

from [Landing].[edw_fact_property_risk] pr
    left outer join edw.dim_property p on pr.property_id = p.property_id and p.DWHIsCurrent = 1
    left outer join edw.dim_property_tenancy pt on pr.property_tenancy_id = pt.property_tenancy_id and pt.DWHIsCurrent = 1