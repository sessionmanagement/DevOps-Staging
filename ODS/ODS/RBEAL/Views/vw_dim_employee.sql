


create view [RBEAL].[vw_dim_employee] as select distinct [IntelliHR].[people].[employeeNumber] AS employee_id,
[IntelliHR].[people].[displayName] AS employee_name,
[IntelliHR].[people].[firstName] AS employee_first_name,
[IntelliHR].[people].[middleName] AS employee_middle_name,
[IntelliHR].[people].[lastName] AS employee_last_name,
[IntelliHR].[people].[title] AS employee_title,
[IntelliHR].[people].[preferredName] AS employee_preferred_name,
[IntelliHR].[people].[employmentStatus] AS employee_employment_status,
'' AS employee_nhi_number,
[IntelliHR].[people].[workRights_name] AS employee_workrights_name,
[IntelliHR].[people].[workRights_country] AS employee_workrights_country,
[IntelliHR].[people].[workRights_expirationDate] AS employee_workrights_expirationdate,
[IntelliHR].[people].[primaryEmailAddress_email] AS employee_primaryemailaddress_email,
[IntelliHR].[people].[primaryEmailAddress_isPersonal] AS employee_primaryemailaddress_ispersonal,
[IntelliHR].[people].[primaryPhoneNumber_number] AS employee_primary_phone_number,
[IntelliHR].[people].[primaryPhoneNumber_fullNumber] AS employee_primary_phone_number_fullnumber,
[IntelliHR].[people].[primaryPhoneNumber_isPersonal] AS employee_primary_phone_number_ispersonal,
--[datapay].[employees].street_value AS employee_street_value,
--[datapay].[employees].suburb_value AS employee_suburb_value,
[datapay].[employees].city_value AS employee_city_value,
[IntelliHR].[people_addresses].[addressType] As employee_address_Type
,[IntelliHR].[people_addresses].[fullAddress] as employee_full_address
,[IntelliHR].[people_addresses].[street] As employee_street_value
,[IntelliHR].[people_addresses].[suburb] AS employee_suburb_value
,[IntelliHR].[people_addresses].[postcode] AS employee_postcode_value
,[IntelliHR].[people_addresses].[isPrimary] AS is_primary_address, 
--intellihr.people_addresses,
--intellihr.people_email_addresses,
--intellihr.people_phone_numbers.number/full_number,
[IntelliHR].[people].[emergencyContact_name] as emergency_Contact_name,
[IntelliHR].[people].[emergencyContact_relationship] as employee_next_of_whanau_relationship,
[IntelliHR].[people].[emergencyContact_phone] as employee_next_of_whanau_phone,
[IntelliHR].[people].[emergencyContact_email] as employee_next_of_whanau_email
      ,intellihr.jobs.[companyStartDate]   as employee_company_start_date
      ,intellihr.jobs.[startDate]  as employee_start_date
      ,intellihr.jobs.[companyEndDate] as employee_company_end_date
      ,intellihr.jobs.[endDate] as  employee_end_date
      ,intellihr.jobs.[positionStartDate] as employee_position_start_date,
--datapay.employees.emergency_contact,
--[IntelliHR].[people_custom_fields].definition_value_label as employee_ethnicity,
--n/a.,
[IntelliHR].[people].[gender] as employee_gender,
--[datapay].[employees].[gender],
--n/a.,
[IntelliHR].[people].[dateOfBirth] as employee_date_of_birth,
Floor(Datediff(Day,[IntelliHR].[people].[dateOfBirth],getdate())/365) as employee_age_in_year,
'' AS employee_age_group,
--[datapay].[employees].start_date as employee_start_date,
[datapay].[employees].start_date as employee_longevity,
[datapay].[employees].[termination_date] as employee_termination_date,
--.tenure_start_date,
'' as employee_long_service_recognition_date,
intellihr.jobs.[workType] as employee_work_type,
intellihr.jobs.[workClass] as employee_work_class,
replace(Replace(REPLACE([IntelliHR].[people_custom_fields].definition_value_label,'"',''),'[',''),']','') as employee_ethnicity,

