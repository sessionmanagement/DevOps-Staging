
CREATE     VIEW [ETL].[fact_property_tenant]

/**********************************************************************************************************
 View		[ETL].[fact_property_tenant]
 Author		Mike Gencic
 Created	[Original Creation Date]	
 Purpose	Fact table that gathers occupant rows from both [vw_contact] and [vw_zav_house] 
		    to provide comprehensive property tenant information for the data warehouse.

 **************************************************************************************************************
--REVISIONS:
--Version	 Date			Author			Description
---------	 ------------	---------------	--------------------------
--1.0		 2025-07-27		Mike Gencic		Initial version
--1.1		 2025-07-27		Greg Nuthall	Modified to remove failed join
--1.2		 2025-07-27		Greg Nuthall	Modified to add ethnicity
--1.3		 2025-08-27		Greg Nuthall	Remove recordbaseid (moved to dim_property_tenancy)
--1.4		 2025-11-04		Greg Nuthall	Added property_tenant_is_main_applicant_flag (User Story 11540)
--1.5        2026-02-20     GitHub Copilot  Removed 7 redundant columns per work item 12210 V2
--1.6		 2026-01-26		Mike Gencic		Renamed property_tenant_primary_tenant_flag to property_tenant_head_of_household_flag
--1.7        2026-06-16     Greg Nuthall    Added three flags occupant_iwi_affiliation_flag, occupant_emergency_contact_flag
                                            ,occupant_social_works_number_flag,
--1.8        2026-07-28     Mike Gencic     Ethnicity + 3 flags on main-applicant HOUSE rows via zav_fullname identity join (US TBC)
--1.9        2026-09-11     Greg Nuthall    Use contact data for tenant gender when house data is null
**************************************************************************************************************/

