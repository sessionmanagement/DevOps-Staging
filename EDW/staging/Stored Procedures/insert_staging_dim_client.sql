
CREATE PROC [staging].[insert_staging_dim_client]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_client]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		?				?					Initial creation of stored procedure
1.1		2023-08-07		Glenn McLeod		Updated to use table Framework table names 
1.11	2023-08-10		Glenn McLeod		removed smoking assessment date from merge key
1.12	2023-08-24		Glenn McLeod		Updated table/column names
1.13	2023-09-08		Glenn McLeod		Added logic to detect activation of flag field and update the corresponding date field
1.2		2023-09-25		Glenn McLeod		Renamed destination column from [dim_company_key] to [company_id]
2.0		2024-11-11		Greg Nuthall		Added new ethncity fields and added ethncity priority

****************************************************************************/

DECLARE @systemCurrentDate DATETIME = GETDATE();

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_client];

with ethncity_priority as (
select src.client_id
	,src.company_key
	,case when et1.priority_group = MinValue then et1.ethnicity_id
	  when et2.priority_group = MinValue then et2.ethnicity_id
	  when et3.priority_group = MinValue then et3.ethnicity_id
	  when et4.priority_group = MinValue then et4.ethnicity_id
	end as Priority_ethnicity

from landing.edw_dim_client as src
	left join reference.edw_ethnicity_mapping em on replace(replace(src.primary_ethnicity2,nchar(257),'a'),nchar(228),'a') = em.Input_Value and em.Category = 'Ethnicity RB'
	left join reference.edw_ethnicity_mapping em2 on replace(replace(src.secondary_ethnicity2,nchar(257),'a'),nchar(228),'a') = em2.Input_Value and em2.Category = 'Ethnicity RB'
	left join reference.edw_ethnicity_mapping em3 on replace(replace(src.tertiary_ethnicity2,nchar(257),'a'),nchar(228),'a') = em3.Input_Value and em3.Category = 'Ethnicity RB'
	left join reference.edw_ethnicity_mapping em4 on replace(replace(src.fourth_ethnicity2,nchar(257),'a'),nchar(228),'a') = em4.Input_Value and em4.Category = 'Ethnicity RB'

	left join reference.edw_ethnicity et1 on em.ethnicity_1 = et1.ethnicity_id
	left join reference.edw_ethnicity et2 on em2.ethnicity_1 = et2.ethnicity_id
	left join reference.edw_ethnicity et3 on em3.ethnicity_1 = et3.ethnicity_id
	left join reference.edw_ethnicity et4 on em4.ethnicity_1 = et4.ethnicity_id
	
	cross apply (select min(d) AS MinValue from (values (et1.priority_group), (et2.priority_group), (et3.priority_group), (et4.priority_group)) as a(d)) A
	)


-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_client] (
	[dim_client_unique_key]
	,[client_id]
	,[company_id]
	,[client_display_name]
	,[client_first_name]
	,[client_middle_name]
	,[client_last_name]
	,[client_preferred_name]
	,[client_nhi_number]
	,[client_created_date]
	,[client_address_missing_flag]
	,[client_address_missing_flag_date]
	,[client_address_name]
	,[client_address_line1]
	,[client_address_line2]
	,[client_address_line3]
	,[client_address_suburb]
	,[client_address_town_or_city]
	,[client_address_post_code]
	,[client_contact_phone_missing_flag]
	,[client_contact_phone_missing_flag_date]
	,[client_contact_home_phone]
	,[client_contact_work_phone]
	,[client_contact_mobile_phone]
	,[client_contact_fax]
	,[client_contact_pager]
	,[client_contact_other]
	,[client_emergency_contact_flag]
	,[client_emergency_contact_phone]
	,[client_email]
	,[client_primary_iwi]
	,[client_primary_region]
	,[client_primary_waka_iwi_unknown_flag]
	,[client_primary_ethnicity]
	,[client_secondary_iwi]
	,[client_secondary_region]
	,[client_secondary_waka_iwi_unknown_flag]
	,[client_secondary_ethnicity]
	,[client_tertiary_iwi]
	,[client_tertiary_region]
	,[client_tertiary_waka_iwi_unknown_flag]
	,[client_tertiary_ethnicity]
	,[client_maori_flag]
	,[client_pasifika_flag]
	,[client_ethnicity_group]
	,[client_gender]
	,[client_date_of_birth]
	,[client_date_of_death]
	,[client_age_years]
	,[client_smoking_status]
	,[client_smoking_cigarettes_per_day]
	,[client_smoking_assessment_date]
	,[client_legal_status_missing_flag]
	,[client_legal_status]
	,[client_mental_health_condition_flag]
	,[client_mental_health_condition]
	,[client_physical_health_condition_flag]
	,[client_physical_condition]
	,[client_substance_use_flag]
	,[client_substance_condition]
	,[client_smoking_status_missing_flag]
	,[client_smoking_advice_flag]
	,[client_smoking_cessation_referral_flag]
	,[client_primhd_review_missing_flag]
	,[client_primhd_review_overdue_flag]
	,[client_primhd_review_due_soon_flag]
	,[client_primhd_review_current_flag]
	,[client_gp_only_missing_flag]
	,[client_gp_registration_missing_flag]
	,[client_residency_status]
	,[client_status_is_active]
	,[client_status_is_active_date]
	,[client_smoking_last_assessment_flag]
	,primary_ethnicity_id 
	,secondary_ethnicity_id  
	,tertiary_ethnicity_id 
	,fourth_ethnicity_id  
	,primary_iwi_id  
	,secondary_iwi_id  
	,tertiary_iwi_id 
	,fourth_iwi_id  
	,priority_ethnicity_id

	)
