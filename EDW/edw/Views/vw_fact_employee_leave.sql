

CREATE VIEW [edw].[vw_fact_employee_leave]
AS
SELECT eh.fact_employee_leave_key
	,eh.dim_company_key
	,eh.dim_business_unit_hierarchy_key
	,eh.dim_employee_key
	,eh.dim_leave_type_key
	,eh.dim_ethnicity_key
	,eh.dim_payroll_category_key
	,eh.employee_leave_effective_date_key
	,eh.employee_leave_anniversary_date_key
	,eh.datapay_company_id
	,eh.employee_id
	,eh.leave_type_id
	,eh.ethnicity_id
	,business_unit_id
	,eh.employee_leave_unit
	,eh.employee_leave_entitlement
	,eh.employee_leave_accrual
	,eh.employee_leave_taken
	,eh.employee_leave_balance
	,eh.employee_leave_entitlement_hours
	,eh.employee_leave_accrual_hours
	,eh.employee_leave_taken_hours
	,eh.employee_leave_balance_hours
	,eh.employee_leave_next_entitlement_hours
	,e1.ethnicity as primary_ethnicity
	,e2.ethnicity as secondary_ethnicity
	,e3.ethnicity as tertiary_ethnicity
	,e4.ethnicity as fourth_ethnicity
	,m1.iwi
	,m1.hapu
	,m1.waka
		
	,eh.DWHBatchId
	,eh.DWHEffectiveFrom
	,eh.DWHEffectiveTo
	,eh.DWHDMLOperation
	,eh.DWHIsCurrent
	,eh.DWHSourceSystem


FROM [edw].[fact_employee_leave] eh
left outer join (Select * from edw.dim_employee where DWHIsCurrent = 1) e on eh.employee_id = e.employee_id 
  left outer join reference.edw_ethnicity e1 on e.primary_ethnicity_id = e1.ethnicity_id
  left outer join reference.edw_ethnicity e2 on e.secondary_ethnicity_id = e2.ethnicity_id
  left outer join reference.edw_ethnicity e3 on e.tertiary_ethnicity_id = e3.ethnicity_id
  left outer join reference.edw_ethnicity e4 on e.fourth_ethnicity_id = e4.ethnicity_id
  left outer join reference.edw_maori_iwi m1 on e.primary_iwi_id = m1.dim_iwi_key