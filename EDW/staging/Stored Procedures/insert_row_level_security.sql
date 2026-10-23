CREATE PROC [staging].[insert_row_level_security] AS
	/***************************************************************************
	 NAME:     [staging].[reference_row_level_security_intellihr]
	 PURPOSE:  
	 
	 NOTES:
	 
	 REVISIONS:
	 Version	 Date		   Author				Description
	 -------	 ------------  ---------------		--------------------------
	 1.0		 2024-03-12    Stefen Hasselberg	Initial version
	 2.0		 2024-06-06	   Stefen Hasselberg	Update the stored procedure so that it gets current
													row back from dim_client_team
	 2.1		 2025-10-17	   Greg Nuthall			Remove invalid employees
	 
	 
	 ****************************************************************************/
	--  clear the staging table before loading
	SET NOCOUNT ON;

	-- Rollback on any errors
	SET XACT_ABORT ON;


	-- clear the staging table
	TRUNCATE TABLE [Staging].[row_level_security] 


	-- load intellihr security model
	EXEC [staging].[insert_row_level_security_intellihr]

	-- load cost alllocation security model
	EXEC [staging].[insert_row_level_security_cost_allocations]

	
	/*###################################################
	 
	 Need to filter out duplicate rows which are cause 
	 by the cost allocations by using row number function
	 
	 ###################################################*/

	;WITH CTE AS (
		SELECT *,
			ROW_NUMBER() OVER (
				PARTITION BY manager_employee_number,
				intellihr_business_unit_id,
				intellihr_company_id			
				ORDER BY level_hierarchy
			) AS row_num
		FROM [staging].[row_level_security]
	)

	UPDATE CTE
	SET not_need_row_flag = row_num

	-- Remove rows where we have a duplicate employee > manager > service
	DELETE FROM [staging].[row_level_security]
	where not_need_row_flag > 1


	-- update the table with the dim_service key
	update staging.row_level_security
	set dim_service_key = ISNULL(s.dim_service_key, CASE WHEN rls.intellihr_business_unit_id IS NOT NULl THEN -1 ELSE 0 END )
	from staging.row_level_security as rls
	left join edw.dim_service as s on rls.intellihr_business_unit_id = s.intellihr_service_id and DWHIsCurrent = 1


	-- load the recordbase security model

	EXEC [staging].[insert_row_level_security_recordbase]

	-- update the dim_client_team_key
	update staging.row_level_security
	set dim_client_team_key = ISNULL(ct.dim_client_team_key, CASE WHEN rls.recordbase_team_id IS NOT NULl THEN -1 ELSE 0 END )
	from staging.row_level_security as rls
	left join edw.dim_company as c on rls.[recordbase_company_name] = c.company_name
	left join (
				SELECT
					dim_client_team_key
					, company_id
					, client_team_id
					, ROW_NUMBER() OVER (PARTITION BY client_team_id, company_id ORDER BY DWHCreatedAt DESC ) as row_index
					from edw.dim_client_team
	) as ct on rls.recordbase_team_id = ct.client_team_id and c.company_id = ct.company_id and ct.row_index = 1

	where level_hierarchy = 50

	--Remove invalid rows
	DELETE FROM [staging].[row_level_security]
	where employee_display_name in ('N/A','Test Employee' )
	and employee_number in (0,601684)