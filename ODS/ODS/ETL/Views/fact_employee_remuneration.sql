


--1.9        2025/05/12    Manish Singh		Changing UTC date column to NZT

--drop view [ETL].[fact_employee_remuneration]


CREATE VIEW [ETL].[fact_employee_remuneration]
AS
	SELECT 
j.[jobs_id]
,j.[person_employeeNumber]
,ethgroup.concatenatedEthnicity as concatenated_ethnicity_id
,j.[businessEntity_id]
,j.[businessUnit_id]
,j.[location_id]
,il.name as [location_name]
,il.address as [location_address]
,j.[recruitment_cost] as fact_employee_remuneration_recruitment_cost
,j.[recruitment_currency] as fact_employee_remuneration_recruitment_currency
,j.[recruitment_source_name] as fact_employee_remuneration_recruitment_source_name
,[payGrade_id]
,j.[payGrade_name] as fact_employee_remuneration_pay_grade_name
,j.[payGrade_code] as fact_employee_remuneration_pay_grade_code
,j.[establishment_name] as fact_employee_remuneration_establishment_name 
,j.[remunerationSchedule_type] as fact_employee_remuneration_schedule_type
,j.[remunerationSchedule_currency] as fact_employee_remuneration_schedule_currency
,j.[remunerationSchedule_hoursPerCycle] as fact_employee_remuneration_schedule_hours_per_cycle
,j.[remunerationSchedule_payCycle] as fact_employee_remuneration_schedule_pay_cycle
,j.[remunerationSchedule_annualPackage] as fact_employee_remuneration_schedule_annual_package
,j.[remunerationSchedule_hourlyPackage] as fact_employee_remuneration_schedule_hourly_package
,j.[remunerationSchedule_baseAnnualSalary] as fact_employee_remuneration_schedule_base_annual_salary
,j.[remunerationSchedule_baseHourlyRate] as fact_employee_remuneration_schedule_base_hourly_rate
,j.[remunerationSchedule_currencyConversionOccurred] as fact_employee_remuneration_schedule_currency_conversion_occurred
,[remunerationSchedule_employmentCondition_name] as fact_employee_remuneration_schedule_employment_condition_name
,j.[name] as fact_employee_remuneration_job_title
,j.[jobStatus] as fact_employee_remuneration_job_status
,CAST((j.positionStartDate AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS positionStartDate
,'' as fact_employee_remuneration_Position
,j.[fte] as fact_employee_remuneration_fte
,j.[workType] as fact_employee_remuneration_work_type
,j.[workClass] as fact_employee_remuneration_work_class
,j.[isPrimaryJob] as fact_employee_remuneration_primary_job_indicator
,CAST((companyStartDate AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS companyStartDate
,CAST((companyEndDate AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS companyEndDate
,j.[isEndDateConfirmed] as fact_employee_remuneration_end_date_confirmed_indicator
,j.[turnoverType] as fact_employee_remuneration_turnover_type
,j.[turnoverReason] as fact_employee_remuneration_turnover_reason
,CAST((j.createdAt AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS fact_employee_remuneration_created_at
,'-1' as fact_employee_remuneration_maori_indicator
,'-1' as fact_employee_remuneration_pasifika_indicator

	FROM [IntelliHR].[jobs] j
	LEFT JOIN [IntelliHR].[people_custom_fields] peth ON j.person_id = peth.people_id
		AND peth.definition_id = 'be08bf8e-bce7-4eeb-9974-621886dd9640'
		AND peth.[ODSIsCurrent] = 1
	LEFT JOIN [IntelliHR].[locations] il ON j.location_id = il.locations_id
	--	AND peth.definition_id = 'be08bf8e-bce7-4eeb-9974-621886dd9640'
		AND il.[ODSIsCurrent] = 1

	LEFT JOIN  [ETL].[reference_intelliHR_person_ethnicity] AS ethgroup
		-- ethnicity grouping is stored in a single string, need to split it out and move to separate columns
	 ON j.person_id = ethgroup.people_id
	WHERE j.ODSIsCurrent = 1