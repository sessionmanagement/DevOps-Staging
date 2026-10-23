
CREATE procedure [staging].[insert_staging_fact_property_tenant]

AS

/***************************************************************************
NAME:     [staging].[insert_staging_fact_property_tenant]
PURPOSE:    

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2025-06-16    Greg Nuthall		Initial version
1.1	     2025-07-04    Greg Nuthall		Changed dim_property_program isnull to ensure missing values are 0 not -1
1.2	     2025-08-15    Greg Nuthall		Added occupant_is_main_applicant_flag column
1.3      2026-02-20    GitHub Copilot   Removed redundant columns per work item 12210
1.4      2026-04-15    Greg Nuthall		Renamed column to property_tenant_head_of_household_flag 
1.5      2026-07-28    Mike Gencic      Ethnicity + 3 flags on main-applicant HOUSE rows via zav_fullname identity join 
										and household_zavanti_status, household_amendment_date added
****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLfact_property_tenant]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLfact_property_tenant] (
	dim_property_key
	,dim_property_tenancy_key
	,dim_property_program_key
	,[property_tenancy_id] 
	,[property_tenant_id] 
	,[property_id] 
	,[property_program_id] 
	,[property_subprogram_id] 
	,[property_tenancy_total_rent_amount] 
	,[property_tenant_tenancy_lease_agreement_date_id] 
	,[property_tenant_tenancy_start_date_id] 
	,[property_tenant_first_name] 
	,[property_tenant_last_name] 
	,[property_tenant_full_name] 
	,[property_tenancy_tenant_date_of_birth] 
	,[property_tenant_registration_date] 
	,[property_tenant_client_identifier] 
	,[property_tenant_head_of_household_flag] 
	,[occupant_record_source] 
	,[occupant_statecode] 
	,[occupant_statuscode] 
	,[property_tenant_tenancy_name] 
	,[property_tenant_household_name] 
	,[property_tenancy_household_identifier] 
	,[property_tenant_number_of_household_members] 
	,[property_tenant_named_household_members] 
	,[property_tenant_rent_share_total] 
	,[property_tenant_total_household_income] 
	,[property_tenant_ethnicity_name]
	,[property_tenant_household_zavanti_status]
	,[property_tenant_household_amendment_date]
	,[occupant_is_main_applicant_flag]
	,[property_tenant_created_datetime] 
	,[property_tenant_modified_datetime] 
	,[occupant_gender_label] 
	,[occupant_disability_label] 
	,[occupant_targetgroup_label] 
	,[occupant_employment_label] 
	,[occupant_contacttype_label]
	,[occupant_eatargetgroup_label]
	,[occupant_state_label] 
	,[occupant_status_label] 
	,[household_state_label] 
	,[household_status_label] 
	,[property_tenant_opportunity_state] 
	,[property_tenant_opportunity_status]
	,[occupant_emergency_contact_flag]
	,[occupant_iwi_affiliation_flag]
	,[occupant_social_works_number_flag]

	,[property_tenant_is_delete_flag]
	)

SELECT
	isnull(p.dim_property_key, case when pt.[property_id] is null then 0 else -1 end) as dim_property_key
	,isnull(t.dim_property_tenancy_key, case when pt.[property_tenancy_id] is null then 0 else -1 end) as dim_property_tenancy_key
	,isnull(pp.dim_property_program_id, 
		case when pt.property_program_id is null or pt.property_subprogram_id is null 
		then 0 else -1 
	end) as dim_property_program
	,pt.[property_tenancy_id] 
	,pt.[property_tenant_id] 
	,pt.[property_id] 
	,pt.[property_program_id] 
	,pt.[property_subprogram_id] 
	,pt.[property_tenancy_total_rent_amount] 
	,pt.[property_tenant_tenancy_lease_agreement_date_id] 
	,pt.[property_tenant_tenancy_start_date_id] 
	,pt.[property_tenant_first_name] 
	,pt.[property_tenant_last_name] 
	,pt.[property_tenant_full_name] 
	,pt.[property_tenancy_tenant_date_of_birth] 
	,pt.[property_tenant_registration_date] 
	,pt.[property_tenant_client_identifier] 
	,pt.[property_tenant_head_of_household_flag] 
	,pt.[occupant_record_source] 
	,pt.[occupant_statecode] 
	,pt.[occupant_statuscode] 
	,pt.[property_tenant_tenancy_name] 
	,pt.[property_tenant_household_name] 
	,pt.[property_tenancy_household_identifier] 
	,pt.[property_tenant_number_of_household_members] 
	,pt.[property_tenant_named_household_members] 
	,pt.[property_tenant_rent_share_total] 
	,pt.[property_tenant_total_household_income]
	,pt.[property_tenant_ethnicity_name]
	,pt.[property_tenant_household_zavanti_status]
	,pt.[property_tenant_household_amendment_date]
	,pt.[occupant_is_main_applicant_flag]
	,pt.[property_tenant_created_datetime] 
	,pt.[property_tenant_modified_datetime] 
	,pt.[occupant_gender_label] 
	,pt.[occupant_disability_label] 
	,pt.[occupant_targetgroup_label] 
	,pt.[occupant_employment_label] 
	,pt.[occupant_contacttype_label]
	,pt.[occupant_eatargetgroup_label]
	,pt.[occupant_state_label] 
	,pt.[occupant_status_label] 
	,pt.[household_state_label] 
	,pt.[household_status_label] 
	,pt.[property_tenant_opportunity_state] 
	,pt.[property_tenant_opportunity_status]
	,pt.[occupant_emergency_contact_flag]
	,pt.[occupant_iwi_affiliation_flag]
	,pt.[occupant_social_works_number_flag]
	,pt.[property_tenant_is_delete_flag]

from [Landing].[edw_fact_property_tenant] pt
left outer join edw.dim_property p on pt.property_id = p.property_id and p.DWHIsCurrent = 1 
left outer join edw.dim_property_tenancy t on pt.property_tenancy_id = t.property_tenancy_id and t.DWHIsCurrent = 1
left outer join edw.dim_property_program pp on pt.property_program_id = pp.property_program_id 
and pt.property_subprogram_id = pp.property_subprogram_id
and pp.DWHIsCurrent = 1