--intellihr.jobs.work_classes name & worktype_name (group),
--intellihr.recruitment_source.name?,
--intellihr.jobs.work_classes name & worktype_name (group),
--intellihr.jobs.location_id/name/address,
--?--?.,
--intellihr.skills.,
--datapay.employees.occupation_start_date,
--datapay.employees.occupation_value,
--.,
intellihr.jobs.[payGrade_name],
intellihr.jobs.[remunerationSchedule_annualPackage],
intellihr.jobs.[remunerationSchedule_baseAnnualSalary],
intellihr.jobs.[remunerationSchedule_baseHourlyRate],
intellihr.jobs.[remunerationSchedule_currency],
intellihr.jobs.[remunerationSchedule_hoursPerCycle],
intellihr.jobs.[remunerationSchedule_payCycle],
intellihr.jobs.[remunerationSchedule_hourlyPackage] ,
datapay.employees.termination_date as employee_leaving_date
 ,intellihr.jobs.[turnoverReason] as employee_leaving_reason,
 intellihr.jobs.[turnoverType] as employee_leaving_turnover_type,
exemption_granted.definition_value_label         AS     employee_exemption_granted,
date_booster_required.definition_value_label         AS     employee_date_booster_required,
nationality.definition_value_label         AS     employee_nationality,
concurrent_job.definition_value_label         AS     employee_concurrent_job,
identified_ethnicity.definition_value_label         AS     employee_identified_ethnicity,
date_of_second_vaccination.definition_value_label         AS     employee_date_of_second_vaccination,
hapu_affilitation.definition_value_label         AS     employee_hapu_affilitation,
ot_vetting.definition_value_label         AS     employee_ot_vetting,
preferred_last_name.definition_value_label         AS     employee_preferred_last_name,
annual_practising_cert_expiry.definition_value_label         AS     employee_annual_practising_cert_expiry,
exception_police_vetting_expiry.definition_value_label         AS     employee_exception_police_vetting_expiry,
mask_exemption.definition_value_label         AS     employee_mask_exemption,
vaccine_status.definition_value_label         AS     employee_vaccine_status,
smoking_status.definition_value_label         AS     employee_smoking_status,
--iwi_affiliation.definition_value_label         AS     employee_iwi_affiliation,


'' as  employee_ird_number,
'' as employee_salary_sacrifice,
'' as employee_bank_details,
'' as employee_incidents,
'' as employee_latest_incident_date,
'' as employee_disciplinary_status,
'' as employee_specific_needs,
'' as employee_qualification_level,
'' as employee_referral_source,
'' as employee_current_status,
 intellihr.jobs.isPrimaryJob

,[IntelliHR].[people].ODSEffectiveFrom,[IntelliHR].[people].ODSEffectiveTo,[IntelliHR].[people].ODSIsCurrent,[Datapay].[employees].ODSIsCurrent ODSIsCurrentDatapay
,[Datapay].[employees].ODSEffectiveFrom as ODSEffectiveFromDataPay,[Datapay].[employees].ODSEffectiveTo as ODSEffectiveToDatapay
,[IntelliHR].[jobs].ODSIsCurrent ODSIsCurrentJob,[IntelliHR].[jobs].ODSEffectiveFrom ODSEffectiveFromjob,[IntelliHR].[jobs].ODSEffectiveTo ODSEffectiveTojob