AS

    WITH
        occupant_union
        AS
        (
                SELECT
                    'CONTACT' as occupant_source,
                    TRY_CONVERT(uniqueidentifier, c.Id) as occupant_id,
                    TRY_CONVERT(uniqueidentifier, c.zav_household) as occupant_household_id,

                    c.createdon as occupant_createdon,
                    c.modifiedon as occupant_modifiedon,

                    ROW_NUMBER() OVER (
                        PARTITION BY c.zav_household
                        ORDER BY c.createdon, c.modifiedon
                    ) as occupant_position_num,

                    -----------------------------------------------------------------------
                    -- Common occupant columns that exist in [vw_contact]
                    -----------------------------------------------------------------------
                    c.firstname as occupant_firstname,
                    c.lastname as occupant_lastname,
                    c.fullname as occupant_fullname,
                    c.zav_aka as occupant_aka,
                    c.zav_gender as occupant_gendercode,
                    TRY_CONVERT(date, c.new_dateofbirth) as occupant_dob,
                    c.zav_registrationdate as occupant_registrationdate,
                    --c.zav_primarytenant as occupant_primarytenant,
                    c.zav_primarytenant as occupant_head_of_household,
                    c.zav_chintaroid as occupant_chintaroid,
                    c.zav_clientid as occupant_clientid,

                    c.zav_disability as occupant_disability,
                    c.zav_targetgroup as occupant_targetgroup,
                    c.zav_employment as occupant_employment,
                    c.zav_contacttype as occupant_contacttype,
                    --c.zav_eatargetgroup as occupant_eatargetgroup2,

                    -- occupant OptionSet columns from [vw_contact]
                    c.zav_cra as occupant_cra,
                    c.zav_band as occupant_band,
                    c.zav_agentfor as occupant_agentfor,
                    c.zav_aremainapplicantsabletosignlegaldocumenos as occupant_signlegaldoc,

                    case when c.zav_iwiaffiliation is not null or c.zav_iwimember = 'True' 
                        then 1 
                        else 0
                    end as occupant_iwi_affiliation_flag,

                    case when isnull(cast(c.zav_emergencycontactname1 as nvarchar),'') <> '' 
                    or isnull(cast(c.zav_emergencycontactname2 as nvarchar),'') <> ''
                        then 1 
                        else 0
                    end as occupant_emergency_contact_flag,

                    case when c.zav_winznumber is not null then
                        case when c.zav_winznumber LIKE '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9]' 
                            then 1
                            else 0
                        end
                    else 0
                    end as occupant_social_works_number_flag,

                    -- NEW occupant column specifically requested:
                    --c.new_recordbaseid as occupant_recordbaseid,

                    -- occupant state/status from contact
                    c.statecode as occupant_statecode,
                    c.statuscode as occupant_statuscode,

                    CAST(c.zav_ethnicityname AS VARCHAR(100)) as occupant_ethnicity_name,
                    null as occupant_is_main_applicant_flag

            
                FROM [Zavanti].[vw_contact] AS c
                WHERE c.zav_household IS NOT NULL


            UNION ALL

            SELECT
                    'HOUSE' as occupant_source,
                    TRY_CONVERT(uniqueidentifier, h.Id) as occupant_id,
                    TRY_CONVERT(uniqueidentifier, h.zav_householdid) as occupant_household_id,

                    h.createdon as occupant_createdon,
                    h.modifiedon as occupant_modifiedon,

                    ROW_NUMBER() OVER (
                        PARTITION BY h.zav_householdid
                        ORDER BY h.createdon, h.modifiedon
                    ) as occupant_position_num,

                    h.zav_firstname as occupant_firstname,
                    h.zav_lastname as occupant_lastname,
                    h.zav_name as occupant_fullname,
                    NULL as occupant_aka,
                    isnull(h.zav_gender,hc.zav_gender) as occupant_gendercode,
                    --h.zav_gender as occupant_gendercode,
                    TRY_CONVERT(date, h.zav_dateofbirth) as occupant_dob,
                    NULL as occupant_registrationdate,
                    h.zav_headofthehousehold as occupant_head_of_household,
                    NULL as occupant_chintaroid,
                    NULL as occupant_clientid,

                    NULL as occupant_disability,
                    NULL as occupant_targetgroup,
                    h.zav_incomesource as occupant_employment, -- if it's numeric
                    NULL as occupant_contacttype,
                    --NULL as occupant_eatargetgroup2,

                    NULL as occupant_cra,
                    NULL as occupant_band,
                    NULL as occupant_agentfor,
                    NULL as occupant_signlegaldoc,

                    --0 as occupant_iwi_affiliation_flag,
                    --0 as occupant_emergency_contact_flag,
                    --0 as occupant_social_works_number_flag,

                    case when hc.zav_iwiaffiliation is not null or hc.zav_iwimember = 'True'
                        then 1
                        else 0
                    end as occupant_iwi_affiliation_flag,

                    case when isnull(cast(hc.zav_emergencycontactname1 as nvarchar),'') <> ''
                    or isnull(cast(hc.zav_emergencycontactname2 as nvarchar),'') <> ''
                        then 1
                        else 0
                    end as occupant_emergency_contact_flag,

                    case when hc.zav_winznumber is not null then
                        case when hc.zav_winznumber LIKE '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9]'
                            then 1
                            else 0
                        end
                    else 0
                    end as occupant_social_works_number_flag,

                    -- occupant_recordbaseid is left blank
                    --NULL as occupant_recordbaseid,

                    NULL as occupant_statecode,
                    NULL as occupant_statuscode,
                    CAST(hc.zav_ethnicityname AS VARCHAR(100)) as occupant_ethnicity_name,
                    h.new_ismainapplicant as occupant_is_main_applicant_flag


                FROM [Zavanti].[vw_zav_house] AS h
                -- Identity lookup to [vw_contact] for the main applicant's ethnicity and flags
                LEFT JOIN [Zavanti].[vw_contact] AS hc
                    ON  hc.[Id] = h.zav_fullname
                    AND h.new_ismainapplicant = 'True'
                    AND hc.statecode = 0
                    AND ISNULL(hc.IsDelete,'False') <> 'True'
                WHERE h.zav_householdid IS NOT NULL

        ),
        -------------------------------------------------------------------------------
        -- 2) Build "latest household revision" from [vw_zav_household], 
        --    expanding to 1..zav_numberofhouseholdmembers
        -------------------------------------------------------------------------------
        hh_latest
        AS
        (SELECT
                property_tenant_household_id,
                property_tenancy_id,
                zav_numberofhouseholdmembers,
                zav_namedhhmembers,
                zav_name,
                statecode,
                statuscode,
                hhmemberdummynumber,
                zav_rentsharetotal,
                zav_tenancyname,
                zav_rentsharetotal_base,
                zav_totalincomeofthehousehold,
                zav_householdstatus,
                zav_dateofamendment,
                zav_hhid,
                createdon,
                modifiedon,
                [IsDelete]
            FROM
                    ( SELECT
                    ROW_NUMBER() OVER (
                       PARTITION BY zav_tenancy
                       ORDER BY [IsDelete], createdon DESC, modifiedon DESC
                     ) AS latest_identifier,
                    [Id] AS property_tenant_household_id,
                    zav_tenancy AS property_tenancy_id,
                    zav_numberofhouseholdmembers,
                    zav_namedhhmembers,
                    zav_name,
                    statecode,
                    statuscode,
                    zav_tenancyname,
                    zav_rentsharetotal,
                    zav_rentsharetotal_base,
                    zav_totalincomeofthehousehold,
                    zav_householdstatus,
                    zav_dateofamendment,
                    zav_hhid,
                    createdon,
                    modifiedon,
                    [IsDelete]
                FROM [Zavanti].[vw_zav_household]
                WHERE zav_tenancy IS NOT NULL) AS hh1
                LEFT JOIN
                (-- Instead of STRING_SPLIT, produce rows 1..15 manually
                  SELECT rn AS hhmemberdummynumber
                            FROM (VALUES(1),
                        (2),
                        (3),
                        (4),
                        (5),
                        (6),
                        (7),
                        (8),
                        (9),
                        (10),
                        (11),
                        (12),
                        (13),
                        (14),
                        (15)) AS t(rn)
                        ) AS numtable
                                    ON hh1.zav_numberofhouseholdmembers >= numtable.hhmemberdummynumber
               WHERE hh1.latest_identifier = 1
         ),
        -------------------------------------------------------------------------------
        -- 3) Match occupant rows to "household occupant slot"
        -------------------------------------------------------------------------------
        occupant_join
        AS
        (
            SELECT
                hh_latest.property_tenant_household_id,
                hh_latest.property_tenancy_id,
                hh_latest.hhmemberdummynumber,
                --occupant_union.*,
                
                occupant_union.occupant_source,
                occupant_union.occupant_id ,
                occupant_union.occupant_household_id,
                occupant_union.occupant_createdon,
                occupant_union.occupant_modifiedon,
                occupant_union.occupant_position_num,
                occupant_union.occupant_firstname ,
                occupant_union.occupant_lastname,
                occupant_union.occupant_fullname,
                occupant_union.occupant_aka,
                occupant_union.occupant_gendercode,
                occupant_union.occupant_dob,
                occupant_union.occupant_registrationdate,
                occupant_union.occupant_head_of_household,
                occupant_union.occupant_chintaroid ,
                occupant_union.occupant_clientid ,
                occupant_union.occupant_disability,
                occupant_union.occupant_targetgroup,
                occupant_union.occupant_employment,
                occupant_union.occupant_contacttype,
                --occupant_union.occupant_eatargetgroup2,
                occupant_union.occupant_cra,
                occupant_union.occupant_band,
                occupant_union.occupant_agentfor,
                occupant_union.occupant_signlegaldoc,
                occupant_union.occupant_statecode,
                occupant_union.occupant_statuscode ,
                occupant_union.occupant_ethnicity_name,
                occupant_union.occupant_is_main_applicant_flag,
                occupant_union.occupant_emergency_contact_flag,
                occupant_union.occupant_iwi_affiliation_flag,
                occupant_union.occupant_social_works_number_flag,


                hh_latest.createdon        AS hh_createdon,
                hh_latest.modifiedon       AS hh_modifiedon,
                hh_latest.[IsDelete]       AS hh_isdelete,
                hh_latest.statecode        AS hh_statecode,
                hh_latest.statuscode       AS hh_statuscode,

                hh_latest.zav_numberofhouseholdmembers,
                hh_latest.zav_namedhhmembers,
                hh_latest.zav_name,
                hh_latest.zav_tenancyname,
                hh_latest.zav_hhid,
                hh_latest.zav_rentsharetotal,
                hh_latest.zav_totalincomeofthehousehold,
                hh_latest.zav_householdstatus,
                hh_latest.zav_dateofamendment


            FROM hh_latest
                LEFT JOIN occupant_union
                ON occupant_union.occupant_household_id = hh_latest.property_tenant_household_id
                    AND occupant_union.occupant_position_num = hh_latest.hhmemberdummynumber
        )
    -------------------------------------------------------------------------------
    -- 4) Finally, join occupant_join to the Opportunity (tenancy) 
    --    plus your metadata lookups
    -------------------------------------------------------------------------------
    SELECT
        ----------------------------------------------------------------------------
        -- Keys and occupant IDs
        ----------------------------------------------------------------------------
        opp.id AS property_tenancy_id,
        CASE WHEN occupant_join.occupant_id IS NOT NULL
        THEN CAST(occupant_join.occupant_id AS VARCHAR(50))
        ELSE 'dummy' + CAST(occupant_join.hhmemberdummynumber AS VARCHAR(2))
        END AS property_tenant_id,

        ----------------------------------------------------------------------------
        -- Columns from [Zavanti].[vw_opportunity] (the Tenancy)
        ----------------------------------------------------------------------------
        opp.zav_property  AS property_id,
        opp.zav_program   AS property_program_id,
        opp.zav_subprogram AS property_subprogram_id,
        opp.zav_totalrentamount  AS property_tenancy_total_rent_amount,

        -- Example date ID columns
        CAST(FORMAT(CONVERT(date, opp.zav_leaseagreementdate), 'yyyyMMdd') AS int)
     AS property_tenant_tenancy_lease_agreement_date_id,
        CAST(FORMAT(CONVERT(date, opp.zav_tenancystartdate), 'yyyyMMdd') AS int)
     AS property_tenant_tenancy_start_date_id,

        ----------------------------------------------------------------------------
        -- Occupant fields
        ----------------------------------------------------------------------------
        occupant_join.occupant_firstname  AS property_tenant_first_name,
        occupant_join.occupant_lastname   AS property_tenant_last_name,
        occupant_join.occupant_fullname   AS property_tenant_full_name,
        occupant_join.occupant_dob        AS property_tenancy_tenant_date_of_birth,
        occupant_join.occupant_registrationdate AS property_tenant_registration_date,
        occupant_join.occupant_clientid   AS property_tenant_client_identifier,

       --CAST(CAST(occupant_join.occupant_primarytenant as bit) as int)
       --AS property_tenant_primary_tenant_flag,

       CAST(CAST(occupant_join.occupant_head_of_household as bit) as int)
       AS property_tenant_head_of_household_flag,


        -- occupant source: 'CONTACT' or 'HOUSE'
        occupant_join.occupant_source       AS occupant_record_source,

        occupant_join.occupant_statecode    AS occupant_statecode,
        occupant_join.occupant_statuscode   AS occupant_statuscode,

        ----------------------------------------------------------------------------
        -- Household-level fields from [vw_zav_household]
        ----------------------------------------------------------------------------
        occupant_join.zav_tenancyname AS property_tenant_tenancy_name,
        occupant_join.zav_name        AS property_tenant_household_name,
        occupant_join.zav_hhid        AS property_tenancy_household_identifier,
        occupant_join.zav_numberofhouseholdmembers AS property_tenant_number_of_household_members,
        occupant_join.zav_namedhhmembers          AS property_tenant_named_household_members,
        occupant_join.zav_rentsharetotal          AS property_tenant_rent_share_total,
        occupant_join.zav_totalincomeofthehousehold AS property_tenant_total_household_income,
        occupant_join.occupant_ethnicity_name as property_tenant_ethnicity_name,

        occupant_join.zav_householdstatus as property_tenant_household_zavanti_status,
        --household_status_md.LocalizedLabel as property_tenant_household_zavanti_status,
        CAST(occupant_join.zav_dateofamendment as date) as property_tenant_household_amendment_date,

        case when occupant_join.occupant_is_main_applicant_flag = 'True' then 1
        when occupant_join.occupant_is_main_applicant_flag = 'False' then 0
        else 0 end as occupant_is_main_applicant_flag,

        GREATEST(occupant_join.hh_createdon, occupant_join.occupant_createdon)
       AS property_tenant_created_datetime,
        GREATEST(occupant_join.hh_modifiedon, occupant_join.occupant_modifiedon)
       AS property_tenant_modified_datetime,

         ----------------------------------------------------------------------------
        -- METADATA LOOKUPS (GlobalOptionsetMetadata) for occupant & opportunity
        ----------------------------------------------------------------------------

        --occupant gender
        gender_md.LocalizedLabel            AS occupant_gender_label,

        -- occupant disability
        occupant_disability_md.LocalizedLabel AS occupant_disability_label,

        -- occupant targetgroup
        occupant_targetgroup_md.LocalizedLabel AS occupant_targetgroup_label,

        -- occupant employment
        occupant_employment_md.LocalizedLabel  AS occupant_employment_label,

        -- occupant contacttype
        occupant_contacttype_md.LocalizedLabel AS occupant_contacttype_label,

        -- occupant eatargetgroup (label only, not code)
        null AS occupant_eatargetgroup_label,

        -- occupant state & status
        state_cont.LocalizedLabel AS occupant_state_label,
        status_cont.LocalizedLabel AS occupant_status_label,

        -- household state & status
        state_hh.LocalizedLabel   AS household_state_label,
        status_hh.LocalizedLabel  AS household_status_label,

          -- opportunity state & status
        state_opp.LocalizedLabel  AS property_tenant_opportunity_state,
        status_opp.LocalizedLabel AS property_tenant_opportunity_status,

        occupant_join.occupant_emergency_contact_flag,
        occupant_join.occupant_iwi_affiliation_flag,
        occupant_join.occupant_social_works_number_flag,

        CAST(CAST(COALESCE(opp.IsDelete, occupant_join.hh_isdelete) as bit) as int)
       AS property_tenant_is_delete_flag

    FROM [Zavanti].[vw_opportunity] AS opp
        LEFT JOIN occupant_join
        ON occupant_join.property_tenancy_id = opp.Id

        -------------------------------------------------------------------------------
        -- occupant gender
        -------------------------------------------------------------------------------
        LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS gender_md
        ON gender_md.EntityName    = 'contact'
            AND gender_md.OptionSetName= 'zav_gender'
            AND gender_md.[Option]     = occupant_join.occupant_gendercode

        -------------------------------------------------------------------------------
        -- occupant disability
        -------------------------------------------------------------------------------
        LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS occupant_disability_md
        ON occupant_disability_md.EntityName    = 'contact'
            AND occupant_disability_md.OptionSetName= 'zav_disability'
            AND occupant_disability_md.[Option]     = occupant_join.occupant_disability

        -------------------------------------------------------------------------------
        -- occupant targetgroup
        -------------------------------------------------------------------------------
        LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS occupant_targetgroup_md
        ON occupant_targetgroup_md.EntityName    = 'contact'
            AND occupant_targetgroup_md.OptionSetName= 'zav_targetgroup'
            AND occupant_targetgroup_md.[Option]     = occupant_join.occupant_targetgroup

        -------------------------------------------------------------------------------
        -- occupant employment
        -------------------------------------------------------------------------------
        LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS occupant_employment_md
        ON occupant_employment_md.EntityName    = 'contact'
            AND occupant_employment_md.OptionSetName= 'zav_employment'
            AND occupant_employment_md.[Option]     = occupant_join.occupant_employment

        -------------------------------------------------------------------------------
        -- occupant contacttype
        -------------------------------------------------------------------------------
        LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS occupant_contacttype_md
        ON occupant_contacttype_md.EntityName    = 'contact'
            AND occupant_contacttype_md.OptionSetName= 'zav_contacttype'
            AND occupant_contacttype_md.[Option]     = occupant_join.occupant_contacttype


        --LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS household_status_md
        --ON household_status_md.EntityName    = 'zav_household'
        --    AND household_status_md.OptionSetName= 'zav_householdstatus'
        --    AND household_status_md.[Option]     = occupant_join.zav_householdstatus

        -------------------------------------------------------------------------------
        -- occupant cra
        -------------------------------------------------------------------------------
        --LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS occupant_cra_md
        --   ON occupant_cra_md.EntityName    = 'contact'
        --   AND occupant_cra_md.OptionSetName= 'zav_cra'
        --   AND occupant_cra_md.[Option]     = occupant_join.occupant_cra

        -------------------------------------------------------------------------------
        -- occupant band
        -------------------------------------------------------------------------------
        --LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS occupant_band_md
        --   ON occupant_band_md.EntityName    = 'contact'
        --   AND occupant_band_md.OptionSetName= 'zav_band'
        --   AND occupant_band_md.[Option]     = occupant_join.occupant_band

        -------------------------------------------------------------------------------
        -- occupant agentfor
        -------------------------------------------------------------------------------
        --LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS occupant_agentfor_md
        --   ON occupant_agentfor_md.EntityName    = 'contact'
        --   AND occupant_agentfor_md.OptionSetName= 'zav_agentfor'
        --   AND occupant_agentfor_md.[Option]     = occupant_join.occupant_agentfor

        -------------------------------------------------------------------------------
        -- occupant e a targetgroup
        -------------------------------------------------------------------------------
        --LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS occupant_eatargetgroup_md
        --ON occupant_eatargetgroup_md.EntityName    = 'contact'
        --    AND occupant_eatargetgroup_md.OptionSetName= 'zav_eatargetgroup'
        --    AND occupant_eatargetgroup_md.[Option]     = occupant_join.occupant_eatargetgroup2

        -------------------------------------------------------------------------------
        -- occupant state / occupant status lookups
        -------------------------------------------------------------------------------
        LEFT JOIN [Zavanti].[vw_StateMetadata] AS state_cont
        ON state_cont.EntityName = 'contact'
            AND state_cont.State     = occupant_join.occupant_statecode

        LEFT JOIN [Zavanti].[vw_StatusMetadata] AS status_cont
        ON status_cont.EntityName = 'contact'
            AND status_cont.State     = occupant_join.occupant_statecode
            AND status_cont.Status    = occupant_join.occupant_statuscode

        -------------------------------------------------------------------------------
        -- Household state & status
        -------------------------------------------------------------------------------
        LEFT JOIN [Zavanti].[vw_StateMetadata] AS state_hh
        ON state_hh.EntityName = 'zav_household'
            AND state_hh.State     = occupant_join.hh_statecode

        LEFT JOIN [Zavanti].[vw_StatusMetadata] AS status_hh
        ON status_hh.EntityName = 'zav_household'
            AND status_hh.State     = occupant_join.hh_statecode
            AND status_hh.Status    = occupant_join.hh_statuscode

        -------------------------------------------------------------------------------
        -- Opportunity state & status
        -------------------------------------------------------------------------------
        LEFT JOIN [Zavanti].[vw_StateMetadata] AS state_opp
        ON state_opp.EntityName = 'opportunity'
            AND state_opp.State     = opp.statecode

        LEFT JOIN [Zavanti].[vw_StatusMetadata] AS status_opp
        ON status_opp.EntityName = 'opportunity'
            AND status_opp.State     = opp.statecode
            AND status_opp.Status    = opp.statuscode