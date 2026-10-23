
CREATE PROC [staging].[insert_staging_fact_employee_leave]

AS
/*********************************************************************************************************
NAME:     [staging].[insert_staging_fact_employee_leave]
PURPOSE:  

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2024-01-17    Glenn McLeod		Initial version This includes a reverse link for company name to get datapay company name
1.1      2024-07-30	   Greg Nuthall		SP on company name reference table, changed to pass the business unit name 
										instead of unknown and link to the reference table 
1.2      2024-08-13	   Greg Nuthall		edw.fact_employee_leave failures from duplicate rows on company reverse linking
1.3		 2024-09-10	   Greg Nuthall		Use the mapping (reference.edw_lookup) to link mapped employees
1.4		 2024-10-08	   Greg Nuthall		Create a list of duplicate employees and remove them
1.5		 2024-11-05	   Greg Nuthall		Where business unit id = 'unknown' set dim key as 0 not -1
1.6		 2025-01-06	   Greg Nuthall		Cast joins as nvarchar and isnull to capture null strings as 0 dim_key value
1.7		 2025-01-23	   Greg Nuthall		Mapping for duplicate leave types to map to the correct one
1.8		 2025-02-25    Greg Nuthall		Make sure duplicate ethnicities do not create duplicate rows * 2
1.9		 2025-04-09    Greg Nuthall		Choose active business unit over in active if two are the same name using a temp table
2.0	     2025-04-15    Greg Nuthall		Added join to reference table to map invalid ethncities
2.1      2025-05-06    Greg Nuthall		Cleaned up the join to business hierarchy
2.2      2025-07-04    Greg Nuthall		Changed #Business_Unit_hierarchy to include where the business unit is no longer active
2.3      2025-07-25    Greg Nuthall		Changed #Business_Unit_hierarchy to avoid duplicate names with different Id's
2.4      2025-10-10    Greg Nuthall		translate case lookup value to eliminate accents not finding the lookup 
										and removed restriction on 'D' ethnicity records 
***********************************************************************************************************/

begin

	if object_id('tempdb..#Duplicate_Employees') is not null drop table #Duplicate_Employees;


	--Create a table of employees duplicated from the mapping so they can be removed 
	create table #Duplicate_Employees (employee_id nvarchar(100) null)

	Insert into #Duplicate_Employees
	Select distinct cast(employee_id as nvarchar(100)) 
	FROM Landing.edw_fact_employee_leave l
	inner join (Select Input_Value from reference.edw_lookup where Category = 'dim_employee.employee_id') r 
					on cast(employee_id as nvarchar(100)) = cast(r.Input_Value as nvarchar(100))


