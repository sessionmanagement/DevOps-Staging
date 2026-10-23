CREATE PROC [staging].[insert_staging_fact_property_remedy_notice]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_fact_property_remedy_notice]
PURPOSE:  

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2025-07-15    Greg Nuthall		Initial version

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLfact_property_remedy_notice]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLfact_property_remedy_notice] (
	 [property_remedy_notice_id] 
	,[property_tenancy_id]
	,[property_id]
	,[property_tenancy_breach_id]
	,[dim_property_tenancy_key]
	,[dim_property_key]
	,[remedy_notice] 
	,[anti_social_behaviour_report] 
	,[behaviour_occurred_between] 
	,[behaviour_locatation] 
	,[behaviour_people] 
	,[unkept_responsibility] 
	,[remedy_path] 
	,[notes] 
	,[other_information] 
	,[remedy_notice_start_date] 
	,[remedy_notice_owner] 
	,[modified_by] 
	,[modified_date] 
	,[created_date] 
	,[remedy_notice_state] 
	,[remedy_notice_status] 
	)
SELECT
	 rn.[property_remedy_notice_id] 
	,rn.[property_tenancy_id]
	,pt.property_id
	,rn.[property_tenancy_breach_id] 
	,pt.dim_property_tenancy_key
	,pt.dim_property_key
	,rn.[remedy_notice] 
	,rn.[anti_social_behaviour_report] 
	,rn.[behaviour_occurred_between] 
	,rn.[behaviour_locatation] 
	,rn.[behaviour_people] 
	,rn.[unkept_responsibility] 
	,rn.[remedy_path] 
	,rn.[notes] 
	,rn.[other_information] 
	,rn.[remedy_notice_start_date] 
	,rn.[remedy_notice_owner] 
	,rn.[modified_by] 
	,rn.[modified_date] 
	,rn.[created_date] 
	,rn.[remedy_notice_state] 
	,rn.[remedy_notice_status] 
from [Landing].[edw_fact_property_remedy_notice] rn
left outer join [edw].dim_property_tenancy pt 
	on rn.property_tenancy_id = pt.property_tenancy_id 
	and pt.DWHIsCurrent = 1