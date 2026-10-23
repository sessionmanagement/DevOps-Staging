CREATE     PROCEDURE [edw].[kpi_tenancy_sp_82_key_information_captured]
AS
/**********************************************************************************************************
 Procedure: [edw].[kpi_tenancy_sp_82_key_information_captured]
 Author:    Mike Gencic
 Created:   2026-06-26
 Purpose:   Whether key information has been captured for Social Housing (SH) and Transitional Housing
            (TH) tenancies, for KPI 82. One row per qualifying tenancy, scored on the main applicant.
              Must-have   = DOB, Gender, Ethnicity, Emergency Contact, tenancy TM = property TM, and
                            (TH only) Recordbase ID.   Should-have = SWN.   Could-have = Iwi Affiliation.
              Status (Table 4): Green = Must AND Should | Amber = Must only | Red = no Must.
 User Story: 13416 (data: 13658)

 Notes:
   - Status comes from the Table 4 flags, not the dim_kpi g/a ladder. Population is Table 1 + Table 2
     only - no service-type gate (it dropped 101 eligible tenancies, see 1.1).
   - Output column order is load-bearing: kpi_snapshot_tenancy_generate binds by position.
   - Reason text is the analyst's Table 6 (reissued 2026-08-18). Spec and the enumeration of every
     reachable state: Property_Work\KPI82_Tests_v3\. Longest 150. There is no runtime length check.
   - DEPLOYMENT BLOCKER: staging.EDWedwkpi_snapshot_tenancy.user_friendly_score_explanation is
     VARCHAR(80); this text needs 200. Safe to run by hand; do not schedule until it is widened.
   - Gender (1.6): the primary contact's gender (the contact record is the source of truth for tenant
     details), ignoring its 'Unspecified/Unknown' default, else the household-member row.
   - Tests: KPI82_Tests\04_unit_tests.sql (hand-pasted mirror - re-paste on every change) and
     KPI82_Tests_v3\08_TABLE6_V2_ACCEPTANCE_TEST_EDW.sql. Never executed against a database.
   - Open with the analyst: 'Emergency Contact' vs 'Emergency Details'; the row 6 comma; the 1.5 change.
 *************************************************************************************************************

 REVISIONS:
 Version   Date         Author          Description
 -------   ------------ --------------- ----------------------------------------------------------------
 1.0       2026-06-26   Mike Gencic     Initial version
 1.1       2026-06-29   Mike Gencic     Removed the service-type-grouping gate (it dropped 101 eligible
                                        tenancies).
 1.2       2026-08-11   Mike Gencic     Reason text names only the details actually missing (06_A: 3,290 of
                                        4,302 v1.1 instructions were false). Budgeted to 80 bytes.
 1.3       2026-08-17   Mike Gencic     Analyst's revised Table 6. Wall 80 -> 200; truncation machinery
                                        removed; bound by enumeration. Text only.
 1.4       2026-08-18   Mike Gencic     Rows 10/11 confirmed; the v1.3 reading switch deleted. No text change.
 1.5       2026-09-10   Mike Gencic     Gender falls back to the primary contact's gender when the house row
                                        is blank. SCORING CHANGE: 220 of 228 recover, 96 Red -> Green,
                                        1 Red -> Amber. Tests re-baselined to expect exactly those flips.
 1.6       2026-09-11   Mike Gencic     Contact gender first, house row as the fallback (Briar Wilson: the
                                        contact record is the source of truth for tenant details). Presence
                                        test only, so no score, text or row changes vs 1.5.
 *************************************************************************************************************/
