CREATE   PROCEDURE [edw].[kpi_kaimahi_sp_148_police_vetting]
AS

/**********************************************************************************************************
 Procedure: [edw].[kpi_kaimahi_148_police_vetting]
 Author (Developer): Greg Nuthall
 Author (Analyst): Greg Hubbard
 Created: 2026-06-22
 Purpose: Validate police vetting status for Kaimahi and return KPI entity-level output
 User Story: 13419

 Notes:
 - Uses KPI metadata from edw.dim_kpi (green/amber threshold signs and values)
 - Uses service type mapping logic consistent with KPI 136 pattern
 - kpi_value is days until expiry (or sentinel value for perpetual approval); kpi_status is derived from dim_kpi threshold logic
 - Output grain is 1 row per employee (bucketing to service/company happens outside this query)
 - Includes employee-level exclusion logic for superseded/redundant qualification rows for:
   Clean Slate Police Vetting, Exception Police Vetting, and Ministry of Justice Check
 - Clean Slate Police Vetting and Exception Police Vetting are treated as one combined
   'Police Vetting' qualification group; only the single most current/superseding record
   of either type is counted, never both
 - Per-qualification-library KPI statuses are rolled up to a single employee-level KPI status
   per Table 1B: any Red -> employee Red; else any Amber -> employee Amber; else Green
 - user_friendly_score_explanation follows the fixed Table 3A wording templates (Green / Amber /
   Red-aligned-to-service / Red-not-aligned-to-service), driven off the single 'driving' qualification
   record already selected for the employee (worst status, then soonest/oldest expiry)

 =========================================================================================================
 REVISIONS:
 Version   Date        Author              Description
 -------   ----------  ------------------  --------------------------
 1.0       2026-06-26  Greg Hubbard        Initial view creation - calculate Kaimahi police vetting
 1.1       2026-08-06  Greg Hubbard        Changed grain 
 *************************************************************************************************************/



