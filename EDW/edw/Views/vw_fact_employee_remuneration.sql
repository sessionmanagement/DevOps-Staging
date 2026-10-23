

CREATE VIEW [edw].[vw_fact_employee_remuneration]
AS
SELECT er.fact_employee_remuneration_key
	,er.dim_company_key
	,er.dim_location_key
	,er.dim_employee_key
	,er.dim_service_key
	,er.dim_ethnicity_key
	,er.dim_role_hierarchy_key
	,er.dim_people_hierarchy_key
	,er.dim_payroll_categories_key
	,er.dim_job_start_date_key
	,er.dim_job_end_date_key
	,er.dim_position_start_date_key
	,er.dim_position_end_date_key
	,er.fact_employee_remuneration_job_key
	,er.fact_employee_remuneration_employee_number
	,er.fact_employee_remuneration_businessentity_id
	,er.fact_employee_remuneration_businessunit_id
	,er.fact_employee_remuneration_location_id
	,er.fact_employee_remuneration_recruitment_cost
	,er.fact_employee_remuneration_recruitment_currency
	,er.fact_employee_remuneration_recruitment_source_name
	,er.fact_employee_remuneration_pay_grade_name
	,er.fact_employee_remuneration_pay_grade_code
	,er.fact_employee_remuneration_establishment_name
	,er.fact_employee_remuneration_schedule_type
	,er.fact_employee_remuneration_schedule_currency
	,er.fact_employee_remuneration_schedule_hours_per_cycle
	,er.fact_employee_remuneration_schedule_pay_cycle
	,er.fact_employee_remuneration_schedule_annual_package
	,er.fact_employee_remuneration_schedule_hourly_package
	,er.fact_employee_remuneration_schedule_base_annual_salary
	,er.fact_employee_remuneration_schedule_base_hourly_rate
	,er.fact_employee_remuneration_schedule_currency_conversion_occurred
	,er.fact_employee_remuneration_schedule_employment_condition_name
	,er.fact_employee_remuneration_job_title
	,er.fact_employee_remuneration_job_status
	,er.fact_employee_remuneration_position_startdate
	,er.fact_employee_remuneration_position
	,er.fact_employee_remuneration_fte
	,er.fact_employee_remuneration_work_type
	,er.fact_employee_remuneration_work_class
	,er.fact_employee_remuneration_primary_job_indicator
	,er.fact_employee_remuneration_company_startdate
	,er.fact_employee_remuneration_company_enddate
	,er.fact_employee_remuneration_end_date_confirmed_indicator
	,er.fact_employee_remuneration_turnover_type
	,er.fact_employee_remuneration_turnover_reason
	,er.fact_employee_remuneration_created_at
	,er.fact_employee_remuneration_maori_indicator
	,er.fact_employee_remuneration_pasifika_indicator
	
	,e1.ethnicity as primary_ethnicity
	,e2.ethnicity as secondary_ethnicity
	,e3.ethnicity as tertiary_ethnicity
	,e4.ethnicity as fourth_ethnicity
	,m1.iwi
	,m1.hapu
	,m1.waka

	,er.dwhsourcesystem
	,er.dwhbatchid
	,er.dwhdmloperation
	,er.dwheffectivefrom
	,er.dwheffectiveto
	,er.dwhiscurrent


FROM [edw].[fact_employee_remuneration] er
left outer join (Select * from edw.dim_employee where DWHIsCurrent = 1) e on er.fact_employee_remuneration_employee_number = e.employee_id 
  left outer join reference.edw_ethnicity e1 on e.primary_ethnicity_id = e1.ethnicity_id
  left outer join reference.edw_ethnicity e2 on e.secondary_ethnicity_id = e2.ethnicity_id
  left outer join reference.edw_ethnicity e3 on e.tertiary_ethnicity_id = e3.ethnicity_id
  left outer join reference.edw_ethnicity e4 on e.fourth_ethnicity_id = e4.ethnicity_id
  left outer join reference.edw_maori_iwi m1 on e.primary_iwi_id = m1.dim_iwi_key
GO


