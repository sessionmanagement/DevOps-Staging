
CREATE PROC [staging].[insert_staging_fact_property_arrears_transaction]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_fact_property_arrears_transaction]
PURPOSE:  

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2025-06-26    Greg Nuthall		Initial version
****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLfact_property_arrears_transaction]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLfact_property_arrears_transaction] (
	 [transaction_id] 
	,[dim_property_arrears_arrangement_key]
    ,[dim_property_key]
    ,[dim_property_tenancy_key]
    ,[dim_property_program_key]
	,[property_arrears_arrangement_id] 
	,[property_tenancy_id] 
	,[property_id] 
	,[property_program_id] 
	,[property_subprogram_id] 
	,[transaction_detail_id] 
	,[transaction_number] 
	,[transaction_name] 
	,[transaction_description] 
	,[transaction_date] 
	,[transaction_date_id] 
	,[arrear_amount] 
	,[paid_amount] 
	,[state_label] 
	,[status_label] 
	,[owner_id] 
	,[created_datetime] 
	,[modified_datetime] 
	,[is_delete_flag] 
	)
SELECT
	 [transaction_id] 
	,isnull(ta.dim_property_arrears_arrangement_key,case when t.property_arrears_arrangement_id is null then 0 else -1 end) as dim_property_arrears_arrangement
	,isnull(p.dim_property_key,case when t.property_id is null then 0 else -1 end) as dim_property_key
	,isnull(pt.dim_property_tenancy_key,case when t.property_tenancy_id is null then 0 else -1 end) as dim_property_tenancy_key
	,isnull(pp.dim_property_program_id, case when t.[property_id] is null then 0 else -1 end) as dim_property_program
	,t.[property_arrears_arrangement_id] 
	,t.[property_tenancy_id] 
	,t.[property_id] 
	,t.[property_program_id] 
	,t.[property_subprogram_id] 
	,t.[transaction_detail_id] 
	,t.[transaction_number] 
	,t.[transaction_name] 
	,t.[transaction_description] 
	,t.[transaction_date] 
	,t.[transaction_date_id] 
	,t.[arrear_amount] 
	,t.[paid_amount] 
	,t.[state_label] 
	,t.[status_label] 
	,t.[owner_id] 
	,t.[created_datetime] 
	,t.[modified_datetime] 
	,t.[is_delete_flag] 

from [Landing].[edw_fact_property_arrears_transaction] t
left outer join edw.dim_property_arrears_arrangement ta 
	on t.property_arrears_arrangement_id = ta.property_arrears_arrangement_id and ta.DWHIsCurrent = 1
left outer join edw.dim_property p 
	on t.property_id = p.property_id and p.DWHIsCurrent = 1
left outer join edw.dim_property_tenancy pt 
	on t.property_tenancy_id = pt.property_tenancy_id 
	and pt.DWHIsCurrent = 1
left outer join edw.dim_property_program pp on t.property_program_id = pp.property_program_id 
	and t.property_subprogram_id = pp.property_subprogram_id
	and pp.DWHIsCurrent = 1