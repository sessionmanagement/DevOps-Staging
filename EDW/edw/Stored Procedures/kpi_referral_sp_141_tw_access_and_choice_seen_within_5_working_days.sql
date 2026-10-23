    CREATE   procedure [edw].[kpi_referral_sp_141_tw_access_and_choice_seen_within_5_working_days]
    AS
/**********************************************************************************************************
 Procedure: [edw].[kpi_referral_sp_141_tw_access_and_choice_seen_within_5_working_days]
 Author (Developer): Manish Singh
 Author (Analyst): Timi Boddington / Thijs Bohm / Greg Nuthall
 Created: 2025-05-23		
 Purpose: Calculate assessments completed in 28 days of acceptance
 User Story: 9838

 Notes: Converted from view [edw].[kpi_referral_141_tw_access_and_choice_seen_within_5_working_days] 
        to stored procedure with temp tables and indexing
 *************************************************************************************************************
 
 REVISIONS:
 Version   Date         Author              Description
-------   ------------ ------------------- --------------------------
 1.0       2025-05-23   Manish Singh        This view is created to calculate '[edw].[kpi_service_140_KPI_support_hours_as_per_contract]
 1.1       2025-06-16   Timi Boddington     Tidy up script, add dwhdmloperation <> 'd' when joining on service_id
 1.2       2025-06-18   Timi Boddington     Changed the join from dim_client_team from client_team_id to dim_client_team_key. Also duplicates in service_type_grouping, made distinct, which I think it was
 1.3       2025-07-10   Timi Boddington     Thijs added (or null), I have taken this out but changed to (isnull()). I have added some more activity exclusions. This is outdated. 
                                            Jacky has thrown this back to the business
 1.4       2025-07-16   Timi Boddington     Feedback from Elizabeth Tingle. Missing Awhi Ora for MnB. Updated to include Awhi Ora Auckland Central and Waitemata
 1.5       2025-07-30   Thijs Bohm          Change user friendly explanation wording to 7 days instead of 5 days
 1.6       2025-08-05   Thijs Bohm          Changed filter logic splitting out Youth and Adult services
 1.7       2025-08-19   Thijs Bohm          Update duration filter from >10 to >=10
 1.8       2025-09-22   Timi Boddington     Changed the days_to_first_activity is not null to include 'and days_to_first_activity <= 7 then -1.
 2.0       2025-01-15   Greg Nuthall        Converted view to stored procedure with temp tables and indexing,
                                            added kpi_id and snapshot_date columns
 1.9       2025-09-22   Timi Boddington     Changed the days_to_first_activity is not null then -1 
                                            Put back the logic to remove referrals > 28 days
                                            Added in number of days to activity for Tangata Whaiora seen after x days
                                            Note: also confirmed that it's from received date, not accepted date with Elizabeth Tingle and Evie Andres
 2.1       2026-05-01   Thijs Bohm          Add Awhi Ora WDHB to the filter condition
 2.2       2026-08-03   Timi Boddington     As per Pae Awhina 123734.  Take out the status = 'Accepted'.  Add in Ease Up One-off
                                            Change description to reflect the status of the referral.

 *************************************************************************************************************/

