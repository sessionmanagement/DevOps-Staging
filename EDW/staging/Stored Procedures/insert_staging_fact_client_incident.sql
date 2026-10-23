






CREATE PROC [staging].[insert_staging_fact_client_incident]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_fact_client_incident]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2025-11-11    Pankaj Bhatt		Initial version
1.1		 2025-11-28    Pankaj Bhatt		Added IncidentStatus
1.2		 2025-12-15    Pankaj Bhatt		Updated to include Email to ID match from lookup
1.3		 2026-01-13	   Pankaj Bhatt		added composite key

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLfact_client_incident]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLfact_client_incident] (
            [dim_client_incident_company_key_incident_id_key]
           ,[dim_client_incident_company_key_category_type_id_key]
           ,[dim_client_incident_company_key_severity_id_key]
           ,[dim_client_incident_company_key_status_type_id_key]
	       ,[dim_company_key]
           ,[dim_client_incident_key]
           ,[dim_incident_date_key]
           ,[dim_incident_created_date_key]
           ,[dim_current_owner_employee_key]
           ,[dim_current_investigator_employee_key]
           ,[dim_current_reporter_employee_key]
           ,[dim_creator_employee_key]
           ,[dim_current_client_incident_status_type_key]
           ,[dim_client_team_key]
           ,[dim_originator_employee_key]
           ,[dim_current_client_incident_severity_key]
           ,[dim_client_incident_category_type_key]
           ,[incident_id]
           ,[incident_date]
           ,[incident_created_date]
           ,[current_owner_employee_id]
           ,[current_investigator_employee_id]
           ,[current_reporter_employee_id]
           ,[creator_employee_id]
           ,[current_owner_email_address]
           ,[current_investigator_email_address]
           ,[current_reporter_email_address]
           ,[creator_email_address]
           ,[current_incident_status_type_id]
           ,[current_incident_status_created_date]
           ,[client_team_id]
           ,[originator_employee_id]
           ,[originator_email_address]
           ,[current_incident_severity_id]
           ,[incident_category_type_id] 
	)
