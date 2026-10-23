
CREATE   PROC [staging].[insert_staging_dim_leave_type]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_leave_type]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2023-12-19    ?				Initial version
1.1      2024-08-08    Greg Nuthall		Modified to get the correct company name
1.2		 2024-08-09	   Greg Nuthall     Modified to use the reference table to convert emplive timesheet types to datapay leave types

****************************************************************************/

	--  clear the staging table before loading
	TRUNCATE TABLE [Staging].[ODSETLdim_leave_type]

	-- insert data from landing table into staging table
	INSERT INTO [Staging].[ODSETLdim_leave_type] (
		 [leave_type_id] 
		,[leave_type_name] 
		,[leave_type_group] 
		,[leave_type_company_name] 
		)



	SELECT
		 max([leave_type_id]) as leave_type_id
		,isnull(lk.Output_Value,lt.[leave_type_name]) as leave_type_name
		,max(isnull([leave_type_group],'')) as leave_type_group
		,isnull(lu.Output_Value, [leave_type_company_name] ) as leave_type_company_name
	from [Landing].[edw_dim_leave_type] lt
	left join [reference].edw_lookup lk on lt.leave_type_name = lk.Input_Value 
			and lk.Category = 'dim_leave_type.leave_type_name'
	
	LEFT JOIN [reference].[EDW_Lookup] lu ON lt.[leave_type_company_name] = lu.[Input_Value]
			and lu.Category = 'dim_company.company_name'
	
	group by isnull(lk.Output_Value,lt.[leave_type_name]), isnull(lu.Output_Value, [leave_type_company_name] )