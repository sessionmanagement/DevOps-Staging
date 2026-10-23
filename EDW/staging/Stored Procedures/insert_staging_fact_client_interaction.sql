CREATE PROC [staging].[insert_staging_fact_client_interaction]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_fact_client_interaction]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2026-08-05    Malhar Badheka	Initial version
1.1		 2026-08-05    Malhar Badheka	Added dim key for client,interaction_type and employee
1.2		 2026-08-05    Malhar Badheka	added condtion in employee_join to remove duplicate records in case of multiple employees with same email address
****************************************************************************/


--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLfact_client_interaction]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLfact_client_interaction] (
	 [dim_company_key]
	 ,[dim_client_key]
	 ,[dim_client_interaction_type_key]
	 ,[dim_employee_key]
	,[client_interaction_id] 
	,[client_id] 
	,[client_interaction_type_id]
	,[client_interaction_date] 
	,[client_interaction_created_date] 
	,[client_interaction_comments] 
	)
	SELECT 
		 cif.[company_key] as dim_company_key
		,CASE WHEN isnull(cif.[client_id],0) = 0 THEN 0		  WHEN isnull(pc.dim_client_key,0) = 0 THEN -1		  else pc.dim_client_key 	 end as dim_client_key 
		,isnull(citd.dim_client_interaction_type_key, CASE WHEN cif.[client_interaction_type_id] IS NOT NULL THEN -1 ELSE 0 END) AS dim_client_interaction_type_key 
		,COALESCE(    ed.dim_employee_key,     ed2.dim_employee_key,
				CASE 
					WHEN cif.employee_id IS NOT NULL THEN -1 
				ELSE 0 
	    END	) AS dim_employee_key 
		,cif.[client_interaction_id] 
		,cif.[client_id]
		,cif.[client_interaction_type_id]
		,cif.[client_interaction_date] 
		,cif.[client_interaction_created_date] 
		,cif.[client_interaction_comments] 
	FROM [Landing].[edw_fact_client_interaction] cif
	LEFT OUTER JOIN edw.[dim_client_interaction_type] citd on citd.[client_interaction_type_id] = cif.[client_interaction_type_id] and citd.company_key =  cif.[company_key]
	LEFT OUTER JOIN edw.dim_client pc 	on cif.client_id = pc.client_id and cif.[company_key] = pc.company_id 	and pc.DWHIsCurrent = 1
	LEFT OUTER JOIN edw.dim_employee ed on ed.employee_id = cif.[employee_id] and ed.DWHIsCurrent = 1 AND ed.employee_id <> 0 and ed.DWHDMLOperation <> 'D'
	LEFT OUTER JOIN (		SELECT 
								LOWER(TRIM(employee_primary_email_address)) as employee_email,
								MAX(dim_employee_key) as dim_employee_key
							FROM edw.dim_employee
							WHERE DWHIsCurrent = 1 
							  AND employee_id <> 0 
							  AND DWHDMLOperation <> 'D'
							GROUP BY LOWER(TRIM(employee_primary_email_address))
					) ed2 on  ed2.employee_email = LOWER(TRIM(cif.[employee_email]))