SELECT
	 isnull(dci.dim_client_incident_company_key_incident_id_key, CASE WHEN l.incident_id IS NOT NULL THEN -1 ELSE 0 END) AS dim_client_incident_company_key_incident_id_key
    ,IIf(l.incident_category_type_id > 0, Cast(l.company_key As bigint) * 1000000000 + l.incident_category_type_id, l.incident_category_type_id) AS dim_client_incident_company_key_category_type_id_key
    ,IIf(l.current_incident_severity_id > 0, Cast(l.company_key As bigint) * 1000000000 + l.current_incident_severity_id, l.current_incident_severity_id) AS dim_client_incident_company_key_severity_id_key
    ,IIf(l.current_incident_status_type_id > 0, Cast(l.company_key As bigint) * 1000000000 + l.current_incident_status_type_id, l.current_incident_status_type_id) AS dim_client_incident_company_key_status_type_id_key

    ,l.[company_key] as dim_company_key
    ,isnull(dci.dim_client_incident_key, CASE WHEN l.incident_id IS NOT NULL THEN -1 ELSE 0 END) AS dim_client_incident_key

    ,FORMAT(cast(l.[incident_date] AS DATE), 'yyyyMMdd') as dim_incident_date_key
    ,FORMAT(cast(l.[incident_created_date] AS DATE), 'yyyyMMdd') as dim_incident_created_date_key
    -- UserEmployeeNumber from dlDimUser is sometimes varchar so need to add try_Cast otherwise it fails using ISNULL example rbeal.dlDimUser UserID - 503627,503710,503921
    ,isnull(empl1.dim_employee_key, CASE WHEN (ISNULL(try_cast(l.current_owner_user_id as int),0) <> 0 or l.current_owner_user_email_address IS NOT NULL ) THEN -1 ELSE 0 END) as dim_current_owner_employee_key
    ,isnull(empl2.dim_employee_key, CASE WHEN (ISNULL(try_cast(l.current_investigator_user_id as int),0) <> 0 or l.current_investigator_user_email_address IS NOT NULL ) THEN -1 ELSE 0 END) as dim_current_investigator_employee_key
    ,isnull(empl3.dim_employee_key, CASE WHEN (ISNULL(try_cast(l.current_reporter_user_id as int),0) <> 0 or l.current_reporter_user_email_address IS NOT NULL ) THEN -1 ELSE 0 END) as dim_current_reporter_employee_key
    ,isnull(empl4.dim_employee_key, CASE WHEN (ISNULL(try_cast(l.incident_created_user_id as int),0) <> 0 or l.incident_created_user_email_address IS NOT NULL ) THEN -1 ELSE 0 END) as dim_creator_employee_key

    ,isnull(dcist.dim_client_incident_status_type_key, CASE WHEN l.current_incident_status_type_id IS NOT NULL THEN -1 ELSE 0 END) AS dim_current_client_incident_status_type_key

    ,isnull(dct.dim_client_team_key, CASE WHEN l.team_id IS NOT NULL THEN -1 ELSE 0 END) AS dim_client_team_key

    ,isnull(empl5.dim_employee_key, CASE WHEN (ISNULL(try_cast(l.originator_user_id as int),0) <> 0 or l.originator_user_email_address IS NOT NULL ) THEN -1 ELSE 0 END) as dim_originator_employee_key

    ,isnull(dcis.dim_client_incident_severity_key, CASE WHEN l.current_incident_severity_id IS NOT NULL THEN -1 ELSE 0 END) AS dim_current_client_incident_severity_key

    ,isnull(dcict.dim_client_incident_category_type_key, CASE WHEN l.incident_category_type_id IS NOT NULL THEN -1 ELSE 0 END) AS dim_client_incident_category_type_key
    
	,l.[incident_id]
    ,l.[incident_date]
    ,l.[incident_created_date]
	,empl1.employee_id as current_owner_employee_id 
	,empl2.employee_id as current_investigator_employee_id  
	,empl3.employee_id as current_reporter_employee_id 
	,empl4.employee_id as creator_employee_id
	,l.[current_owner_user_email_address] as current_owner_email_address
	,l.[current_investigator_user_email_address] as current_investigator_email_address
	,l.[current_reporter_user_email_address] as current_reporter_email_address
	,l.[incident_created_user_email_address] as creator_email_address
	,l.[current_incident_status_type_id]
    ,l.[current_incident_status_created_date]
	,l.[team_id] as client_team_id
	,empl5.employee_id as originator_employee_id
	,l.[originator_user_email_address] as originator_email_address
	,l.[current_incident_severity_id] 
	,l.[incident_category_type_id] 