SELECT cast(src.client_id AS NVARCHAR) + '-' + CAST(src.[company_key] AS NVARCHAR)
	,src.[client_id]
	,src.[company_key]
	,src.[client_display_name]
	,src.[client_first_name]
	,src.[client_middle_name]
	,src.[client_last_name]
	,src.[client_preferred_name]
	,src.[client_nhi_number]
	,src.[client_created_date]
	,src.[client_address_missing_indicator]
	,CASE 
		WHEN src.[client_address_missing_indicator] = '1'
			AND dc.[client_address_missing_flag] = '0'
			THEN @systemCurrentDate
		ELSE ISNULL(dc.[client_address_missing_flag_date],'1 January 1900')
		END -- if client_address_missing_indicator changes to active update the date field
	,src.[client_address_name]
	,src.[client_address_line1]
	,src.[client_address_line2]
	,src.[client_address_line3]
	,src.[client_address_suburb]
	,src.[client_address_town_or_city]
	,src.[client_address_post_code]
	,src.[client_contact_phone_missing_indicator]
	,CASE 
		WHEN src.[client_contact_phone_missing_indicator] = '1'
			AND dc.[client_contact_phone_missing_flag] = '0'
			THEN @systemCurrentDate
		ELSE ISNULL(dc.[client_contact_phone_missing_flag_date],'1 January 1900')
		END -- if client_contact_phone_missing_indicator changes to active update the date field
	,src.[client_contact_home_phone]
	,src.[client_contact_work_phone]
	,src.[client_contact_mobile_phone]
	,src.[client_contact_fax]
	,src.[client_contact_pager]
	,src.[client_contact_other]
	,src.[client_emergency_contact_indicator]
	,src.[client_emergency_contact_phone]
	,src.[client_email]
	,src.[primary_iwi]
	,src.[primary_region]
	,src.[primary_waka_IwiUnknown]
	,src.[primary_ethnicity]
	,src.[secondary_iwi]
	,src.[secondary_region]
	,src.[secondary_waka_IwiUnknown]
	,src.[secondary_ethnicity]
	,src.[tertiary_iwi]
	,src.[tertiary_region]
	,src.[tertiary_waka_IwiUnknown]
	,src.[tertiary_ethnicity]
	,src.[maori_indicator]
	,src.[pasifika_indicator]
	,src.[ethnicity_group]
	,src.[client_gender]
	,src.[client_date_of_birth]
	,src.[client_date_of_death]
	,src.[client_age_years]
	,src.[smoking_status]
	,src.[smoking_cigarettes_per_day]
	,src.[smoking_assessment_date]
	,src.[client_legal_status_missing_indicator]
	,src.[client_legal_status]
	,src.[client_mental_health_condition_indicator]
	,src.[client_mental_health_condition]
	,src.[client_physical_health_condition_indicator]
	,src.[client_physical_condition]
	,src.[client_substance_use_indicator]
	,src.[client_substance_condition]
	,src.[client_smoking_status_missing_indicator]
	,src.[client_smoking_advice_indicator]
	,src.[client_smoking_cessation_referral_indicator]
	,src.[client_primhd_review_missing_indicator]
	,src.[client_primhd_review_overdue_indicator]
	,src.[client_primhd_review_due_soon_indicator]
	,src.[client_primhd_review_current_indicator]
	,src.[client_gp_only_missing_indicator]
	,src.[client_gp_registration_missing_indicator]
	,src.[client_residency_status]
	,src.[client_status_is_active]
	,CASE 
		WHEN src.[client_status_is_active] = 'Active'
			AND dc.[client_status_is_active] <> 'Active'
			THEN @systemCurrentDate
		ELSE ISNULL(dc.[client_status_is_active_date],'1 January 1900')
		END -- if client_status_is_active changes to active update the date field
	,src.[LastAssessmentIndicator]
	,em.ethnicity_1 as primary_ethnicity_id
	,em2.ethnicity_1 as secondary_ethnicity_id
	,em3.ethnicity_1 as tertiary_ethnicity_id
	,em4.ethnicity_1 as fourth_ethnicity_id
	,em5.ethnicity_1 as primary_iwi_id
	,em6.ethnicity_1 as secondary_iwi_id
	,em7.ethnicity_1 as tertiary_iwi_id
	,em8.ethnicity_1 as fourth_iwi_id
	,ep.Priority_ethnicity

	from landing.edw_dim_client as src
	left join edw.dim_client dc on (cast(src.client_id AS nvarchar) + '-' + cast(company_key AS nvarchar)) = dc.dim_client_unique_key
		and dc.DWHIsCurrent = 1
	left join reference.edw_ethnicity_mapping em on replace(replace(src.primary_ethnicity2,nchar(257),'a'),nchar(228),'a') = em.Input_Value and em.Category = 'Ethnicity RB'
	left join reference.edw_ethnicity_mapping em2 on replace(replace(src.secondary_ethnicity2,nchar(257),'a'),nchar(228),'a') = em2.Input_Value and em2.Category = 'Ethnicity RB'
	left join reference.edw_ethnicity_mapping em3 on replace(replace(src.tertiary_ethnicity2,nchar(257),'a'),nchar(228),'a') = em3.Input_Value and em3.Category = 'Ethnicity RB'
	left join reference.edw_ethnicity_mapping em4 on replace(replace(src.fourth_ethnicity2,nchar(257),'a'),nchar(228),'a') = em4.Input_Value and em4.Category = 'Ethnicity RB'

	left join reference.edw_ethnicity_mapping em5 on replace(replace(replace(trim(src.primary_iwi2),nchar(257),'a'),nchar(228),'a'),'''','') = em5.Input_Value and em5.Category = 'maori_iwi_RB'
	left join reference.edw_ethnicity_mapping em6 on replace(replace(replace(trim(src.secondary_iwi2),nchar(257),'a'),nchar(228),'a'),'''','') = em6.Input_Value and em6.Category = 'maori_iwi_RB'
	left join reference.edw_ethnicity_mapping em7 on replace(replace(replace(trim(src.tertiary_iwi2),nchar(257),'a'),nchar(228),'a'),'''','') = em7.Input_Value and em7.Category = 'maori_iwi_RB'
	left join reference.edw_ethnicity_mapping em8 on replace(replace(replace(trim(src.fourth_iwi2),nchar(257),'a'),nchar(228),'a'),'''','') = em8.Input_Value and em8.Category = 'maori_iwi_RB'
	
	left join ethncity_priority ep on src.client_id = ep.client_id and src.company_key = ep.company_key

--with CTE_ethncity_priority_selection

--as (
--select src.client_id
--	,et1.priority_group as priority1
--	,et2.priority_group as priority2
--	,et3.priority_group as priority3
--	,et4.priority_group as priority4
--	,et1.ethnicity_id as ethnicity_id1
--	,et2.ethnicity_id as ethnicity_id2
--	,et3.ethnicity_id as ethnicity_id3
--	,et4.ethnicity_id as ethnicity_id4

--from landing.edw_dim_client as src
--	left join reference.edw_ethnicity_mapping em on replace(replace(src.primary_ethnicity2,nchar(257),'a'),nchar(228),'a') = em.Input_Value and em.Category = 'Ethnicity RB'
--	left join reference.edw_ethnicity_mapping em2 on replace(replace(src.secondary_ethnicity2,nchar(257),'a'),nchar(228),'a') = em2.Input_Value and em2.Category = 'Ethnicity RB'
--	left join reference.edw_ethnicity_mapping em3 on replace(replace(src.tertiary_ethnicity2,nchar(257),'a'),nchar(228),'a') = em3.Input_Value and em3.Category = 'Ethnicity RB'
--	left join reference.edw_ethnicity_mapping em4 on replace(replace(src.fourth_ethnicity2,nchar(257),'a'),nchar(228),'a') = em4.Input_Value and em4.Category = 'Ethnicity RB'

--	left join reference.edw_ethnicity et1 on em.ethnicity_1 = et1.ethnicity_id
--	left join reference.edw_ethnicity et2 on em2.ethnicity_1 = et2.ethnicity_id
--	left join reference.edw_ethnicity et3 on em3.ethnicity_1 = et3.ethnicity_id
--	left join reference.edw_ethnicity et4 on em4.ethnicity_1 = et4.ethnicity_id)


--,ethncity_priority as (

--select CTE_ethncity_priority_selection.client_id, priority1, priority2, priority3, priority4, TheMin
--,case when priority1 = TheMin then ethnicity_id1
--	  when priority2 = TheMin then ethnicity_id2
--	  when priority3 = TheMin then ethnicity_id3
--	  when priority4 = TheMin then ethnicity_id4
--end as Priority_ethnicity

--from CTE_ethncity_priority_selection
--join
--(
--    select
--        client_id, min(Amount) as TheMin
--    from 
--        CTE_ethncity_priority_selection 
--        UNPIVOT (Amount for AmountCol in (priority1, priority2, priority3, priority4)) as unpvt
--    group by client_id
--) as minValues
--on CTE_ethncity_priority_selection.client_id = minValues.client_id)