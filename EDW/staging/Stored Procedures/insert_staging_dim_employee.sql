
CREATE procedure [staging].[insert_staging_dim_employee]
as 
/***********************************************************************************************************************
NAME:     [staging].[insert_staging_dim_employee]
PURPOSE:  Move data from landing.[edw_dim_employee] table into
				staging.[ODSETLdim_employee] table

NOTES: Call By EDW Pipeline ODS_dim_funder-Incremental Merge


REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		?			  ?						Initial creation of stored procedure
1.1		2023-08-04	  Glenn McLeod			Updated to use table Framework table names 
1.11	2023-08-11	  Glenn McLeod			Moved logic to remove duplicates to the source query
1.12	2023-08-25	  Glenn McLeod			Updated table/column names
1.2		2023-11-27	  Glenn McLeod			Added [employee_job_name]
1.3		2024-09-10	  Greg Nuthall			Added mapping logic where employee already exists by email/name in dim_employee
1.31	2024-09-26    Greg Nuthall			Added system_data_source
1.4		2024-12-05	  Greg Nuthall			Changed to handle text in reference lookup table
1.5		2024-12-09	  Greg Nuthall		    Added employee_full_time_equivalent
1.6		2024-12-10    Greg Nuthall			Added Job status (different from employment status for people with more than 1 job)
											                Removed blank columns
1.7		2025-01-08	  Greg Nuthall			Remove age and age group to avoid SCD2 new rows, it will be added to the view 
1.8     2025-12-03    Greg Nuthall		    Added extended leave type
1.9     2026-07-07    Malhar Badheka		Added employee_profile_system_id
2.0     2026-10-20    Greg Nuthall			Added employee_employment_condition
**************************************************************************************************************************/

--•	New employee from IntelliHR but has the same name as someone in dim_employee  add a record to the mapping table.
--•	New employee from IntelliHR and has no match by name in dim_employee  create a new record in dim_employee.
--•	Employees in datapay not in dim_employee by ID or by email  create a new record in dim_employee
--•	Employees in datapay  and in dim_employee by email but not by ID  create a mapping record
--•	Employees in recordbase not in dim_employee by ID or by email  create a new record in dim_employee
--•	Employees in recordbase  and in dim_employee by email but not by ID  create a mapping record

--Duplicate name from list take the one from 


