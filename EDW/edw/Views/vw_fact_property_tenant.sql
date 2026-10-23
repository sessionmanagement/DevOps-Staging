
CREATE   view [edw].[vw_fact_property_tenant]

AS

    SELECT f.[fact_property_tenant_key] as [fact_property_tenant_id]
	

	, f.[dim_property_key]
	, isnull(dp.[dim_property_key], CASE 
			WHEN f.[property_id] IS NOT NULL
				THEN - 1
			ELSE 0
			END) AS [dim_property_key_latest]
	, f.[dim_property_key] as [dim_property_detail_key]
	, isnull(dpd.[dim_property_detail_key], CASE 
			WHEN f.[property_id] IS NOT NULL
				THEN - 1
			ELSE 0
			END) AS [dim_property_detail_key_latest]
	, f.[dim_property_key] as [dim_property_healthy_homes_key]
	, isnull(dphh.[dim_property_healthy_homes_key], CASE 
			WHEN f.[property_id] IS NOT NULL
				THEN - 1
			ELSE 0
			END) AS [dim_property_healthy_homes_key_latest]
	, f.[dim_property_tenancy_key]
	, isnull(dpt.[dim_property_tenancy_key], CASE 
			WHEN f.[property_tenancy_id] IS NOT NULL
				THEN - 1
			ELSE 0
			END) AS [dim_property_tenancy_key_latest]
	, f.[dim_property_program_key]
	, isnull(dpp.[dim_property_program_id], CASE 
			WHEN f.[property_program_id] IS NOT NULL
				THEN - 1
			ELSE 0
			END) AS [dim_property_program_key_latest]

	, f.[property_tenancy_id]
    , f.[property_tenant_id]
    , f.[property_id]
    , f.[property_program_id]
    , f.[property_subprogram_id]
    , f.[occupant_record_source]
    , f.[occupant_statecode]
    , f.[occupant_statuscode]
	, f.[property_tenancy_total_rent_amount]
    , f.[property_tenant_tenancy_lease_agreement_date_id]
    , f.[property_tenant_tenancy_start_date_id]
    , f.[property_tenant_first_name]
    , f.[property_tenant_last_name]
    , f.[property_tenant_full_name]
    , f.[property_tenancy_tenant_date_of_birth]
    , f.[property_tenant_registration_date]
    , f.[property_tenant_client_identifier]
    --, f.[property_tenant_primary_tenant_flag]
	, f.property_tenant_head_of_household_flag
	, f.[property_tenant_opportunity_state]
    , f.[property_tenant_opportunity_status]
	, f.[property_tenant_tenancy_name]
    , f.[property_tenant_household_name]
    , f.[property_tenancy_household_identifier]
    , f.[property_tenant_number_of_household_members]
    , f.[property_tenant_named_household_members]
    , f.[property_tenant_rent_share_total]
    , f.[property_tenant_total_household_income]
	, f.[property_tenant_ethnicity_name]
    , f.[property_tenant_household_zavanti_status]
    , f.[property_tenant_household_amendment_date]
	, f.[occupant_is_main_applicant_flag]
    , f.[property_tenant_created_datetime]
    , f.[property_tenant_modified_datetime]
    , f.[occupant_gender_label]
    , f.[occupant_disability_label]
    , f.[occupant_targetgroup_label]
    , f.[occupant_employment_label]
    , f.[occupant_contacttype_label]
    , f.[occupant_eatargetgroup_label]
    , f.[occupant_state_label]
    , f.[occupant_status_label]
    , f.[household_state_label]
    , f.[household_status_label]
    , f.[occupant_emergency_contact_flag]
	, f.[occupant_iwi_affiliation_flag]
	, f.[occupant_social_works_number_flag]
	, f.[property_tenant_is_delete_flag]
    , f.[DWHBatchId]
	, f.[DWHCreatedAt]
	, f.[DWHModifiedOn]
	, f.[DWHDMLOperation]
	, f.[DWHSourceSystem]
    
	


    FROM [edw].[fact_property_tenant] f
        LEFT JOIN [edw].[dim_property] dp ON f.[property_id] = dp.[property_id]
            AND dp.DWHIsCurrent = 1
        LEFT JOIN [edw].[dim_property_detail] dpd ON f.[property_id] = dpd.[property_detail_id]
            AND dpd.DWHIsCurrent = 1
        LEFT JOIN [edw].[dim_property_healthy_homes] dphh ON f.[property_id] = dphh.[property_healthy_homes_id]
            AND dphh.DWHIsCurrent = 1
        LEFT JOIN [edw].[dim_property_tenancy] dpt ON f.[property_tenancy_id] = dpt.[property_tenancy_id]
            AND dpt.DWHIsCurrent = 1
        LEFT JOIN [edw].[dim_property_program] dpp ON f.[property_program_id] = dpp.[property_program_id]
            AND f.[property_subprogram_id] = dpp.[property_subprogram_id]
            AND dpp.[DWHIsCurrent] = 1