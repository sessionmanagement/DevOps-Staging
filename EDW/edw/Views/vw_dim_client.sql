
CREATE VIEW [edw].[vw_dim_client]

/***************************************************************************
NAME:     [edw].[vw_dim_client]
NOTES:

REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		?				?					Initial creation of stored procedure
1.1     2026-09-10    Greg Nuthall          Removed PII data columns
****************************************************************************/


AS
SELECT
    dim_client_key
    ,company_id
    ,dim_client_unique_key
    ,client_id
    ,client_display_name
    ,client_first_name
    ,client_middle_name
    ,client_last_name
    ,client_preferred_name
    ,client_nhi_number
    ,client_created_date
    ,client_address_missing_flag
    ,client_address_missing_flag_date
    ,client_address_name
    ,client_address_line1
    ,client_address_line2
    ,client_address_line3
    ,client_address_suburb
    ,client_address_town_or_city
    ,client_address_post_code
    ,client_contact_phone_missing_flag
    ,client_contact_phone_missing_flag_date
    ,client_contact_home_phone

    -- always empty
    ,'' AS client_contact_work_phone
    ,client_contact_mobile_phone
    ,client_contact_fax

    -- always empty
    ,'' AS client_contact_pager
    ,'' AS client_contact_other

    -- missing flag still based on real value
    ,CASE 
        WHEN [client_emergency_contact_phone] IS NULL
            THEN 1
        ELSE 0
     END AS client_emergency_contact_phone_missing_flag

    -- always empty
    ,'' AS client_emergency_contact_phone

    -- always empty
    ,'' AS client_email

    -- always empty
    ,'' AS client_primary_iwi
    ,client_primary_region
    ,client_primary_waka_iwi_unknown_flag
    ,client_primary_ethnicity

    -- always empty
    ,'' AS client_secondary_iwi
    ,'' AS client_secondary_region
    ,'' AS client_secondary_ethnicity

    -- always empty
    ,'' AS client_tertiary_iwi
    ,'' AS client_tertiary_region
    ,'' AS client_tertiary_ethnicity

    ,client_maori_flag
    ,client_pasifika_flag
    ,CASE 
        WHEN client_ethnicity_group IS NULL	
            THEN 1
        ELSE 0
     END AS client_ethnicity_group_missing_flag
    ,client_ethnicity_group
    ,client_gender
    ,client_date_of_birth

    -- if this must be non-sensitive, return empty string always added back in
    --,cast(null as date) AS client_date_of_death
    ,client_date_of_death

    ,client_age_years
    ,client_smoking_status
    ,client_smoking_cigarettes_per_day
    ,client_smoking_assessment_date
    ,client_legal_status_missing_flag

    -- always empty
    ,'' AS client_legal_status

    ,CASE 
        WHEN [client_mental_health_condition] IS NULL
            THEN 1
        ELSE 0
     END AS client_mental_health_condition_missing_flag
    ,client_mental_health_condition
    ,CASE 
        WHEN [client_physical_condition] IS NULL
            THEN 1
        ELSE 0
     END AS client_physical_condition_missing_flag
    ,client_physical_condition
    ,CASE 
        WHEN [client_substance_condition] IS NULL
            THEN 1
        ELSE 0
     END AS client_substance_condition_missing_flag
    ,client_substance_condition
    ,client_smoking_status_missing_flag
    ,client_smoking_advice_flag
    ,client_smoking_cessation_referral_flag
    ,client_primhd_review_missing_flag
    ,client_primhd_review_overdue_flag
    ,client_primhd_review_due_soon_flag
    ,client_primhd_review_current_flag
    ,client_gp_only_missing_flag
    ,client_gp_registration_missing_flag
    ,client_residency_status
    ,client_status_is_active
    ,client_status_is_active_date
    ,client_smoking_last_assessment_flag

    ,e1.ethnicity       AS primary_ethnicity
    ,e2.ethnicity       AS secondary_ethnicity
    ,e3.ethnicity       AS tertiary_ethnicity
    ,e4.ethnicity       AS fourth_ethnicity
    ,e1.ethnicity_group AS primary_ethnicity_group
    ,e2.ethnicity_group AS secondary_ethnicity_group
    ,e3.ethnicity_group AS tertiary_ethnicity_group
    ,e4.ethnicity_group AS fourth_ethnicity_group

    ,'' AS primary_iwi -- as m1.iwi             
    ,'' AS secondary_iwi -- as m2.iwi             
    ,'' AS tertiary_iwi -- as m3.iwi             
    ,'' AS fourth_iwi -- as m4.iwi             
     
    ,'' AS primary_waka --as m1.waka            
    ,'' AS secondary_waka --as m2.waka            
    ,'' AS tertiary_waka --as m3.waka            
    ,'' AS fourth_waka --as m4.waka            

    ,ep.ethnicity       AS priority_ethncity
    ,ep.ethncity_section AS priority_ethncity_section

    ,CASE 
        WHEN dc.primary_ethnicity_id  = 21111 
          OR dc.secondary_ethnicity_id = 21111  
          OR dc.tertiary_ethnicity_id  = 21111  
          OR dc.fourth_ethnicity_id    = 21111
        THEN 1 
        ELSE 0 
     END AS is_maori_flag

    ,CASE 
        WHEN ISNULL(e1.ethncity_section,'') = 'Pacific Peoples'
          OR ISNULL(e2.ethncity_section,'') = 'Pacific Peoples'
          OR ISNULL(e3.ethncity_section,'') = 'Pacific Peoples'
          OR ISNULL(e4.ethncity_section,'') = 'Pacific Peoples'
        THEN 1 
        ELSE 0 
     END AS is_pasifika_flag

    ,DWHSourceSystem
    ,DWHBatchId
    ,DWHDMLOperation
    ,DWHEffectiveFrom
    ,DWHEffectiveTo
    ,DWHIsCurrent

FROM edw.[dim_client] dc
LEFT OUTER JOIN reference.edw_ethnicity e1 ON dc.primary_ethnicity_id   = e1.ethnicity_id
LEFT OUTER JOIN reference.edw_ethnicity e2 ON dc.secondary_ethnicity_id = e2.ethnicity_id
LEFT OUTER JOIN reference.edw_ethnicity e3 ON dc.tertiary_ethnicity_id  = e3.ethnicity_id
LEFT OUTER JOIN reference.edw_ethnicity e4 ON dc.fourth_ethnicity_id    = e4.ethnicity_id

--LEFT OUTER JOIN reference.edw_maori_iwi m1 ON dc.primary_iwi_id   = m1.dim_iwi_key
--LEFT OUTER JOIN reference.edw_maori_iwi m2 ON dc.secondary_iwi_id = m2.dim_iwi_key
--LEFT OUTER JOIN reference.edw_maori_iwi m3 ON dc.tertiary_iwi_id  = m3.dim_iwi_key
--LEFT OUTER JOIN reference.edw_maori_iwi m4 ON dc.fourth_iwi_id    = m4.dim_iwi_key

LEFT OUTER JOIN reference.edw_ethnicity ep ON dc.priority_ethnicity_id = ep.ethnicity_id;