from [Landing].[edw_fact_client_incident] l
left outer join edw.dim_client_incident dci on l.incident_id = dci.incident_id and l.company_key = dci.dim_company_key and dci.DWHIsCurrent = 1
left outer join reference.edw_lookup elk1 on cast(l.current_owner_user_id as nvarchar) = Cast(elk1.Input_Value as nvarchar) and elk1.Category = 'dim_employee.employee_id'
LEFT OUTER JOIN reference.edw_lookup elk11 ON CAST(UPPER(TRIM(l.current_owner_user_email_address)) AS NVARCHAR(MAX)) = CAST(UPPER(TRIM(elk11.Input_Value)) AS NVARCHAR(MAX)) AND elk11.Category = 'dim_employee.employee_name'
outer apply
(    SELECT TOP 1 empl_inner.*
    FROM edw.dim_employee empl_inner
    WHERE 
        -- Only consider current, non-unknown employee records
        empl_inner.DWHIsCurrent = 1 AND empl_inner.employee_id <> 0   
        -- Only include employees who are actual matches on ID OR Email
        AND (
            -- Match 1: By ID (Looked-up or Original)
            empl_inner.employee_id = ISNULL(elk1.Output_Value, TRY_CAST(l.current_owner_user_id AS INT))           
            -- OR Match 2: By Raw Email
            OR UPPER(TRIM(empl_inner.employee_primary_email_address)) = UPPER(TRIM(l.current_owner_user_email_address))
            -- OR Match 3: By Email Lookup
            OR empl_inner.employee_id = TRY_CAST(elk11.Output_Value AS INT)
        )        
    ORDER BY
        -- Priority 1: ID Match (Highest Priority)
        CASE WHEN empl_inner.employee_id = ISNULL(elk1.Output_Value, TRY_CAST(l.current_owner_user_id AS INT)) THEN 1 ELSE 0 END DESC,      
        -- Priority 2: Raw Email Match
        CASE WHEN UPPER(TRIM(empl_inner.employee_primary_email_address)) = UPPER(TRIM(l.current_owner_user_email_address)) THEN 1 ELSE 0 END DESC,      
        -- Priority 3: ID from Email lookup
        CASE WHEN empl_inner.employee_id = TRY_CAST(elk11.Output_Value AS INT) THEN 1 ELSE 0 END DESC,
        -- Ensures only one row is selected if multiple employees match (e.g., duplicate emails)
        empl_inner.employee_id ASC 
) empl1
left outer join reference.edw_lookup elk2 on cast(l.current_investigator_user_id as nvarchar) = Cast(elk2.Input_Value as nvarchar) and elk2.Category = 'dim_employee.employee_id'
LEFT OUTER JOIN reference.edw_lookup elk21 ON CAST(UPPER(TRIM(l.current_investigator_user_email_address)) AS NVARCHAR(MAX)) = CAST(UPPER(TRIM(elk21.Input_Value)) AS NVARCHAR(MAX)) AND elk21.Category = 'dim_employee.employee_name'
outer apply
(
    SELECT TOP 1 empl_inner.*
    FROM edw.dim_employee empl_inner
    WHERE 
        empl_inner.DWHIsCurrent = 1 AND empl_inner.employee_id <> 0    
        AND (
            empl_inner.employee_id = ISNULL(elk2.Output_Value, TRY_CAST(l.current_investigator_user_id AS INT))        
            OR UPPER(TRIM(empl_inner.employee_primary_email_address)) = UPPER(TRIM(l.current_investigator_user_email_address))
            OR empl_inner.employee_id = TRY_CAST(elk21.Output_Value AS INT)
        )        
    ORDER BY
        CASE WHEN empl_inner.employee_id = ISNULL(elk2.Output_Value, TRY_CAST(l.current_investigator_user_id AS INT)) THEN 1 ELSE 0 END DESC,        
        CASE WHEN UPPER(TRIM(empl_inner.employee_primary_email_address)) = UPPER(TRIM(l.current_investigator_user_email_address)) THEN 1 ELSE 0 END DESC,
        CASE WHEN empl_inner.employee_id = TRY_CAST(elk21.Output_Value AS INT) THEN 1 ELSE 0 END DESC,
        empl_inner.employee_id ASC
) empl2
left outer join reference.edw_lookup elk3 on cast(l.current_reporter_user_id as nvarchar) = Cast(elk3.Input_Value as nvarchar) and elk3.Category = 'dim_employee.employee_id'
LEFT OUTER JOIN reference.edw_lookup elk31 ON CAST(UPPER(TRIM(l.current_reporter_user_email_address)) AS NVARCHAR(MAX)) = CAST(UPPER(TRIM(elk31.Input_Value)) AS NVARCHAR(MAX)) AND elk31.Category = 'dim_employee.employee_name'
outer apply
(
    SELECT TOP 1 empl_inner.*
    FROM edw.dim_employee empl_inner
    WHERE 
        empl_inner.DWHIsCurrent = 1 AND empl_inner.employee_id <> 0    
        AND (
            empl_inner.employee_id = ISNULL(elk3.Output_Value, TRY_CAST(l.current_reporter_user_id AS INT))        
            OR UPPER(TRIM(empl_inner.employee_primary_email_address)) = UPPER(TRIM(l.current_reporter_user_email_address))
            OR empl_inner.employee_id = TRY_CAST(elk31.Output_Value AS INT)
        )        
    ORDER BY
        CASE WHEN empl_inner.employee_id = ISNULL(elk3.Output_Value, TRY_CAST(l.current_reporter_user_id AS INT)) THEN 1 ELSE 0 END DESC,        
        CASE WHEN UPPER(TRIM(empl_inner.employee_primary_email_address)) = UPPER(TRIM(l.current_reporter_user_email_address)) THEN 1 ELSE 0 END DESC,
        CASE WHEN empl_inner.employee_id = TRY_CAST(elk31.Output_Value AS INT) THEN 1 ELSE 0 END DESC,
        empl_inner.employee_id ASC
) empl3
left outer join reference.edw_lookup elk4 on cast(l.incident_created_user_id as nvarchar) = Cast(elk4.Input_Value as nvarchar) and elk4.Category = 'dim_employee.employee_id'
LEFT OUTER JOIN reference.edw_lookup elk41 ON CAST(UPPER(TRIM(l.incident_created_user_email_address)) AS NVARCHAR(MAX)) = CAST(UPPER(TRIM(elk41.Input_Value)) AS NVARCHAR(MAX)) AND elk41.Category = 'dim_employee.employee_name'
outer apply
(
    SELECT TOP 1 empl_inner.*
    FROM edw.dim_employee empl_inner
    WHERE 
        empl_inner.DWHIsCurrent = 1 AND empl_inner.employee_id <> 0    
        AND (
            empl_inner.employee_id = ISNULL(elk4.Output_Value, TRY_CAST(l.incident_created_user_id AS INT))        
            OR UPPER(TRIM(empl_inner.employee_primary_email_address)) = UPPER(TRIM(l.incident_created_user_email_address))
            OR empl_inner.employee_id = TRY_CAST(elk41.Output_Value AS INT)
        )        
    ORDER BY
        CASE WHEN empl_inner.employee_id = ISNULL(elk4.Output_Value, TRY_CAST(l.incident_created_user_id AS INT)) THEN 1 ELSE 0 END DESC,        
        CASE WHEN UPPER(TRIM(empl_inner.employee_primary_email_address)) = UPPER(TRIM(l.incident_created_user_email_address)) THEN 1 ELSE 0 END DESC,
        CASE WHEN empl_inner.employee_id = TRY_CAST(elk41.Output_Value AS INT) THEN 1 ELSE 0 END DESC,
        empl_inner.employee_id ASC
) empl4
left outer join edw.dim_client_incident_status_type dcist on l.current_incident_status_type_id = dcist.incident_status_type_id and l.company_key = dcist.dim_company_key and dcist.DWHIsCurrent = 1

