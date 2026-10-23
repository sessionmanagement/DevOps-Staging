
CREATE PROC [staging].[insert_staging_fact_client_account_activity]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_fact_client_account_activity]
PURPOSE:  Move data from Landing.edw_fact_client_account_activity table into
			staging.edw_fact_client_account_activity table 

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2024-10-16    Greg Nuthall		Initial version
1.1		 2024-10-16    Greg Nuthall		Added client team area
1.2      2026-01-22    Greg Nuthall		Added participated_employee_id and created_user_id removed client_account_id
****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLfact_client_account_activity]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLfact_client_account_activity] (
	 [fact_client_account_activity_id] 
	,dim_client_team_key
	,dim_service_key
	,dim_company_key
	,dim_participated_employee_key
	,dim_created_employee_key
	,[client_account_activity_id] 
	,[client_account_activity_location] 
	,[client_account_activity_subject] 
	,[client_account_activity_description_html] 
	,[client_account_activity_description_raw] 
	,[client_account_activity_start_date] 
	,[client_account_activity_end_date] 
	,[client_account_activity_type_id] 
	,[client_account_activity_classification_id] 
	,[client_account_activity_created_date] 
	,[client_account_activity_created_user_id] 
	,[client_account_activity_udf1] 
	,[client_account_activity_udf2] 
	,[client_account_activity_udf3] 
	,[client_account_activity_udf4] 
	,[client_account_activity_udf5] 
	,[client_account_activity_other_participants] 
	,[client_team_id] 
	,[client_account_activity_audience_size] 
	,[client_account_activity_classification_text] 
	,[client_account_activity_type_text] 
	,[client_account_name] 
	,[company_id] 
	,[primary_contact_id] 
	,[participated_employee_id]
	,[created_employee_id]
	)
SELECT
	 src.[fact_client_account_activity_id]
	 ,case when isnull(src.client_team_id,0) <= 0 or isnull(src.company_id,0) <= 0 then 0
	      when isnull(ct.dim_client_team_key,-999) = -999 then -1
		  else ct.dim_client_team_key
	end as dim_client_team_key
	,case when isnull(src.client_team_id,0) <= 0 or isnull(src.company_id,0) <= 0 then 0
	      when isnull(ct.dim_service_key,-999) = -999 then -1
		  else ct.dim_service_key
	end as dim_service_key
	,case when isnull(src.company_id,0) <= 0 then 0
	      when isnull(c.dim_company_key,-999) = -999 then -1
		  else c.dim_company_key
	end as dim_company_key
	,case when isnull(participated_employee_id,0) <= 0 then 0
	      when isnull(e1.dim_employee_key,-999) = -999 then -1
		  else e1.dim_employee_key
	end

	,case when isnull(created_employee_id,0) <= 0 then 0
	      when isnull(e2.dim_employee_key,-999) = -999 then -1
		  else e2.dim_employee_key
	end
	,src.[client_account_activity_id] 
	,src.[client_account_activity_location] 
	,src.[client_account_activity_subject] 
	,src.[client_account_activity_description_html] 
	,src.[client_account_activity_description_raw] 
	,src.[client_account_activity_start_date] 
	,src.[client_account_activity_end_date] 
	,src.[client_account_activity_type_id] 
	,src.[client_account_activity_classification_id] 
	,src.[client_account_activity_created_date] 
	,src.[client_account_activity_created_user_id] 
	,src.[client_account_activity_udf1] 
	,src.[client_account_activity_udf2] 
	,src.[client_account_activity_udf3] 
	,src.[client_account_activity_udf4] 
	,src.[client_account_activity_udf5] 
	,src.[client_account_activity_other_participants] 
	,src.[client_team_id] 
	,src.[client_account_activity_audience_size] 
	,src.[client_account_activity_classification_text] 
	,src.[client_account_activity_type_text] 
	,src.[client_account_name] 
	,src.[company_id] 
	,src.[primary_contact_id]
	,src.[participated_employee_id]
	,src.[created_employee_id]

	from [Landing].[edw_fact_client_account_activity] src
	left join edw.dim_company c 
		on src.company_id = c.company_id 
		and c.DWHIsCurrent = 1
	left join edw.dim_client_team ct 
		on src.client_team_id = ct.client_team_id and src.company_id = ct.company_id 
		and ct.DWHDMLOperation <> 'D'
		and ct.DWHDMLOperation <> 'M'
	left join reference.edw_lookup elk 
		on cast(src.participated_employee_id as nvarchar) = cast(elk.Input_Value as nvarchar)
		and elk.Category = 'dim_employee.employee_id'
	left join edw.dim_employee e1 
		on isnull(elk.Output_Value,src.participated_employee_id) = e1.employee_id 
		and e1.DWHIsCurrent = 1
	left join reference.edw_lookup elk2 
		on cast(src.created_employee_id as nvarchar) = cast(elk2.Input_Value as nvarchar)
		and elk2.Category = 'dim_employee.employee_id'
	left join edw.dim_employee e2 
		on isnull(elk2.Output_Value,src.created_employee_id) = e2.employee_id 
		and e2.DWHIsCurrent = 1