FROM  [IntelliHR].[jobs] 
left outer join  [IntelliHR].[people]  on [IntelliHR].[jobs].[person_id]=[IntelliHR].[people].[people_id] AND [IntelliHR].[people].ODSIsCurrent=1
left outer join [Datapay].[employees] on [IntelliHR].[people].employeeNumber=[Datapay].[employees].code AND  [Datapay].[employees].ODSIsCurrent=1  
left outer join [IntelliHR].[people_addresses] on [IntelliHR].[people].[people_id]=[IntelliHR].[people_addresses].[people_id]
left outer join [IntelliHR].[people_custom_fields] on [IntelliHR].[people].[people_id]=[IntelliHR].[people_custom_fields].[people_id] AND [IntelliHR].[people_custom_fields].[custom_field_name]='ethnicity' and [IntelliHR].[people_custom_fields].[ODSIsCurrent]=1
left outer join [IntelliHR].[people_custom_fields] exemption_granted on [IntelliHR].[people].[people_id]=exemption_granted.[people_id] AND exemption_granted.[custom_field_name]='exemption_granted' and exemption_granted.[ODSIsCurrent]=1
left outer join [IntelliHR].[people_custom_fields] date_booster_required on [IntelliHR].[people].[people_id]=date_booster_required.[people_id] AND date_booster_required.[custom_field_name]='date_booster_required' and date_booster_required.[ODSIsCurrent]=1
left outer join [IntelliHR].[people_custom_fields] nationality on [IntelliHR].[people].[people_id]=nationality.[people_id] AND nationality.[custom_field_name]='nationality' and nationality.[ODSIsCurrent]=1
left outer join [IntelliHR].[people_custom_fields] concurrent_job on [IntelliHR].[people].[people_id]=concurrent_job.[people_id] AND concurrent_job.[custom_field_name]='concurrent_job' and concurrent_job.[ODSIsCurrent]=1
left outer join [IntelliHR].[people_custom_fields] identified_ethnicity on [IntelliHR].[people].[people_id]=identified_ethnicity.[people_id] AND identified_ethnicity.[custom_field_name]='identified_ethnicity' and identified_ethnicity.[ODSIsCurrent]=1
left outer join [IntelliHR].[people_custom_fields] date_of_second_vaccination on [IntelliHR].[people].[people_id]=date_of_second_vaccination.[people_id] AND date_of_second_vaccination.[custom_field_name]='date_of_second_vaccination' and date_of_second_vaccination.[ODSIsCurrent]=1
left outer join [IntelliHR].[people_custom_fields] hapu_affilitation on [IntelliHR].[people].[people_id]=hapu_affilitation.[people_id] AND hapu_affilitation.[custom_field_name]='hapu_affilitation' and hapu_affilitation.[ODSIsCurrent]=1
left outer join [IntelliHR].[people_custom_fields] ot_vetting on [IntelliHR].[people].[people_id]=ot_vetting.[people_id] AND ot_vetting.[custom_field_name]='ot_vetting' and ot_vetting.[ODSIsCurrent]=1
left outer join [IntelliHR].[people_custom_fields] preferred_last_name on [IntelliHR].[people].[people_id]=preferred_last_name.[people_id] AND preferred_last_name.[custom_field_name]='preferred_last_name' and preferred_last_name.[ODSIsCurrent]=1
left outer join [IntelliHR].[people_custom_fields] annual_practising_cert_expiry on [IntelliHR].[people].[people_id]=annual_practising_cert_expiry.[people_id] AND annual_practising_cert_expiry.[custom_field_name]='annual_practising_cert_expiry' and annual_practising_cert_expiry.[ODSIsCurrent]=1
left outer join [IntelliHR].[people_custom_fields] exception_police_vetting_expiry on [IntelliHR].[people].[people_id]=exception_police_vetting_expiry.[people_id] AND exception_police_vetting_expiry.[custom_field_name]='exception_police_vetting_expiry' and exception_police_vetting_expiry.[ODSIsCurrent]=1
left outer join [IntelliHR].[people_custom_fields] mask_exemption on [IntelliHR].[people].[people_id]=mask_exemption.[people_id] AND mask_exemption.[custom_field_name]='mask_exemption' and mask_exemption.[ODSIsCurrent]=1
left outer join [IntelliHR].[people_custom_fields] vaccine_status on [IntelliHR].[people].[people_id]=vaccine_status.[people_id] AND vaccine_status.[custom_field_name]='vaccine_status' and vaccine_status.[ODSIsCurrent]=1
left outer join [IntelliHR].[people_custom_fields] smoking_status on [IntelliHR].[people].[people_id]=smoking_status.[people_id] AND smoking_status.[custom_field_name]='smoking_status' and smoking_status.[ODSIsCurrent]=1
left outer join [IntelliHR].[people_custom_fields] iwi_affiliationon on [IntelliHR].[people].[people_id]=iwi_affiliationon.[people_id] AND iwi_affiliationon.[custom_field_name]='iwi_affiliationon' and iwi_affiliationon.[ODSIsCurrent]=1
 WHERE 
 [IntelliHR].[people_custom_fields].[ODSIsCurrent]=1
