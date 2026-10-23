
CREATE PROC [staging].[insert_staging_fact_client_primhd_service_review]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_fact_client_primhd_service_review]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2026-04-21    Pankaj Bhatt		Initial version

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLfact_client_primhd_service_review]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLfact_client_primhd_service_review] (
	 [dim_company_key] 
	,[dim_client_key]
    ,[dim_client_unique_key]
    ,[dim_client_referral_key]
    ,[dim_client_referral_unique_key]
    ,[dim_created_by_employee_key]
    ,[dim_review_date_key]
    ,[dim_created_date_key]
    ,[primhd_service_review_id] 
	,[client_id] 
	,[client_referral_id] 
	,[created_by_employee_id] 
	,[created_by_user_email_address] 
	,[review_date] 
	,[created_date] 
	,[accommodation_status_value] 
	,[accommodation_status_text] 
	,[parent_accommodation_status_value] 
	,[parent_accommodation_status_text] 
	,[education_status_value] 
	,[education_status_text] 
	,[parent_education_status_value] 
	,[parent_education_status_text] 
	,[employment_status_value] 
	,[employment_status_text] 
	,[parent_employment_status_value] 
	,[parent_employment_status_text] 
	,[wellness_plan_status_value] 
	,[wellness_plan_status_text] 
	,[parent_wellness_plan_status_value] 
	,[parent_wellness_plan_status_text] 
	)
SELECT
	 l.[dim_company_key] as dim_company_key
	,isnull(dc.dim_client_key, CASE WHEN l.client_id IS NOT NULL THEN -1 ELSE 0 END) AS dim_client_key	
	,cast(l.client_id as nvarchar) + '-' + cast(l.dim_company_key as nvarchar) as dim_client_unique_key
	,isnull(dr.dim_client_referral_key, CASE WHEN l.client_referral_id IS NOT NULL THEN -1 ELSE 0 END) as dim_client_referral_key
	,cast(l.client_referral_id as nvarchar)+'_'+ cast(l.client_id as nvarchar)+'_'+ cast(l.dim_company_key as nvarchar) as dim_client_referral_unique_key
	,isnull(empl1.dim_employee_key, CASE WHEN (ISNULL(try_cast(l.created_by_employee_id as int),0) <> 0 or l.created_by_user_email_address IS NOT NULL ) THEN -1 ELSE 0 END) as dim_created_by_employee_key
    ,FORMAT(cast(l.review_date AS DATE), 'yyyyMMdd') as dim_review_date_key
    ,FORMAT(cast(l.created_date AS DATE), 'yyyyMMdd') as dim_created_date_key
	,l.[primhd_service_review_id] 
	,l.[client_id] 
	,l.[client_referral_id] 
	,empl1.employee_id as created_by_employee_id
	,l.[created_by_user_email_address] 
	,l.[review_date] 
	,l.[created_date] 
	,l.[accommodation_status_value] 
	,l.[accommodation_status_text] 
	,l.[parent_accommodation_status_value] 
	,l.[parent_accommodation_status_text] 
	,l.[education_status_value] 
	,l.[education_status_text] 
	,l.[parent_education_status_value] 
	,l.[parent_education_status_text] 
	,l.[employment_status_value] 
	,l.[employment_status_text] 
	,l.[parent_employment_status_value] 
	,l.[parent_employment_status_text] 
	,l.[wellness_plan_status_value] 
	,l.[wellness_plan_status_text] 
	,l.[parent_wellness_plan_status_value] 
	,l.[parent_wellness_plan_status_text] 
from [Landing].[edw_fact_client_primhd_service_review] l
left outer join edw.dim_client dc on l.dim_company_key = dc.company_id and l.client_id = dc.client_id and dc.DWHIsCurrent = 1
left outer join edw.dim_client_referral dr ON l.[client_referral_id] = dr.[client_referral_id]
				AND l.dim_company_key = dr.[company_id]
				AND l.client_id = dr.client_id
left outer join reference.edw_lookup elk1 on cast(l.created_by_employee_id as nvarchar) = Cast(elk1.Input_Value as nvarchar) and elk1.Category = 'dim_employee.employee_id'
left outer join reference.edw_lookup elk11 ON CAST(UPPER(TRIM(l.created_by_user_email_address)) AS NVARCHAR(MAX)) = CAST(UPPER(TRIM(elk11.Input_Value)) AS NVARCHAR(MAX)) AND elk11.Category = 'dim_employee.employee_name'
outer apply
(    SELECT TOP 1 empl_inner.*
    FROM edw.dim_employee empl_inner
    WHERE 
        -- Only consider current, non-unknown employee records
        empl_inner.DWHIsCurrent = 1 AND empl_inner.employee_id <> 0   
        -- Only include employees who are actual matches on ID OR Email
        AND (
            -- Match 1: By ID (Looked-up or Original)
            empl_inner.employee_id = ISNULL(elk1.Output_Value, TRY_CAST(l.created_by_employee_id AS INT))           
            -- OR Match 2: By Raw Email
            OR UPPER(TRIM(empl_inner.employee_primary_email_address)) = UPPER(TRIM(l.created_by_user_email_address))
            -- OR Match 3: By Email Lookup
            OR empl_inner.employee_id = TRY_CAST(elk11.Output_Value AS INT)
        )        
    ORDER BY
        -- Priority 1: ID Match (Highest Priority)
        CASE WHEN empl_inner.employee_id = ISNULL(elk1.Output_Value, TRY_CAST(l.created_by_employee_id AS INT)) THEN 1 ELSE 0 END DESC,      
        -- Priority 2: Raw Email Match
        CASE WHEN UPPER(TRIM(empl_inner.employee_primary_email_address)) = UPPER(TRIM(l.created_by_user_email_address)) THEN 1 ELSE 0 END DESC,      
        -- Priority 3: ID from Email lookup
        CASE WHEN empl_inner.employee_id = TRY_CAST(elk11.Output_Value AS INT) THEN 1 ELSE 0 END DESC,
        -- Ensures only one row is selected if multiple employees match (e.g., duplicate emails)
        empl_inner.employee_id ASC 
) empl1