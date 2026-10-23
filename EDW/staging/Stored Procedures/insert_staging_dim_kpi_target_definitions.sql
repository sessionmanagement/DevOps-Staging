
CREATE PROC [staging].[insert_staging_dim_kpi_target_definitions]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_kpi_target_definitions]
PURPOSE:  
NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2025-04-14   Greg Nuthall		Initial version
1.1      2025-06-05   Greg Nuthall		Change to deal with non unique service_id (add companyid)
1.2      2025-11-20   Greg Nuthall		Added goal_planning_applies
****************************************************************************/


create table #service_with_unique_id 
 (dim_service_key int null
, service_id int null
, dim_company_key int null
, service_code varchar(40) null
, service_name varchar(100) null)

--Get a unique list of services_ids using lowest companyid first
Insert into #service_with_unique_id (service_id, dim_company_key)
select service_id, dim_company_key
from (
    select 
        service_id, 
        s.dim_company_key,
        row_number() over (partition by service_id order by service_id, s.dim_company_key) as rn
    from edw.dim_service s
    where dwhiscurrent = 1
	and service_id >= -1
) t
where rn = 1;


Update #service_with_unique_id Set dim_service_key = T1.dim_service_key
,service_code = T1.service_code
,service_name = T1.service_name
from (Select dim_service_key, service_id, s.dim_company_key, service_code, service_name
from edw.dim_service s
where DWHIsCurrent = 1) T1
where #service_with_unique_id.service_id = T1.service_id
and #service_with_unique_id.dim_company_key = T1.dim_company_key



--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_kpi_target_definitions]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_kpi_target_definitions] (
	 [target_definition_id]
	,[dim_service_key]
	,[dim_service_type_key]
	,[service_id] 
	,[service_code] 
	,[service_name] 
	,[service_type]
	,[service_type_id]
	,[region] 
	,[temp_region] 
	,[district] 
	,[bed_nights] 
	,[caseload] 
	,[fully_staffed_fte] 
	,[support_hours] 
	,[programmes_delivered] 
	,[service_action_plan_link] 
	,[bed_nights_applies] 
	,[fully_staffed_applies] 
	,[support_hours_applies] 
	,[prog_delivered_target_applies] 
	,[caseload_target_applies]
	,[goal_planning_applies]
	,[outcome_tool_review]
	)
	
	SELECT
		 t.[target_definition_id] 
		,s.dim_service_key
		,st.dim_kpi_service_type_key as dim_service_type_key  
		,t.[service_id] 
		,s.[service_code] 
		,s.[service_name] 
		--,'' as service_type
		,st.[service_type] 
		,t.[service_type_id]
		,t.[region] 
		,t.[temp_region] 
		,t.[district] 
		,t.[bed_nights] 
		,t.[caseload] 
		,t.[fully_staffed_fte] 
		,t.[support_hours] 
		,t.[programmes_delivered] 
		,isnull(t.[service_action_plan_link],'') as service_action_plan_link
		,isnull(t.[bed_nights_applies],0) as bed_nights_applies
		,isnull(t.[fully_staffed_applies],0) as fully_staffed_applies  
		,isnull(t.[support_hours_applies],0)  as support_hours_applies 
		,isnull(t.[prog_delivered_target_applies],0) as prog_delivered_target_applies  
		,isnull(t.[caseload_target_applies],0) as caseload_target_applies
		,isnull(t.[goal_planning_applies],0) as goal_planning_applies
		,isnull([outcome_tool_review],0) as outcome_tool_review
	from [Landing].[edw_dim_kpi_target_definitions] t
	left outer join #service_with_unique_id s on t.service_id = s.service_id 
	left outer join edw.dim_kpi_service_type st on t.[service_type_id] = st.[service_type_id] and st.DWHisCurrent = 1