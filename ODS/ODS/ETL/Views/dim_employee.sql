

CREATE   view [ETL].[dim_employee]

as

/**********************************************************************************************************
 View		[ETL].[dim_employee]
 Author		Manish Singh
 Created	2023/02/10	
 Purpose	Used to build the edw.dim_employee table 

 /*
This script consolidates employee data from multiple HR and payroll systems (IntelliHR, RecordBase, Datapay
, EmpLive) into a unified employee dataset. It uses several Common Table Expressions (CTEs) to deduplicate
, filter, and enrich employee records, ensuring only the most current and relevant information is included. 
The final SELECT statement outputs a comprehensive, de-duplicated list of employees with standardized
fields, suitable for reporting or integration purposes.
*/

 **************************************************************************************************************
--REVISIONS:
--Version	 Date		   Author			description
---------	 ------------  ---------------	--------------------------
--1.0		 2023/02/10						Initial version
--1.1		 2024/09/06	   Greg Nuthall     Added two new groups of employees employees without employee number 
											but common email with employees with employee numbers
											and datapay employees with no matching employee in intelliHR
--1.2		 2024/09/27	   Greg Nuthall		Added data source, agencies from empllive and data(Select pay employees without managers
--1.3		 2024/10/03	   Greg Nuthall		Changed job status and work types to be inline with IntelliHR
--1.4		 2024/12/09	   Greg Nuthall		Added fte from IntelliHR jobs
--1.5		 2024/12/10	   Greg Nuthall		Added Job status (different from employment status for people with more than 1 job)
											Removed blank columns
--1.6		 2025/01/07	   Greg Nuthall		Added IntelliHR email check for record base clients
--1.7		 2025/03/17    Greg Nuthall		Ensure no employee_id = 0 records are pushed
--1.8		 2025/03/26	   Greg Nuthall	    Additional sorting to eliminate datapay duplicates
--1.9        2025/05/12    Manish Singh		Changing UTC date column to NZT
--2.0        2025/12/03    Greg Nuthall		Added extended leave type
--2.1        2026-01-15    Greg Nuthall		Added additional phone number source 
--2.2        2026-03-13	   Greg Nuthall		Added clause to remove ODSDMLOperation = 'D' for IntelliHR.people table
--2.3        2026-07-07	   Malhar Badheka	Added column [people_id] from IntelliHR.people renamed to employee_profile_system_id
--2.4        2026-10-20    Greg Nuthall		Added employment condition from intelliHR.jobs remunerationSchedule_employmentCondition_name
**************************************************************************************************************/
with cte_employees_from_intellihr_and_recordbase as 

(select case when isnull(cast(du.UserEmployeeNumber as nvarchar),'')='' 
		then cast(e.employeeNumber as nvarchar) 
		else cast(du.UserEmployeeNumber as nvarchar) 
		end as employee_id
		from RBEAL.dlDimUser du
		left join [IntelliHR].[people] e on du.UserEmailAddress = e.primaryEmailAddress_email and e.ODSIsCurrent = 1
		left join [IntelliHR].[jobs] j on e.[people_id] = j.person_id and j.ODSIsCurrent = 1
		where case when isnull(cast(du.UserEmployeeNumber as nvarchar),'')='' 
		then cast(e.employeeNumber as nvarchar) 
		else cast(du.UserEmployeeNumber as nvarchar) end 
		not in (select isnull(cast(e.[employeeNumber] as nvarchar), cast(e.autoIncrementIntellihrId as nvarchar))
				FROM [IntelliHR].[jobs] j
				left outer join [IntelliHR].[people] e ON j.[person_id] = e.[people_id]
				left outer join [Datapay].[employees] ON e.employeeNumber = [Datapay].[employees].code
				AND [Datapay].[employees].ODSIsCurrent = 1
				where j.ODSIsCurrent = 1 and e.ODSIsCurrent = 1 and e.ODSDMLOperation <> 'D' )
		
		Union all
		
		select case when isnull(cast(du.UserEmployeeNumber as nvarchar),'')='' 
		then cast(e.employeeNumber as nvarchar) 
		else cast(du.UserEmployeeNumber as nvarchar) 
		end as employee_id
		from RBMNB.dlDimUser du
		left join [IntelliHR].[people] e on du.UserEmailAddress = e.primaryEmailAddress_email and e.ODSIsCurrent = 1
		left join [IntelliHR].[jobs] j on e.[people_id] = j.person_id and j.ODSIsCurrent = 1
		where case when isnull(cast(du.UserEmployeeNumber as nvarchar),'')='' 
		then cast(e.employeeNumber as nvarchar) 
		else cast(du.UserEmployeeNumber as nvarchar) end 
		not in (select isnull(cast(e.[employeeNumber] as nvarchar), cast(e.autoIncrementIntellihrId as nvarchar))
				FROM [IntelliHR].[jobs] j
				left outer join [IntelliHR].[people] e ON j.[person_id] = e.[people_id]
				left outer join [Datapay].[employees] ON e.employeeNumber = [Datapay].[employees].code
				AND [Datapay].[employees].ODSIsCurrent = 1
				where j.ODSIsCurrent = 1 and e.ODSIsCurrent = 1 and e.ODSDMLOperation <> 'D' )
	),	

	--Use this to remove employees already found in IntelliHR for recordbase 
	cte_employees_in_intllihr as (
	select isnull(cast(e.[employeeNumber] as nvarchar), cast(e.autoIncrementIntellihrId as nvarchar)) as employee_id
	FROM [IntelliHR].[jobs] j
	left outer join [IntelliHR].[people] e ON j.[person_id] = e.[people_id]
	where j.ODSIsCurrent = 1 and e.ODSIsCurrent = 1  and e.ODSDMLOperation <> 'D' 
	),
	
	----Use this to remove employees already found in IntelliHR for recordbase 
	--cte_employees_email_in_intllihr as (
	--select isnull(e.primaryEmailAddress_email,'XXXXX') as primaryEmailAddress_email
	--FROM [IntelliHR].[jobs] j
	--left outer join [IntelliHR].[people] e ON j.[person_id] = e.[people_id]
	--where j.ODSIsCurrent = 1 and e.ODSIsCurrent = 1
	--group by isnull(e.primaryEmailAddress_email,'XXXXX')
	--),

	--Use this to remove IntelliHR duplicates
	cte_duplicate_employees_in_IntelliHR as (select min(j.positionStartDate) as MinStartDate, e.firstName, e.lastName, e.displayName

	FROM [IntelliHR].[jobs] j
	inner join (select j.jobs_id, max(ODSEffectiveFrom) as LastRecord 
				from [IntelliHR].[jobs] j 
				where j.ODSIsCurrent = 1
				group by j.jobs_id) lr 
	on j.jobs_id = lr.jobs_id and j.ODSEffectiveFrom = lr.LastRecord
	left outer join [IntelliHR].[people] e ON j.[person_id] = e.[people_id]

	where j.ODSIsCurrent = 1 and e.ODSIsCurrent = 1  and e.ODSDMLOperation <> 'D' 
	group by e.firstName, e.lastName, e.displayName
	having count(*) >= 2
	and max(e.[employeeNumber]) <> min(e.[employeeNumber])
	),


	cte_Rbeal_Employees as (Select case when isnull(du.UserEmployeeNumber,'')='' then cast(e.employeeNumber as nvarchar) else cast(du.UserEmployeeNumber as nvarchar) end as employee_id
	from RBEAL.dlDimUser du
	left outer join (select * from [IntelliHR].[people] where ODSIsCurrent = 1) e on du.UserEmailAddress = e.primaryEmailAddress_email
	left outer join (select * from [IntelliHR].[jobs] where ODSIsCurrent = 1) j on e.[people_id] = j.person_id
	left outer join [Datapay].[employees] de ON e.employeeNumber = de.code AND de.ODSIsCurrent = 1
	left outer join [IntelliHR].[people_addresses] pa ON e.[people_id] = pa.[people_id] AND pa.[isPrimary] = 1
	left outer join RBEAL.dlDimUser dm on du.ReportsToUserID = dm.UserID
	
	WHERE du.UserEmployeeNumber <> '6043.' and
	case when isnull(cast(du.UserEmployeeNumber as nvarchar),'')='' 
		then cast(e.employeeNumber as nvarchar) 
		else cast(du.UserEmployeeNumber as nvarchar) 
	end
	not in (select employee_id from cte_employees_in_intllihr)
	and isnumeric(case when isnull(du.UserEmployeeNumber,'')='' then cast(e.employeeNumber as nvarchar) else cast(du.UserEmployeeNumber as nvarchar) end)=1
	),

	people_custom_fields_pivot as (
    select
    [people_id],
    max(case when [custom_field_name] = 'ethnicity' then [definition_value_label] end) as ethnicity,
    max(case when [custom_field_name] = 'exemption_granted' then [definition_value_label] end) as exemption_granted,
    max(case when [custom_field_name] = 'nationality' then [definition_value_label] end) as nationality,
    max(case when [custom_field_name] = 'concurrent_job' then [definition_value_label] end) as concurrent_job,
    max(case when [custom_field_name] = 'identified_ethnicity' then [definition_value_label] end) as identified_ethnicity,
    max(case when [custom_field_name] = 'hapu_affilitation' then [definition_value_label] end) as hapu_affilitation,
    max(case when [custom_field_name] = 'ot_vetting' then [definition_value_label] end) as ot_vetting,
    max(case when [custom_field_name] = 'preferred_last_name' then [definition_value_label] end) as preferred_last_name,
    max(case when [custom_field_name] = 'annual_practising_cert_expiry' then [definition_value_label] end) as annual_practising_cert_expiry,
    max(case when [custom_field_name] = 'exception_police_vetting_expiry' then [definition_value_label] end) as exception_police_vetting_expiry,
    max(case when [custom_field_name] = 'mask_exemption' then [definition_value_label] end) as mask_exemption,
    max(case when [custom_field_name] = 'vaccine_status' then [definition_value_label] end) as vaccine_status,
    max(case when [custom_field_name] = 'smoking_status' then [definition_value_label] end) as smoking_status
	FROM [IntelliHR].[people_custom_fields]
	WHERE [ODSIsCurrent] = 1
	GROUP BY [people_id]
    ),

	
	
	RankedPhoneNumbers AS (
    SELECT 
        people_id,
        fullNumber as phone_number,
        isPrimary,
        isPersonal,
        -- Ranking logic: Primary non-personal numbers get priority
        ROW_NUMBER() OVER (
            PARTITION BY people_id 
            ORDER BY 
                CASE WHEN isPrimary = 1 AND isPersonal = 0 THEN 1
                     WHEN isPrimary = 0 AND isPersonal = 0 THEN 2
                     ELSE 3
                END,
                -- Add a tie-breaker if you have a created/modified date column
                -- created_date DESC, 
                fullNumber  -- Alphabetical tie-breaker as last resort
        ) AS rn
    FROM [IntelliHR].[people_phone_numbers]
    WHERE isPersonal = 0  -- Exclude personal phone numbers
	),
	

	cte_phone_numbers as (
	SELECT 
		people_id,
		phone_number,
		isPrimary,
		isPersonal
	FROM RankedPhoneNumbers
	WHERE rn = 1)



select a.employee_id
	,a.employee_name
	,a.employee_first_name
	,a.employee_middle_name
	,a.employee_last_name
	,a.employee_title
	,a.employee_preferred_name
	,a.employee_employment_status
	,a.employee_job_name
	,a.employee_nhi_number
	,a.employee_profile_system_id
	,a.employee_workrights_name
	,a.employee_workrights_country
	,a.employee_workrights_expirationdate
	,a.employee_employment_condition
	,a.employee_primaryemailaddress_email
	,a.employee_primaryemailaddress_ispersonal
	,a.employee_primary_phone_number
	,a.employee_primary_phone_number_fullnumber
	,a.employee_primary_phone_number_ispersonal
	,a.employee_city_value
	,a.employee_address_Type
	,a.employee_full_address
	,a.employee_street_value
	,a.employee_suburb_value
	,a.employee_postcode_value
	,a.is_primary_address
	,a.emergency_Contact_name
	,a.employee_next_of_whanau_relationship
	,a.employee_next_of_whanau_phone
	,a.employee_next_of_whanau_email
	,a.employee_company_name
	--,a.employee_company_start_date
	

  ,CAST((a.employee_company_start_date AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS employee_company_start_date

	--,a.employee_start_date
	,CAST((a.employee_start_date AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS employee_start_date
	--,a.employee_company_end_date
	,CAST((a.employee_company_end_date AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS employee_company_end_date
	,a.employee_end_date
	--,a.employee_position_start_date
	,CAST((a.employee_position_start_date AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS employee_position_start_date
	,a.employee_gender
	,a.employee_date_of_birth
	,a.employee_age_group
	,a.employee_longevity
	,a.employee_termination_date
	,a.employee_long_service_recognition_date
	,a.employee_work_type
	,a.employee_work_class
	,a.employee_ethnicity
	,a.payGrade_name
	,a.remunerationSchedule_annualPackage
	,a.remunerationSchedule_baseAnnualSalary
	,a.remunerationSchedule_baseHourlyRate
	,a.remunerationSchedule_currency
	,a.remunerationSchedule_hoursPerCycle
	,a.remunerationSchedule_payCycle
	,a.remunerationSchedule_hourlyPackage
	,a.employee_leaving_date
	,a.employee_leaving_reason
	,a.employee_leaving_turnover_type
	,a.employee_exemption_granted
	,a.employee_nationality
	,a.employee_concurrent_job
	,a.employee_identified_ethnicity
	,a.employee_hapu_affilitation
	,a.employee_ot_vetting
	,a.employee_preferred_last_name
	,a.employee_annual_practising_cert_expiry
	,a.employee_exception_police_vetting_expiry
	,a.employee_mask_exemption
	,a.employee_vaccine_status
	,a.employee_smoking_status
	,a.employee_people_manager_job_status
	,a.employee_people_manager_Job_name
	,a.employee_people_manager_name
	,a.employee_people_manager_id
	,a.employee_ird_number
	,a.employee_job_status
	,a.isPrimaryJob
	,a.[extended_leave_type_name]
	,a.[extended_leave_start_date]
	,a.[extended_leave_end_date]
	,a.employee_full_time_equivalent
	,a.system_data_source
	,a.RowNumber
FROM (
	select isnull(cast(e.[employeeNumber] as nvarchar), cast(e.autoIncrementIntellihrId as nvarchar)) as employee_id
		,e.[displayName] as employee_name
		,e.[firstName] as employee_first_name
		,e.[middleName] as employee_middle_name
		,e.[lastName] as employee_last_name
		,e.[title] as employee_title
		,e.[preferredName] as employee_preferred_name
		,e.[employmentStatus] as employee_employment_status
		,j.[name] as employee_job_name
		,'' as employee_nhi_number
		,e.[people_id] as employee_profile_system_id
		,e.[workRights_name] as employee_workrights_name
		,e.[workRights_country] as employee_workrights_country
		,e.[workRights_expirationDate] as employee_workrights_expirationdate
		,j.remunerationSchedule_employmentCondition_name as employee_employment_condition
		,e.[primaryEmailAddress_email] as employee_primaryemailaddress_email
		,e.[primaryEmailAddress_isPersonal] as employee_primaryemailaddress_ispersonal
		--,e.[primaryPhoneNumber_number] as employee_primary_phone_number
		,case when isnull(e.[primaryPhoneNumber_fullNumber],'') <> '' 
			then e.[primaryPhoneNumber_fullNumber]
			else isnull(pn.phone_number,'') end as employee_primary_phone_number

		,e.[primaryPhoneNumber_fullNumber] as employee_primary_phone_number_fullnumber
		,e.[primaryPhoneNumber_isPersonal] as employee_primary_phone_number_ispersonal
		,de.city_value as employee_city_value
		,pa.[addressType] as employee_address_Type
		,pa.[fullAddress] as employee_full_address
		,pa.[street] as employee_street_value
		,pa.[suburb] as employee_suburb_value
		,pa.[postcode] as employee_postcode_value
		,pa.[isPrimary] as is_primary_address
		,e.[emergencyContact_name] as emergency_Contact_name
		,e.[emergencyContact_relationship] as employee_next_of_whanau_relationship
		,e.[emergencyContact_phone] as employee_next_of_whanau_phone
		,e.[emergencyContact_email] as employee_next_of_whanau_email
		,cast(replace(replace(replace(j.[businessEntity_name],
				'Ignite Aotearoa','Ignite Aotearoa Limited') --Ignite Aotearoa Limited
				,'Emerge Aotearoa','Emerge Aotearoa Limited')  --Emerge Aotearoa Limited
				,'Mind & Body','Mind and Body Consultants Ltd')  --Mind and Body Consultants Ltd
				as nvarchar(200)) as employee_company_name
		--,cast(j.[businessEntity_name] as nvarchar(200)) as employee_company_name
		,j.[companyStartDate] as employee_company_start_date
		,j.[startDate] as employee_start_date
		,j.[companyendDate] as employee_company_end_date
		,j.[endDate] as employee_end_date
		,j.[positionStartDate] as employee_position_start_date
		,e.[gender] as employee_gender
		,e.[dateOfBirth] as employee_date_of_birth
		,cast('' as varchar(10)) as employee_age_group
		,de.start_date as employee_longevity
		,de.[termination_date] as employee_termination_date
		,cast('' as varchar(10)) as employee_long_service_recognition_date
		,j.[workType] as employee_work_type
		,j.[workClass] as employee_work_class
		,replace(replace(replace(pcf.ethnicity, '"', ''), '[', ''), ']', '') as employee_ethnicity 
		,j.[payGrade_name]
		,j.[remunerationSchedule_annualPackage]
		,j.[remunerationSchedule_baseAnnualSalary]
		,j.[remunerationSchedule_baseHourlyRate]
		,j.[remunerationSchedule_currency]
		,j.[remunerationSchedule_hoursPerCycle]
		,j.[remunerationSchedule_payCycle]
		,j.[remunerationSchedule_hourlyPackage]
		,de.termination_date as employee_leaving_date
		,j.[turnoverReason] as employee_leaving_reason
		,j.[turnoverType] as employee_leaving_turnover_type
		,pcf.exemption_granted as employee_exemption_granted
		,pcf.nationality as employee_nationality
		,pcf.concurrent_job as employee_concurrent_job
		,pcf.identified_ethnicity as employee_identified_ethnicity
		,pcf.hapu_affilitation as employee_hapu_affilitation
		,pcf.ot_vetting as employee_ot_vetting
		,pcf.preferred_last_name as employee_preferred_last_name
		,pcf.annual_practising_cert_expiry as employee_annual_practising_cert_expiry
		,pcf.exception_police_vetting_expiry as employee_exception_police_vetting_expiry
		,pcf.mask_exemption as employee_mask_exemption
		,replace(replace(replace(pcf.vaccine_status, '"', ''), '[', ''), ']', '') as employee_vaccine_status
		,pcf.smoking_status as employee_smoking_status
		,isnull(j.[supervisorJob_jobStatus],'Unknown') as employee_people_manager_job_status
		,j.[supervisorJob_name] as employee_people_manager_Job_name
		,j.[supervisorPerson_displayName] as employee_people_manager_name
		,j.[supervisorPerson_employeeNumber] as employee_people_manager_id
		,'' as employee_ird_number
		,j.fte as employee_full_time_equivalent
		,j.jobStatus as employee_job_status
		,j.isPrimaryJob
		,j.[extended_leave_type_name]
		,j.[extended_leave_start_date]
		,j.[extended_leave_end_date]

		,'IntelliHR.people' as system_data_source
		,row_number() OVER (
			PARTITION BY isnull(cast(e.[employeeNumber] as nvarchar), cast(e.autoIncrementIntellihrId as nvarchar)) order by j.ODSIsCurrent desc
				,j.jobstatus asc --Added to push past jobs below current jobs 
				,j.isPrimaryJob desc  --Add to push non primary jobs below primary jobs
				,j.positionStartDate desc -- added to keep employee record consistent in no Prod environments
				,j.[companyStartDate] desc -- added to keep employee record consistent in no Prod environments
				,j.[createdAt] desc -- added to keep employee record consistent in no Prod environments
				,e.updatedAt desc -- added to keep employee record consistent in no Prod environments
				,pa.fullAddress desc -- added to keep employee record consistent in no Prod environments 
				,de.city_value asc   -- added for duplicate datapay records
			) as RowNumber

	FROM [IntelliHR].[jobs] j
	left outer join [IntelliHR].[people] e ON j.person_id = e.[people_id]
	left outer join [Datapay].[employees] de ON e.employeeNumber = de.code AND de.ODSIsCurrent = 1
	left outer join [IntelliHR].[people_addresses] pa ON e.[people_id] = pa.[people_id] AND pa.[isPrimary] = 1
	left outer join people_custom_fields_pivot pcf ON e.[people_id] = pcf.[people_id]
	left outer join cte_phone_numbers pn on e.[people_id] = pn.[people_id]

	WHERE e.ODSIsCurrent = 1
		AND j.ODSIsCurrent = 1
		and ISNUMERIC(isnull(cast(e.[employeeNumber] as nvarchar), cast(e.autoIncrementIntellihrId as nvarchar)))=1
		and isnull(isnull(cast(e.[employeeNumber] as nvarchar), cast(e.autoIncrementIntellihrId as nvarchar)),'0') <> '0'
		and e.ODSDMLOperation <> 'D'
		--and isnull(de.displayName,'XXX') = 'XXX'

	Union All --Record base EAL employees where UserEmployeeNumber not in intelliHR but joined back to intelliHR on email address

		select case when isnull(cast(du.UserEmployeeNumber as nvarchar),'')='' then cast(e.employeeNumber as nvarchar) else cast(du.UserEmployeeNumber as nvarchar) end as employee_id
		,isnull(e.[displayName],du.UserUsername) as employee_name
		,isnull(e.[firstName],du.UserFirstName) as employee_first_name
		,e.[middleName] as employee_middle_name
		,isnull(e.[lastName],du.UserLastName) as employee_last_name
		,e.[title] as employee_title
		,e.[preferredName] as employee_preferred_name
		--,isnull(e.[employmentStatus],du.userLicenceType) as employee_employment_status
		
		,isnull(e.[employmentStatus],
			case 
			when isnull(de.start_date,'01-01-1900')>getdate() or isnull(du.UserCreatedDate,'01-01-1900')>getdate() then 'Upcoming Staff'
			when isnull(de.[termination_date],'01-01-1900')>getdate() or isnull(du.UserDisabledDate,'01-01-1900')>getdate() then 'Exiting Staff'
			when de.[termination_date] is null and du.UserDisabledDate is null then 'Current Staff'
			when de.[termination_date] is not null or du.UserDisabledDate is not null then 'Past Staff'
			else 'Unknown' end  
		) as employee_employment_status

		,isnull(j.[name],du.UserPosition) as employee_job_name
		,'' as employee_nhi_number
		,e.[people_id] as employee_profile_system_id
		,e.[workRights_name] as employee_workrights_name
		,e.[workRights_country] as employee_workrights_country
		,e.[workRights_expirationDate] as employee_workrights_expirationdate
		,j.remunerationSchedule_employmentCondition_name as employee_employment_condition
		,isnull(e.[primaryEmailAddress_email],du.UserEmailAddress) as employee_primaryemailaddress_email
		,isnull(e.[primaryEmailAddress_isPersonal],case when len(du.UserEmailAddress)>1 then 1 else 0 end) as employee_primaryemailaddress_ispersonal
		--,e.[primaryPhoneNumber_number] as employee_primary_phone_number
		,case when isnull(e.[primaryPhoneNumber_fullNumber],'') <> '' 
			then e.[primaryPhoneNumber_fullNumber]
			else isnull(pn.phone_number,'') end as employee_primary_phone_number
		,e.[primaryPhoneNumber_fullNumber] as employee_primary_phone_number_fullnumber
		,e.[primaryPhoneNumber_isPersonal] as employee_primary_phone_number_ispersonal
		,de.city_value as employee_city_value
		,pa.[addressType] as employee_address_Type
		,pa.[fullAddress] as employee_full_address
		,pa.[street] as employee_street_value
		,pa.[suburb] as employee_suburb_value
		,pa.[postcode] as employee_postcode_value
		,pa.[isPrimary] as is_primary_address
		,e.[emergencyContact_name] as emergency_Contact_name
		,e.[emergencyContact_relationship] as employee_next_of_whanau_relationship
		,e.[emergencyContact_phone] as employee_next_of_whanau_phone
		,e.[emergencyContact_email] as employee_next_of_whanau_email
		--,cast(j.[businessEntity_name] as nvarchar(200)) as employee_company_name
		,cast(isnull(replace(replace(replace(j.[businessEntity_name],
				'Ignite Aotearoa','Ignite Aotearoa Limited') --Ignite Aotearoa Limited
				,'Emerge Aotearoa','Emerge Aotearoa Limited')  --Emerge Aotearoa Limited
				,'Mind & Body','Mind and Body Consultants Ltd')  --Mind and Body Consultants Ltd
				,'Emerge Aotearoa Limited')
				as nvarchar(200)) as employee_company_name
		,isnull(j.[companyStartDate],du.UserCreatedDate) as employee_company_start_date
		,isnull(j.[startDate],du.UserCreatedDate) as employee_start_date
		,isnull(j.[companyendDate],du.UserDisabledDate) as employee_company_end_date
		,isnull(j.[endDate],du.UserDisabledDate) as employee_end_date
		,j.[positionStartDate] as employee_position_start_date
		,e.[gender] as employee_gender
		,e.[dateOfBirth] as employee_date_of_birth
		,cast('' as varchar(10)) as employee_age_group
		,de.start_date as employee_longevity
		,de.[termination_date] as employee_termination_date
		,cast('' as varchar(10)) as employee_long_service_recognition_date
		,isnull(j.[workType],'Unknown') as employee_work_type
		,isnull(j.[workClass],'Unknown') as employee_work_class
		,replace(replace(replace(pcf.ethnicity, '"', ''), '[', ''), ']', '') as employee_ethnicity 
		,j.[payGrade_name]
		,j.[remunerationSchedule_annualPackage]
		,j.[remunerationSchedule_baseAnnualSalary]
		,j.[remunerationSchedule_baseHourlyRate]
		,j.[remunerationSchedule_currency]
		,j.[remunerationSchedule_hoursPerCycle]
		,j.[remunerationSchedule_payCycle]
		,j.[remunerationSchedule_hourlyPackage]
		,de.termination_date as employee_leaving_date
		,j.[turnoverReason] as employee_leaving_reason
		,j.[turnoverType] as employee_leaving_turnover_type
		,pcf.exemption_granted as employee_exemption_granted
		,pcf.nationality as employee_nationality
		,pcf.concurrent_job as employee_concurrent_job
		,pcf.identified_ethnicity as employee_identified_ethnicity
		,pcf.hapu_affilitation as employee_hapu_affilitation
		,pcf.ot_vetting as employee_ot_vetting
		,pcf.preferred_last_name as employee_preferred_last_name
		,pcf.annual_practising_cert_expiry as employee_annual_practising_cert_expiry
		,pcf.exception_police_vetting_expiry as employee_exception_police_vetting_expiry
		,pcf.mask_exemption as employee_mask_exemption
		,replace(replace(replace(pcf.vaccine_status, '"', ''), '[', ''), ']', '') as employee_vaccine_status
		,pcf.smoking_status as employee_smoking_status
		
		--iwi_affiliation.definition_value_label         as     employee_iwi_affiliation,
		--,isnull(j.[supervisorJob_jobStatus],dm.UserPosition) as employee_people_manager_job_status
		,isnull(j.[supervisorJob_jobStatus],
			case 
			when isnull(de.start_date,'01-01-1900')>getdate() or isnull(dm.UserCreatedDate,'01-01-1900')>getdate() then 'Upcoming Staff'
			when isnull(dpm.[termination_date],'01-01-1900')>getdate() or isnull(dm.UserDisabledDate,'01-01-1900')>getdate() then 'Exiting Staff'
			when dpm.[termination_date] is null and dm.UserDisabledDate is null then 'Current Staff'
			when dpm.[termination_date] is not null or dm.UserDisabledDate is not null then 'Past Staff'
			else 'Unknown' end  --Must have a termination or disabled date
		) as employee_people_manager_job_status
		,isnull(j.[supervisorJob_name],dm.UserPosition) as employee_people_manager_Job_name
		,isnull(j.[supervisorPerson_displayName],dm.UserFirstName + ' ' + dm.UserLastName) as employee_people_manager_name
		,isnull(j.[supervisorPerson_employeeNumber],dm.UserEmployeeNumber) as employee_people_manager_id
		,'' as employee_ird_number
		,j.fte as employee_full_time_equivalent
		,j.jobStatus as employee_job_status
		,isnull(j.isPrimaryJob,1) as isPrimaryJob
		,j.[extended_leave_type_name]
		,j.[extended_leave_start_date]
		,j.[extended_leave_end_date]
		,'RBEAL.dlDimUser' as system_data_source
		,row_number() OVER (
			PARTITION BY du.UserEmployeeNumber order by j.ODSIsCurrent desc
				,j.jobstatus asc --Added to push past jobs below current jobs 
				,j.isPrimaryJob desc  --Add to push non primary jobs below primary jobs
				,j.positionStartDate desc -- added to keep employee record consistent in no Prod environments
				,j.[companyStartDate] desc -- added to keep employee record consistent in no Prod environments
				,j.[createdAt] desc -- added to keep employee record consistent in no Prod environments
				,e.updatedAt desc -- added to keep employee record consistent in no Prod environments
				,pa.fullAddress desc -- added to keep employee record consistent in no Prod environments
				,de.city_value asc   -- added for duplicate datapay records
			) as RowNumber
	
	
	from RBEAL.dlDimUser du
	left outer join (select * from [IntelliHR].[people] where ODSIsCurrent = 1 and ODSDMLOperation <> 'D') e on du.UserEmailAddress = e.primaryEmailAddress_email
	left outer join (select * from [IntelliHR].[jobs] where ODSIsCurrent = 1) j on e.[people_id] = j.person_id
	left outer join [Datapay].[employees] de ON e.employeeNumber = de.code AND de.ODSIsCurrent = 1
	left outer join [IntelliHR].[people_addresses] pa ON e.[people_id] = pa.[people_id] AND pa.[isPrimary] = 1
	left outer join people_custom_fields_pivot pcf ON e.[people_id] = pcf.[people_id]
	left outer join RBEAL.dlDimUser dm on du.ReportsToUserID = dm.UserID
	left outer join [Datapay].[employees] dpm ON j.supervisorPerson_employeeNumber = dpm.code AND dpm.ODSIsCurrent = 1
	left outer join cte_phone_numbers pn on e.[people_id] = pn.[people_id]

	WHERE du.UserEmployeeNumber <> '6043.' and
	case when isnull(cast(du.UserEmployeeNumber as nvarchar),'')='' 
		then cast(e.employeeNumber as nvarchar) 
		else cast(du.UserEmployeeNumber as nvarchar) 
	end
	not in (select employee_id from cte_employees_in_intllihr)
	--and isnull(e.[primaryEmailAddress_email],du.UserEmailAddress) not in (select primaryEmailAddress_email from cte_employees_email_in_intllihr)
	and isnumeric(case when isnull(du.UserEmployeeNumber,'')='' then cast(e.employeeNumber as nvarchar) else cast(du.UserEmployeeNumber as nvarchar) end)=1


	union all --Record base MNB employees where UserEmployeeNumber not in intelliHR but joined back to intelliHR on email address
	
		select case when isnull(cast(du.UserEmployeeNumber as nvarchar),'')='' then cast(e.employeeNumber as nvarchar) else cast(du.UserEmployeeNumber as nvarchar) end as employee_id
		,isnull(e.[displayName],du.UserUsername) as employee_name
		,isnull(e.[firstName],du.UserFirstName) as employee_first_name
		,e.[middleName] as employee_middle_name
		,isnull(e.[lastName],du.UserLastName) as employee_last_name
		,e.[title] as employee_title
		,e.[preferredName] as employee_preferred_name
		--,isnull(e.[employmentStatus],du.userLicenceType) as employee_employment_status
		,isnull(e.[employmentStatus],
			case 
			when isnull(de.start_date,'01-01-1900')>getdate() or isnull(du.UserCreatedDate,'01-01-1900')>getdate() then 'Upcoming Staff'
			when isnull(de.[termination_date],'01-01-1900')>getdate() or isnull(du.UserDisabledDate,'01-01-1900')>getdate() then 'Exiting Staff'
			when de.[termination_date] is null and du.UserDisabledDate is null then 'Current Staff'
			when de.[termination_date] is not null or du.UserDisabledDate is not null then 'Past Staff'
			else 'Unknown' end  
		) as employee_employment_status
		,isnull(j.[name],du.UserPosition) as employee_job_name
		,'' as employee_nhi_number
		,e.[people_id] as employee_profile_system_id
		,e.[workRights_name] as employee_workrights_name
		,e.[workRights_country] as employee_workrights_country
		,e.[workRights_expirationDate] as employee_workrights_expirationdate
		,j.remunerationSchedule_employmentCondition_name as employee_employment_condition
		,isnull(e.[primaryEmailAddress_email],du.UserEmailAddress) as employee_primaryemailaddress_email
		,isnull(e.[primaryEmailAddress_isPersonal],case when len(du.UserEmailAddress)>1 then 1 else 0 end) as employee_primaryemailaddress_ispersonal
		--,e.[primaryPhoneNumber_number] as employee_primary_phone_number
		,case when isnull(e.[primaryPhoneNumber_fullNumber],'') <> '' 
			then e.[primaryPhoneNumber_fullNumber]
			else isnull(pn.phone_number,'') end as employee_primary_phone_number
		,e.[primaryPhoneNumber_fullNumber] as employee_primary_phone_number_fullnumber
		,e.[primaryPhoneNumber_isPersonal] as employee_primary_phone_number_ispersonal
		,de.city_value as employee_city_value
		,pa.[addressType] as employee_address_Type
		,pa.[fullAddress] as employee_full_address
		,pa.[street] as employee_street_value
		,pa.[suburb] as employee_suburb_value
		,pa.[postcode] as employee_postcode_value
		,pa.[isPrimary] as is_primary_address
		,e.[emergencyContact_name] as emergency_Contact_name
		,e.[emergencyContact_relationship] as employee_next_of_whanau_relationship
		,e.[emergencyContact_phone] as employee_next_of_whanau_phone
		,e.[emergencyContact_email] as employee_next_of_whanau_email
		--,cast(j.[businessEntity_name] as nvarchar(200)) as employee_company_name
		,cast(isnull(replace(replace(replace(j.[businessEntity_name],
				'Ignite Aotearoa','Ignite Aotearoa Limited') --Ignite Aotearoa Limited
				,'Emerge Aotearoa','Emerge Aotearoa Limited')  --Emerge Aotearoa Limited
				,'Mind & Body','Mind and Body Consultants Ltd')  --Mind and Body Consultants Ltd
				,'Mind and Body Consultants Ltd')
				as nvarchar(200)) as employee_company_name
		
		,j.[companyStartDate] as employee_company_start_date
		,j.[startDate] as employee_start_date
		,isnull(j.[companyendDate],du.UserDisabledDate) as employee_company_end_date
		,isnull(j.[endDate],du.UserDisabledDate) as employee_end_date
		,j.[positionStartDate] as employee_position_start_date
		,e.[gender] as employee_gender
		,e.[dateOfBirth] as employee_date_of_birth
		,cast('' as varchar(10)) as employee_age_group
		,de.start_date as employee_longevity
		,de.[termination_date] as employee_termination_date
		,cast('' as varchar(10)) as employee_long_service_recognition_date
		,isnull(j.[workType],'Unknown') as employee_work_type
		,isnull(j.[workClass],'Unknown') as employee_work_class
		,replace(replace(replace(pcf.ethnicity, '"', ''), '[', ''), ']', '') as employee_ethnicity 
		,j.[payGrade_name]
		,j.[remunerationSchedule_annualPackage]
		,j.[remunerationSchedule_baseAnnualSalary]
		,j.[remunerationSchedule_baseHourlyRate]
		,j.[remunerationSchedule_currency]
		,j.[remunerationSchedule_hoursPerCycle]
		,j.[remunerationSchedule_payCycle]
		,j.[remunerationSchedule_hourlyPackage]
		,de.termination_date as employee_leaving_date
		,j.[turnoverReason] as employee_leaving_reason
		,j.[turnoverType] as employee_leaving_turnover_type
		,pcf.exemption_granted as employee_exemption_granted
		,pcf.nationality as employee_nationality
		,pcf.concurrent_job as employee_concurrent_job
		,pcf.identified_ethnicity as employee_identified_ethnicity
		,pcf.hapu_affilitation as employee_hapu_affilitation
		,pcf.ot_vetting as employee_ot_vetting
		,pcf.preferred_last_name as employee_preferred_last_name
		,pcf.annual_practising_cert_expiry as employee_annual_practising_cert_expiry
		,pcf.exception_police_vetting_expiry as employee_exception_police_vetting_expiry
		,pcf.mask_exemption as employee_mask_exemption
		,replace(replace(replace(pcf.vaccine_status, '"', ''), '[', ''), ']', '') as employee_vaccine_status
		,pcf.smoking_status as employee_smoking_status
		
		--iwi_affiliation.definition_value_label         as     employee_iwi_affiliation,
		--,isnull(j.[supervisorJob_jobStatus],dm.UserPosition) as employee_people_manager_job_status
	
		,isnull(j.[supervisorJob_jobStatus],
			case 
			when isnull(de.start_date,'01-01-1900')>getdate() or isnull(dm.UserCreatedDate,'01-01-1900')>getdate() then 'Upcoming Staff'
			when isnull(dpm.[termination_date],'01-01-1900')>getdate() or isnull(dm.UserDisabledDate,'01-01-1900')>getdate() then 'Exiting Staff'
			when dpm.[termination_date] is null and dm.UserDisabledDate is null then 'Current Staff'
			when dpm.[termination_date] is not null or dm.UserDisabledDate is not null then 'Past Staff'
			else 'Unknown' end  --Must have a termination or disabled date
		) as employee_people_manager_job_status
	
		,isnull(j.[supervisorJob_name],dm.UserPosition) as employee_people_manager_Job_name
		,isnull(j.[supervisorPerson_displayName],dm.UserFirstName + ' ' + dm.UserLastName) as employee_people_manager_name
		,isnull(j.[supervisorPerson_employeeNumber],dm.UserEmployeeNumber) as employee_people_manager_id
		,'' as employee_ird_number
		,j.fte as employee_full_time_equivalent
		,j.jobStatus as employee_job_status
		,isnull(j.isPrimaryJob,1) as isPrimaryJob
		,j.[extended_leave_type_name]
		,j.[extended_leave_start_date]
		,j.[extended_leave_end_date]
		,'RBMNB.dlDimUser' as system_data_source
		,row_number() OVER (
			PARTITION BY du.UserEmployeeNumber order by j.ODSIsCurrent desc
				,j.jobstatus asc --Added to push past jobs below current jobs 
				,j.isPrimaryJob desc  --Add to push non primary jobs below primary jobs
				,j.positionStartDate desc -- added to keep employee record consistent in no Prod environments
				,j.[companyStartDate] desc -- added to keep employee record consistent in no Prod environments
				,j.[createdAt] desc -- added to keep employee record consistent in no Prod environments
				,e.updatedAt desc -- added to keep employee record consistent in no Prod environments
				,pa.fullAddress desc -- added to keep employee record consistent in no Prod environments 
				,de.city_value asc   -- added for duplicate datapay records
			) as RowNumber
	
	
	from RBMNB.dlDimUser du
	left outer join (select * from [IntelliHR].[people] where ODSIsCurrent = 1 and ODSDMLOperation <> 'D') e on du.UserEmailAddress = e.primaryEmailAddress_email
	left outer join (select * from [IntelliHR].[jobs] where ODSIsCurrent = 1) j on e.[people_id] = j.person_id
	left outer join [Datapay].[employees] de ON e.employeeNumber = de.code AND de.ODSIsCurrent = 1
	left outer join [IntelliHR].[people_addresses] pa ON e.[people_id] = pa.[people_id] AND pa.[isPrimary] = 1
	left outer join people_custom_fields_pivot pcf ON e.[people_id] = pcf.[people_id]
	left outer join RBMNB.dlDimUser dm on du.ReportsToUserID = dm.UserID
	left outer join [Datapay].[employees] dpm ON j.supervisorPerson_employeeNumber = dpm.code AND dpm.ODSIsCurrent = 1
	left outer join cte_phone_numbers pn on e.[people_id] = pn.[people_id]

	WHERE du.UserEmployeeNumber <> '6043.' and
	case when isnull(cast(du.UserEmployeeNumber as nvarchar),'')='' 
		then cast(e.employeeNumber as nvarchar) 
		else cast(du.UserEmployeeNumber as nvarchar) 
	end
	not in (select employee_id from cte_employees_in_intllihr)
	--and isnull(e.[primaryEmailAddress_email],du.UserEmailAddress) not in (select primaryEmailAddress_email from cte_employees_email_in_intllihr)
	--and isnumeric(case when isnull(du.UserEmployeeNumber,'')='' then cast(e.employeeNumber as nvarchar) else cast(du.UserEmployeeNumber as nvarchar) end)=1

	and
	case when isnull(cast(du.UserEmployeeNumber as nvarchar),'')='' 
		then cast(e.employeeNumber as nvarchar) 
		else cast(du.UserEmployeeNumber as nvarchar) 
	end
	not in (select employee_id from cte_Rbeal_Employees) 
	
	and isnumeric(case when isnull(du.UserEmployeeNumber,'')='' 
		then cast(e.employeeNumber as nvarchar) 
		else cast(du.UserEmployeeNumber as nvarchar) end)=1

	union all  --Datapay employees where not in intelliHR 

		select 
		--replace(e.code,'.','') as employee_id
		cast(e.code as nvarchar) as employee_id
		--'0' as employee_id
		,e.first_name + ' ' + e.last_name as employee_name
		,e.[first_name] as employee_first_name
		,'' as employee_middle_name
		,e.[last_name] as employee_last_name
		,e.[title] as employee_title
		,e.[preferred_name] as employee_preferred_name
		--,e.employment_conditions_free_text_1_value as employee_employment_status
		,case 
			when isnull(e.occupation_start_date,'01-01-1900')>getdate() then 'Upcoming Staff'
			when isnull(e.termination_date,'01-01-1900')>getdate() then 'Exiting Staff'
			when e.termination_date is null then 'Current Staff'
			else 'Past Staff' end
		 as employee_employment_status

		,e.occupation_value as employee_job_name
		,'' as employee_nhi_number
		,cast(null as nvarchar(36)) as employee_profile_system_id
		,e.work_visa_free_text_3_value as employee_workrights_name
		,'' as employee_workrights_country
		,e.work_visa_free_text_3_end_date as employee_workrights_expirationdate
		,'' as employee_employment_condition
		,e.email_address as employee_primaryemailaddress_email
		,0 as employee_primaryemailaddress_ispersonal
		,e.work_phone_value as employee_primary_phone_number
		,e.mobile_phone_value as employee_primary_phone_number_fullnumber
		,0 as employee_primary_phone_number_ispersonal
		--e.street_value as employee_street_value,
		--e.suburb_value as employee_suburb_value,
		,e.city_value as employee_city_value
		,'' as employee_address_Type
		,e.city_value as employee_full_address
		,e.street_value as employee_street_value
		,e.suburb_value as employee_suburb_value
		,'' as employee_postcode_value
		,1 as is_primary_address
		,e.emergency_contact_name_value as emergency_contact_name
		,e.emergency_contact_relationship_value as employee_next_of_whanau_relationship
		,e.emergency_contact_mobile_phone_value as employee_next_of_whanau_phone
		,'' as employee_next_of_whanau_email
		--,cast(c.name as nvarchar(200)) as employee_company_name
		--Ignite --> Ignite Aotearoa  Datapay.employees
		--Emerge Aotearoa Ltd --> Emerge Aotearoa Datapay.employees
		--Mind & Body Consultants --> Mind & Body Datapay.employees
		,cast(replace(replace(replace(c.name,
				'Ignite','Ignite Aotearoa Limited')
				,'Emerge Aotearoa Ltd','Emerge Aotearoa Limited')
				,'Mind & Body Consultants','Mind and Body Consultants Ltd')
				as nvarchar(200)) as employee_company_name
		,e.occupation_start_date as employee_company_start_date
		,e.start_date as employee_start_date
		,e.occupation_end_date as employee_company_end_date
		,e.termination_date as employee_end_date
		,e.occupation_start_date as employee_position_start_date
		,e.gender as employee_gender
		,e.birth_date as employee_date_of_birth
		,cast('' as varchar(10)) as employee_age_group
		,e.start_date as employee_longevity
		,e.[termination_date] as employee_termination_date
		,cast('' as varchar(10)) as employee_long_service_recognition_date
		,case when e.tenure_value in ('Full Time') then 'Permanent'
			  when e.tenure_value in ('Temporary Part Time','Casual','Temporary Full Time') then 'Temporary/Casual'
			  when e.tenure_value in ('Fixed Term') then 'Fixed Contract'
			  Else 'Unknown'
		end as employee_work_type

		,case when e.tenure_value in ('Full Time','Temporary Part Time','Temporary Part Time','Casual','Part Time') then e.tenure_value
			  when e.tenure_value in ('Fixed Term') then 'Fixed Contract'
			  Else 'Unknown'
		end as employee_work_class

		,'' as employee_ethnicity
		,e.pay_group_value as payGrade_name
		,case when isnumeric(replace(replace(replace(isnull(e.pay_rate_value,0),',',''),'+',''),'-',''))=1 
		then case when cast(replace(replace(replace(isnull(e.pay_rate_value,0),',',''),'+',''),'-','') as real) >= 5000 
			 then cast(replace(replace(replace(isnull(e.pay_rate_value,0),',',''),'+',''),'-','') as real)
			 else cast(replace(replace(replace(isnull(e.pay_rate_value,0),',',''),'+',''),'-','') as real) * 250.0000 * 8.0000 end
		else 0.0 end as [remunerationschedule_annualPackage]
		
		,case when isnumeric(replace(replace(replace(isnull(e.pay_rate_value,0),',',''),'+',''),'-',''))=1 
		then case when cast(replace(replace(replace(isnull(e.pay_rate_value,0),',',''),'+',''),'-','') as real) >= 5000 
			 then cast(replace(replace(replace(isnull(e.pay_rate_value,0),',',''),'+',''),'-','') as real)
			 else cast(replace(replace(replace(isnull(e.pay_rate_value,0),',',''),'+',''),'-','') as real) * 250.0000 * 8.0000 end
		else 0.0 end as remunerationschedule_baseAnnualSalary
		

		,case when isnumeric(replace(replace(replace(isnull(e.pay_rate_value,0),',',''),'+',''),'-',''))=1 
		then case when cast(replace(replace(replace(isnull(e.pay_rate_value,0),',',''),'+',''),'-','') as real) >= 5000 
			 then cast(replace(replace(replace(isnull(e.pay_rate_value,0),',',''),'+',''),'-','') as real) / 250.0000 / 8.0000
			 else cast(replace(replace(replace(isnull(e.pay_rate_value,0),',',''),'+',''),'-','') as real)  end 
		 else 0.0 end as remunerationschedule_baseHourlyRate

		,'NZD' as  [remunerationschedule_currency]
		,e.hours_per_cycle_free_text_8_value as remunerationschedule_hoursPerCycle
		,g.name as [remunerationSchedule_payCycle]
		,e.standard_days_per_week_value as [remunerationschedule_hourlypackage]
		,e.termination_date as employee_leaving_date
		,'' as employee_leaving_reason
		,'' as employee_leaving_turnover_type
		,'' as employee_exemption_granted
		--date_booster_required.definition_value_label         as     employee_date_booster_required,
		,'' as employee_nationality
		,e.occupation_value as employee_concurrent_job
		,'' as employee_identified_ethnicity
		--date_of_second_vaccination.definition_value_label         as     employee_date_of_second_vaccination,
		,'' as employee_hapu_affilitation
		,'' as employee_ot_vetting
		,e.last_name as employee_preferred_last_name
		,'' as employee_annual_practising_cert_expiry
		,'' as employee_exception_police_vetting_expiry
		,'' as employee_mask_exemption
		,
		--vaccine_status.definition_value_label         as     employee_vaccine_status,
		'' as employee_vaccine_status
		,'' as employee_smoking_status
		--iwi_affiliation.definition_value_label         as     employee_iwi_affiliation,
		,case 
			when isnull(m.start_date,'01-01-1900')>getdate() then 'Upcoming Staff'
			when isnull(m.termination_date,'01-01-1900')>getdate() then 'Exiting Staff'
			when m.termination_date is null then 'Current Staff'
			else 'Past Staff' end  --Must have a termination or disabled date
		as employee_people_manager_job_status
		
		--,max((case when isnull(m.termination_date,'19000101') = '19000101' then 'Current Employee' else 'Ex Employee' end)) as employee_people_manager_job_status
		
		,m.occupation_value as employee_people_manager_job_name
		,m.first_name + ' ' + m.last_name as employee_people_manager_name
		,m.code as employee_people_manager_id
		,'' as employee_ird_number
		,null as employee_full_time_equivalent
		,case 
			when isnull(e.occupation_start_date,'01-01-1900')>getdate() then 'Future Job'
			when isnull(e.termination_date,'01-01-1900')>getdate() then 'Ending Job'
			when e.termination_date is null then 'Current Job'
			else 'Past Job' end
		 as employee_job_status
		,1 as isPrimaryJob
		,'' as [extended_leave_type_name]
		,null as [extended_leave_start_date]
		,null as [extended_leave_end_date]

		,'Datapay.employees' as system_data_source
		,1 as RowNumber

		from Datapay.employees e
		left outer join Datapay.companies c on e.company_id = c.company_id
		left outer join Datapay.pay_groups g on e.pay_group_Value = g.paygroup_id and e.company_id = g.company_id
		left outer join Datapay.employees m on e.manager_id = m.id and m.ODSIsCurrent = 1
		

		where cast(e.code as nvarchar) not in (select employee_id from cte_employees_in_intllihr)
		and isnumeric(cast(e.code as nvarchar))=1
		and e.ODSIsCurrent = 1
		and cast(e.code as nvarchar) not in (select employee_id from CTE_Employees_From_IntelliHR_and_RecordBase)
		
		group by

		cast(e.code as nvarchar) 
		,e.first_name + ' ' + e.last_name
		,e.[first_name] 
		,e.[last_name] 
		,e.[title] 
		,e.[preferred_name] 
		,e.employment_conditions_free_text_1_value 
		,e.occupation_value 
		,e.work_visa_free_text_3_value 
		,e.work_visa_free_text_3_end_date
		,e.email_address
		,e.work_phone_value
		,e.mobile_phone_value 
		,e.home_phone_value
		,e.city_value
		,e.street_value
		,e.suburb_value 
		,e.emergency_contact_name_value 
		,e.emergency_contact_relationship_value
		,e.emergency_contact_mobile_phone_value 
		,cast(replace(replace(replace(c.name,
				'Ignite','Ignite Aotearoa Limited')
				,'Emerge Aotearoa Ltd','Emerge Aotearoa Limited')
				,'Mind & Body Consultants','Mind and Body Consultants Ltd')
				as nvarchar(200))
		,e.occupation_start_date 
		,e.start_date 
		,e.occupation_end_date 
		,e.termination_date 
		,e.occupation_start_date 
		,e.gender 
		,e.birth_date 
		,e.start_date 
		,e.[termination_date]
		,cast(left(e.occupation_value,50) as varchar(50))
		,e.pay_group_value
		,replace(replace(replace(isnull(e.pay_rate_value,0),',',''),'+',''),'-','')
		,e.hours_per_cycle_free_text_8_value
		,g.name 
		,e.standard_days_per_week_value 
		,e.termination_date 
		,e.occupation_value
		,e.last_name 
		--,(case when isnull(m.termination_date,'19000101') = '19000101' then 'Current Employee' else 'Ex Employee' end) 
		,m.occupation_value 
		,m.first_name + ' ' + m.last_name 
		,m.code
		,case 
			when isnull(e.occupation_start_date,'01-01-1900')>getdate() then 'Upcoming Staff'
			when isnull(e.termination_date,'01-01-1900')>getdate() then 'Exiting Staff'
			when e.termination_date is null then 'Current Staff'
			else 'Past Staff' end
		,case when e.tenure_value in ('Full Time') then 'Permanent'
			  when e.tenure_value in ('Temporary Part Time','Casual','Temporary Full Time') then 'Temporary/Casual'
			  when e.tenure_value in ('Fixed Term') then 'Fixed Contract'
			  Else 'Unknown'
		end 
		,case when e.tenure_value in ('Full Time','Temporary Part Time','Temporary Part Time','Casual','Part Time') then e.tenure_value
			  when e.tenure_value in ('Fixed Term') then 'Fixed Contract'
			  Else 'Unknown'
		end 
		,case 
			when isnull(m.start_date,'01-01-1900')>getdate() then 'Upcoming Staff'
			when isnull(m.termination_date,'01-01-1900')>getdate() then 'Exiting Staff'
			when m.termination_date is null then 'Current Staff'
			else 'Past Staff' end
		,case 
			when isnull(e.occupation_start_date,'01-01-1900')>getdate() then 'Future Job'
			when isnull(e.termination_date,'01-01-1900')>getdate() then 'Ending Job'
			when e.termination_date is null then 'Current Job'
			else 'Past Job' end

		union all 

		select isnull(cast(e.reference_number as nvarchar),0) as employee_id
		,e.[first_name] + ' ' + e.last_name as employee_name
		,e.[first_name] as employee_first_name
		,'' as employee_middle_name
		,e.last_name as employee_last_name
		,'' as employee_title
		,e.[nickname] as employee_preferred_name
		,case 
			when isnull(e.start_date,'01-01-1900')>getdate() then 'Upcoming Staff'
			else 'Current Staff'
		end
		as employee_employment_status
		--,e.[employment_type] as employee_employment_status
		,e.[employment_type] as employee_job_name
		,'' as employee_nhi_number
		,cast(null as nvarchar(36)) as employee_profile_system_id
		,'' as employee_workrights_name
		,'' as employee_workrights_country
		,'2999-01-01' as employee_workrights_expirationdate
		,'' as employee_employment_condition
		,e.email_address as employee_primaryemailaddress_email
		,0 as employee_primaryemailaddress_ispersonal
		,e.work_phone as employee_primary_phone_number
		,e.mobile_phone as employee_primary_phone_number_fullnumber
		,0 as employee_primary_phone_number_ispersonal
		,e.[state] as employee_city_value
		,'' as employee_address_Type
		,'' as employee_full_address
		,e.address_1 as employee_street_value
		,e.[suburb] as employee_suburb_value
		,e.post_code as employee_postcode_value
		,1 as is_primary_address
		,'' as emergency_Contact_name
		,'' as employee_next_of_whanau_relationship
		,'' as employee_next_of_whanau_phone
		,'' as employee_next_of_whanau_email
		,cast(comp.company_name as nvarchar(200)) as employee_company_name
		,e.start_date as employee_company_start_date
		,e.start_date as employee_start_date
		,null as employee_company_end_date
		,null as employee_end_date
		,e.start_date as employee_position_start_date
		,e.gender as employee_gender
		,e.birth_date as employee_date_of_birth
		,cast('' as varchar(10)) as employee_age_group
		,null as employee_longevity
		,null as employee_termination_date
		,cast('' as varchar(10)) as employee_long_service_recognition_date
		
		--For agencies depict work type as agency otherwise the employee work type
		,case when e.last_name like '%agency%' then 'Agency'
			  when e.employment_type in ('TEMP','PT','CAS') then 'Temporary/Casual'
			  when e.employment_type = 'FT' then 'Permanent'
			  else 'Unknown'
		end as employee_work_type
		
		--Agencies will usually have TEMP here but leave it in for other employees from emplive
		,case when e.employment_type  = 'TEMP' then 'Temporary'
			  when e.employment_type = 'PT' then 'Part Time'
			  when e.employment_type = 'CAS' then 'Casual'
			  when e.employment_type = 'FT' then 'Permanent'
			  else 'Unknown'
		end as employee_work_class
		--,'Agency' as employee_work_type
		--,'Agency' as employee_work_class
		,replace(replace(replace(ethgroup.ethnicity_level1, '"', ''), '[', ''), ']', '') as employee_ethnicity 
		,pl.name as payGrade_name
		,0 [remunerationSchedule_annualPackage]
		,0 [remunerationSchedule_baseAnnualSalary]
		,0 [remunerationSchedule_baseHourlyRate]
		,'NZD' [remunerationSchedule_currency]
		,0 [remunerationSchedule_hoursPerCycle]
		,'' [remunerationSchedule_payCycle]
		,0 [remunerationSchedule_hourlyPackage]
		,null as employee_leaving_date
		,'' as employee_leaving_reason
		,'' as employee_leaving_turnover_type
		,'' as employee_exemption_granted
		,e.country as employee_nationality
		,'' as employee_concurrent_job
		,ethgroup.ClientEthnicityGrouped as employee_identified_ethnicity
		,'' as employee_hapu_affilitation
		,'' as employee_ot_vetting
		,'' as employee_preferred_last_name
		,'' as employee_annual_practising_cert_expiry
		,null as employee_exception_police_vetting_expiry
		,'' as employee_mask_exemption
		,'' as employee_vaccine_status
		,'' as employee_smoking_status
		,'Unknown' as employee_people_manager_job_status
		,'' as employee_people_manager_Job_name
		,'' as employee_people_manager_name
		,'' as employee_people_manager_id
		,'' as employee_ird_number
		,null as employee_full_time_equivalent
		,null as employee_job_status
		,1 isPrimaryJob
		,'' as [extended_leave_type_name]
		,null as [extended_leave_start_date]
		,null as [extended_leave_end_date]
		,'EmpLive.employees' as data_source
		,row_number() OVER (
			PARTITION BY cast(e.reference_number as nvarchar) order by e.ODSIsCurrent desc
				,e.employment_type asc --Added to push past jobs below current jobs 
				,e.start_date desc  --Add to push non primary jobs below primary jobs
			) as RowNumber
		

		from [EmpLive].[employees] e
		left join [EmpLive].[pay_levels] pl on e.pay_level_id = pl.id
		left join [ETL].[reference_intelliHR_person_ethnicity]  ethgroup 
						ON  cast(ethgroup.employeeNumber as nvarchar(20)) = e.[reference_number]
		left join (
			select id
				,trim(right([name], len([name]) - charindex('-', replace([name], '–', '-')))) as company_name
			FROM [EmpLive].[entities] ent
			WHERE ent.[ODSIsCurrent] = 1
		) as comp ON e.default_service_id = comp.id

		where e.ODSIsCurrent = 1
		and e.last_name like '%agency%'
		and isnumeric(e.reference_number)=1
		and isnull(cast(e.reference_number as nvarchar),0) <> 60000056
		
	) as a
WHERE a.RowNumber = 1
and isnull(a.employee_id,'0') <> '0'
--and isnumeric(a.employee_id)=1
GO


