

CREATE view [edw].[vw_fact_employee_hours_worked]

as

select [fact_employee_hours_worked_key]
      ,eh.[dim_company_key]
      ,eh.[dim_employee_key]
      ,eh.[dim_ethnicity_key]
      ,eh.[dim_payroll_category_key]
      ,eh.[dim_leave_type_key]
      ,eh.[dim_shift_start_date_key]
      ,eh.[dim_shift_end_date_key]
      ,eh.[dim_shift_start_time_key]
      ,eh.[dim_shift_end_time_key]
      ,eh.[time_sheet_entry_id]
      ,eh.[fact_hours_worked_company_name]
      ,eh.[fact_hours_worked_payroll_category_id]
      ,eh.[fact_hours_worked_employee_number]
      ,eh.[fact_hours_worked_leave_type_name]
      ,eh.[fact_hours_worked_emplive_service_id]
      ,eh.[fact_hours_worked_concatenated_ethnicity_id]
      ,eh.[fact_hours_worked_total_duration]
      ,eh.[fact_hours_worked_approval_status]
	  ,eh.fact_hours_worked_role
	  ,e1.ethnicity as primary_ethnicity
	  ,e2.ethnicity as secondary_ethnicity
	  ,e3.ethnicity as tertiary_ethnicity
	  ,e4.ethnicity as fourth_ethnicity
	  ,m1.iwi
	  ,m1.hapu
	  ,m1.waka

      ,eh.[DWHBatchId]
      ,eh.[DWHEffectiveFrom]
      ,eh.[DWHEffectiveTo]
      ,eh.[DWHDMLOperation]
      ,eh.[DWHIsCurrent]
      ,eh.[DWHSourceSystem]


  from [edw].[fact_employee_hours_worked] eh
  left outer join (Select * from edw.dim_employee where DWHIsCurrent = 1) e on cast(eh.fact_hours_worked_employee_number as nvarchar) = cast(e.employee_id as nvarchar)
  left outer join reference.edw_ethnicity e1 on e.primary_ethnicity_id = e1.ethnicity_id
  left outer join reference.edw_ethnicity e2 on e.secondary_ethnicity_id = e2.ethnicity_id
  left outer join reference.edw_ethnicity e3 on e.tertiary_ethnicity_id = e3.ethnicity_id
  left outer join reference.edw_ethnicity e4 on e.fourth_ethnicity_id = e4.ethnicity_id
  left outer join reference.edw_maori_iwi m1 on e.primary_iwi_id = m1.dim_iwi_key