--Create a business unit hierarchy table to use is_active_flag = 1 entries first and is_active_flag = 0 second

	if object_id('tempdb..#Business_Unit_hierarchy') is not null drop table #Business_Unit_hierarchy;

	create table #Business_Unit_hierarchy (Business_Unit_hierarchy_id int identity(1,1) not null
	,business_unit_name nvarchar(100) null
	,business_unit_id nvarchar(100) null
	,dim_business_unit_hierarchy_key int null)
	
	--Insert the BU's where is_active_flag = 1 and are not duplicated
	Insert into #Business_Unit_hierarchy (business_unit_name,business_unit_id, dim_business_unit_hierarchy_key)
	Select h.business_unit_name, business_unit_id, dim_business_unit_hierarchy_key
     from [edw].[dim_business_unit_hierarchy] h
	inner join (Select business_unit_name, max(cast(DWHModifiedOn as date)) as LastRecordWithSameName
				from [edw].[dim_business_unit_hierarchy]
				where is_active_flag = 1 
				group by business_unit_name) d 
			on h.business_unit_name = d.business_unit_name
			and cast(h.DWHModifiedOn as date) = d.LastRecordWithSameName
	where is_active_flag = 1 

	union 
	--insert any non active BU's if they do not already exist or duplicated
	Select b2.business_unit_name,b2.business_unit_id, b2.dim_business_unit_hierarchy_key 
	from (select * from [edw].[dim_business_unit_hierarchy] where is_active_flag = 0 ) b2 
	inner join (Select business_unit_name, max(cast(DWHModifiedOn as date)) as LastRecordWithSameName
				from [edw].[dim_business_unit_hierarchy]
				where is_active_flag = 0 
				group by business_unit_name) d 
			on b2.business_unit_name = d.business_unit_name
			and cast(b2.[DWHModifiedOn] as date) = d.LastRecordWithSameName
	where b2.business_unit_name not in (Select h.business_unit_name
										from [edw].[dim_business_unit_hierarchy] h
										inner join (Select business_unit_name
													,max(cast(DWHModifiedOn as date)) as LastRecordWithSameName
													from [edw].[dim_business_unit_hierarchy]
													where is_active_flag = 1 
													group by business_unit_name) d 
												on h.business_unit_name = d.business_unit_name
												and cast(h.DWHModifiedOn as date) = d.LastRecordWithSameName
										where h.is_active_flag = 1)

	--  clear the staging table before loading
	Truncate table [Staging].[ODSETLfact_employee_leave]

	-- insert data from landing table into staging table
	insert into [Staging].[ODSETLfact_employee_leave] (
		  [dim_company_key]
		  ,[dim_business_unit_hierarchy_key]
		  ,[dim_employee_key]
		  ,[dim_leave_type_key]
		  ,[dim_ethnicity_key]
		  ,[dim_payroll_category_key]
		  ,[employee_leave_effective_date_key]
		  ,[employee_leave_anniversary_date_key]
		  ,[datapay_company_id]
		  ,[employee_id]
		  ,[leave_type_id]
		  ,[ethnicity_id]
		  ,[business_unit_id]
		  ,[business_unit_name]
		  ,[employee_leave_unit]
		  ,[employee_leave_entitlement]
		  ,[employee_leave_accrual]
		  ,[employee_leave_taken]
		  ,[employee_leave_balance]
		  ,[employee_leave_entitlement_hours]
		  ,[employee_leave_accrual_hours]
		  ,[employee_leave_taken_hours]
		  ,[employee_leave_balance_hours]
		  ,[employee_leave_next_entitlement_hours]
		)


		select isnull(dc.[dim_company_key], CASE 
				WHEN isnull(cast(src.[datapay_company_id] as nvarchar),'') <> ''
					THEN - 1
				ELSE 0
				END) AS dim_company_key
		,src.dim_business_unit_hierarchy
		,isnull(de.dim_employee_key, CASE 
				WHEN isnull(cast(src.[employee_id] as nvarchar),'') <> ''
					THEN - 1
				ELSE 0
				END) AS [dim_employee_key]
		,isnull(dlt.[dim_leave_type_key], CASE 
				WHEN isnull(src.[leave_type_id],'') <> '' 
					THEN - 1
				ELSE 0
				END) AS [dim_leave_type_key]
		,isnull(eth.[dim_ethnicity_key], CASE 
				WHEN isnull(src.[dim_ethnicity_id],'') <> '' 
					THEN - 1
				ELSE 0
				END) AS [dim_ethnicity_key]
		,isnull(dpc.[dim_payroll_category_key], CASE 
				WHEN isnull(src.[leave_type_id],'') <> '' 
					THEN - 1
				ELSE 0
				END) AS [dim_payroll_category_key]
		,src.[employee_leave_effective_date_key]
		,src.[employee_leave_anniversary_date_key]
		,src.[datapay_company_id]
		,src.[employee_id]
		,src.[leave_type_id]
		,src.[dim_ethnicity_id] AS ethnicity_id
		,src.business_unit_id
		,src.[business_unit_name]
		,src.[employee_leave_unit]
		,src.[employee_leave_entitlement]
		,src.[employee_leave_accrual]
		,src.[employee_leave_taken]
		,src.[employee_leave_balance]
		,src.[employee_leave_entitlement_hours]
		,src.[employee_leave_accrual_hours]
		,src.[employee_leave_taken_hours]
		,src.[employee_leave_balance_hours]
		,src.[employee_leave_next_entitlement_hours]
	from (
		-- this section converts all values to expected edw values
			select isnull(l.[datapay_company_id],-1) as datapay_company_id
				,isnull(lu3.Output_Value,isnull(l.[employee_id],-1)) as employee_id
				,isnull(l.[leave_type_id],-1) as leave_type_id
				--,ISNULL(lu.[Output_Value], dc.company_name) AS leave_type_company_name -- convert company name to the one used in datapay
				,dc.company_name AS leave_type_company_name 
				,l.[dim_ethnicity_id]
				,l.[employee_leave_effective_date_key]
				,l.[employee_leave_anniversary_date_key]
				--,l.[business_unit_name]
				,isnull(bh.[business_unit_id],'N/A') as business_unit_id
				,isnull(bh.[business_unit_name],isnull(lk.Output_value, l.[business_unit_name])) as business_unit_name
				,isnull(bh.dim_business_unit_hierarchy_key, 
										case when isnull(l.[business_unit_name],'') <> '' 
										then -1 else 0 end) 
										as dim_business_unit_hierarchy
				,l.[employee_leave_unit]
				,l.[employee_leave_entitlement]
				,l.[employee_leave_accrual]
				,l.[employee_leave_taken]
				,l.[employee_leave_balance]
				,l.[employee_leave_entitlement_hours]
				,l.[employee_leave_accrual_hours]
				,l.[employee_leave_taken_hours]
				,l.[employee_leave_balance_hours]
				,l.[employee_leave_next_entitlement_hours]
			from Landing.edw_fact_employee_leave l
			left join edw.dim_company dc on dc.dim_company_datapay_key = l.[datapay_company_id]
			left join reference.edw_lookup lu on dc.company_name = lu.[Input_Value]
				and lu.Category = 'dim_company.company_name'
			left join reference.edw_lookup lk on l.[business_unit_name] = lk.[Input_Value]
				and lk.Category = 'dim_business_unit_hierarchy.business_unit_name'
			left join #Business_Unit_hierarchy bh on isnull(lk.Output_value, l.[business_unit_name]) = bh.business_unit_name
			
			left join reference.edw_lookup lu3 on cast(l.[employee_id] as nvarchar) = cast(lu3.Input_Value as nvarchar) 
				and lu3.Category = 'dim_employee.employee_id'

			where isnull(cast(l.[employee_id] as nvarchar(100)),'XXX') not in (Select employee_id from #Duplicate_Employees)
		
			) AS src
		left join [edw].[dim_company] AS dc on src.[datapay_company_id] = dc.dim_company_datapay_key
			and dc.DWHIsCurrent = 1
		left join [edw].[dim_employee] AS de on src.[employee_id] = de.[employee_id]
			and de.DWHIsCurrent = 1
		--No reference lookup for leave type becasue its using the ID
		left join [reference].[EDW_Lookup] lk on src.[leave_type_id] = lk.Input_Value and lk.Category = 'dim_leave_type.leave_type_id'

		left join [edw].[dim_leave_type] AS dlt on isnull(lk.Output_Value, src.[leave_type_id]) = dlt.[leave_type_id]
			and dc.company_name = dlt.leave_type_company_name
		
		left join [reference].[EDW_Lookup] elk on translate(cast(src.[dim_ethnicity_id] as varchar(2000)), 'äā', 'aa') = elk.Input_Value and elk.Category = 'dim_ethnicity.dim_ethnicity_id'
		left join (select max(dim_ethnicity_key) as dim_ethnicity_key, translate(cast([dim_ethnicity_id] as varchar(2000)), 'äā', 'aa') as dim_ethnicity_id
					from [edw].[dim_ethnicity] 
					--where DWHDMLOperation <> 'D' 
					group by translate(cast([dim_ethnicity_id] as varchar(2000)), 'äā', 'aa')) AS eth 
		on translate(cast(eth.[dim_ethnicity_id] as varchar(2000)), 'äā', 'aa') = translate(cast(isnull(elk.Output_value,src.[dim_ethnicity_id]) AS varchar(2000)), 'äā', 'aa') 

		left join [reference].[EDW_Lookup] lu3 on dlt.[leave_type_name] = lu3.[Input_Value]
			and lu3.Category = 'dim_payroll_category.payroll_category_name' -- use lookup table to convert EmpLive leave type into Datapay payroll category
		left join [edw].[dim_payroll_category] dpc ON dpc.[payroll_category_name] = isnull(lu3.[Output_Value],dlt.[leave_type_name])

end;