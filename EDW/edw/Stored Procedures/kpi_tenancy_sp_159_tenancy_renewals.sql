CREATE   PROCEDURE [edw].[kpi_tenancy_sp_159_tenancy_renewals]
AS
/**********************************************************************************************************
 Procedure: [edw].[kpi_tenancy_sp_159_tenancy_renewals]
 Author:    Mike Gencic (authored with Claude Code)
 Created:   2026-06-16
 Purpose:   Returns KPI 159 (Tenancy Renewals) tenancy-level rows for snapshot generation.
            Gives TLTM/TM visibility of upcoming Transitional Housing (TH) lease renewals so whanau
            can be re-signed before the Short Term Tenancy End Date.

            Output is consumed by [edw].[kpi_snapshot_tenancy_generate] via the standard INSERT...EXEC
            pattern into [landing].[kpi_ds_snapshot_tenancy_current].

 Feature:   New KPI added to SP April 2026 - 159 (Tenancy Renewals)
 Driver:    'We predominantly have 90 day re-signs and it is not unusual for a TM to forget to re-sign
             with a whanau; this should help us keep on track.' (AR)

 --------------------------------------------------------------------------------------------------------
 MEASURE RULES (tenancy level)
 --------------------------------------------------------------------------------------------------------
 Inclusions (Table 2):
   * TH properties only (Table 1): property_program = 'Transitional Housing'
       AND property_sub_program = 'Transitional Housing'
       AND property_sub_property_type <> 'Office'.  Motels excluded.
   * Active tenancy that has been active for MORE than 4 weeks
       (Tenancy Start Date >= 29 days ago).
   * Short Term Tenancy End Date populated.

 Exclusions (overlaid AFTER inclusions are determined - Table 2):
   * Tenancy Start Date < 29 days ago.
   * 'parent' in property Name.
   * A future-dated Acquired Date.
   * A Confirmed Date of Disposal of the report run date or earlier.
   * Property Status of Untenantable.
   * Untenanted properties.

 --------------------------------------------------------------------------------------------------------
 UNIT-LEVEL (tenant) STATUS  - driven by days-until-renewal
   days_until_renewal = DATEDIFF(DAY, NZ today, Short Term Tenancy End Date)
   Status is set by comparing kpi_value (= days_until_renewal) against the BUSINESS-MAINTAINED
   thresholds in [edw].[dim_kpi] (kpi_g_sign / kpi_g_value for Green, kpi_a_sign / kpi_a_value for
   Amber). dim_kpi is controlled by the business via SharePoint, so the Green/Amber cut-offs can be
   retuned without a code change. Sign variants '=>' / '=<' entered in SharePoint are normalised to
   '>=' / '<='. With the current dim_kpi 159 config (kpi_g '>' 14, kpi_a '>' 0):
     Green (3): days_until_renewal > 14
     Amber (2): days_until_renewal > 0 and not Green  (i.e. 1..14)
     Red   (1): otherwise (today or in the past, <= 0)

 STATUS REASON wording (user_friendly_score_explanation, VARCHAR(80)):
   Green/Amber : 'Renewal date of dd/mm/yy is N day(s) away'
   Red (today) : 'Renewal date is today'
   Red (past)  : 'Renewal date of dd/mm/yy was N day(s) ago'
   (Day counts are made grammatically correct: '1 day' vs 'N days'.)

 --------------------------------------------------------------------------------------------------------
 GROUP / ROLLED-UP status (100% green = Green; >=90% green/amber = Amber; else Red) and the
 Call to Action text are NOT produced here. They are derived downstream in the Power BI / DAX layer
 from these tenancy rows plus [edw].[dim_kpi], consistent with the other tenancy KPIs.

 PREREQUISITE: a current row for kpi_id = 159 must exist in [edw].[dim_kpi] (dim_kpi_key is NOT NULL
               in the snapshot target). This is ALREADY the case in production
               (dim_kpi_key = 457, DWHIsCurrent = 1, DWHDMLOperation = 'U'); the lookup filter
               DWHDMLOperation <> 'D' correctly includes that 'U' row. Its thresholds
               (kpi_g '>' 14 ; kpi_a '>' 0) DRIVE the Green/Amber status (read at runtime - see below).
               See dim_kpi_159_seed.sql only for sandbox seeding. If 159 were absent the proc returns
               zero rows (schema constraint); if its g/a signs were NULL every row would fall to Red.

 NOTE: This file uses CREATE OR ALTER for standalone manual deployment/testing. If it is added to the
       EDW SSDT project, change the header to a bare CREATE PROCEDURE to match the project convention.

 REVISIONS:
 Version  Date         Author        Description
 -------  -----------  ------------  --------------------------------------------------------------
 1.0      2026-06-16   Mike Gencic   Initial stored procedure version for KPI 159 snapshot output
 **********************************************************************************************************/
