
CREATE PROC [staging].[insert_staging_dim_property_arrears_arrangement]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_property_arrears_arrangement]
PURPOSE:  

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2025-06-26    Greg Nuthall		Initial version
1.1      2026-02-20    GitHub Copilot    Removed redundant columns per work item 12210

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_property_arrears_arrangement]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_property_arrears_arrangement] (
	 [property_arrears_arrangement_id]
	,dim_property_tenancy_key
	,dim_property_key
	,dim_property_program_key
	,[property_tenancy_id] 
	,[property_id] 
	,[property_program_id] 
	,[property_subprogram_id] 
	,[property] 
	,[property_program] 
	,[property_subprogram] 
	,[tenancy_transaction_type_id] 
	,[property_tenancy] 
	,[transaction_type] 
	,[arrears_arrangement_reference] 
	,[arrears_arrangement] 
	,[arrears_arrangement_priority] 
	,[arrears_arrangement_type] 
	,[arrears_arrangement_frequency] 
	,[calculated_based_on] 
	,[comments] 
	,[start_date_id] 
	,[end_date_id] 
	,[first_payment_date_id] 
	,[amount] 
	,[balance_amount] 
	,[managed_arrears] 
	,[unmanaged_arrears] 
	,[total_arrears] 
	,[total_balance] 
	,[owner_name] 
	,[created_by_name] 
	,[created_datetime] 
	,[modified_by_name] 
	,[modified_datetime] 
	,[is_delete_flag] 
	,synapse_link_sink_modified_on
	)
SELECT
	 [property_arrears_arrangement_id] 
	,isnull(pt.dim_property_tenancy_key,case when t.property_tenancy_id is null then 0 else -1 end) as dim_property_tenancy_key
	,isnull(p.dim_property_key,case when t.property_id is null then 0 else -1 end) as dim_property_key
	,isnull(pp.dim_property_program_id, case when t.[property_id] is null then 0 else -1 end) as dim_property_program
	,t.[property_tenancy_id] 
	,t.[property_id] 
	,t.[property_program_id] 
	,t.[property_subprogram_id] 
	,t.[property] 
	,t.[property_program] 
	,t.[property_subprogram] 
	,t.[tenancy_transaction_type_id] 
	,t.[property_tenancy] 
	,t.[transaction_type] 
	,t.[arrears_arrangement_reference] 
	,t.[arrears_arrangement] 
	,t.[arrears_arrangement_priority] 
	,t.[arrears_arrangement_type] 
	,t.[arrears_arrangement_frequency] 
	,t.[calculated_based_on] 
	,t.[comments] 
	,t.[start_date_id] 
	,t.[end_date_id] 
	,t.[first_payment_date_id] 
	,t.[amount] 
	,t.[balance_amount] 
	,t.[managed_arrears] 
	,t.[unmanaged_arrears] 
	,t.[total_arrears] 
	,t.[total_balance] 
	,t.[owner_name] 
	,t.[created_by_name] 
	,t.[created_datetime] 
	,t.[modified_by_name] 
	,t.[modified_datetime] 
	,t.[is_delete_flag] 
	,t.synapse_link_sink_modified_on
from [Landing].[edw_dim_property_arrears_arrangement] t 

left outer join edw.dim_property p 
	on t.property_id = p.property_id and p.DWHIsCurrent = 1
left outer join edw.dim_property_tenancy pt 
	on t.property_tenancy_id = pt.property_tenancy_id 
	and pt.DWHIsCurrent = 1
left outer join edw.dim_property_program pp on t.property_program_id = pp.property_program_id 
	and t.property_subprogram_id = pp.property_subprogram_id
	and pp.DWHIsCurrent = 1