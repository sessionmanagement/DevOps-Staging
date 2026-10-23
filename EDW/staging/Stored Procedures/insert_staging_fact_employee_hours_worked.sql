

CREATE PROC [staging].[insert_staging_fact_employee_hours_worked]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_fact_employee_hours_worked]
PURPOSE:  
NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2024-03-06    Manish Singh		Initial version
1.1      2024-07-08    Greg Nuthall		Company link: Corrected the refrence table name, changed to also link if there is no record in the reference table
1.2      2024-07-12    Greg Nuthall		Leave Type: Added a new link to the reference table to interpret leave types, then use the current if none exisit
1.3		 2024-08-08    Greg Nuthall	    Company name changed to correct name
1.4		 2024-09-10	   Greg Nuthall		Use the mapping (reference.edw_lookup) to link mapped employees
1.5		 2024-11-05	   Greg Nuthall		Changed mapping to leave type specifically (not payroll as before)
1.6		 2025-01-23	   Greg Nuthall     Fixed leave type reference lookup bug
1.7		 2024-01-23	   Greg Nuthall		Added fact_hours_worked_role column
1.8		 2025-04-09    Greg Nuthall		Changed ethnicity join to avoid duplicates and match on accent characters
1.9	     2025-04-15    Greg Nuthall		Added join to reference table to map invalid ethnicities
2.0      2025-10-10    Greg Nuthall		Include D ethnicities for historical ethnicity links 
****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLfact_employee_hours_worked]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLfact_employee_hours_worked] (
		dim_company_key
		,dim_employee_key
		,dim_ethnicity_key
		,dim_payroll_category_key
		,dim_leave_type_key
		,dim_shift_start_date_key 
		,dim_shift_end_date_key 
		,dim_shift_start_time_key
		,dim_shift_end_time_key
		,time_sheet_entry_id 
		,fact_hours_worked_company_name
		,fact_hours_worked_payroll_category_id 
		,fact_hours_worked_employee_number 
		,fact_hours_worked_leave_type_name 
		,fact_hours_worked_emplive_service_id 
		,fact_hours_worked_concatenated_ethnicity_id 
		,fact_hours_worked_total_duration 
		,fact_hours_worked_approval_status
		,fact_hours_worked_role
		)
SELECT  isnull(dc.dim_company_key, CASE 
			WHEN isnull(src.fact_hours_worked_company_name,'') <> '' 
				THEN - 1
			ELSE 0
			END) AS dim_company_key

	----,src.employee_number 
	,isnull(de.dim_employee_key, CASE 
			WHEN isnull(src.fact_hours_worked_employee_number,'') <> '' 
				THEN - 1
			ELSE 0
			END) AS dim_employee_key

	,isnull(deth.dim_ethnicity_key, CASE 
			WHEN isnull(src.fact_hours_worked_concatenated_ethnicity_id,'') <> '' 
				THEN - 1
			ELSE 0
			END) AS dim_ethnicity_key
	--,lu3.Output_Value,dlt.leave_type_name
	,isnull(dpc.dim_payroll_category_key, CASE 
			WHEN isnull(src.fact_hours_worked_leave_type_name,'') <> '' 
				THEN - 1
			ELSE 0
			END) AS dim_payroll_category_key
				
	,isnull(dlt.dim_leave_type_key, CASE 
			WHEN isnull(src.fact_hours_worked_leave_type_name,'') <> '' 
				THEN - 1
			ELSE 0
			END) AS dim_leave_type_key
	,dds.dim_date_key as dim_shift_start_date_key
	,dde.dim_date_key as dim_shift_start_date_key
	,dts.dim_time_key as dim_shift_start_time_key
	,dte.dim_time_key as dim_shift_end_time_key
	,time_sheet_entry_id 
	,isnull(lu.Output_Value,fact_hours_worked_company_name) as fact_hours_worked_company_name
	,fact_hours_worked_payroll_category_id 
	,isnull(lu2.Output_Value, src.fact_hours_worked_employee_number) as fact_hours_worked_employee_number
	,fact_hours_worked_leave_type_name 
	,fact_hours_worked_emplive_service_id 
	,fact_hours_worked_concatenated_ethnicity_id 
	,fact_hours_worked_total_duration 
	,fact_hours_worked_approval_status
	,fact_hours_worked_role

