
CREATE view [edw].[vw_dim_employee]

/**********************************************************************************************************
 Procedure	[edw].[Updateedwdim_employee] 
 Author		Glenn McLeod	
 Created	2023-08-25		
 =========================================================================================================

REVISIONS:
Version	 Date			Author					Description
-------	------------	------------------		--------------------------
1.0		2023-08-25		Glenn McLeod			Initial creation of view
1.1		2023-08-25		Glenn McLeod			Updated table/column names
1.2		2023-11-27		Glenn McLeod			Added [employee_job_name]
2.0		2024-11-08		Greg Nuthall			Added new ethnicity fields
2.1		2024-12-09		Greg Nuthall			Added employee_full_time_equivalent
2.2		2024-12-09		Greg Nuthall			Added Job status (different from employment status for people with more than 1 job)
												Removed blank columns
2.3		2025-01-08		Greg Nuthall			Added primary_ethnicity_section
2.4		2025-07-03		Greg Nuthall			Added age group calculation to avoid SCD2 new rows
2.5		2026-07-07		malhar badheka			Added employee_profile_system_id
2.6     2026-10-20      Greg Nuthall			Added employee_employment_condition
**********************************************************************************************************/

as

select dim_employee_key
	,employee_id
	,employee_name
	,employee_first_name
	,employee_middle_name
	,employee_last_name
	,employee_title
	,employee_preferred_name
	,employee_employment_status
	,employee_nhi_number
	,employee_profile_system_id
	,employee_workrights_name
	,employee_workrights_country
	,employee_workrights_expiration_date
	,employee_employment_condition
	,employee_primary_email_address
	,employee_primary_email_address_ispersonal
	,employee_primary_phone_number
	,employee_primary_phone_number_fullnumber
	,employee_primary_phone_number_ispersonal
	,employee_city_value
	,employee_address_Type
	,employee_full_address
	,employee_street_value
	,employee_suburb_value
	,employee_postcode_value
	,employee_is_primary_address_flag
	,employee_emergency_contact_name
	,employee_next_of_whanau_relationship
	,employee_next_of_whanau_phone
	,employee_next_of_whanau_email
	,employee_company_name
	,employee_company_start_date
	,employee_start_date
	,employee_company_end_date
	,employee_end_date
	,employee_position_start_date
	,employee_gender
	,employee_previous_gender
	,employee_previous_gender_valid_to_date
	,employee_date_of_birth
	,case when e.[employee_date_of_birth] is null 
		or isnull(e.[employee_date_of_birth],'2500-01-01') >= getdate() 
		or isnull(e.[employee_date_of_birth],'1875-01-01') <= DateAdd(year,-125,getdate())
	then
		null
	else 
		floor(datediff(day,e.[employee_date_of_birth],getdate())/365.25) 
	end
		as employee_age_in_year
    ,ag.[dim_age_group_key] AS employee_age_group
	--,employee_age_in_year
	--,employee_age_group
	,employee_longevity
	,employee_termination_date
	,employee_long_service_recognition_date
	,employee_work_type
	,employee_work_class
	,employee_ethnicity
	,employee_pay_grade_name
	,employee_remuneration_annual_package
	,employee_remuneration_base_annual_salary
	,employee_remuneration_base_hourly_rate
	,employee_remuneration_schedule_currency
	,employee_remuneration_hours_per_cycle
	,employee_remuneration_pay_cycle
	,employee_remuneration_hourly_package
	,employee_leaving_date
	,employee_leaving_reason
	,employee_leaving_turnover_type
	,employee_exemption_granted
	,employee_nationality
	,employee_concurrent_job
	,employee_identified_ethnicity
	,employee_hapu_affilitation
	,employee_ot_vetting
	,employee_preferred_last_name
	,employee_annual_practising_cert_expiry_date
	,employee_exception_police_vetting_expiry
	,employee_mask_exemption
	,employee_vaccine_status
	,employee_smoking_status
	,employee_people_manager_job_status
	,employee_people_manager_job_name
	,employee_people_manager_name
	,employee_people_manager_id
	,employee_ird_number
	,employee_salary_sacrifice
	,employee_bank_details
	,employee_incidents
	,employee_latest_incident_date
	,employee_disciplinary_status
	,employee_specific_needs
	,employee_qualification_level
	,employee_referral_source
	,employee_current_status
	,employee_job_status
	,employee_is_primary_Job_flag
	,e.extended_leave_type_name
	,e.extended_leave_start_date
	,e.extended_leave_end_date
	,e.employee_full_time_equivalent
	,e.DWHSourceSystem
	,e.DWHBatchId
	,e.DWHDMLOperation
	,e.DWHEffectiveFrom
	,e.DWHEffectiveTo
	,e.DWHIsCurrent
	,e.employee_job_name
	,e1.ethnicity as primary_ethnicity
	,e2.ethnicity as secondary_ethnicity
	,e3.ethnicity as tertiary_ethnicity
	,e4.ethnicity as fourth_ethnicity
	,e1.ethnicity_group as primary_ethnicity_group
	,e1.ethncity_section as primary_ethnicity_section 
	,e2.ethnicity_group as secondary_ethnicity_group
	,e3.ethnicity_group as tertiary_ethnicity_group
	,e4.ethnicity_group as fourth_ethnicity_group
	,m1.iwi as primary_iwi
	,m1.waka as primary_waka

	,ei.ethnicity as identified_ethnicity --No longer populated in IntelliHR do not use
	,ei.ethncity_section as identified_ethnicity_section --No longer populated in IntelliHR do not use

	,case when e.primary_ethnicity_id = 21111 
	or e.secondary_ethnicity_id = 21111  
	or e.tertiary_ethnicity_id = 21111  
	or e.fourth_ethnicity_id = 21111
	then 1 else 0 end as is_maori_flag

	,case when isnull(e1.ethncity_section,'') = 'Pacific Peoples'
	or isnull(e2.ethncity_section,'') = 'Pacific Peoples'
	or isnull(e3.ethncity_section,'') = 'Pacific Peoples'
	or isnull(e4.ethncity_section,'') = 'Pacific Peoples'
	then 1 else 0 end as is_pasifika_flag


FROM [edw].[dim_employee] e

	left outer join reference.edw_ethnicity e1 on e.primary_ethnicity_id = e1.ethnicity_id
	left outer join reference.edw_ethnicity e2 on e.secondary_ethnicity_id = e2.ethnicity_id
	left outer join reference.edw_ethnicity e3 on e.tertiary_ethnicity_id = e3.ethnicity_id
	left outer join reference.edw_ethnicity e4 on e.fourth_ethnicity_id = e4.ethnicity_id
	left outer join reference.edw_maori_iwi m1 on e.primary_iwi_id = m1.dim_iwi_key
	left outer join reference.edw_ethnicity ei on e.identified_ethnicity_id = ei.ethnicity_id
	left outer join [edw].[dim_age_group] ag on floor(datediff(day,e.[employee_date_of_birth],getdate())/365.25)=ag.[age_in_years]