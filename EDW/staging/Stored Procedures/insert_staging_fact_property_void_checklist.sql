
CREATE   PROC [staging].[insert_staging_fact_property_void_checklist]

AS
/**********************************************************************************************************
Procedure	[staging].[insert_staging_fact_property_void_checklist]
Author		Greg Nuthall
Created		2026-02-26
Purpose		Insert data from landing into staging for fact_property_void_checklist
			Simplified version with reduced columns (85 → 36 business columns)
			Work Item 12210: Property field improvements

=========================================================================================================
REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2025-03-10    Greg Nuthall		Initial version (fact_void_checklist)
1.1      2025-04-30    Greg Nuthall		Added created_on and status_name
2.0      2026-02-26    Greg Nuthall		Reduced from 85 to 36 columns, simplified column names
										Changed dim_void_category_key to dim_property_category_key
2.1      2026-06-05    Greg Nuthall		Added an additional way to lookup offered property from the name 
										and set nulls and '0000' to 0 dim_key
2.2      2026-07-27    Greg Nuthall		Added void_checklist_state_code + void_checklist_state_code_name
                                        (User Story 14211, Gap D) 
**********************************************************************************************************/

IF OBJECT_ID('tempdb..#dim_property_ranked') IS NOT NULL DROP TABLE #dim_property_ranked;
IF OBJECT_ID('tempdb..#offered_property_lookup') IS NOT NULL DROP TABLE #offered_property_lookup;


SELECT
	property_name,
	dim_property_key,
	property_id,
	ROW_NUMBER() OVER (PARTITION BY property_name ORDER BY dim_property_key DESC, property_id DESC) AS rn
	into #dim_property_ranked
	FROM edw.dim_property
	WHERE DWHIsCurrent = 1