from [Landing].[edw_fact_employee_hours_worked] src
            left join [reference].[EDW_Lookup] lu ON src.[fact_hours_worked_company_name] = lu.[Input_Value]
		and lu.Category = 'dim_company.company_name'
	left join [edw].[dim_company] dc ON dc.company_name = isnull(lu.Output_Value,src.[fact_hours_worked_company_name]) and dc.DWHIsCurrent=1

	left join reference.edw_lookup lu2 on CAST(src.[fact_hours_worked_employee_number] AS nvarchar) = cast(lu2.Input_Value as nvarchar)
			and lu2.Category = 'dim_employee.employee_id'
	
	left join [edw].[dim_employee] AS de ON CAST(isnull(lu2.Output_Value, src.[fact_hours_worked_employee_number]) as nvarchar) = CAST(de.[employee_id] as nvarchar)
	AND de.DWHIsCurrent = 1

	--left join [edw].[dim_ethnicity] AS deth 
	--ON deth.dim_ethnicity_id=src.fact_hours_worked_concatenated_ethnicity_id 
	left join [reference].[EDW_Lookup] elk on src.fact_hours_worked_concatenated_ethnicity_id = elk.Input_Value and elk.Category = 'dim_ethnicity.dim_ethnicity_id'
	left join (select max(dim_ethnicity_key) as dim_ethnicity_key, translate(cast([dim_ethnicity_id] as varchar(2000)), 'äā', 'aa') as dim_ethnicity_id
					from [edw].[dim_ethnicity] --where DWHDMLOperation <> 'D' 
					group by translate(cast([dim_ethnicity_id] as varchar(2000)), 'äā', 'aa')) AS deth 
	on translate(cast(deth.[dim_ethnicity_id] as varchar(2000)), 'äā', 'aa') = translate(cast(isnull(elk.Output_value,src.fact_hours_worked_concatenated_ethnicity_id) AS varchar(2000)), 'äā', 'aa') 


	left join [reference].[EDW_Lookup] lu3 ON src.[fact_hours_worked_leave_type_name] = lu3.[Input_Value]
	AND lu3.Category = 'dim_payroll_category.payroll_category_name' -- use lookup table to convert EmpLive leave type into Datapay payroll category
    left join [edw].[dim_payroll_category] dpc ON dpc.[payroll_category_name] = ISNULL(lu3.[Output_Value],src.[fact_hours_worked_leave_type_name])

	--Join on converted payroll_category_name for leave type
	left join [reference].[EDW_Lookup] lt ON src.[fact_hours_worked_leave_type_name] = lt.[Input_Value]
	and lt.Category = 'dim_leave_type.leave_type_name'
	
	left join [edw].[dim_leave_type] AS dlt ON isnull(lt.[Output_Value],src.[fact_hours_worked_leave_type_name]) = dlt.leave_type_name
	 and isnull(lu.Output_Value,src.[fact_hours_worked_company_name]) = dlt.leave_type_company_name
	 and dlt.DWHDMLOperation <> 'D'

	 left outer join edw.dim_date as dds on dds.dim_date_key=src.fact_hours_worked_concatenated_shift_start_date_id
	 left outer join edw.dim_date as dde on dde.dim_date_key=src.fact_hours_worked_concatenated_shift_end_date_id
	 left outer join [edw].[dim_time] as dts on dts.time=src.[fact_hours_worked_concatenated_shift_start_time_id]
	 left outer join [edw].[dim_time] as dte on dte.time=src.[fact_hours_worked_concatenated_shift_end_time_id]

	 
	--Find any leave type lookups and use that, if none exists then try the leave type given, else it will be -1
	--LEFT JOIN  [reference].[EDW_Lookup] lt ON src.[fact_hours_worked_leave_type_name] = lt.[Input_Value] 
	--and lt.Category = 'dim_leave_type.leave_type_name'