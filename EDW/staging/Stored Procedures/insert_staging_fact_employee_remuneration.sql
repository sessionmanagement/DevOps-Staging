


CREATE PROC [staging].[insert_staging_fact_employee_remuneration]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_fact_employee_remuneration]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2024-01-10    Manish Singh			Initial version
2.0      2024-02-13	   Manish Singh	        Added location and ethnicity information

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLfact_employee_remuneration]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLfact_employee_remuneration] (
            [fact_employee_remuneration_job_key]
           ,[fact_employee_remuneration_employee_Number]
     	   ,[fact_employee_remuneration_concatenated_ethnicity_id]
           ,[fact_employee_remuneration_businessEntity_id]
           ,[fact_employee_remuneration_businessUnit_id]
           ,[fact_employee_remuneration_location_id]
		   ,[fact_employee_remuneration_location_address]
           ,[fact_employee_remuneration_recruitment_cost]
           ,[fact_employee_remuneration_recruitment_currency]
           ,[fact_employee_remuneration_recruitment_source_name]
           ,[fact_employee_remuneration_pay_grade_name]
           ,[fact_employee_remuneration_pay_grade_code]
           ,[fact_employee_remuneration_establishment_name]
           ,[fact_employee_remuneration_schedule_type]
           ,[fact_employee_remuneration_schedule_currency]
           ,[fact_employee_remuneration_schedule_hours_per_cycle]
           ,[fact_employee_remuneration_schedule_pay_cycle]
           ,[fact_employee_remuneration_schedule_annual_package]
           ,[fact_employee_remuneration_schedule_hourly_package]
           ,[fact_employee_remuneration_schedule_base_annual_salary]
           ,[fact_employee_remuneration_schedule_base_hourly_rate]
           ,[fact_employee_remuneration_schedule_currency_conversion_occurred]
           ,[fact_employee_remuneration_schedule_employment_condition_name]
           ,[fact_employee_remuneration_job_title]
           ,[fact_employee_remuneration_job_status]
           ,[fact_employee_remuneration_position_StartDate]
           ,[fact_employee_remuneration_Position]
           ,[fact_employee_remuneration_fte]
           ,[fact_employee_remuneration_work_type]
           ,[fact_employee_remuneration_work_class]
           ,[fact_employee_remuneration_primary_job_indicator]
           ,[fact_employee_remuneration_company_StartDate]
           ,[fact_employee_remuneration_company_EndDate]
           ,[fact_employee_remuneration_end_date_confirmed_indicator]
           ,[fact_employee_remuneration_turnover_type]
           ,[fact_employee_remuneration_turnover_reason]
           ,[fact_employee_remuneration_created_at]
           ,[fact_employee_remuneration_maori_indicator]
           ,[fact_employee_remuneration_pasifika_indicator]	)
SELECT
	 [jobs_id] 
	,[person_employeeNumber] 
	,[concatenated_ethnicity_id]
	,[businessEntity_id] 
	,[businessUnit_id] 
	,[location_id] 
	,[location_address]
	,[fact_employee_remuneration_recruitment_cost] 
	,[fact_employee_remuneration_recruitment_currency] 
	,[fact_employee_remuneration_recruitment_source_name] 
	,[fact_employee_remuneration_pay_grade_name] 
	,[fact_employee_remuneration_pay_grade_code] 
	,[fact_employee_remuneration_establishment_name] 
	,[fact_employee_remuneration_schedule_type] 
	,[fact_employee_remuneration_schedule_currency] 
	,[fact_employee_remuneration_schedule_hours_per_cycle] 
	,[fact_employee_remuneration_schedule_pay_cycle] 
	,[fact_employee_remuneration_schedule_annual_package] 
	,[fact_employee_remuneration_schedule_hourly_package] 
	,[fact_employee_remuneration_schedule_base_annual_salary] 
	,[fact_employee_remuneration_schedule_base_hourly_rate] 
	,[fact_employee_remuneration_schedule_currency_conversion_occurred] 
	,[fact_employee_remuneration_schedule_employment_condition_name] 
	,[fact_employee_remuneration_job_title] 
	,[fact_employee_remuneration_job_status] 
	,[positionStartDate] 
	,[fact_employee_remuneration_Position] 
	,[fact_employee_remuneration_fte] 
	,[fact_employee_remuneration_work_type] 
	,[fact_employee_remuneration_work_class] 
	,[fact_employee_remuneration_primary_job_indicator] 
	,[companyStartDate] 
	,[companyEndDate] 
	,[fact_employee_remuneration_end_date_confirmed_indicator] 
	,[fact_employee_remuneration_turnover_type] 
	,[fact_employee_remuneration_turnover_reason] 
	,[fact_employee_remuneration_created_at] 
	,[fact_employee_remuneration_maori_indicator] 
	,[fact_employee_remuneration_pasifika_indicator] 
from [Landing].[edw_fact_employee_remuneration]