BEGIN
    SET NOCOUNT ON;

    DECLARE @SnapshotDate DATE = CAST(SYSUTCDATETIME() AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time' AS DATE);
    DECLARE @KPI_ID INT = 148;
    DECLARE @Entity_ID INT = 666;
    --------------------------------------------------------------------------------
    -- Temp Table 1: CurrentEmployees
    --------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#CurrentEmployees') IS NOT NULL DROP TABLE #CurrentEmployees;

    ;WITH RankedCurrentEmployees AS (
        SELECT
            de.dim_employee_key,
            de.employee_id,
            de.employee_name,
            de.employee_job_name,
            ROW_NUMBER() OVER (
                PARTITION BY de.employee_id
                ORDER BY de.dim_employee_key DESC
            ) AS rn
        FROM edw.dim_employee de
        WHERE de.employee_job_status IN ('Current Job', 'Ending Job')
            AND de.employee_job_name <> 'Cleaner'
            AND de.DWHIsCurrent = 1
            AND de.DWHDMLOperation <> 'D'
    )
    SELECT
        rce.dim_employee_key,
        rce.employee_id,
        rce.employee_name,
        rce.employee_job_name
    INTO #CurrentEmployees
    FROM RankedCurrentEmployees rce
    WHERE rce.rn = 1;

    CREATE CLUSTERED INDEX CIX_CurrentEmployees_employee_id
        ON #CurrentEmployees (employee_id);

    --------------------------------------------------------------------------------
    -- Temp Table 2: RelevantServices (Non-SS + Lived Experience Team + National Housing Management)
    --------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#RelevantServices') IS NOT NULL DROP TABLE #RelevantServices;

    SELECT
        ds.dim_service_key,
        ds.service_id,
        ds.dim_company_key,
        ds.service_name,
        ds.department_code,
        ds.service_type_code,
        ds.service_type_name
    INTO #RelevantServices
    FROM edw.dim_service ds
    WHERE ds.DWHIsCurrent = 1
        AND ds.DWHDMLOperation <> 'D'
        AND ISNULL(ds.is_inactive, 0) <> 1
        AND ds.dim_service_key > 0
        AND (
            ds.department_code NOT IN ('SS', 'WELLBEING')
            OR ds.service_name IN ('Lived Experience Team', 'National Housing Management')
        );

    CREATE CLUSTERED INDEX CIX_RelevantServices_service_id
        ON #RelevantServices (service_id);

    --------------------------------------------------------------------------------
    -- Temp Table 3: QualificationExclusionAssessment
    -- Builds the base qualification set and applies employee-level exclusion rules
    -- (base join + window calculations combined in one pass via chained CTEs):
    -- Rule 1: Like-for-like renewal
    -- Rule 2: All-expired, keep latest only
    -- Rule 3/4: Expired Police Vetting replaced by current Police Vetting or current MOJ
    --------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#QualificationExclusionAssessment') IS NOT NULL DROP TABLE #QualificationExclusionAssessment;

    ;WITH QualificationBase AS (
        SELECT
            fq.fact_employee_qualification_key,
            fq.dim_employee_key,
            rs.dim_service_key,
            rs.service_id,
            rs.dim_company_key,
            rs.service_name,
            fq.expiry_date,
            fq.issue_date,
            fq.issuing_organisation,
            qli.employee_qualification_library,
            qt.employee_qualification_type,
            fq.employee_id,
            fq.company_name,
            fq.qualification_status,
            UPPER(LTRIM(RTRIM(COALESCE(fq.qualification_status, '')))) AS qualification_status_normalized,
            CASE
                WHEN qli.employee_qualification_library IN (
                    'Clean Slate Police Vetting',
                    'Exception Police Vetting',
                    'Ministry of Justice Check'
                ) THEN 1
                ELSE 0
            END AS is_scope_library,
            CASE
                WHEN qli.employee_qualification_library IN (
                    'Clean Slate Police Vetting',
                    'Exception Police Vetting'
                ) THEN 1
                ELSE 0
            END AS is_police_vetting_type,
            CASE
                WHEN qli.employee_qualification_library = 'Ministry of Justice Check' THEN 1
                ELSE 0
            END AS is_moj_type,
            CASE
                WHEN UPPER(LTRIM(RTRIM(COALESCE(fq.qualification_status, '')))) = 'EXPIRED' THEN 0
                ELSE 1
            END AS is_non_expired_for_exclusion,
            CASE
                WHEN qli.employee_qualification_library IN (
                    'Clean Slate Police Vetting',
                    'Exception Police Vetting'
                ) THEN 'Police Vetting'
                ELSE qli.employee_qualification_library
            END AS qualification_group
        FROM edw.fact_employee_qualification fq
        INNER JOIN #CurrentEmployees ce
            ON fq.employee_id = ce.employee_id
        INNER JOIN edw.dim_service ds_fq
            ON fq.dim_service_key = ds_fq.dim_service_key
            AND ds_fq.DWHDMLOperation <> 'D'
        INNER JOIN #RelevantServices rs
            ON ds_fq.service_id = rs.service_id
        INNER JOIN edw.dim_employee_qualification_library qli
            ON fq.employee_qualification_library_id = qli.employee_qualification_library_id
            AND qli.DWHIsCurrent = 1
        INNER JOIN edw.dim_employee_qualification_type qt
            ON fq.employee_qualification_type_id = qt.employee_qualification_type_id
            AND qt.DWHIsCurrent = 1
            AND qt.employee_qualification_type = 'Vetting'
        WHERE fq.DWHIsCurrent = 1
            AND fq.DWHDMLOperation <> 'D'
    ),
    QualificationWindows AS (
        SELECT
            qb.*,
            SUM(
                CASE
                    WHEN qb.is_scope_library = 1
                        AND qb.is_non_expired_for_exclusion = 1
                        THEN 1
                    ELSE 0
                END
            ) OVER (
                PARTITION BY qb.employee_id, qb.employee_qualification_library
            ) AS same_library_non_expired_count,
            ROW_NUMBER() OVER (
                PARTITION BY qb.employee_id, qb.employee_qualification_library
                ORDER BY
                    COALESCE(CAST(qb.expiry_date AS DATE), CAST('1900-01-01' AS DATE)) DESC,
                    COALESCE(CAST(qb.issue_date AS DATE), CAST('1900-01-01' AS DATE)) DESC,
                    qb.fact_employee_qualification_key DESC
            ) AS same_library_keep_rank,
            MAX(
                CASE
                    WHEN qb.is_police_vetting_type = 1
                        AND qb.is_non_expired_for_exclusion = 1
                        THEN 1
                    ELSE 0
                END
            ) OVER (
                PARTITION BY qb.employee_id
            ) AS employee_has_non_expired_police,
            MAX(
                CASE
                    WHEN qb.is_moj_type = 1
                        AND qb.is_non_expired_for_exclusion = 1
                        THEN 1
                    ELSE 0
                END
            ) OVER (
                PARTITION BY qb.employee_id
            ) AS employee_has_non_expired_moj
        FROM QualificationBase qb
    )
    SELECT
        qw.fact_employee_qualification_key,
        qw.dim_employee_key,
        qw.dim_service_key,
        qw.service_id,
        qw.dim_company_key,
        qw.service_name,
        qw.expiry_date,
        qw.issue_date,
        qw.issuing_organisation,
        qw.employee_qualification_library,
        qw.qualification_group,
        qw.employee_qualification_type,
        qw.employee_id,
        qw.company_name,
        qw.qualification_status,
        CASE
            WHEN qw.qualification_status_normalized <> 'EXPIRED' THEN 0

            -- Rule 1: same qualification library has at least one non-expired record
            WHEN qw.is_scope_library = 1
                AND qw.same_library_non_expired_count > 0
                THEN 1

            -- Rule 3 + Rule 4: expired Police Vetting replaced by any non-expired Police Vetting or non-expired MOJ
            WHEN qw.is_police_vetting_type = 1
                AND (
                    qw.employee_has_non_expired_police = 1
                    OR qw.employee_has_non_expired_moj = 1
                )
                THEN 1

            -- Rule 2: all records for the same qualification library are expired, keep latest only
            WHEN qw.is_scope_library = 1
                AND qw.same_library_non_expired_count = 0
                AND qw.same_library_keep_rank > 1
                THEN 1

            ELSE 0
        END AS is_excluded
    INTO #QualificationExclusionAssessment
    FROM QualificationWindows qw;

    CREATE CLUSTERED INDEX CIX_QualificationExclusionAssessment_excluded_employee
        ON #QualificationExclusionAssessment (
            is_excluded,
            employee_id,
            qualification_group,
            issue_date,
            expiry_date,
            fact_employee_qualification_key
        );

    --------------------------------------------------------------------------------
    -- Temp Table 4: QualificationStatus (row-level detail)
    -- Combines the exclusion filter, latest-remaining-record ranking, and
    -- days-until-expiry calculation in a single pass (previously 3 separate temp tables).
    -- Ranking is partitioned by qualification_group (not the literal library) so that
    -- Clean Slate Police Vetting and Exception Police Vetting compete against each
    -- other for the same 'Police Vetting' slot - only the single most current/superseding
    -- Police-type record survives, even if both types are simultaneously non-expired.
    --------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#QualificationStatus') IS NOT NULL DROP TABLE #QualificationStatus;

    ;WITH RankedQualifications AS (
        SELECT
            qea.fact_employee_qualification_key,
            qea.dim_employee_key,
            qea.dim_service_key,
            qea.service_id,
            qea.dim_company_key,
            qea.service_name,
            qea.expiry_date,
            qea.issue_date,
            qea.issuing_organisation,
            qea.employee_qualification_library,
            qea.employee_qualification_type,
            qea.employee_id,
            qea.company_name,
            qea.qualification_status,
            ROW_NUMBER() OVER (
                PARTITION BY qea.employee_id, qea.qualification_group
                ORDER BY
                    COALESCE(CAST(qea.issue_date AS DATE), CAST(qea.expiry_date AS DATE), CAST('1900-01-01' AS DATE)) DESC,
                    COALESCE(CAST(qea.expiry_date AS DATE), CAST('9999-12-31' AS DATE)) DESC,
                    CASE UPPER(LTRIM(RTRIM(qea.qualification_status)))
                        WHEN 'CURRENT' THEN 1
                        WHEN 'EXPIRING_SOON' THEN 2
                        WHEN 'AWAITING_APPROVAL' THEN 3
                        WHEN 'FUTURE' THEN 4
                        WHEN 'DRAFT' THEN 5
                        WHEN 'EXPIRED' THEN 6
                        ELSE 7
                    END,
                    qea.fact_employee_qualification_key DESC
            ) AS rn
        FROM #QualificationExclusionAssessment qea
        WHERE qea.is_excluded = 0
    )
    SELECT
        rq.fact_employee_qualification_key,
        ce.dim_employee_key,
        rq.dim_service_key,
        rq.service_id,
        rq.dim_company_key,
        rq.service_name,
        rq.employee_id,
        ce.employee_name,
        rq.expiry_date,
        rq.issue_date,
        rq.issuing_organisation,
        rq.employee_qualification_library,
        rq.qualification_status,
        CASE
            WHEN rq.employee_qualification_library = 'Vetting Results and Criminal Conviction Approval'
                THEN NULL
            WHEN rq.expiry_date IS NULL
                THEN NULL
            ELSE DATEDIFF(DAY, @SnapshotDate, CAST(rq.expiry_date AS DATE))
        END AS days_until_expiry
    INTO #QualificationStatus
    FROM RankedQualifications rq
    INNER JOIN #CurrentEmployees ce
        ON rq.employee_id = ce.employee_id
    WHERE rq.rn = 1;

    CREATE NONCLUSTERED INDEX IX_QualificationStatus_service_employee
        ON #QualificationStatus (dim_service_key, employee_id)
        INCLUDE (employee_name, days_until_expiry, qualification_status, dim_company_key, service_id, service_name, dim_employee_key, employee_qualification_library);

    --------------------------------------------------------------------------------
    -- Temp Table 5: LibraryKpiStatus (employee + qualification library level)
    -- Evaluates each employee's individual qualification-library record against the
    -- KPI's green/amber thresholds.
    --------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#LibraryKpiStatus') IS NOT NULL DROP TABLE #LibraryKpiStatus;

    ;WITH Selected_KPI AS (
        SELECT TOP 1
            dim_kpi.kpi_id,
            dim_kpi.dim_kpi_key,
            dim_kpi.what_is_measured,
            dim_kpi.kpi_g_value,
            dim_kpi.kpi_a_value,
            dim_kpi.kpi_g_sign,
            dim_kpi.kpi_a_sign
        FROM edw.dim_kpi
        WHERE dim_kpi.DWHDMLOperation <> 'D'
            AND dim_kpi.DWHIsCurrent = 1
            AND dim_kpi.kpi_id = @KPI_ID
        ORDER BY dim_kpi.dim_kpi_key DESC
    )
    SELECT
        sk.dim_kpi_key,
        qs.dim_company_key,
        qs.dim_service_key,
        qs.service_id,
        qs.service_name,
        qs.dim_employee_key,
        qs.employee_id,
        qs.employee_name,
        qs.employee_qualification_library,
        qs.qualification_status,
        qs.expiry_date,
        qs.days_until_expiry AS kpi_value,
        CASE
            WHEN qs.employee_qualification_library = 'Vetting Results and Criminal Conviction Approval' THEN 3
            WHEN qs.days_until_expiry IS NULL THEN 3
            WHEN (sk.kpi_g_sign = '>=' AND qs.days_until_expiry >= sk.kpi_g_value)
                OR (sk.kpi_g_sign = '>' AND qs.days_until_expiry > sk.kpi_g_value)
                OR (sk.kpi_g_sign = '<=' AND qs.days_until_expiry <= sk.kpi_g_value)
                OR (sk.kpi_g_sign = '<' AND qs.days_until_expiry < sk.kpi_g_value)
                OR (sk.kpi_g_sign = '=' AND qs.days_until_expiry = sk.kpi_g_value)
                THEN 3
            WHEN (sk.kpi_a_sign = '>=' AND qs.days_until_expiry >= sk.kpi_a_value)
                OR (sk.kpi_a_sign = '>' AND qs.days_until_expiry > sk.kpi_a_value)
                OR (sk.kpi_a_sign = '<=' AND qs.days_until_expiry <= sk.kpi_a_value)
                OR (sk.kpi_a_sign = '<' AND qs.days_until_expiry < sk.kpi_a_value)
                OR (sk.kpi_a_sign = '=' AND qs.days_until_expiry = sk.kpi_a_value)
                THEN 2
            ELSE 1
        END AS library_kpi_status
    INTO #LibraryKpiStatus
    FROM #QualificationStatus qs
    CROSS JOIN Selected_KPI sk;

    CREATE CLUSTERED INDEX CIX_LibraryKpiStatus_employee
        ON #LibraryKpiStatus (employee_id, library_kpi_status, kpi_value);

    --------------------------------------------------------------------------------
    -- Temp Table 6: EmployeeRollup
    -- Rolls the per-library KPI statuses up to a single row per employee per Table 1B:
    --   any Red -> employee Red; else any Amber -> employee Amber; else Green.
    -- The 'driving' library record (worst status, then soonest/oldest expiry) supplies the
    -- representative service/company/expiry context and the Table 3A explanation text for
    -- the employee-level row. The employee-level status is computed as a window MIN()
    -- alongside the driving-record ranking, avoiding a separate aggregation pass/join.
    --------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#EmployeeRollup') IS NOT NULL DROP TABLE #EmployeeRollup;

    ;WITH DrivingRecord AS (
        SELECT
            lks.*,
            MIN(lks.library_kpi_status) OVER (PARTITION BY lks.employee_id) AS employee_kpi_status,
            ROW_NUMBER() OVER (
                PARTITION BY lks.employee_id
                ORDER BY
                    lks.library_kpi_status ASC,
                    CASE WHEN lks.kpi_value IS NULL THEN 1 ELSE 0 END ASC,
                    lks.kpi_value ASC,
                    lks.employee_qualification_library ASC
            ) AS driving_rn
        FROM #LibraryKpiStatus lks
    )
    SELECT
        dr.dim_kpi_key,
        dr.dim_company_key,
        dr.dim_employee_key,
        dr.dim_service_key,
        @kpi_id as kpi_id,
        dr.employee_id,
        dr.service_id,
        CONCAT(@Entity_ID, '_', dr.employee_id, '_', dr.service_id, '_', dr.dim_company_key) AS entity_key,

        dr.kpi_value,
        
        -- Table 3A wording. The driving record already carries the lowest days-to-expiry (Amber case)
        -- or the oldest expiry date (Red case), because DrivingRecord orders worst status first then
        -- kpi_value ASC (most negative/oldest-expired first, smallest-positive/soonest-expiring first).
        CASE dr.employee_kpi_status
            WHEN 3 THEN 'All vetting is in date.'
            WHEN 2 THEN CONCAT(
                'A vetting is due to expire in ',
                dr.kpi_value,
                ' days.'
            )
            WHEN 1 THEN CONCAT(
                        'A vetting expired ',
                        CONVERT(VARCHAR(10), dr.expiry_date, 103)
                )
        END AS user_friendly_score_explanation,
        dr.employee_kpi_status AS kpi_status,
        CAST(GETDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time' AS DATE) AS snapshot_date

    --INTO #EmployeeRollup
    FROM DrivingRecord dr
    LEFT JOIN #RelevantServices rs
        ON dr.service_id = rs.service_id
    WHERE dr.driving_rn = 1;


    END