BEGIN
    SET NOCOUNT ON;

    DECLARE @SnapshotDate DATE = CAST(GETDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time' AS DATE);
    DECLARE @KPI_ID INT = 82;

    -------------------------------------------------------------------------------
    -- Temp Table 1: #SelectedKPI  (resolves dim_kpi_key; thresholds NOT used for status)
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#SelectedKPI') IS NOT NULL DROP TABLE #SelectedKPI;

    SELECT TOP 1
        dim_kpi.kpi_id,
        dim_kpi.dim_kpi_key
    INTO #SelectedKPI
    FROM edw.dim_kpi
    WHERE dim_kpi.DWHDMLOperation <> 'D'
      AND dim_kpi.DWHIsCurrent = 1
      AND dim_kpi.kpi_id = @KPI_ID
    ORDER BY dim_kpi.dim_kpi_key DESC;

    -------------------------------------------------------------------------------
    -- Temp Table 5: #BaseTenancies - qualifying SH/TH tenancies (Table 1 + Table 2). No service-type gate.
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#BaseTenancies') IS NOT NULL DROP TABLE #BaseTenancies;

    SELECT
        COALESCE(vw_dim_service.dim_company_key, dim_service_2.dim_company_key) AS dim_company_key,
        pt.property_tenancy_id,
        pt.dim_property_tenancy_key,
        COALESCE(vw_dim_service.dim_service_key, dim_service_2.dim_service_key) AS dim_service_key,
        COALESCE(vw_dim_service.service_id, dim_service_2.service_id)           AS service_id,
        CASE
            WHEN (
                     (ISNULL(p.property_program, '') = 'Affordable Housing Management' AND ISNULL(p.property_sub_program, '') = 'Rotorua Lakes Council')
                  OR (ISNULL(p.property_program, '') = 'Affordable Rental'             AND ISNULL(p.property_sub_program, '') = 'Affordable Rental')
                  OR (ISNULL(p.property_program, '') = 'Boarding'                      AND ISNULL(p.property_sub_program, '') = 'Residential Services Boarding')
                  OR (ISNULL(p.property_program, '') = 'IRRS'                          AND ISNULL(p.property_sub_program, '') IN (
                          'CCP (Creating Positive Pathways Spot)',
                          'Housing First (SPOT)',
                          'Social Housing (Capacity)',
                          'Social Housing (SPOT)',
                          'Social Housing TM'
                      ))
                 ) THEN 'SH'
            WHEN (
                     ISNULL(p.property_program, '')           = 'Transitional Housing'
                 AND ISNULL(p.property_sub_program, '')       = 'Transitional Housing'
                 AND ISNULL(p.property_sub_property_type, '') <> 'Office'
                 ) THEN 'TH'
            ELSE NULL
        END AS tenancy_type,
        pt.property_tenancy_manager_name,
        p.property_assigned_tenancy_manager,
        pt.property_tenancy_primary_tenant_recordbaseid,
        pt.property_tenancy_primary_tenant_gender      -- v1.6: primary gender source (opportunity primary contact)
    INTO #BaseTenancies
    FROM edw.vw_dim_property_tenancy pt
    INNER JOIN edw.vw_dim_property p
        ON pt.property_id = p.property_id
        AND p.DWHIsCurrent = 1
        AND p.DWHDMLOperation <> 'D'
    LEFT JOIN edw.vw_dim_service
        ON p.property_contract_bc_service_code = vw_dim_service.service_code
        AND vw_dim_service.DWHIsCurrent = 1
        AND vw_dim_service.DWHDMLOperation <> 'D'
    LEFT JOIN edw.vw_dim_service AS dim_service_2
        ON p.property_bc_service_code = dim_service_2.service_code
        AND dim_service_2.DWHIsCurrent = 1
        AND dim_service_2.DWHDMLOperation <> 'D'
    WHERE pt.DWHIsCurrent = 1
      AND pt.DWHDMLOperation <> 'D'
      AND p.dim_property_key > 0
      -- Inclusions (Table 2)
      AND p.property_statecode = 'Active'
      -- Current/active tenancy (tenancy grain)
      AND pt.property_tenant_opportunity_status IN ('new', 'active arrears', 'active')
      AND pt.property_tenancy_vacate_confirmation_flag = 0
      AND pt.property_tenancy_actual_close_date IS NULL
      -- Exclusions (Table 2)
      AND p.property_name NOT LIKE '%parent%'
      AND ISNULL(p.property_acquired_date, '2099-12-31')          <= @SnapshotDate              -- exclude future-dated acquired
      AND ISNULL(p.property_confirmed_disposal_date, '2099-12-31') > @SnapshotDate              -- exclude disposal today-or-earlier (Table 2)
      AND LOWER(ISNULL(p.property_status, '')) <> 'vacant: un-tenantable'                        -- exclude untenantable
      AND ISNULL(p.property_program, '')     <> 'Motels'                                         -- exclude Motels (program)
      AND ISNULL(p.property_sub_program, '') NOT IN ('Motels', 'Motels (CLS)')                   -- exclude Motels (sub-program)
      -- SH/TH inclusion (Table 1): keep only rows that classify as SH or TH
      AND (
              (
                     (ISNULL(p.property_program, '') = 'Affordable Housing Management' AND ISNULL(p.property_sub_program, '') = 'Rotorua Lakes Council')
                  OR (ISNULL(p.property_program, '') = 'Affordable Rental'             AND ISNULL(p.property_sub_program, '') = 'Affordable Rental')
                  OR (ISNULL(p.property_program, '') = 'Boarding'                      AND ISNULL(p.property_sub_program, '') = 'Residential Services Boarding')
                  OR (ISNULL(p.property_program, '') = 'IRRS'                          AND ISNULL(p.property_sub_program, '') IN (
                          'CCP (Creating Positive Pathways Spot)',
                          'Housing First (SPOT)',
                          'Social Housing (Capacity)',
                          'Social Housing (SPOT)',
                          'Social Housing TM'
                      ))
              )
           OR (
                     ISNULL(p.property_program, '')           = 'Transitional Housing'
                 AND ISNULL(p.property_sub_program, '')       = 'Transitional Housing'
                 AND ISNULL(p.property_sub_property_type, '') <> 'Office'
              )
          )
      -- A resolvable service is required (kpi.ds_snapshot_tenancy_current.dim_service_key is NOT NULL); matches sp_39/sp_63
      AND COALESCE(vw_dim_service.dim_service_key, dim_service_2.dim_service_key) IS NOT NULL;

    CREATE CLUSTERED INDEX IX_BaseTenancies ON #BaseTenancies(property_tenancy_id);

    -------------------------------------------------------------------------------
    -- Temp Table 6: #MainApplicant - one row per tenancy, occupant_is_main_applicant_flag = 1 only, no
    -- fallback. Live occupants via property_tenant_is_delete_flag (the fact has no DWHIsCurrent).
    -- occupant_statecode is NULL on every scored row, so it cannot be used here.
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#MainApplicant') IS NOT NULL DROP TABLE #MainApplicant;

    SELECT
        ma.property_tenancy_id,
        ma.date_of_birth,
        ma.gender_label,
        ma.ethnicity_name,
        ma.emergency_contact_flag,
        ma.social_works_number_flag,
        ma.iwi_affiliation_flag
    INTO #MainApplicant
    FROM (
        SELECT
            f.property_tenancy_id,
            f.property_tenancy_tenant_date_of_birth AS date_of_birth,
            f.occupant_gender_label                 AS gender_label,
            f.property_tenant_ethnicity_name        AS ethnicity_name,
            f.occupant_emergency_contact_flag       AS emergency_contact_flag,
            f.occupant_social_works_number_flag     AS social_works_number_flag,
            f.occupant_iwi_affiliation_flag         AS iwi_affiliation_flag,
            ROW_NUMBER() OVER (
                PARTITION BY f.property_tenancy_id
                ORDER BY f.property_tenant_modified_datetime DESC, f.fact_property_tenant_key DESC
            ) AS rn
        FROM edw.fact_property_tenant f
        WHERE f.property_tenancy_id IS NOT NULL
          AND f.DWHDMLOperation <> 'D'                       -- exclude warehouse-deleted occupant rows
          AND ISNULL(f.property_tenant_is_delete_flag, 0) = 0
          AND f.occupant_is_main_applicant_flag = 1
    ) ma
    WHERE ma.rn = 1;

    CREATE CLUSTERED INDEX IX_MainApplicant ON #MainApplicant(property_tenancy_id);

    -------------------------------------------------------------------------------
    -- Temp Table 7: #Scored - the Table 3 flags plus the six MUST components. INNER JOIN enforces the
    -- strict main-applicant rule.
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#Scored') IS NOT NULL DROP TABLE #Scored;

    SELECT
        bt.dim_company_key,
        bt.property_tenancy_id,
        bt.dim_property_tenancy_key,
        bt.dim_service_key,
        bt.service_id,
        bt.tenancy_type,
        CASE
            WHEN ma.date_of_birth IS NOT NULL
             AND NULLIF(LTRIM(RTRIM(x.gender_effective)), '') IS NOT NULL   -- v1.6: primary contact, else house row
             AND NULLIF(LTRIM(RTRIM(ma.ethnicity_name)), '')  IS NOT NULL
             AND ISNULL(ma.emergency_contact_flag, 0) = 1
             -- Tenancy Manager (tenancy record) matches Assigned Tenancy Manager (property record)
             AND NULLIF(LTRIM(RTRIM(bt.property_tenancy_manager_name)), '')      IS NOT NULL
             AND NULLIF(LTRIM(RTRIM(bt.property_assigned_tenancy_manager)), '')  IS NOT NULL
             AND LTRIM(RTRIM(bt.property_tenancy_manager_name)) = LTRIM(RTRIM(bt.property_assigned_tenancy_manager))
             -- Recordbase ID required for TH tenancies only
             AND (
                   bt.tenancy_type = 'SH'
                OR (bt.tenancy_type = 'TH' AND NULLIF(LTRIM(RTRIM(bt.property_tenancy_primary_tenant_recordbaseid)), '') IS NOT NULL)
                 )
            THEN 1 ELSE 0
        END AS must_have_flag,
        CASE WHEN ISNULL(ma.social_works_number_flag, 0) = 1 THEN 1 ELSE 0 END AS should_have_flag,
        CASE WHEN ISNULL(ma.iwi_affiliation_flag, 0)     = 1 THEN 1 ELSE 0 END AS could_have_flag,
        -- Projections of the SAME predicates as the CASE above, so the text can name the failed component.
        -- Change both together (as 1.5 did for gender); never re-derive must_have_flag from these.
        CAST(CASE WHEN ma.date_of_birth IS NOT NULL                            THEN 1 ELSE 0 END AS TINYINT) AS c_dob,
        CAST(CASE WHEN NULLIF(LTRIM(RTRIM(x.gender_effective)), '') IS NOT NULL THEN 1 ELSE 0 END AS TINYINT) AS c_gender,
        CAST(CASE WHEN NULLIF(LTRIM(RTRIM(ma.ethnicity_name)), '') IS NOT NULL THEN 1 ELSE 0 END AS TINYINT) AS c_ethnicity,
        CAST(CASE WHEN ISNULL(ma.emergency_contact_flag, 0) = 1                THEN 1 ELSE 0 END AS TINYINT) AS c_emergency_contact,
        CAST(CASE WHEN NULLIF(LTRIM(RTRIM(bt.property_tenancy_manager_name)), '')     IS NOT NULL
                   AND NULLIF(LTRIM(RTRIM(bt.property_assigned_tenancy_manager)), '') IS NOT NULL
                   AND LTRIM(RTRIM(bt.property_tenancy_manager_name)) = LTRIM(RTRIM(bt.property_assigned_tenancy_manager))
                                                                               THEN 1 ELSE 0 END AS TINYINT) AS c_tm_match,
        CAST(CASE WHEN bt.tenancy_type = 'SH'                                  THEN 1
                  WHEN bt.tenancy_type = 'TH'
                   AND NULLIF(LTRIM(RTRIM(bt.property_tenancy_primary_tenant_recordbaseid)), '') IS NOT NULL
                                                                               THEN 1
                  ELSE 0 END AS TINYINT)                                                                     AS c_recordbase
        -- PII FLOOR: c_tm_match carries the comparison of two staff names as a flag; the names stop here.
        -- The reason text is shown across services in Power BI - a manager's name in it is not acceptable.
    INTO #Scored
    FROM #BaseTenancies bt
    INNER JOIN #MainApplicant ma
        ON ma.property_tenancy_id = bt.property_tenancy_id
    -- v1.6 GENDER SOURCE: the primary contact's gender (vw_dim_property_tenancy) first - the contact record is
    -- the source of truth for tenant details - else the household-member row. The ODS stamps
    -- 'Unspecified/Unknown' on every non-primary contact, so that literal is load-bearing. The KPI tests
    -- presence only, so the order changes no score; it changes which value wins on the 11 tenancies where
    -- the two records disagree. Effect vs v1.4 (2026-09-10): 220 of 228 blanks recovered, 96 Red -> Green,
    -- 1 -> Amber. The proper fix is the ETL view reading hc.zav_gender; this becomes a no-op if that ships.
    CROSS APPLY (VALUES (
        COALESCE(NULLIF(NULLIF(LTRIM(RTRIM(bt.property_tenancy_primary_tenant_gender)), ''), 'Unspecified/Unknown'),
                 NULLIF(LTRIM(RTRIM(ma.gender_label)), ''))
    )) AS x(gender_effective);

    CREATE CLUSTERED INDEX IX_Scored ON #Scored(property_tenancy_id);

    -------------------------------------------------------------------------------
    -- REASON TEXT (Temp Tables 8-11). Cannot move a flag, a value or a status.
    -- ROW-LOSS TRAP: Green and Amber have NO gap rows, so every join from #Scored onto this chain MUST
    -- be LEFT - an INNER JOIN silently deletes them all and no test would notice. (#Scored's own join
    -- to #MainApplicant is INNER and must stay so.)
    -------------------------------------------------------------------------------
    -- Temp Table 8: #GapItem - one row per failed component, in phrase order. TM is not in this list;
    -- it renders as a clause in #Reason. Keep every branch a literal - a NULL item corrupts the join.
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#GapItem') IS NOT NULL DROP TABLE #GapItem;

    SELECT
        sc.property_tenancy_id,
        i.ord,
        CAST(i.item_text AS VARCHAR(40)) AS item_text
    INTO #GapItem
    FROM #Scored sc
    CROSS APPLY (VALUES
        (1, CAST('DOB'               AS VARCHAR(40)), CASE WHEN sc.c_dob               = 0 THEN 1 ELSE 0 END),
        (2, CAST('Gender'            AS VARCHAR(40)), CASE WHEN sc.c_gender            = 0 THEN 1 ELSE 0 END),
        (3, CAST('Ethnicity'         AS VARCHAR(40)), CASE WHEN sc.c_ethnicity         = 0 THEN 1 ELSE 0 END),
        -- 'Emergency Contact' per the footnote of her table; her N.B. says 'Emergency Details' - still open.
        (4, CAST('Emergency Contact' AS VARCHAR(40)), CASE WHEN sc.c_emergency_contact = 0 THEN 1 ELSE 0 END),
        -- SH GUARD: redundant (c_recordbase auto-passes SH) but makes 'RecordBase is never named on SH'
        -- explicit. Tests that an ID is RECORDED in Zavanti; never reads RecordBase.
        (5, CAST('RecordBase ID'     AS VARCHAR(40)), CASE WHEN sc.c_recordbase = 0 AND sc.tenancy_type = 'TH' THEN 1 ELSE 0 END)
    ) AS i(ord, item_text, is_gap)
    WHERE i.is_gap = 1;

    CREATE CLUSTERED INDEX IX_GapItem ON #GapItem(property_tenancy_id, ord);

    -------------------------------------------------------------------------------
    -- Temp Table 9: #GapList - AE as one string, ', ' between pairs and ' & ' before the last. The
    -- separator is positional, so it is folded into the item and aggregated with ''. WITHIN GROUP
    -- (ORDER BY ord) is not optional. VARCHAR(100) is looser than the 57-character maximum on purpose.
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#GapList') IS NOT NULL DROP TABLE #GapList;

    SELECT
        r.property_tenancy_id,
        CAST(STRING_AGG(
                 CASE WHEN r.item_pos = 1            THEN r.item_text
                      WHEN r.item_pos = r.item_count THEN CONCAT(' & ', r.item_text)
                      ELSE                                CONCAT(', ',  r.item_text)
                 END, '') WITHIN GROUP (ORDER BY r.ord) AS VARCHAR(100)) AS gap_list,
        MAX(r.item_count) AS item_count
    INTO #GapList
    FROM (
        SELECT
            g.property_tenancy_id,
            g.ord,
            g.item_text,
            CAST(ROW_NUMBER() OVER (PARTITION BY g.property_tenancy_id ORDER BY g.ord) AS INT) AS item_pos,
            CAST(COUNT(*)     OVER (PARTITION BY g.property_tenancy_id)                AS INT) AS item_count
        FROM #GapItem g
    ) r
    GROUP BY r.property_tenancy_id;

    CREATE CLUSTERED INDEX IX_GapList ON #GapList(property_tenancy_id);

    -------------------------------------------------------------------------------
    -- Temp Table 10: #Tail - the SWN / iwi prompt, one row per scored tenancy (Green/Amber ignore it).
    -- One expression covers Table 6 rows 5-12; it asks for what is MISSING (flag = 0). Do not
    -- reintroduce a toggle here - v1.3's was invisible to every check in the suite.
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#Tail') IS NOT NULL DROP TABLE #Tail;

    SELECT
        sc.property_tenancy_id,
        CAST(x.tail_text AS VARCHAR(60)) AS tail_text
    INTO #Tail
    FROM #Scored sc
    CROSS APPLY (VALUES (
        CASE
            -- Both captured: nothing to prompt for.
            WHEN sc.should_have_flag = 1 AND sc.could_have_flag = 1
                THEN ''
            -- Neither captured: the 46-character tail the 150 worst case is built on.
            WHEN sc.should_have_flag = 0 AND sc.could_have_flag = 0
                THEN ' Then add SWN & iwi affiliation (if relevant).'
            -- SWN captured, iwi not (Table 6 rows 6 and 11).
            WHEN sc.should_have_flag = 1
                THEN ' Then add iwi affiliation (if relevant).'
            -- iwi captured, SWN not (Table 6 rows 7 and 10).
            ELSE     ' Then add SWN.'
        END
    )) AS x(tail_text);

    CREATE CLUSTERED INDEX IX_Tail ON #Tail(property_tenancy_id);

    -------------------------------------------------------------------------------
    -- Temp Table 11: #Reason - one message per scored tenancy. LEFT JOINs only, so it is total over #Scored.
    -- BRANCH ORDER IS LOAD-BEARING: the four must_have_flag = 1 branches must come first, S4 last.
    --   S1  AE empty, TM failed   'Ensure Tenancy & Property TM values match.'             (rows 5-8)
    --   S2  AE, TM failed         'Add ' + AE + ' & ensure Tenancy/Property TM values match.'
    --   S3  AE, TM ok             'Add ' + AE + '.'                                        (rows 9-12)
    --   S4  nothing failed        'Review key details.'   defensive - must measure 0 rows
    -- CONCAT, never '+': the LEFT JOINs make NULL operands possible. The index is UNIQUE so a duplicate
    -- grain raises Msg 1505 instead of quietly inflating the Table 5 denominator. VARCHAR(400) > CAST 255
    -- > landing 200 > staging 80: each layer wider than the next, so an oversized string is seen, not clipped.
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#Reason') IS NOT NULL DROP TABLE #Reason;

    SELECT
        sc.property_tenancy_id,
        x.reason_text
    INTO #Reason
    FROM #Scored sc
    LEFT JOIN #GapList gl
        ON gl.property_tenancy_id = sc.property_tenancy_id
    LEFT JOIN #Tail t
        ON t.property_tenancy_id = sc.property_tenancy_id
    CROSS APPLY (VALUES (CAST(
        CASE
            -- Table 6 row 1. 'you''ve' is T-SQL escaping - never re-paste this line from a document that
            -- substitutes the typographic apostrophe; the file is pure ASCII by policy.
            WHEN sc.must_have_flag = 1 AND sc.should_have_flag = 1 AND sc.could_have_flag = 1
                THEN 'Great work, you''ve captured all key details.'
            -- Table 6 row 2. Says 'Add', not 'Now add' or 'Then add' - reproduced exactly.
            WHEN sc.must_have_flag = 1 AND sc.should_have_flag = 1 AND sc.could_have_flag = 0
                THEN 'All key details have been captured. Add iwi affiliation (if relevant).'
            -- Table 6 row 3. Amber, iwi captured. 48 characters.
            WHEN sc.must_have_flag = 1 AND sc.should_have_flag = 0 AND sc.could_have_flag = 1
                THEN 'All key details have been captured. Now add SWN.'
            -- Table 6 row 4. Exactly 80 characters - fits the staging column with nothing to spare.
            WHEN sc.must_have_flag = 1 AND sc.should_have_flag = 0 AND sc.could_have_flag = 0
                THEN 'All key details have been captured. Now add SWN & iwi affiliation (if relevant).'
            -- S1: Table 6 rows 5-8. 'Tenancy & Property' / 'Ensure' here vs 'Tenancy/Property' / 'ensure' in S2 - as written.
            WHEN gl.gap_list IS NULL AND sc.c_tm_match = 0
                THEN CONCAT('Ensure Tenancy & Property TM values match.', t.tail_text)
            -- S2: Table 6 rows 9-12 where the TM component ALSO failed.
            WHEN gl.gap_list IS NOT NULL AND sc.c_tm_match = 0
                THEN CONCAT('Add ', gl.gap_list, ' & ensure Tenancy/Property TM values match.', t.tail_text)
            -- S3: Table 6 rows 9-12 with the TM values matching.
            WHEN gl.gap_list IS NOT NULL
                THEN CONCAT('Add ', gl.gap_list, '.', t.tail_text)
            -- S4: defensive, must sit LAST and must measure 0 rows (a hit means tenancy_type broke).
            ELSE CONCAT('Review key details.', t.tail_text)
        END AS VARCHAR(400)))) AS x(reason_text);

    CREATE UNIQUE CLUSTERED INDEX IX_Reason ON #Reason(property_tenancy_id);

    -------------------------------------------------------------------------------
    -- Final SELECT - 12 columns in the load-bearing order (INSERT...EXEC binds by position).
    -------------------------------------------------------------------------------
    SELECT
        sk.dim_kpi_key,
        sc.dim_company_key,
        sc.dim_property_tenancy_key,
        sc.dim_service_key,
        CONCAT('888', '_', sc.property_tenancy_id, '_', sc.service_id, '_', sc.dim_company_key) AS entity_key,
        @KPI_ID AS kpi_id,
        sc.property_tenancy_id,
        sc.service_id,
        CAST(CASE WHEN sc.must_have_flag = 1 AND sc.should_have_flag = 1 THEN 1 ELSE 0 END AS NUMERIC(8, 2)) AS kpi_value,
        -- 10th column, generated in #Reason. The CAST is VARCHAR(255) on purpose: a CAST to the wall would
        -- truncate silently and blind the width tests. The bound is 150 by enumeration; this must never fire.
        CAST(rs.reason_text AS VARCHAR(255)) AS user_friendly_score_explanation,
        CAST(
            CASE
                WHEN sc.must_have_flag = 1 AND sc.should_have_flag = 1 THEN 3   -- Green
                WHEN sc.must_have_flag = 1 AND sc.should_have_flag = 0 THEN 2   -- Amber
                ELSE 1                                                          -- Red
            END AS TINYINT
        ) AS kpi_status,
        @SnapshotDate AS snapshot_date
    FROM #Scored sc
    CROSS JOIN #SelectedKPI sk    -- population = #Scored (Table 1/2 + main applicant); no service-type gate
    LEFT JOIN #Reason rs          -- total over #Scored by construction; LEFT so it cannot drop a tenancy
        ON rs.property_tenancy_id = sc.property_tenancy_id;

END