BEGIN
SET NOCOUNT ON;

    DECLARE @SnapshotDate DATE = CAST(GETDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time' AS DATE);
    DECLARE @NZDateTime DATETIME = CONVERT(DATETIME, SWITCHOFFSET(GETDATE(), DATEPART(TZOFFSET, GETDATE() AT TIME ZONE 'New Zealand Standard Time')));
    DECLARE @KPI_ID INT = 141;

    -------------------------------------------------------------------------------
    -- Temp Table 1: referral_base_Adult (Adult services only)
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#referral_base_Adult') IS NOT NULL DROP TABLE #referral_base_Adult;
    
    SELECT 
        dim_date.calendar_date AS received_date,
        DATEDIFF(DAY, dim_date.calendar_date, @NZDateTime) AS days_in_service,
        vw_fact_client_referral.client_referral_received_date_key,
        '' AS kpi_snapshot_client_id,
        vw_fact_client_referral.client_id,
        vw_fact_client_referral.dim_company_key,
        vw_fact_client_referral.dim_client_referral_key,
        dim_client_team.client_team_name,
        vw_fact_client_referral.dim_client_key,
        vw_fact_client_referral.dim_service_key,
        vw_fact_client_referral.client_referral_id,
        CONCAT(999, '_', vw_fact_client_referral.client_referral_id, '_', vw_fact_client_referral.client_id, '_', dco.company_id) AS entity_key,
        dim_client_referral.client_referral_status,
        dim_client_referral.client_referral_type
    INTO #referral_base_Adult
    FROM edw.vw_fact_client_referral
    LEFT JOIN edw.dim_client_referral 
        ON vw_fact_client_referral.dim_client_referral_key = dim_client_referral.dim_client_referral_key
    INNER JOIN edw.dim_date 
        ON vw_fact_client_referral.client_referral_received_date_key = dim_date.dim_date_key
    INNER JOIN edw.dim_client_team 
        ON vw_fact_client_referral.dim_client_team_key = dim_client_team.dim_client_team_key
    LEFT JOIN edw.vw_dim_company dco 
        ON vw_fact_client_referral.dim_company_key = dco.dim_company_key
    WHERE vw_fact_client_referral.DWHDMLOperation <> 'd'
        AND dim_client_referral.client_referral_type = 'inboundreferral'
        AND client_referral_decline_date_key IS NULL
        AND client_referral_discharge_date_key IS NULL
        AND dim_client_referral.client_status_is_active = 'active'
        
        -- Removed this 3/8/2026 Timi 

        /*AND client_referral_status = 'Accepted' 
        AND (client_team_name IN (  
            'Access and Choice – HBDHB',
            'Access and Choice – CCDHB',
            'Mahea', 
            'Awhi Ora - ADHB',
            'Awhi Ora - CMDHB',
            'Te Tumu Waiora',
            'Awhi Ora - Auckland Central',
             'Awhi Ora - WDHB'
        )
        OR client_team_name LIKE '%EaseUp%' 
        AND client_team_name NOT LIKE '%one%off%'
        OR client_team_name LIKE 'awhi ora%waitemat%')
        AND client_team_function NOT LIKE '%Youth%'
        */

        and vw_fact_client_referral.client_team_id in (
         14     --Awhi Ora - Auckland Central
        ,19     --Awhi Ora - Waitematā
        ,29     --Te Tumu Waiora
        ,625    --EaseUp - ADHB
        ,663    --Access and Choice – CCDHB
        ,668    --Awhi Ora - CMDHB
        ,673    --Awhi Ora - ADHB
        ,674    --Awhi Ora - WDHB
        ,680    --Te Tumu Waiora - Health Coach
        ,682    --Access and Choice – HBDHB
        ,683    --EaseUp - ADHB - One Off Support
        ,685    --EaseUp - West
        ,686    --EaseUp - West - One Off Support
        ,708    --EaseUp - Waikato
        ,709    --EaseUp - Waikato - One Off Support
        ,715    --Mahea
        ,748    --EaseUp - North
        ,749    --EaseUp - North - One Off Support
        );

    CREATE CLUSTERED INDEX IX_referral_base_Adult ON #referral_base_Adult(client_referral_id, dim_company_key);

    -------------------------------------------------------------------------------
    -- Temp Table 2: Activities_adult
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#Activities_adult') IS NOT NULL DROP TABLE #Activities_adult;
    
    SELECT DISTINCT 
        CASE 
            WHEN dim_client_team.company_id = 5 THEN 'Mind and Body'
            ELSE 'EmergeAotearoa LTD'
        END AS Company,
        dim_client_team.company_id AS dim_company_key,
        dim_client_team.client_team_id,
        dim_client_team.client_team_name,
        '' AS TeamArea,
        dim_client_team.client_team_function,
        dim_employee.employee_first_name,
        dim_employee.employee_last_name,
        1 AS rows,
        client_activity_id,
        client_id AS personid,
        client_referral_id AS clientreferralid,
        dim_client_referral_key,
        CAST(client_activity_start_date AS DATE) AS client_activity_date,
        FORMAT(client_activity_start_date, 'yyyy-MM') AS calendar_year_month,
        DATEDIFF(DAY, CAST(client_activity_start_date AS DATE), @NZDateTime) AS days_activity_to_today,
        client_activity_start_date,
        client_activity_end_date,
        client_activity_duration,
        client_activity_whanau_involvement,
        client_parent_activity_id,
        client_activity_subject,
        client_activity_type_name,
        client_activity_classification_name,
        client_activity_breakdown_type_name,
        client_parent_activity_breakdown_type_name
    INTO #Activities_adult
    FROM edw.fact_client_activity_breakdown
    LEFT JOIN edw.dim_client_activity_breakdown_type 
        ON fact_client_activity_breakdown.dim_client_activity_breakdown_type_key = dim_client_activity_breakdown_type.dim_client_activity_breakdown_type_key
    INNER JOIN edw.dim_employee 
        ON fact_client_activity_breakdown.dim_employee_key = dim_employee.dim_employee_key
    INNER JOIN edw.dim_client_team 
        ON fact_client_activity_breakdown.dim_client_team_key = dim_client_team.dim_client_team_key
    WHERE client_team_name IS NOT NULL
        AND client_parent_activity_id IS NULL
        AND fact_client_activity_breakdown.DWHDMLOperation <> 'd'
        AND dim_client_activity_breakdown_type.DWHDMLOperation <> 'd'
        AND dim_employee.DWHDMLOperation <> 'd'
        AND edw.dim_client_team.DWHDMLOperation <> 'd'
        AND client_activity_duration >= 10
        AND client_activity_type_name NOT IN (
            'Non-psychiatric', 'Inpatient (psychiatric ward)', 'Education/Training', 'Mapusaga', 'Jansen House',
            'OM Other Social Media', 'Police', 'GP/Medical centre', 'Email or Letter sent', 'MH Inpatient',
            'WINZ', 'Written correspondence', 'Letter', 'MC Maori cultural setting', 'Peer''s Home',
            'GP''s office', 'Hospital Ward', 'Court', 'Court & MH Act Hearings', 'Inpatient',
            'Prison or police cells', 'Police Station', 'Mind & Body office', 'Hospital (excl. A&E, psych ward)',
            'Youth Justice', 'Hospital A&E', 'Email', 'Maori cultural setting', 'GP/School Nurse',
            'PR Prison or Police cells', 'Day Programme', 'Email/Letter/Fax', 'Other', 'Day consumer setting',
            'Emergency Department', 'Emergency Dept', 'Inpatient/emergency department', 'Nga Taumahatanga',
            'Residential AOD Service', 'Court and MH Act Hearings'
        )
        AND ISNULL(client_activity_classification_name, '') NOT IN (
            'Attempted Contact', 'Cancelled', 'Cancelled - rebooked', 'Client cancelled', 'Client cancelled on day',
            'Client DNA', 'Did Not Attend', 'F2F contact-unsuccessful', 'Liaison with Professional',
            'Phone call- unsuccessful', 'Phone call- unsuccessful, left msg', 'Same Day Cancellation',
            'Scheduling', 'T35 Client did not attend, no notice given', 'T35 Did not attend',
            'T08 Care co-ordin with external agency', 'Group', 'Contact with External Agencies',
            'Contact with family/whanau, peer absent', 'EaseUp Group', 'External Agency contact',
            'Family Contact without client', 'Group Programme/Workshop', 'Shift Note'
        )
        AND ISNULL(client_parent_activity_breakdown_type_name, '') NOT LIKE 'non contact%'
        AND ISNULL(client_activity_breakdown_type_name, '') NOT IN (
            'Client cancelled', 'Contact with external agency', 'Contact with landlord', 'Contact with OT',
            'Contact with other agency', 'Contact with other agency, client not present', 'Contact with other Health Prof',
            'Contact with other health professional', 'Contact with other health professional.', 'Contact with external agencies',
            'Contact with family member(s)', 'Contact with landlord/motelier', 'Contact with other NGO',
            'Contact with WINZ', 'Face to face group (only use for Group Activities)', 'Face to face group',
            'Other Health Professional contact'
        );

    CREATE CLUSTERED INDEX IX_Activities_adult ON #Activities_adult(Company, clientreferralid, client_activity_start_date);

    -------------------------------------------------------------------------------
    -- Temp Table 3: Activites_Staged_Adult
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#Activites_Staged_Adult') IS NOT NULL DROP TABLE #Activites_Staged_Adult;
    
    SELECT 
        ROW_NUMBER() OVER (
            PARTITION BY Company, clientreferralid 
            ORDER BY Company, clientreferralid, client_activity_start_date
        ) AS Activity_order,
        Company,
        dim_company_key,
        client_team_id,
        client_team_name,
        TeamArea,
        client_team_function,
        employee_first_name,
        employee_last_name,
        rows,
        client_activity_id,
        personid,
        clientreferralid,
        dim_client_referral_key,
        client_activity_date,
        calendar_year_month,
        days_activity_to_today,
        client_activity_start_date,
        client_activity_end_date,
        client_activity_duration,
        client_activity_whanau_involvement,
        client_parent_activity_id,
        client_activity_subject,
        client_activity_type_name,
        client_activity_classification_name,
        client_activity_breakdown_type_name,
        client_parent_activity_breakdown_type_name
    INTO #Activites_Staged_Adult
    FROM #Activities_adult;

    CREATE CLUSTERED INDEX IX_Activites_Staged_Adult ON #Activites_Staged_Adult(clientreferralid, dim_company_key, Activity_order);

    -------------------------------------------------------------------------------
    -- Temp Table 4: Referrals_Stage_2_Adult
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#Referrals_Stage_2_Adult') IS NOT NULL DROP TABLE #Referrals_Stage_2_Adult;
    
    SELECT 
        rba.received_date,
        rba.days_in_service,
        rba.client_referral_received_date_key,
        rba.kpi_snapshot_client_id,
    --    rba.client_team_name,
        rba.client_id,
        rba.dim_company_key,
        rba.dim_client_referral_key,
        rba.dim_client_key,
        rba.dim_service_key,
        rba.client_referral_id,
        rba.entity_key,
        rba.client_referral_status,
        rba.client_referral_type,
        ma.client_activity_start_date,
        DATEDIFF(DAY, rba.received_date, ma.client_activity_start_date) AS days_to_first_activity
    INTO #Referrals_Stage_2_Adult
    FROM #referral_base_Adult rba
    LEFT JOIN (
        SELECT 
            dim_company_key,
            clientreferralid,
            CAST(client_activity_start_date AS DATE) AS client_activity_start_date
        FROM #Activites_Staged_Adult
        WHERE Activity_order = 1
    ) AS ma 
        ON rba.client_referral_id = ma.clientreferralid
        AND rba.dim_company_key = ma.dim_company_key;

    CREATE CLUSTERED INDEX IX_Referrals_Stage_2_Adult ON #Referrals_Stage_2_Adult(client_referral_id);

    -------------------------------------------------------------------------------
    -- Temp Table 5: referral_base (Youth services only)
    -------------------------------------------------------------------------------

    --I don't understand what this was supposed to do, it's now duplicated above so am getting rid of it as its duplicate code
    --IF OBJECT_ID('tempdb..#referral_base') IS NOT NULL DROP TABLE #referral_base;
    
    --SELECT 
    --    dim_date.calendar_date AS received_date,
    --    DATEDIFF(DAY, dim_date.calendar_date, @NZDateTime) AS days_in_service,
    --    vw_fact_client_referral.client_referral_received_date_key,
    --    '' AS kpi_snapshot_client_id,
    --    vw_fact_client_referral.client_id,
    --    vw_fact_client_referral.dim_company_key,
    --    vw_fact_client_referral.dim_client_referral_key,
    --    vw_fact_client_referral.dim_client_key,
    --    vw_fact_client_referral.dim_service_key,
    --    vw_fact_client_referral.client_referral_id,
    --    CONCAT(999, '_', vw_fact_client_referral.client_referral_id, '_', vw_fact_client_referral.client_id, '_', dco.company_id) AS entity_key,
    --    dim_client_referral.client_referral_status,
    --    dim_client_referral.client_referral_type
    --INTO #referral_base
    --FROM edw.vw_fact_client_referral
    --LEFT JOIN edw.dim_client_referral 
    --    ON vw_fact_client_referral.dim_client_referral_key = dim_client_referral.dim_client_referral_key
    --INNER JOIN edw.dim_date 
    --    ON vw_fact_client_referral.client_referral_received_date_key = dim_date.dim_date_key
    --INNER JOIN edw.dim_client_team 
    --    ON vw_fact_client_referral.dim_client_team_key = dim_client_team.dim_client_team_key
    --LEFT JOIN edw.vw_dim_company dco 
    --    ON vw_fact_client_referral.dim_company_key = dco.dim_company_key
    --WHERE vw_fact_client_referral.DWHDMLOperation <> 'd'
    --    AND dim_client_referral.client_referral_type = 'inboundreferral'
    --    AND client_referral_decline_date_key IS NULL
    --    AND client_referral_discharge_date_key IS NULL
    --    AND dim_client_referral.client_status_is_active = 'active'
    --   /* 
    --   Changed Timi 3-8-2026
    --   AND client_referral_status = 'Accepted'
    --    AND (client_team_name IN (  
    --        'Access and Choice – HBDHB',
    --        'Access and Choice – CCDHB',
    --        'Mahea', 
    --        'Awhi Ora - ADHB',
    --        'Awhi Ora - CMDHB',
    --        'Te Tumu Waiora',
    --        'Awhi Ora - Auckland Central',
    --         'Awhi Ora - WDHB'
    --    )
    --    OR client_team_name LIKE '%EaseUp%' 
    --    AND client_team_name NOT LIKE '%one%off%'
    --    OR client_team_name LIKE 'awhi ora%waitemat%')
    --    AND client_team_function LIKE '%Youth%'
    --    */
        
    --    and vw_fact_client_referral.client_team_id in (
    --     14     --Awhi Ora - Auckland Central
    --    ,19     --Awhi Ora - Waitematā
    --    ,29     --Te Tumu Waiora
    --    ,625    --EaseUp - ADHB
    --    ,663    --Access and Choice – CCDHB
    --    ,668    --Awhi Ora - CMDHB
    --    ,673    --Awhi Ora - ADHB
    --    ,674    --Awhi Ora - WDHB
    --    ,680    --Te Tumu Waiora - Health Coach
    --    ,682    --Access and Choice – HBDHB
    --    ,683    --EaseUp - ADHB - One Off Support
    --    ,685    --EaseUp - West
    --    ,686    --EaseUp - West - One Off Support
    --    ,708    --EaseUp - Waikato
    --    ,709    --EaseUp - Waikato - One Off Support
    --    ,715    --Mahea
    --    ,748    --EaseUp - North
    --    ,749    --EaseUp - North - One Off Support
    --    )

        
    --    ;

    --CREATE CLUSTERED INDEX IX_referral_base ON #referral_base(client_referral_id, dim_company_key);

    ---------------------------------------------------------------------------------
    ---- Temp Table 6: Activities (Youth services)
    ---------------------------------------------------------------------------------
    --IF OBJECT_ID('tempdb..#Activities') IS NOT NULL DROP TABLE #Activities;
    
    --SELECT DISTINCT 
    --    CASE 
    --        WHEN dim_client_team.company_id = 5 THEN 'Mind and Body'
    --        ELSE 'EmergeAotearoa LTD'
    --    END AS Company,
    --    dim_client_team.company_id AS dim_company_key,
    --    dim_client_team.client_team_id,
    --    dim_client_team.client_team_name,
    --    '' AS TeamArea,
    --    dim_client_team.client_team_function,
    --    dim_employee.employee_first_name,
    --    dim_employee.employee_last_name,
    --    1 AS rows,
    --    client_activity_id,
    --    client_id AS personid,
    --    client_referral_id AS clientreferralid,
    --    dim_client_referral_key,
    --    CAST(client_activity_start_date AS DATE) AS client_activity_date,
    --    FORMAT(client_activity_start_date, 'yyyy-MM') AS calendar_year_month,
    --    DATEDIFF(DAY, CAST(client_activity_start_date AS DATE), @NZDateTime) AS days_activity_to_today,
    --    client_activity_start_date,
    --    client_activity_end_date,
    --    client_activity_duration,
    --    client_activity_whanau_involvement,
    --    client_parent_activity_id,
    --    client_activity_subject,
    --    client_activity_type_name,
    --    client_activity_classification_name,
    --    client_activity_breakdown_type_name,
    --    client_parent_activity_breakdown_type_name
    --INTO #Activities
    --FROM edw.fact_client_activity_breakdown
    --LEFT JOIN edw.dim_client_activity_breakdown_type 
    --    ON fact_client_activity_breakdown.dim_client_activity_breakdown_type_key = dim_client_activity_breakdown_type.dim_client_activity_breakdown_type_key
    --INNER JOIN edw.dim_employee 
    --    ON fact_client_activity_breakdown.dim_employee_key = dim_employee.dim_employee_key
    --INNER JOIN edw.dim_client_team 
    --    ON fact_client_activity_breakdown.dim_client_team_key = dim_client_team.dim_client_team_key
    --WHERE client_team_name IS NOT NULL
    --    AND client_parent_activity_id IS NULL
    --    AND fact_client_activity_breakdown.DWHDMLOperation <> 'd'
    --    AND dim_client_activity_breakdown_type.DWHDMLOperation <> 'd'
    --    AND dim_employee.DWHDMLOperation <> 'd'
    --    AND edw.dim_client_team.DWHDMLOperation <> 'd'
    --    AND client_activity_duration >= 10
    --    AND client_activity_type_name NOT IN (
    --        'Non-psychiatric', 'Inpatient (psychiatric ward)', 'Education/Training', 'Mapusaga', 'Jansen House',
    --        'OM Other Social Media', 'Police', 'GP/Medical centre', 'Email or Letter sent', 'MH Inpatient',
    --        'WINZ', 'Written correspondence', 'Letter', 'MC Maori cultural setting', 'Peer''s Home',
    --        'GP''s office', 'Hospital Ward', 'Court', 'Court & MH Act Hearings', 'Inpatient',
    --        'Prison or police cells', 'Police Station', 'Mind & Body office', 'Hospital (excl. A&E, psych ward)',
    --        'Youth Justice', 'Hospital A&E', 'Email', 'Maori cultural setting', 'GP/School Nurse',
    --        'PR Prison or Police cells', 'Day Programme', 'Email/Letter/Fax', 'Other', 'Day consumer setting',
    --        'Emergency Department', 'Emergency Dept', 'Inpatient/emergency department', 'Nga Taumahatanga',
    --        'Residential AOD Service', 'Court and MH Act Hearings'
    --    )
    --    AND ISNULL(client_activity_classification_name, '') NOT IN (
    --        'Attempted Contact', 'Cancelled', 'Cancelled - rebooked', 'Client cancelled', 'Client cancelled on day',
    --        'Client DNA', 'Did Not Attend', 'F2F contact-unsuccessful', 'Liaison with Professional',
    --        'Phone call- unsuccessful', 'Phone call- unsuccessful, left msg', 'Same Day Cancellation',
    --        'Scheduling', 'T35 Client did not attend, no notice given', 'T35 Did not attend',
    --        'T08 Care co-ordin with external agency', 'Contact with External Agencies', 'External Agency contact',
    --        'Shift Note'
    --    )
    --    AND ISNULL(client_parent_activity_breakdown_type_name, '') NOT LIKE 'non contact%'
    --    AND ISNULL(client_activity_breakdown_type_name, '') NOT IN (
    --        'Client cancelled', 'Contact with external agency', 'Contact with landlord', 'Contact with OT',
    --        'Contact with other agency', 'Contact with other agency, client not present', 'Contact with other Health Prof',
    --        'Contact with other health professional', 'Contact with other health professional.', 'Contact with external agencies',
    --        'Contact with landlord/motelier', 'Contact with other NGO', 'Contact with WINZ', 'Other Health Professional contact'
    --    );

    --CREATE CLUSTERED INDEX IX_Activities ON #Activities(Company, clientreferralid, client_activity_start_date);

    ---------------------------------------------------------------------------------
    ---- Temp Table 7: Activites_Staged (Youth)
    ---------------------------------------------------------------------------------
    --IF OBJECT_ID('tempdb..#Activites_Staged') IS NOT NULL DROP TABLE #Activites_Staged;
    
    --SELECT 
    --    ROW_NUMBER() OVER (
    --        PARTITION BY Company, clientreferralid 
    --        ORDER BY Company, clientreferralid, client_activity_start_date
    --    ) AS Activity_order,
    --    Company,
    --    dim_company_key,
    --    client_team_id,
    --    client_team_name,
    --    TeamArea,
    --    client_team_function,
    --    employee_first_name,
    --    employee_last_name,
    --    rows,
    --    client_activity_id,
    --    personid,
    --    clientreferralid,
    --    dim_client_referral_key,
    --    client_activity_date,
    --    calendar_year_month,
    --    days_activity_to_today,
    --    client_activity_start_date,
    --    client_activity_end_date,
    --    client_activity_duration,
    --    client_activity_whanau_involvement,
    --    client_parent_activity_id,
    --    client_activity_subject,
    --    client_activity_type_name,
    --    client_activity_classification_name,
    --    client_activity_breakdown_type_name,
    --    client_parent_activity_breakdown_type_name
    --INTO #Activites_Staged
    --FROM #Activities;

    --CREATE CLUSTERED INDEX IX_Activites_Staged ON #Activites_Staged(clientreferralid, dim_company_key, Activity_order);

    ---------------------------------------------------------------------------------
    ---- Temp Table 8: Referrals_Stage_2_youth
    ---------------------------------------------------------------------------------
    --IF OBJECT_ID('tempdb..#Referrals_Stage_2_youth') IS NOT NULL DROP TABLE #Referrals_Stage_2_youth;
    
    --SELECT 
    --    rb.received_date,
    --    rb.days_in_service,
    --    rb.client_referral_received_date_key,
    --    rb.kpi_snapshot_client_id,
    --    rb.client_id,
    --    rb.dim_company_key,
    --    rb.dim_client_referral_key,
    --    rb.dim_client_key,
    --    rb.dim_service_key,
    --    rb.client_referral_id,
    --    rb.entity_key,
    --    rb.client_referral_status,
    --    rb.client_referral_type,
    --    ma.client_activity_start_date,
    --    DATEDIFF(DAY, rb.received_date, ma.client_activity_start_date) AS days_to_first_activity
    --INTO #Referrals_Stage_2_youth
    --FROM #referral_base rb
    --LEFT JOIN (
    --    SELECT 
    --        dim_company_key,
    --        clientreferralid,
    --        CAST(client_activity_start_date AS DATE) AS client_activity_start_date
    --    FROM #Activites_Staged
    --    WHERE Activity_order = 1
    --) AS ma 
    --    ON rb.client_referral_id = ma.clientreferralid
    --    AND rb.dim_company_key = ma.dim_company_key;

    --CREATE CLUSTERED INDEX IX_Referrals_Stage_2_youth ON #Referrals_Stage_2_youth(client_referral_id);

    ---------------------------------------------------------------------------------
    ---- Temp Table 9: Referrals_Union (combine Adult and Youth)
    ---------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#Referrals_Union') IS NOT NULL DROP TABLE #Referrals_Union;
    
    --SELECT * 
   -- INTO #Referrals_Union
   -- FROM #Referrals_stage_2_youth
   -- where days_in_service <=28 -- added 9/3/2026
   -- UNION
    SELECT * 
    INTO #Referrals_Union
    FROM #Referrals_stage_2_Adult
    where days_in_service <=28;  --added 9/3/2026


    CREATE NONCLUSTERED INDEX IX_Referrals_Union_service ON #Referrals_Union(dim_service_key);

    -------------------------------------------------------------------------------
    -- Temp Table 10: service_type_grouping
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#service_type_grouping') IS NOT NULL DROP TABLE #service_type_grouping;
    
    SELECT DISTINCT 
        dim_kpi.kpi_id,
        dim_kpi.dim_kpi_key,
        dim_service.service_id
    INTO #service_type_grouping
    FROM edw.dim_kpi
    LEFT JOIN edw.bridge_kpi_measure_to_service_type_group 
        ON dim_kpi.dim_kpi_key = bridge_kpi_measure_to_service_type_group.dim_kpi_key
    LEFT JOIN edw.dim_kpi_service_type_grouping 
        ON bridge_kpi_measure_to_service_type_group.service_type_grouping_id = dim_kpi_service_type_grouping.dim_kpi_service_type_grouping_key
        AND dim_kpi_service_type_grouping.dwhiscurrent = 1
    LEFT JOIN edw.bridge_kpi_service_type_to_grouping 
        ON bridge_kpi_measure_to_service_type_group.dim_kpi_service_type_grouping_key = bridge_kpi_service_type_to_grouping.dim_kpi_service_type_grouping_key
    LEFT JOIN edw.dim_kpi_service_type 
        ON bridge_kpi_service_type_to_grouping.dim_kpi_service_type_key = dim_kpi_service_type.dim_kpi_service_type_key
    LEFT JOIN edw.dim_service 
        ON dim_kpi_service_type.service_type = dim_service.service_type_name
        AND dim_service.dwhiscurrent = 1
        AND dim_service.dwhdmloperation <> 'D'
    WHERE dim_kpi.dwhiscurrent = 1;

    CREATE NONCLUSTERED INDEX IX_service_type_grouping ON #service_type_grouping(dim_kpi_key, service_id);

    -------------------------------------------------------------------------------
    -- Temp Table 11: ms_count
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#ms_count') IS NOT NULL DROP TABLE #ms_count;
    
    SELECT 
        kpi_id,
        COUNT(service_id) AS service_count
    INTO #ms_count
    FROM #service_type_grouping
    GROUP BY kpi_id;

    -------------------------------------------------------------------------------
    -- Temp Table 12: final_table
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#final_table') IS NOT NULL DROP TABLE #final_table;
    
    SELECT 
        dim_company_key,
        client_activity_start_date,
        received_date,
        client_referral_received_date_key,
        client_referral_id,
        client_id,
        --client_team_name,
        dim_client_referral_key,
        entity_key,
        dim_service_key,
        days_in_service,
        days_to_first_activity,
        CASE 
            WHEN days_to_first_activity IS NOT NULL AND days_to_first_activity <= 7  --removed 9/3/2026 Pae Awhina 12800
            THEN -1
            ELSE days_in_service
        END AS kpi_value,
        --changed tthe wording - Timi PA 12800
        CASE 
            WHEN days_to_first_activity IS NULL and days_in_service = 1
            THEN CONCAT('Tangata Whaiora with a status of ',client_referral_status,' not seen.  Referral received ', days_in_service, ' day ago')
            WHEN days_to_first_activity IS NULL and days_in_service > 1
            THEN CONCAT('Tangata Whaiora with a status of ',client_referral_status,' not seen.  Referral received ', days_in_service, ' days ago')
            WHEN days_to_first_activity <= 7 THEN concat('Tangata Whaiora with a status of ',client_referral_status,' seen within 7 days')
            WHEN days_to_first_activity > 7 THEN concat('Tangata Whaiora with a status of ',client_referral_status,' seen at ',days_to_first_activity,' days')  -- added Pae Awhina 12800
        END AS user_friendly_score_explanation
    INTO #final_table
    FROM #Referrals_Union;

    CREATE NONCLUSTERED INDEX IX_final_table_service ON #final_table(dim_service_key);

    -------------------------------------------------------------------------------
    -- Temp Table 13: Selected_KPI
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#Selected_KPI') IS NOT NULL DROP TABLE #Selected_KPI;
    
    SELECT TOP 1 
        dim_kpi.kpi_id,
        dim_kpi.dim_kpi_key,
        dim_kpi.what_is_measured,
        dim_kpi.kpi_g_value,
        dim_kpi.kpi_a_value,
        dim_kpi.kpi_g_sign,
        dim_kpi.kpi_a_sign
    INTO #Selected_KPI
    FROM edw.dim_kpi
    WHERE dim_kpi.dwhdmloperation <> 'D'
        AND dim_kpi.dwhiscurrent = 1
        AND dim_kpi.kpi_id = @KPI_ID;

    -------------------------------------------------------------------------------
    -- Temp Table 14: final_final_table (with KPI status calculation)
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#final_final_table') IS NOT NULL DROP TABLE #final_final_table;
    
    SELECT 
        sk.dim_kpi_key,
        sk.kpi_id,
        ft.dim_company_key,
        ft.dim_client_referral_key,
        ft.client_referral_id,
       -- ft.client_team_name,
        ft.entity_key,
        ft.dim_service_key,
        ft.client_activity_start_date,
        ft.received_date,
        ft.client_referral_received_date_key,
        ft.days_to_first_activity,
        ft.days_in_service,
        ft.kpi_value,
        ft.user_friendly_score_explanation,
        CASE 
            WHEN ft.kpi_value IS NULL THEN 1 -- Red
            WHEN (sk.kpi_g_sign = '>=' AND ft.kpi_value >= sk.kpi_g_value)
                OR (sk.kpi_g_sign = '>' AND ft.kpi_value > sk.kpi_g_value)
                OR (sk.kpi_g_sign = '<=' AND ft.kpi_value <= sk.kpi_g_value)
                OR (sk.kpi_g_sign = '<' AND ft.kpi_value < sk.kpi_g_value)
                OR (sk.kpi_g_sign = '=' AND ft.kpi_value = sk.kpi_g_value)
                THEN 3 -- Green
            WHEN (sk.kpi_a_sign = '>=' AND ft.kpi_value >= sk.kpi_a_value)
                OR (sk.kpi_a_sign = '>' AND ft.kpi_value > sk.kpi_a_value)
                OR (sk.kpi_a_sign = '<=' AND ft.kpi_value <= sk.kpi_a_value)
                OR (sk.kpi_a_sign = '<' AND ft.kpi_value < sk.kpi_a_value)
                OR (sk.kpi_a_sign = '=' AND ft.kpi_value = sk.kpi_a_value)
                THEN 2 -- Amber
            ELSE 1 -- Red
        END AS kpi_status
    INTO #final_final_table
    FROM #final_table ft
    CROSS JOIN #Selected_KPI sk;

    CREATE NONCLUSTERED INDEX IX_final_final_table ON #final_final_table(dim_service_key, kpi_id);

    -------------------------------------------------------------------------------
    -- Final SELECT - Returns same columns as view + kpi_id and snapshot_date
    -------------------------------------------------------------------------------
    SELECT 
        fff.dim_kpi_key,
        fff.dim_company_key,
        fff.dim_client_referral_key,
        fff.dim_service_key,
        fff.entity_key,
        @KPI_ID AS kpi_id,
        fff.client_referral_id,
        ds.service_id,
        -- fff.client_team_name, --used for checking 
        fff.kpi_value,
        fff.user_friendly_score_explanation,
        fff.kpi_status,
        @SnapshotDate AS snapshot_date
  
    FROM #final_final_table fff
    LEFT JOIN edw.dim_service ds 
        ON fff.dim_service_key = ds.dim_service_key
    LEFT JOIN #service_type_grouping stg 
        ON stg.dim_kpi_key = fff.dim_kpi_key
        AND stg.service_id = ds.service_id
    LEFT JOIN #ms_count mc 
        ON fff.kpi_id = mc.kpi_id
    WHERE (mc.service_count IS NULL OR mc.service_count = 0)
        OR (stg.service_id IS NOT NULL);


END