BEGIN
    SET NOCOUNT ON;

    -- NZ 'today': anchor via UTC so it is correct on UTC-clock servers (matches KPI 158 / dim_date build).
    DECLARE @SnapshotDate DATE = CAST(((GETUTCDATE() AT TIME ZONE 'UTC') AT TIME ZONE 'New Zealand Standard Time') AS DATE);
    DECLARE @KPI_ID INT = 159;

    -------------------------------------------------------------------------------
    -- Temp Table 1: selected_kpi
    --   Resolve dim_kpi_key AND the business-maintained Green/Amber thresholds for KPI 159.
    --   Sign is normalised so SharePoint-entered '=>' / '=<' behave as '>=' / '<=' (cf. KPI 158).
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#selected_kpi') IS NOT NULL DROP TABLE #selected_kpi;

    SELECT TOP 1
        dim_kpi.kpi_id,
        dim_kpi.dim_kpi_key,
        dim_kpi.kpi_g_value,
        dim_kpi.kpi_a_value,
        CASE REPLACE(LTRIM(RTRIM(ISNULL(dim_kpi.kpi_g_sign, ''))), ' ', '')
            WHEN '=>' THEN '>='
            WHEN '=<' THEN '<='
            ELSE REPLACE(LTRIM(RTRIM(ISNULL(dim_kpi.kpi_g_sign, ''))), ' ', '')
        END AS kpi_g_sign,
        CASE REPLACE(LTRIM(RTRIM(ISNULL(dim_kpi.kpi_a_sign, ''))), ' ', '')
            WHEN '=>' THEN '>='
            WHEN '=<' THEN '<='
            ELSE REPLACE(LTRIM(RTRIM(ISNULL(dim_kpi.kpi_a_sign, ''))), ' ', '')
        END AS kpi_a_sign
    INTO #selected_kpi
    FROM edw.dim_kpi
    WHERE dim_kpi.DWHDMLOperation <> 'D'
      AND dim_kpi.DWHIsCurrent = 1
      AND dim_kpi.kpi_id = @KPI_ID
    ORDER BY dim_kpi.dim_kpi_key DESC;

    -------------------------------------------------------------------------------
    -- Temp Table 2: service_type_grouping  (services mapped to this KPI)
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
        AND dim_kpi_service_type_grouping.DWHIsCurrent = 1
    LEFT JOIN edw.bridge_kpi_service_type_to_grouping
        ON bridge_kpi_measure_to_service_type_group.dim_kpi_service_type_grouping_key = bridge_kpi_service_type_to_grouping.dim_kpi_service_type_grouping_key
    LEFT JOIN edw.dim_kpi_service_type
        ON bridge_kpi_service_type_to_grouping.dim_kpi_service_type_key = dim_kpi_service_type.dim_kpi_service_type_key
    LEFT JOIN edw.dim_service
        ON dim_kpi_service_type.service_type = dim_service.service_type_name
        AND dim_service.DWHIsCurrent = 1
        AND dim_service.DWHDMLOperation <> 'D'
    WHERE dim_kpi.DWHIsCurrent = 1
      AND dim_kpi.kpi_id = (SELECT kpi_id FROM #selected_kpi);

    CREATE NONCLUSTERED INDEX IX_service_type_grouping ON #service_type_grouping(dim_kpi_key, service_id);

    -------------------------------------------------------------------------------
    -- Temp Tables 3 & 4: ms_count  (how many services are mapped to this KPI)
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#ms_count_0') IS NOT NULL DROP TABLE #ms_count_0;

    SELECT
        (SELECT DISTINCT kpi_id FROM #selected_kpi) AS kpi_id,
        service_id
    INTO #ms_count_0
    FROM #service_type_grouping;

    IF OBJECT_ID('tempdb..#ms_count') IS NOT NULL DROP TABLE #ms_count;

    SELECT
        kpi_id,
        COUNT(service_id) AS service_count
    INTO #ms_count
    FROM #ms_count_0
    GROUP BY kpi_id;

    -------------------------------------------------------------------------------
    -- Temp Table 5: dim_current_tenancies
    --   Apply ALL inclusion + exclusion rules and compute days-until-renewal.
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#dim_current_tenancies') IS NOT NULL DROP TABLE #dim_current_tenancies;

    SELECT
        COALESCE(svc_contract.dim_company_key, svc_property.dim_company_key) AS dim_company_key,
        vw_dim_property_tenancy.property_tenancy_id,
        vw_dim_property_tenancy.dim_property_tenancy_key,
        COALESCE(svc_contract.dim_service_key, svc_property.dim_service_key) AS dim_service_key,
        vw_dim_property.dim_property_key,
        vw_dim_property.property_id,
        COALESCE(svc_contract.service_name, svc_property.service_name) AS service_name,
        COALESCE(svc_contract.service_id, svc_property.service_id) AS service_id,
        vw_dim_property_tenancy.property_tenancy_short_term_tenancy_end_date AS renewal_date,
        DATEDIFF(DAY, @SnapshotDate, vw_dim_property_tenancy.property_tenancy_short_term_tenancy_end_date) AS days_until_renewal
    INTO #dim_current_tenancies
    FROM edw.vw_dim_property_tenancy
    INNER JOIN edw.vw_dim_property
        ON vw_dim_property_tenancy.property_id = vw_dim_property.property_id
        AND vw_dim_property.DWHIsCurrent = 1
        AND vw_dim_property.DWHDMLOperation <> 'D'
    -- Resolve the service via OUTER APPLY ... TOP 1 (one current service per code) rather than two
    -- plain LEFT JOINs. service_code is not unique among current dim_service rows, so two independent
    -- LEFT JOINs could multiply a tenancy into duplicate rows that share the same service_id/company
    -- (hence the same '888_...' entity_key). TOP 1 guarantees at most one match per code and keeps the
    -- contract-code-preferred resolution identical to the sibling procs in the normal (unique) case.
    OUTER APPLY (
        SELECT TOP 1 s.dim_service_key, s.dim_company_key, s.service_id, s.service_name
        FROM edw.vw_dim_service s
        WHERE s.service_code = vw_dim_property.property_contract_bc_service_code
          AND s.DWHIsCurrent = 1
          AND s.DWHDMLOperation <> 'D'
        ORDER BY s.dim_service_key
    ) AS svc_contract
    OUTER APPLY (
        SELECT TOP 1 s.dim_service_key, s.dim_company_key, s.service_id, s.service_name
        FROM edw.vw_dim_service s
        WHERE s.service_code = vw_dim_property.property_bc_service_code
          AND s.DWHIsCurrent = 1
          AND s.DWHDMLOperation <> 'D'
        ORDER BY s.dim_service_key
    ) AS svc_property
    WHERE vw_dim_property_tenancy.DWHIsCurrent = 1
      AND vw_dim_property_tenancy.DWHDMLOperation <> 'D'
      AND vw_dim_property.dim_property_key > 0
      AND vw_dim_property.property_statecode = 'Active'
      -- Active tenancy (house definition)
      AND vw_dim_property_tenancy.property_tenant_opportunity_status IN ('new', 'active arrears', 'active')
      AND vw_dim_property_tenancy.property_tenancy_vacate_confirmation_flag = 0
      AND vw_dim_property_tenancy.property_tenancy_actual_close_date IS NULL
      -- Active for MORE than 4 weeks AND exclude tenancies < 29 days old
      AND vw_dim_property_tenancy.property_tenancy_tenancy_start_date IS NOT NULL
      AND DATEDIFF(DAY, vw_dim_property_tenancy.property_tenancy_tenancy_start_date, @SnapshotDate) >= 29
      -- Inclusion: Short Term Tenancy End Date populated
      AND vw_dim_property_tenancy.property_tenancy_short_term_tenancy_end_date IS NOT NULL
      -- Exclusion: 'parent' in Name
      AND vw_dim_property.property_name NOT LIKE '%parent%'
      -- Exclusion: Confirmed Date of Disposal of report run date or earlier (compare on DATE so same-day is excluded)
      AND ISNULL(CAST(vw_dim_property.property_confirmed_disposal_date AS DATE), '2099-12-31') > @SnapshotDate
      -- Exclusion: future Acquired Date (NULL acquired treated as not-yet-acquired => excluded, matches KPI 40 / 158)
      AND ISNULL(CAST(vw_dim_property.property_acquired_date AS DATE), '2099-12-31') <= @SnapshotDate
      -- Exclusion: Untenantable
      AND LOWER(ISNULL(vw_dim_property.property_status, '')) <> 'vacant: un-tenantable'
      -- Exclusion: Untenanted properties
      AND vw_dim_property.property_current_tenancy IS NOT NULL
      -- TH scope (Table 1): TH program & sub-program, exclude Office; Motels excluded (belt-and-braces)
      AND ISNULL(vw_dim_property.property_program, '') = 'Transitional Housing'
      AND ISNULL(vw_dim_property.property_sub_program, '') = 'Transitional Housing'
      AND ISNULL(vw_dim_property.property_sub_property_type, '') <> 'Office'
      AND ISNULL(vw_dim_property.property_program, '') <> 'Motels'
      AND ISNULL(vw_dim_property.property_sub_program, '') NOT IN ('Motels', 'Motels (CLS)');

    CREATE CLUSTERED INDEX IX_dim_current_tenancies ON #dim_current_tenancies(dim_service_key);
    CREATE NONCLUSTERED INDEX IX_dim_current_tenancies_property ON #dim_current_tenancies(dim_property_key, property_id);

    -------------------------------------------------------------------------------
    -- Temp Table 6: dim_current_tenancies_2 (resolve dim_company_key + service grouping)
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#dim_current_tenancies_2') IS NOT NULL DROP TABLE #dim_current_tenancies_2;

    SELECT
        COALESCE(vw_dim_service.dim_company_key, dct.dim_company_key, 1) AS dim_company_key,
        dct.dim_service_key,
        dct.dim_property_key,
        dct.property_id,
        dct.property_tenancy_id,
        dct.dim_property_tenancy_key,
        dct.service_id,
        dct.renewal_date,
        dct.days_until_renewal,
        dim_kpi_service_type_grouping.service_type_grouping
    INTO #dim_current_tenancies_2
    FROM #dim_current_tenancies dct
    LEFT JOIN edw.vw_dim_service
        ON dct.dim_service_key = vw_dim_service.dim_service_key
        AND vw_dim_service.DWHDMLOperation <> 'D'
        AND vw_dim_service.DWHIsCurrent = 1
    LEFT JOIN edw.dim_kpi_service_type
        ON vw_dim_service.service_type_name = dim_kpi_service_type.service_type
        AND dim_kpi_service_type.DWHIsCurrent = 1
    LEFT JOIN edw.bridge_kpi_service_type_to_grouping
        ON dim_kpi_service_type.dim_kpi_service_type_key = bridge_kpi_service_type_to_grouping.dim_kpi_service_type_key
    LEFT JOIN edw.dim_kpi_service_type_grouping
        ON bridge_kpi_service_type_to_grouping.service_type_grouping_id = dim_kpi_service_type_grouping.service_type_grouping_id
        AND dim_kpi_service_type_grouping.DWHIsCurrent = 1
    WHERE dct.dim_service_key IS NOT NULL;

    CREATE CLUSTERED INDEX IX_dim_current_tenancies_2 ON #dim_current_tenancies_2(dim_property_key);
    CREATE NONCLUSTERED INDEX IX_dim_current_tenancies_2_service ON #dim_current_tenancies_2(service_id, dim_company_key);

    -------------------------------------------------------------------------------
    -- Temp Table 7: final_table  (kpi_value = days-until-renewal + factual wording)
    --   kpi_status is NOT set here - it is derived in the final SELECT from the
    --   business-maintained dim_kpi thresholds. The wording stays driven by the actual
    --   day count (away / today / ago), which is factual regardless of the colour cut-offs.
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#final_table') IS NOT NULL DROP TABLE #final_table;

    SELECT
        CONCAT('888', '_', dct2.property_tenancy_id, '_', dct2.service_id, '_', dct2.dim_company_key) AS entity_key,
        dct2.dim_company_key,
        dct2.property_id,
        dct2.property_tenancy_id,
        dct2.dim_property_key,
        dct2.dim_property_tenancy_key,
        dct2.dim_service_key,
        dct2.service_id,
        CAST(dct2.days_until_renewal AS NUMERIC(8, 2)) AS kpi_value,
        CAST(
            CASE
                WHEN dct2.days_until_renewal >= 1 THEN
                    CONCAT('Renewal date of ', CONVERT(VARCHAR(8), dct2.renewal_date, 3), ' is ',
                           dct2.days_until_renewal,
                           CASE WHEN dct2.days_until_renewal = 1 THEN ' day away' ELSE ' days away' END)
                WHEN dct2.days_until_renewal = 0 THEN
                    'Renewal date is today'
                ELSE
                    CONCAT('Renewal date of ', CONVERT(VARCHAR(8), dct2.renewal_date, 3), ' was ',
                           ABS(dct2.days_until_renewal),
                           CASE WHEN dct2.days_until_renewal = -1 THEN ' day ago' ELSE ' days ago' END)
            END
        AS VARCHAR(80)) AS user_friendly_score_explanation
    INTO #final_table
    FROM #dim_current_tenancies_2 dct2;

    CREATE NONCLUSTERED INDEX IX_final_table ON #final_table(service_id, dim_company_key);

    -------------------------------------------------------------------------------
    -- Final SELECT - column order/names match the INSERT in kpi_snapshot_tenancy_generate
    -------------------------------------------------------------------------------
    SELECT
        sk.dim_kpi_key,
        ft.dim_company_key,
        ft.dim_property_tenancy_key,
        ft.dim_service_key,
        ft.entity_key,
        @KPI_ID AS kpi_id,
        ft.property_tenancy_id,
        ft.service_id,
        ft.kpi_value,
        ft.user_friendly_score_explanation,
        -- Green/Amber/Red from the business-maintained dim_kpi thresholds (kpi_value = days-until-renewal).
        -- With KPI 159's config (kpi_g '>' 14, kpi_a '>' 0): Green > 14, Amber 1..14, Red <= 0.
        CASE
            WHEN ft.kpi_value IS NULL THEN 1 -- Red (defensive; STTED is filtered NOT NULL upstream)
            WHEN (sk.kpi_g_sign = '>=' AND ft.kpi_value >= sk.kpi_g_value)
                OR (sk.kpi_g_sign = '>'  AND ft.kpi_value >  sk.kpi_g_value)
                OR (sk.kpi_g_sign = '<=' AND ft.kpi_value <= sk.kpi_g_value)
                OR (sk.kpi_g_sign = '<'  AND ft.kpi_value <  sk.kpi_g_value)
                OR (sk.kpi_g_sign = '='  AND ft.kpi_value =  sk.kpi_g_value)
                THEN 3 -- Green
            WHEN (sk.kpi_a_sign = '>=' AND ft.kpi_value >= sk.kpi_a_value)
                OR (sk.kpi_a_sign = '>'  AND ft.kpi_value >  sk.kpi_a_value)
                OR (sk.kpi_a_sign = '<=' AND ft.kpi_value <= sk.kpi_a_value)
                OR (sk.kpi_a_sign = '<'  AND ft.kpi_value <  sk.kpi_a_value)
                OR (sk.kpi_a_sign = '='  AND ft.kpi_value =  sk.kpi_a_value)
                THEN 2 -- Amber
            ELSE 1 -- Red
        END AS kpi_status,
        @SnapshotDate AS snapshot_date
    FROM #final_table ft
    CROSS JOIN #selected_kpi sk
    LEFT JOIN #service_type_grouping stg
        ON stg.dim_kpi_key = sk.dim_kpi_key
        AND stg.service_id = ft.service_id
    LEFT JOIN #ms_count mc
        ON sk.kpi_id = mc.kpi_id
    WHERE (mc.service_count IS NULL OR mc.service_count = 0)
       OR (stg.service_id IS NOT NULL);
END