begin 


	declare @ReferenceTableCategory as nvarchar(50) = 'dim_employee.employee_id';
	declare @SystemDefaultEffectiveFrom datetime2(7) = '1 January 1900';

	--Not done with cte becasue they get changed/reused during the execution
	 --drop table #employee_status
	
	create table #employee_status 
	(
	 employee_id int
	,emailaddress nvarchar(100)
	,employee_name nvarchar(100)
	,employee_id_in_dim_employee int
	,employee_date_of_birth date
	,employee_email_in_dim_employee int
	,employee_name_in_dim_employee int
	,employee_id_in_mapping int
	,employee_duplicate_rownumber int
	);


	--Use this to deal with null DOB's matching a DOB
	with cte_max_DOB (employee_name, employee_date_of_birth)  
	as (select employee_name
	,max(case when l.employee_date_of_birth is null then @SystemDefaultEffectiveFrom else l.employee_date_of_birth end) employee_date_of_birth
	from landing.edw_dim_employee l 
	group by l.employee_name),
	
	cte_duplicate_employee_names as(select le.employee_id
	,le.employee_name
	,le.employee_date_of_birth
	--use row number to find the preferred employee (rownumber 1 = preferred, row number greater = unpreferred
	--unpreferred employees will be mapped to the preferred employees 
	,row_number() over (
				partition by le.employee_name order by le.employee_employment_status --Added to push past jobs below current jobs 
					,le.isPrimaryJob desc  --Add to push non primary jobs below primary jobs
					,le.employee_position_start_date desc
					,le.employee_company_start_date desc 
				) as rownumber

	from landing.edw_dim_employee le
	inner join (select le.employee_name,isnull(le.employee_date_of_birth,db.employee_date_of_birth) as employee_date_of_birth
							  from landing.edw_dim_employee le
							  inner join cte_max_DOB db on le.employee_name = db.employee_name
							  group by le.employee_name
							  ,isnull(le.employee_date_of_birth,db.employee_date_of_birth)
							  having Count(*)>=2) de
	on le.employee_name = de.employee_name and le.employee_date_of_birth = de.employee_date_of_birth
	)

	--Get the status of all the employees from the source compared with all the employees in the dim table, the mapping table and duplicate source list
	--insert a value in the field if there is a link otherwise leave it empty
	--If it's a duplicated employee insert a value in employee_id_in_mapping field
	insert into #employee_status (
		employee_id
		,emailaddress
		,employee_name
		,employee_date_of_birth
		,employee_id_in_dim_employee
		,employee_email_in_dim_employee
		,employee_name_in_dim_employee
		,employee_id_in_mapping
		,employee_duplicate_rownumber)

	select src.employee_id
           ,src.employee_primaryemailaddress_email
		   ,src.employee_name
		   ,isnull(src.employee_date_of_birth,dob.employee_date_of_birth) as employee_date_of_birth
		   ,isnull(eid.employee_id,-999) as employee_id_in_dim_employee
		   ,isnull(eem.employee_id,-999) as employee_email_in_dim_employee
		   ,isnull(enm.employee_id,-999) as employee_name_in_dim_employee
		   ,isnull(lk.EDW_LookupId,-999) as employee_id_in_mapping
		   ,isnull(dn.rownumber,-999) as employee_duplicate_rownumber
	
	from landing.edw_dim_employee src
	left outer join edw.dim_employee eid on src.employee_id = eid.employee_id and eid.DWHIsCurrent = 1 
	left outer join (Select max(employee_id) as employee_id, employee_primary_email_address 
					from edw.dim_employee where DWHIsCurrent = 1 
					group by employee_primary_email_address ) eem on src.employee_primaryemailaddress_email = eem.employee_primary_email_address 
	left outer join (Select max(employee_id) as employee_id, employee_first_name, employee_last_name, employee_date_of_birth 
					from edw.dim_employee where DWHIsCurrent = 1 
					group by employee_first_name, employee_last_name, employee_date_of_birth) enm on src.employee_first_name = enm.employee_first_name  
					and src.employee_last_name = enm.employee_last_name and src.employee_date_of_birth = enm.employee_date_of_birth
	
	left outer join (select * from reference.edw_lookup where Category = @ReferenceTableCategory) lk
	on cast(src.employee_id as nvarchar) = cast(lk.Input_Value as nvarchar)
	left outer join cte_duplicate_employee_names dn on src.employee_id = dn.employee_id and dn.rownumber = 1
	left outer join cte_max_DOB dob on src.employee_name = dob.employee_name

	group by src.employee_id
           ,src.employee_name
		   ,src.employee_primaryemailaddress_email
		   ,isnull(src.employee_date_of_birth,dob.employee_date_of_birth)
		   ,isnull(eid.employee_id,-999)
		   ,isnull(eem.employee_id,-999)
		   ,isnull(enm.employee_id,-999)
		   ,isnull(lk.EDW_LookupId,-999)
		   ,isnull(dn.rownumber,-999)

	--Insert into mapping where employee_id not in dim table but the 
	--employee exists (linked via email or name) with another employee_id 
	Insert into reference.edw_lookup (Input_Value, Output_Value, Source_System, Category)

	Select employee_id as Input_Value
	,case when employee_email_in_dim_employee <> -999 
		  then employee_email_in_dim_employee 
		  else employee_name_in_dim_employee 
	 end as Output_Value
	,'IntelliHR' as Source_System
	, @ReferenceTableCategory as Category
	
	from #employee_status es
	left outer join (Select * from reference.edw_lookup where Category = @ReferenceTableCategory) lk 
	on cast(es.employee_id as nvarchar) = cast(lk.Input_Value as nvarchar)

	where employee_id_in_dim_employee = -999 
	and (employee_email_in_dim_employee <> -999 or employee_name_in_dim_employee <> -999)
	and employee_id_in_mapping = -999 
	and employee_duplicate_rownumber = -999  --Not in the list of duplicates, that is dealt with below
	and isnull(lk.EDW_LookupId,-999) = -999

	group by employee_id 
	,case when employee_email_in_dim_employee <> -999 
		  then employee_email_in_dim_employee 
		  else employee_name_in_dim_employee 
	 end
		
	--Insert the mapping from the unpreferred duplicate to the preferred duplicate (from rownumber) 
	Insert into reference.edw_lookup (Input_Value, Output_Value, Source_System, Category)
	
	select c2.employee_id
	, c1.employee_id 
	,'IntelliHR' as Source_System
	, @ReferenceTableCategory as Category
	from (Select * from #employee_status where employee_duplicate_rownumber = 1) c1
	inner join (select * from #employee_status where employee_duplicate_rownumber >= 2) c2 on c1.employee_name = c2.employee_name
	left outer join (Select * from reference.edw_lookup where Category = @ReferenceTableCategory) lk 
	on cast(c2.employee_id as nvarchar) = cast(lk.Input_Value as nvarchar)
	where isnull(lk.EDW_LookupId,-999) = -999
	group by c2.employee_id
	, c1.employee_id 

	--Reset the employee status for all those new records the mapping table so not to push any mapped employees
	Update #employee_status Set employee_id_in_mapping = isnull(T1.Input_Value,-999)
	from (Select * from reference.edw_lookup where Category = @ReferenceTableCategory) T1
	where cast(#employee_status.employee_id as nvarchar) = cast(T1.Input_Value as nvarchar)


	--  clear the staging table before loading
	TRUNCATE TABLE staging.ODSETLdim_employee
     
	 -- insert data from landing table into staging table
	 INSERT INTO staging.ODSETLdim_employee
           ([employee_id]
           ,[employee_name]
           ,[employee_first_name]
           ,[employee_middle_name]
           ,[employee_last_name]
           ,[employee_title]
           ,[employee_preferred_name]
           ,[employee_employment_status]
           ,[employee_nhi_number]
           ,[employee_profile_system_id]
           ,[employee_workrights_name]
           ,[employee_workrights_country]
           ,[employee_workrights_expiration_date]
		   ,[employee_employment_condition]
           ,[employee_primary_email_address]
           ,[employee_primary_email_address_ispersonal]
           ,[employee_primary_phone_number]
           ,[employee_primary_phone_number_fullnumber]
           ,[employee_primary_phone_number_ispersonal]
           ,[employee_city_value]
           ,[employee_address_Type]
           ,[employee_full_address]
           ,[employee_street_value]
           ,[employee_suburb_value]
           ,[employee_postcode_value]
           ,[employee_is_primary_address_flag]
           ,[employee_emergency_contact_name]
           ,[employee_next_of_whanau_relationship]
           ,[employee_next_of_whanau_phone]
           ,[employee_next_of_whanau_email]
		   ,[employee_company_name]
           ,[employee_company_start_date]
           ,[employee_start_date]
           ,[employee_company_end_date]
           ,[employee_end_date]
           ,[employee_position_start_date]
           ,[employee_gender]
           ,[employee_date_of_birth]
           --,[employee_age_in_year]
           --,[employee_age_group]
           ,[employee_longevity]
           ,[employee_termination_date]
           ,[employee_long_service_recognition_date]
           ,[employee_work_type]
           ,[employee_work_class]
           ,[employee_ethnicity]
           ,[employee_pay_grade_name]
           ,[employee_remuneration_annual_package]
           ,[employee_remuneration_base_annual_salary]
           ,[employee_remuneration_base_hourly_rate]
           ,[employee_remuneration_schedule_currency]
           ,[employee_remuneration_hours_per_cycle]
           ,[employee_remuneration_pay_cycle]
           ,[employee_remuneration_hourly_package]
           ,[employee_leaving_date]
           ,[employee_leaving_reason]
           ,[employee_leaving_turnover_type]
           ,[employee_exemption_granted]
           --,[employee_date_booster_required]
           ,[employee_nationality]
           ,[employee_concurrent_job]
           ,[employee_identified_ethnicity]
           --,[employee_date_of_second_vaccination]
           ,[employee_hapu_affilitation]
           ,[employee_ot_vetting]
           ,[employee_preferred_last_name]
           ,[employee_annual_practising_cert_expiry_date]
           ,[employee_exception_police_vetting_expiry]
           ,[employee_mask_exemption]
           ,[employee_vaccine_status]
           ,[employee_smoking_status]
           ,[employee_people_manager_job_status]
           ,[employee_people_manager_Job_name]
           ,[employee_people_manager_name]
           ,[employee_people_manager_id]
           ,[employee_ird_number]
           ,[employee_job_status]
           ,[employee_is_primary_Job_flag]
		   ,extended_leave_type_name
		   ,extended_leave_start_date
		   ,extended_leave_end_date
		   ,[employee_full_time_equivalent]
		   ,[employee_job_name]
		   ,system_data_source
   )  
   
   
SELECT src.[employee_id] as employee_id
      ,src.[employee_name]
      ,src.[employee_first_name]
      ,src.[employee_middle_name]
      ,src.[employee_last_name]
      ,src.[employee_title]
      ,src.[employee_preferred_name]
      ,src.[employee_employment_status]
      ,src.[employee_nhi_number]
      ,src.[employee_profile_system_id]
      ,src.[employee_workrights_name]
      ,src.[employee_workrights_country]
      ,Cast(src.[employee_workrights_expirationdate] as datetime2) As employee_workrights_expirationdate
	  ,src.[employee_employment_condition]
      ,src.[employee_primaryemailaddress_email] as employee_primary_email_address
      ,src.[employee_primaryemailaddress_ispersonal] as employee_primary_email_address_ispersonal
      ,src.[employee_primary_phone_number]
      ,src.[employee_primary_phone_number_fullnumber]
      ,src.[employee_primary_phone_number_ispersonal]
      ,src.[employee_city_value]
      ,src.[employee_address_Type]
      ,src.[employee_full_address]
      ,src.[employee_street_value]
      ,src.[employee_suburb_value]
      ,src.[employee_postcode_value]
      ,src.[is_primary_address]
      ,src.[emergency_Contact_name]
      ,src.[employee_next_of_whanau_relationship]
      ,src.[employee_next_of_whanau_phone]
      ,src.[employee_next_of_whanau_email]
	  ,src.[employee_company_name]
      ,src.[employee_company_start_date]
      ,src.[employee_start_date]
      ,src.[employee_company_end_date]
      ,src.[employee_end_date]
      ,src.[employee_position_start_date]
      ,src.[employee_gender]
      ,src.[employee_date_of_birth]
	  --,floor(datediff(day,src.[employee_date_of_birth],getdate())/365.25) AS employee_age_in_year
	--,floor(datediff(day,src.[employee_date_of_birth],getdate())/365.25)
      --,ag.[dim_age_group_key] AS [dim_age_group_key]
      ,src.[employee_longevity]
      ,src.[employee_termination_date]
      ,src.[employee_long_service_recognition_date]
      ,src.[employee_work_type]
      ,src.[employee_work_class]
      ,src.[employee_ethnicity]
      ,src.[payGrade_name] AS employee_pay_grade_name
      ,src.[remunerationSchedule_annualPackage] AS employee_remuneration_annual_package
      ,src.[remunerationSchedule_baseAnnualSalary] AS employee_remuneration_base_annual_salary
      ,src.[remunerationSchedule_baseHourlyRate] AS employee_remuneration_base_hourly_rate
      ,src.[remunerationSchedule_currency]  AS employee_remuneration_schedule_currency
      ,src.[remunerationSchedule_hoursPerCycle] AS employee_remuneration_hours_per_cycle
      ,src.[remunerationSchedule_payCycle] AS employee_remuneration_pay_cycle
      ,src.[remunerationSchedule_hourlyPackage] AS employee_remuneration_hourly_package
      ,src.[employee_leaving_date]
      ,src.[employee_leaving_reason]
      ,src.[employee_leaving_turnover_type]
      ,src.[employee_exemption_granted]
    --  ,cast([employee_date_booster_required] As datetime2) AS employee_date_booster_required
      ,src.[employee_nationality]
      ,src.[employee_concurrent_job]
      ,src.[employee_identified_ethnicity]
     -- ,Cast([employee_date_of_second_vaccination] As datetime2) AS employee_date_of_second_vaccination
      ,src.[employee_hapu_affilitation]
      ,src.[employee_ot_vetting]
      ,src.[employee_preferred_last_name]
      ,convert(datetime,src.[employee_annual_practising_cert_expiry],104) as [employee_annual_practising_cert_expiry]
      ,convert(datetime,src.[employee_exception_police_vetting_expiry],104) as [employee_exception_police_vetting_expiry]
      ,src.[employee_mask_exemption]
      ,src.[employee_vaccine_status]
      ,src.[employee_smoking_status]
      ,src.[employee_people_manager_job_status]
      ,src.[employee_people_manager_Job_name]
      ,src.[employee_people_manager_name]
      ,src.[employee_people_manager_id]
      ,src.[employee_ird_number]
      ,src.[employee_job_status]
	  ,cast(src.isPrimaryJob AS INT) as isPrimaryJob
	  ,src.extended_leave_type_name
	  ,src.extended_leave_start_date
      ,src.extended_leave_end_date
	  ,src.[employee_full_time_equivalent]
	  ,src.employee_job_name
	  ,src.system_data_source

  from [landing].[edw_dim_employee] src 
	inner join #employee_status es on src.employee_id = es.employee_id
	--left outer join [edw].[dim_age_group] ag on floor(datediff(day,src.[employee_date_of_birth],getdate())/365.25)=ag.[age_in_years]
	
	--include all records if they exist in dim_employee or not but do not exist in the mapping table
	where es.employee_id_in_mapping = -999
	

  end