SELECT distinct
		vc.offered_property_id,
		vc.offered_property_name,
		p2.dim_property_key,
		p2.property_id,
		x.property_lookup
		into #offered_property_lookup
		
		FROM landing.edw_fact_property_void_checklist vc
		CROSS APPLY (
			SELECT
				first_dash  = CHARINDEX('-', vc.offered_property_name),
				second_dash = CASE
								WHEN CHARINDEX('-', vc.offered_property_name) > 0
									THEN CHARINDEX('-', vc.offered_property_name, CHARINDEX('-', vc.offered_property_name) + 1)
								ELSE 0
							  END
		) d
		CROSS APPLY (
			SELECT
				property_lookup = CASE
									WHEN d.second_dash > 1 THEN TRIM(LEFT(vc.offered_property_name, d.second_dash - 1))
									WHEN d.first_dash  > 1 THEN TRIM(LEFT(vc.offered_property_name, d.first_dash - 1))
									ELSE vc.offered_property_name
								  END
		) x
		LEFT OUTER JOIN (select * from #dim_property_ranked where rn = 1) p2
			ON x.property_lookup = p2.property_name
		 
--  Clear the staging table before loading
TRUNCATE TABLE [staging].[ODSETLfact_property_void_checklist]

-- Insert data from landing table into staging table with dimension key lookups
INSERT INTO [staging].[ODSETLfact_property_void_checklist]
    (
    [dim_property_key]
    ,[dim_property_tenancy_key]
    ,[dim_offered_property_key]
    ,[dim_property_void_category_key]
    ,[void_checklist_id]
    ,[void_checklist_status]
    ,[void_checklist_status_name]
	,[void_checklist_state_code]
	,[void_checklist_state_code_name]
    ,[offered_property_id]
    ,[offered_property_entity_type]
    ,[property_id]
    ,[property_entity_type]
    ,[vacated_tenancy_id]
    ,[vacated_tenancy_entity_type]
    ,[void_category_id]
    ,[void_category_entity_type]
    ,[owner_id]
    ,[owner_entity_type]
    ,[comments]
    ,[created_on]
    ,[owner_id_name]
    ,[assessment_scoping]
    ,[bond_recovery_forms_completed]
    ,[date_key_received_from_tenant]
    ,[date_keys_to_tenancy_team_to_allocate]
    ,[date_pre_vacate_inspection]
    ,[date_tenancy_terminated]
    ,[void_checklist_name]
    ,[offered_property_name]
    ,[property_name]
    ,[property_units_submitted_to_bos_approved]
    ,[target_completion_date_vacant]
    ,[target_completion_date_void]
    ,[tenancy_resolved_and_exited]
    ,[utilities_connections_recorded_and_setup_if_applicable]
    ,[utilities_disconnected]
    ,[vacated_tenancy_name]
    ,[void_category_name]
    ,[property_void_checklist_id]
    ,[void_completed_date]
    ,[is_delete_flag]
    )
SELECT    
     isnull(p.[dim_property_key],case when vc.[property_id] is null then 0 else -1 end) as dim_property_key
    ,isnull(pt.[dim_property_tenancy_key],case when vc.[vacated_tenancy_id] is null then 0 else -1 end) as dim_property_tenancy_key
    ,case when vc.offered_property_id is null 
		or vc.offered_property_id = '00000000-0000-0000-0000-000000000000'
		then 0 
	else 
		isnull(isnull(op.[dim_property_key],olk.dim_property_key),-1) 
	end as [dim_offered_property_key]
	--,isnull(op.[dim_property_key],case when vc.[offered_property_id] is null then 0 else -1 end) as dim_offered_property_key
    ,isnull(pc.[dim_void_category_key],case when vc.[void_category_id] is null then 0 else -1 end) as dim_void_category_key
	, vc.[void_checklist_id]
	, vc.[void_checklist_status]
	, vc.[void_checklist_status_name]
	, vc.[void_checklist_state_code]
	, vc.[void_checklist_state_code_name]
	, vc.[offered_property_id]
	, vc.[offered_property_entity_type]
	, vc.[property_id]
	, vc.[property_entity_type]
	, vc.[vacated_tenancy_id]
	, vc.[vacated_tenancy_entity_type]
	, vc.[void_category_id]
	, vc.[void_category_entity_type]
	, vc.[owner_id]
	, vc.[owner_entity_type]
	, vc.[comments]
	, vc.[created_on]
	, vc.[owner_id_name]
	, vc.[assessment_scoping]
	, vc.[bond_recovery_forms_completed]
	, vc.[date_key_received_from_tenant]
	, vc.[date_keys_to_tenancy_team_to_allocate]
	, vc.[date_pre_vacate_inspection]
	, vc.[date_tenancy_terminated]
	, vc.[void_checklist_name]
	, vc.[offered_property_name]
	, vc.[property_name]
	, vc.[property_units_submitted_to_bos_approved]
	, vc.[target_completion_date_vacant]
	, vc.[target_completion_date_void]
	, vc.[tenancy_resolved_and_exited]
	, vc.[utilities_connections_recorded_and_setup_if_applicable]
	, vc.[utilities_disconnected]
	, vc.[vacated_tenancy_name]
	, vc.[void_category_name]
	, vc.[property_void_checklist_id]
	, vc.[void_completed_date]
	, vc.[is_delete_flag]
FROM [landing].[edw_fact_property_void_checklist] vc
    LEFT OUTER JOIN [edw].[dim_property] p
    ON vc.[property_id] = p.[property_id]
        AND p.[DWHIsCurrent] = 1
    LEFT OUTER JOIN [edw].[dim_property] op
    ON vc.[offered_property_id] = op.[property_id]
        AND op.[DWHIsCurrent] = 1
	left outer join #offered_property_lookup olk 
		on vc.offered_property_id = olk.offered_property_id
		and vc.offered_property_name = olk.offered_property_name
    LEFT OUTER JOIN [edw].[dim_property_tenancy] pt
    ON vc.[vacated_tenancy_id] = pt.[property_tenancy_id]
        AND pt.[DWHIsCurrent] = 1
    LEFT OUTER JOIN [edw].[dim_void_category] pc
    ON vc.[void_category_id] = pc.[void_category_id]
        AND pc.[DWHIsCurrent] = 1