left outer join edw.dim_client_team dct on l.team_id = dct.client_team_id and l.company_key = dct.company_id and dct.DWHDMLOperation <> 'D' and dct.DWHDMLOperation <> 'M'

left outer join reference.edw_lookup elk5 on cast(l.originator_user_id as nvarchar) = Cast(elk5.Input_Value as nvarchar) and elk5.Category = 'dim_employee.employee_id'
LEFT OUTER JOIN reference.edw_lookup elk51 ON CAST(UPPER(TRIM(l.originator_user_email_address)) AS NVARCHAR(MAX)) = CAST(UPPER(TRIM(elk51.Input_Value)) AS NVARCHAR(MAX)) AND elk51.Category = 'dim_employee.employee_name'
outer apply
(
    SELECT TOP 1 empl_inner.*
    FROM edw.dim_employee empl_inner
    WHERE 
        empl_inner.DWHIsCurrent = 1 AND empl_inner.employee_id <> 0    
        AND (
            empl_inner.employee_id = ISNULL(elk5.Output_Value, TRY_CAST(l.originator_user_id AS INT))        
            OR UPPER(TRIM(empl_inner.employee_primary_email_address)) = UPPER(TRIM(l.originator_user_email_address))
            OR empl_inner.employee_id = TRY_CAST(elk51.Output_Value AS INT)
        )        
    ORDER BY
        CASE WHEN empl_inner.employee_id = ISNULL(elk5.Output_Value, TRY_CAST(l.originator_user_id AS INT)) THEN 1 ELSE 0 END DESC,        
        CASE WHEN UPPER(TRIM(empl_inner.employee_primary_email_address)) = UPPER(TRIM(l.originator_user_email_address)) THEN 1 ELSE 0 END DESC,
        CASE WHEN empl_inner.employee_id = TRY_CAST(elk51.Output_Value AS INT) THEN 1 ELSE 0 END DESC,
        empl_inner.employee_id ASC
) empl5

left outer join edw.dim_client_incident_severity dcis on l.current_incident_severity_id = dcis.incident_severity_id and l.company_key = dcis.dim_company_key and dcis.DWHIsCurrent = 1

left outer join edw.dim_client_incident_category_type dcict on l.incident_category_type_id = dcict.incident_category_type_id and l.company_key = dcict.dim_company_key and dcict.DWHIsCurrent = 1