
CREATE   PROCEDURE [data_monitoring].[update_client_obfuscation_status]
(
      @RetentionYears INT  = 7
    , @AsAtDate       DATE = NULL
)
AS
BEGIN

    /**********************************************************************************************************
        NAME:      data_monitoring.update_client_obfuscation_status
        PURPOSE:   Stage per-client, per-company obfuscation status based on last interaction dates.

        Assumptions:
        1. Integer date keys are YYYYMMDD.
        2. fact_client_account_activity.primary_contact_id is the client_id.
        3. This procedure only stages the decision; it does not obfuscate data itself.
        4. Individual date columns below are a straight MAX(...) per client+company (nulls ignored),
           independent of the priority cascades used for last_*_date columns.
        5. fact_client_person_relationship.*_date fields are stored as INT (YYYYMMDD) despite no "_key"
           suffix – converted accordingly.
        6. Sources are staged into #temp tables (each scanned once, clustered PK on client_id+company_id)
           to avoid re-evaluating complex CTE logic.

        Revisions:
        Version   Date         Author          Description
        -------   ----------   --------------  ---------------------------------------
        1.0       2026-05-11   Greg Nuthall    Initial version
        1.1       2026-09-17   (Assistant)     Client+company grain, new date columns, person relationships
        1.2       2026-09-22   Greg Nuthall    Added fact_client_relationship to client_person_relatinship data
    **********************************************************************************************************/

    SET NOCOUNT ON;

    IF @AsAtDate IS NULL
    BEGIN
        SET @AsAtDate = CAST(GETDATE() AS DATE);
    END;

    DECLARE @ObfuscationCutoffDate DATE = DATEADD(YEAR, -@RetentionYears, @AsAtDate);

    TRUNCATE TABLE data_monitoring.client_obfuscation_status;

    /* ==========================================================================================
       1. Account activity (fact_client_account_activity)
       ========================================================================================== */
    CREATE TABLE #tmp_account_activity
    (
          client_id                         INT       NOT NULL
        , company_id                        INT       NOT NULL
        , last_account_activity_date        DATETIME  NULL
        , client_account_activity_created_date DATETIME NULL
        , client_account_activity_start_date   DATETIME NULL
        , client_account_activity_end_date     DATETIME NULL
        , CONSTRAINT PK_tmp_account_activity PRIMARY KEY CLUSTERED (client_id, company_id)
    );

    INSERT INTO #tmp_account_activity
    (
          client_id
        , company_id
        , last_account_activity_date
        , client_account_activity_created_date
        , client_account_activity_start_date
        , client_account_activity_end_date
    )
    SELECT
          faa.primary_contact_id                           AS client_id
        , faa.dim_company_key                              AS company_id
        , MAX(CAST(COALESCE(faa.client_account_activity_end_date,
                           faa.client_account_activity_start_date,
                           faa.client_account_activity_created_date) AS DATETIME)) AS last_account_activity_date
        , MAX(CAST(faa.client_account_activity_created_date AS DATETIME)) AS client_account_activity_created_date
        , MAX(CAST(faa.client_account_activity_start_date   AS DATETIME)) AS client_account_activity_start_date
        , MAX(CAST(faa.client_account_activity_end_date     AS DATETIME)) AS client_account_activity_end_date
    FROM edw.fact_client_account_activity faa
    WHERE faa.primary_contact_id IS NOT NULL
      AND faa.dim_company_key IS NOT NULL
      AND ISNULL(faa.DWHIsCurrent, 1) = 1
      AND faa.DWHDMLOperation <> 'D'
      AND COALESCE(faa.client_account_activity_end_date,
                   faa.client_account_activity_start_date,
                   faa.client_account_activity_created_date) IS NOT NULL
    GROUP BY faa.primary_contact_id, faa.dim_company_key;

    /* ==========================================================================================
       2. Activity breakdown (fact_client_activity_breakdown)
       ========================================================================================== */
    CREATE TABLE #tmp_activity_breakdown
    (
          client_id                              INT       NOT NULL
        , company_id                             INT       NOT NULL
        , last_activity_breakdown_date           DATETIME  NULL
        , client_activity_breakdown_created_date DATETIME  NULL
        , client_activity_start_date             DATETIME  NULL
        , client_activity_end_date               DATETIME  NULL
        , client_activity_created_date           DATETIME  NULL
        , CONSTRAINT PK_tmp_activity_breakdown PRIMARY KEY CLUSTERED (client_id, company_id)
    );

    INSERT INTO #tmp_activity_breakdown
    (
          client_id
        , company_id
        , client_activity_breakdown_created_date
        , client_activity_start_date
        , client_activity_end_date
        , client_activity_created_date
    )
    SELECT
          fab.client_id
        , fab.dim_company_key
        , MAX(CAST(fab.client_activity_breakdown_created_date AS DATETIME))
        , MAX(CAST(fab.client_activity_start_date             AS DATETIME))
        , MAX(CAST(fab.client_activity_end_date               AS DATETIME))
        , MAX(CAST(fab.client_activity_created_date           AS DATETIME))
    FROM edw.fact_client_activity_breakdown fab
    WHERE fab.client_id IS NOT NULL
      AND fab.dim_company_key IS NOT NULL
    GROUP BY fab.client_id, fab.dim_company_key;

    -- Derive last_activity_breakdown_date from the staged fields
    UPDATE tab
    SET last_activity_breakdown_date = va.max_date
    FROM #tmp_activity_breakdown tab
    CROSS APPLY
    (
        SELECT MAX(d) AS max_date
        FROM (VALUES (tab.client_activity_breakdown_created_date),
                     (tab.client_activity_start_date),
                     (tab.client_activity_end_date),
                     (tab.client_activity_created_date)) v(d)
    ) va;

    /* ==========================================================================================
       3. Referral (fact_client_referral_V2) – cascade + raw maxes
       ========================================================================================== */
    CREATE TABLE #tmp_referral
    (
          client_id                                  INT       NOT NULL
        , company_id                                 INT       NOT NULL
        , last_referral_date                         DATETIME  NULL
        , client_referral_created_date               DATETIME  NULL
        , client_referral_discharge_date             DATETIME  NULL
        , client_referral_end_date                   DATETIME  NULL
        , client_referral_person_relationship_end_date DATETIME NULL
        , client_referral_accepted_date              DATETIME  NULL
        , client_referral_decline_date               DATETIME  NULL
        , client_referral_pending_date               DATETIME  NULL
        , CONSTRAINT PK_tmp_referral PRIMARY KEY CLUSTERED (client_id, company_id)
    );

    INSERT INTO #tmp_referral
    (
          client_id
        , company_id
        , last_referral_date
        , client_referral_created_date
        , client_referral_discharge_date
        , client_referral_end_date
        , client_referral_person_relationship_end_date
        , client_referral_accepted_date
        , client_referral_decline_date
        , client_referral_pending_date
    )
    SELECT
          staged.client_id
        , staged.company_id
        , MAX(staged.chosen_referral_date)           AS last_referral_date
        , MAX(staged.created_dt)                     AS client_referral_created_date
        , MAX(staged.discharge_dt)                   AS client_referral_discharge_date
        , MAX(staged.end_dt)                         AS client_referral_end_date
        , MAX(staged.person_rel_end_dt)              AS client_referral_person_relationship_end_date
        , MAX(staged.accepted_dt)                    AS client_referral_accepted_date
        , MAX(staged.decline_dt)                     AS client_referral_decline_date
        , MAX(staged.pending_dt)                     AS client_referral_pending_date
    FROM
    (
        SELECT
              fr.client_id
            , fr.dim_company_key                                      AS company_id
            , CAST(x.chosen_date AS DATETIME)                         AS chosen_referral_date
            , CAST(TRY_CONVERT(DATE, CONVERT(CHAR(8), fr.client_referral_created_date_key      ), 112) AS DATETIME) AS created_dt
            , CAST(TRY_CONVERT(DATE, CONVERT(CHAR(8), fr.client_referral_discharge_date_key     ), 112) AS DATETIME) AS discharge_dt
            , CAST(TRY_CONVERT(DATE, CONVERT(CHAR(8), fr.client_referral_end_date_key           ), 112) AS DATETIME) AS end_dt
            , CAST(TRY_CONVERT(DATE, CONVERT(CHAR(8), fr.client_referral_person_relationship_end_date_key), 112) AS DATETIME) AS person_rel_end_dt
            , CAST(TRY_CONVERT(DATE, CONVERT(CHAR(8), fr.client_referral_accepted_date_key      ), 112) AS DATETIME) AS accepted_dt
            , CAST(TRY_CONVERT(DATE, CONVERT(CHAR(8), fr.client_referral_decline_date_key       ), 112) AS DATETIME) AS decline_dt
            , CAST(TRY_CONVERT(DATE, CONVERT(CHAR(8), fr.client_referral_pending_date_key       ), 112) AS DATETIME) AS pending_dt
        FROM edw.fact_client_referral_V2 fr
        OUTER APPLY
        (
            SELECT TOP (1)
                   d.chosen_date
            FROM
            (
                VALUES
                      (1, TRY_CONVERT(DATE, CONVERT(CHAR(8), fr.client_referral_discharge_date_key       ), 112))
                    , (2, TRY_CONVERT(DATE, CONVERT(CHAR(8), fr.client_referral_end_date_key             ), 112))
                    , (3, TRY_CONVERT(DATE, CONVERT(CHAR(8), fr.client_referral_person_relationship_end_date_key ), 112))
                    , (4, TRY_CONVERT(DATE, CONVERT(CHAR(8), fr.client_referral_accepted_date_key        ), 112))
                    , (4, TRY_CONVERT(DATE, CONVERT(CHAR(8), fr.client_referral_decline_date_key         ), 112))
                    , (5, TRY_CONVERT(DATE, CONVERT(CHAR(8), fr.client_referral_waitlist_date_key        ), 112))
                    , (5, TRY_CONVERT(DATE, CONVERT(CHAR(8), fr.client_referral_pending_date_key         ), 112))
                    , (6, TRY_CONVERT(DATE, CONVERT(CHAR(8), fr.client_referral_received_date_key        ), 112))
                    , (7, TRY_CONVERT(DATE, CONVERT(CHAR(8), fr.client_referral_created_date_key         ), 112))
                    , (8, TRY_CONVERT(DATE, CONVERT(CHAR(8), fr.client_referral_person_relationship_start_date_key ), 112))
            ) d(priority_order, chosen_date)
            WHERE d.chosen_date IS NOT NULL
            ORDER BY d.priority_order ASC, d.chosen_date DESC
        ) x
        WHERE fr.client_id IS NOT NULL
          AND fr.dim_company_key IS NOT NULL
          AND x.chosen_date IS NOT NULL
    ) staged
    GROUP BY staged.client_id, staged.company_id;

    /* ==========================================================================================
       4a. Referral goals (fact_client_referral_goal)
       ========================================================================================== */
    CREATE TABLE #tmp_goal
    (
          client_id                      INT       NOT NULL
        , company_id                     INT       NOT NULL
        , last_goal_date                 DATETIME  NULL
        , client_referral_goal_start_date   DATETIME  NULL
        , client_referral_goal_end_date     DATETIME  NULL
        , client_referral_goal_created_date DATETIME  NULL
        , CONSTRAINT PK_tmp_goal PRIMARY KEY CLUSTERED (client_id, company_id)
    );

    INSERT INTO #tmp_goal
    (
          client_id
        , company_id
        , last_goal_date
        , client_referral_goal_start_date
        , client_referral_goal_end_date
        , client_referral_goal_created_date
    )
    SELECT
          fg.client_id
        , fg.dim_company_key
        , MAX(CAST(x.chosen_date AS DATETIME)) AS last_goal_date
        , MAX(CAST(TRY_CONVERT(DATE, CONVERT(CHAR(8), fg.client_referral_goal_start_date_key   ), 112) AS DATETIME))
        , MAX(CAST(TRY_CONVERT(DATE, CONVERT(CHAR(8), fg.client_referral_goal_end_date_key     ), 112) AS DATETIME))
        , MAX(CAST(TRY_CONVERT(DATE, CONVERT(CHAR(8), fg.client_referral_goal_created_date_key ), 112) AS DATETIME))
    FROM edw.fact_client_referral_goal fg
    OUTER APPLY
    (
        SELECT TOP (1)
               d.chosen_date
        FROM
        (
            VALUES
                  (1, TRY_CONVERT(DATE, CONVERT(CHAR(8), fg.client_referral_goal_end_date_key   ), 112))
                , (2, TRY_CONVERT(DATE, CONVERT(CHAR(8), fg.client_referral_goal_start_date_key ), 112))
                , (3, TRY_CONVERT(DATE, CONVERT(CHAR(8), fg.client_referral_goal_created_date_key), 112))
        ) d(priority_order, chosen_date)
        WHERE d.chosen_date IS NOT NULL
        ORDER BY d.priority_order ASC, d.chosen_date DESC
    ) x
    WHERE fg.client_id IS NOT NULL
      AND fg.dim_company_key IS NOT NULL
      AND x.chosen_date IS NOT NULL
    GROUP BY fg.client_id, fg.dim_company_key;

    /* ==========================================================================================
       4b. Personal goals (fact_client_personal_goal)
       ========================================================================================== */
    CREATE TABLE #tmp_goal_personal
    (
          client_id                                      INT       NOT NULL
        , company_id                                     INT       NOT NULL
        , client_personal_goal_created_date              DATETIME  NULL
        , client_personal_plan_start_date                DATETIME  NULL
        , client_personal_plan_end_date                  DATETIME  NULL
        , client_personal_goal_start_date                DATETIME  NULL
        , client_personal_goal_due_date                  DATETIME  NULL
        , client_personal_goal_action_due_date           DATETIME  NULL
        , client_personal_goal_action_completed_date     DATETIME  NULL
        , client_personal_goal_close_completed_date      DATETIME  NULL
        , client_personal_goal_close_not_completed_date  DATETIME  NULL
        , client_personal_goal_close_date                DATETIME  NULL
        , CONSTRAINT PK_tmp_goal_personal PRIMARY KEY CLUSTERED (client_id, company_id)
    );

    INSERT INTO #tmp_goal_personal
    (
          client_id
        , company_id
        , client_personal_goal_created_date
        , client_personal_plan_start_date
        , client_personal_plan_end_date
        , client_personal_goal_start_date
        , client_personal_goal_due_date
        , client_personal_goal_action_due_date
        , client_personal_goal_action_completed_date
        , client_personal_goal_close_completed_date
        , client_personal_goal_close_not_completed_date
        , client_personal_goal_close_date
    )
    SELECT
          pg.client_id
        , pg.dim_company_key
        , MAX(CAST(TRY_CONVERT(DATE, CONVERT(CHAR(8), pg.client_personal_goal_created_date_key             ), 112) AS DATETIME))
        , MAX(CAST(TRY_CONVERT(DATE, CONVERT(CHAR(8), pg.client_personal_plan_start_date_key               ), 112) AS DATETIME))
        , MAX(CAST(TRY_CONVERT(DATE, CONVERT(CHAR(8), pg.client_personal_plan_end_date_key                 ), 112) AS DATETIME))
        , MAX(CAST(TRY_CONVERT(DATE, CONVERT(CHAR(8), pg.client_personal_goal_start_date_key               ), 112) AS DATETIME))
        , MAX(CAST(TRY_CONVERT(DATE, CONVERT(CHAR(8), pg.client_personal_goal_due_date_key                 ), 112) AS DATETIME))
        , MAX(CAST(TRY_CONVERT(DATE, CONVERT(CHAR(8), pg.client_personal_goal_action_due_date_key          ), 112) AS DATETIME))
        , MAX(CAST(TRY_CONVERT(DATE, CONVERT(CHAR(8), pg.client_personal_goal_action_completed_date_key    ), 112) AS DATETIME))
        , MAX(CAST(TRY_CONVERT(DATE, CONVERT(CHAR(8), pg.client_personal_goal_close_completed_date_key     ), 112) AS DATETIME))
        , MAX(CAST(TRY_CONVERT(DATE, CONVERT(CHAR(8), pg.client_personal_goal_close_not_completed_date_key ), 112) AS DATETIME))
        , MAX(CAST(TRY_CONVERT(DATE, CONVERT(CHAR(8), pg.client_personal_goal_close_date_key               ), 112) AS DATETIME))
    FROM edw.fact_client_personal_goal pg
    WHERE pg.client_id IS NOT NULL
      AND pg.dim_company_key IS NOT NULL
    GROUP BY pg.client_id, pg.dim_company_key;

    /* ==========================================================================================
       5. Assessment (fact_client_assessment_outcome)
       ========================================================================================== */
    CREATE TABLE #tmp_assessment
(
      client_id             INT       NOT NULL
    , company_id            INT       NOT NULL
    , last_assessment_date  DATETIME  NULL
    , response_created_date DATETIME  NULL
    , CONSTRAINT PK_tmp_assessment PRIMARY KEY CLUSTERED (client_id, company_id)
);

INSERT INTO #tmp_assessment
(
      client_id
    , company_id
    , last_assessment_date
    , response_created_date
)
SELECT
      fao.client_id
    , fao.dim_company_key
    , MAX(CAST(fao.response_created_date AS DATETIME)) AS last_assessment_date
    , MAX(CAST(fao.response_created_date AS DATETIME)) AS response_created_date
FROM edw.fact_client_assessment_outcome fao
WHERE fao.client_id IS NOT NULL
  AND fao.dim_company_key IS NOT NULL
  AND ISNULL(fao.DWHIsCurrent, 1) = 1
GROUP BY fao.client_id, fao.dim_company_key;

    /* ==========================================================================================
       6. Incident (fact_client_incident + fact_client_incident_person)
       ========================================================================================== */
    CREATE TABLE #tmp_incident
    (
          client_id             INT       NOT NULL
        , company_id            INT       NOT NULL
        , last_incident_date    DATETIME  NULL
        , incident_date         DATETIME  NULL
        , incident_created_date DATETIME  NULL
        , CONSTRAINT PK_tmp_incident PRIMARY KEY CLUSTERED (client_id, company_id)
    );

    INSERT INTO #tmp_incident
    (
          client_id
        , company_id
        , last_incident_date
        , incident_date
        , incident_created_date
    )
    SELECT
          staged.client_id
        , staged.dim_company_key AS company_id
        , MAX(staged.chosen_incident_date)
        , MAX(staged.incident_dt)
        , MAX(staged.incident_created_dt)
    FROM
    (
        SELECT
              cip.client_id
            , cip.dim_company_key
            , x.chosen_incident_date
            , CAST(fi.incident_date        AS DATETIME) AS incident_dt
            , CAST(fi.incident_created_date AS DATETIME) AS incident_created_dt
        FROM edw.fact_client_incident fi
        INNER JOIN edw.fact_client_incident_person cip
            ON fi.dim_company_key         = cip.dim_company_key
           AND fi.dim_client_incident_key = cip.dim_client_incident_key
        OUTER APPLY
        (
            SELECT TOP (1)
                   d.chosen_incident_date
            FROM
            (
                VALUES
                      (1, CAST(fi.current_incident_status_created_date AS DATETIME))
                    , (2, CAST(fi.incident_date                        AS DATETIME))
                    , (3, CAST(fi.incident_created_date                AS DATETIME))
            ) d(priority_order, chosen_incident_date)
            WHERE d.chosen_incident_date IS NOT NULL
            ORDER BY d.priority_order ASC, d.chosen_incident_date DESC
        ) x
        WHERE cip.client_id IS NOT NULL
          AND cip.dim_company_key IS NOT NULL
          AND ISNULL(fi.DWHIsCurrent, 1) = 1
          AND ISNULL(cip.DWHIsCurrent, 1) = 1
          AND x.chosen_incident_date IS NOT NULL
    ) staged
    GROUP BY staged.client_id, staged.dim_company_key;

    /* ==========================================================================================
       7. Relationships (fact_client_relationship)
       ========================================================================================== */
    CREATE TABLE #tmp_relationship
    (
          client_id               INT       NOT NULL
        , company_id              INT       NOT NULL
        , last_relationship_date  DATETIME  NULL
        , relationship_start_date DATETIME  NULL
        , relationship_end_date   DATETIME  NULL
        , CONSTRAINT PK_tmp_relationship PRIMARY KEY CLUSTERED (client_id, company_id)
    );

    INSERT INTO #tmp_relationship
    (
          client_id
        , company_id
        , last_relationship_date
        , relationship_start_date
        , relationship_end_date
    )
    SELECT
          v.client_id
        , fr.dim_company_key
        , MAX(CAST(COALESCE(fr.relationship_end_date, fr.relationship_start_date) AS DATETIME))
        , MAX(CAST(fr.relationship_start_date AS DATETIME))
        , MAX(CAST(fr.relationship_end_date   AS DATETIME))
    FROM edw.fact_client_relationship fr
    CROSS APPLY (VALUES (fr.primary_client_id),
                        (fr.related_client_id)) v(client_id)
    WHERE v.client_id IS NOT NULL
      AND fr.dim_company_key IS NOT NULL
      AND ISNULL(fr.DWHIsCurrent, 1) = 1
      AND COALESCE(fr.relationship_end_date, fr.relationship_start_date) IS NOT NULL
    GROUP BY v.client_id, fr.dim_company_key;

    /* ==========================================================================================
       8. Person relationships (fact_client_person_relationship and fact_client_relationship) 
       ========================================================================================== */
    CREATE TABLE #tmp_person_relationship
    (
          client_id                             INT       NOT NULL
        , company_id                            INT       NOT NULL
        , client_person_relationship_start_date DATETIME  NULL
        , client_person_relationship_end_date   DATETIME  NULL
        , client_person_relationship_created_date DATETIME NULL
        , last_client_person_relationship       DATETIME  NULL
        , CONSTRAINT PK_tmp_person_relationship PRIMARY KEY CLUSTERED (client_id, company_id)
    );

    INSERT INTO #tmp_person_relationship
    (
          client_id
        , company_id
        , client_person_relationship_start_date
        , client_person_relationship_end_date
        , client_person_relationship_created_date
        , last_client_person_relationship
    )
    SELECT
          pr.client_id
        , pr.dim_company_key AS company_id
        , MAX(CAST(TRY_CONVERT(DATE, CONVERT(CHAR(8), pr.client_person_relationship_start_date), 112) AS DATETIME)) AS start_date
        , MAX(CAST(TRY_CONVERT(DATE, CONVERT(CHAR(8), pr.client_person_relationship_end_date  ), 112) AS DATETIME)) AS end_date
        , MAX(CAST(TRY_CONVERT(DATE, CONVERT(CHAR(8), pr.client_person_relationship_created_date), 112) AS DATETIME)) AS created_date
        , MAX(
            CAST(
                COALESCE(
                    TRY_CONVERT(DATE, CONVERT(CHAR(8), pr.client_person_relationship_end_date    ), 112),
                    TRY_CONVERT(DATE, CONVERT(CHAR(8), pr.client_person_relationship_start_date ), 112),
                    TRY_CONVERT(DATE, CONVERT(CHAR(8), pr.client_person_relationship_created_date), 112)
                ) AS DATETIME)
          ) AS last_client_person_relationship
    FROM edw.fact_client_person_relationship pr
    WHERE pr.client_id IS NOT NULL
      AND pr.dim_company_key IS NOT NULL
    GROUP BY pr.client_id, pr.dim_company_key

    
    INSERT INTO #tmp_person_relationship
    (
          client_id
        , company_id
        , client_person_relationship_start_date
        , client_person_relationship_end_date
        , client_person_relationship_created_date
        , last_client_person_relationship
    )

    SELECT
          pr.primary_client_id
        , pr.dim_company_key AS company_id
        , MAX(pr.relationship_start_date) AS start_date
        , MAX(pr.relationship_end_date) AS end_date
        , null AS created_date
        , MAX(
            CAST(
                COALESCE(
                    pr.relationship_start_date,
                    pr.relationship_end_date
                ) AS DATETIME)
          ) AS last_client_person_relationship
    FROM edw.fact_client_relationship pr
    left outer join #tmp_person_relationship tr on pr.primary_client_id = tr.client_id 
    and pr.dim_company_key = tr.company_id

    WHERE pr.primary_client_id IS NOT NULL
      AND pr.dim_company_key IS NOT NULL
      and tr.client_id is null
      and tr.company_id is null
    GROUP BY pr.primary_client_id, pr.dim_company_key

     
    INSERT INTO #tmp_person_relationship
    (
          client_id
        , company_id
        , client_person_relationship_start_date
        , client_person_relationship_end_date
        , client_person_relationship_created_date
        , last_client_person_relationship
    ) 

    SELECT
          pr.related_client_id
        , pr.dim_company_key AS company_id
        , MAX(pr.relationship_start_date) AS start_date
        , MAX(pr.relationship_end_date) AS end_date
        , null AS created_date
        , MAX(
            CAST(
                COALESCE(
                    pr.relationship_start_date,
                    pr.relationship_end_date
                ) AS DATETIME)
          ) AS last_client_person_relationship
    FROM edw.fact_client_relationship pr
    left outer join #tmp_person_relationship tr on pr.primary_client_id = tr.client_id 
    WHERE pr.related_client_id IS NOT NULL
      AND pr.dim_company_key IS NOT NULL
      and tr.client_id is null
      and tr.company_id is null
    GROUP BY pr.related_client_id, pr.dim_company_key


    /* ==========================================================================================
       9. Interactions (fact_client_interaction)
       ========================================================================================== */
    CREATE TABLE #tmp_interaction
    (
          client_id                  INT       NOT NULL
        , company_id                 INT       NOT NULL
        , client_interaction_date    DATETIME  NULL
        , client_interaction_created_date DATETIME NULL
        , CONSTRAINT PK_tmp_interaction PRIMARY KEY CLUSTERED (client_id, company_id)
    );

    INSERT INTO #tmp_interaction
    (
          client_id
        , company_id
        , client_interaction_date
        , client_interaction_created_date
    )
    SELECT
          fi.client_id
        , fi.dim_company_key
        , MAX(CAST(fi.client_interaction_date        AS DATETIME))
        , MAX(CAST(fi.client_interaction_created_date AS DATETIME))
    FROM edw.fact_client_interaction fi
    WHERE fi.client_id IS NOT NULL
      AND fi.dim_company_key IS NOT NULL
    GROUP BY fi.client_id, fi.dim_company_key;

    /* ==========================================================================================
       10. Base client set: dim_client plus any client+company in facts
       ========================================================================================== */
    CREATE TABLE #tmp_base_clients
    (
          client_id  INT NOT NULL
        , company_id INT NOT NULL
        , CONSTRAINT PK_tmp_base_clients PRIMARY KEY CLUSTERED (client_id, company_id)
    );

    INSERT INTO #tmp_base_clients (client_id, company_id)
    SELECT DISTINCT
           dc.client_id,
           dc.company_id
    FROM edw.dim_client dc
    WHERE dc.client_id IS NOT NULL
      AND dc.company_id IS NOT NULL
      AND ISNULL(dc.DWHIsCurrent, 1) = 1;

    INSERT INTO #tmp_base_clients (client_id, company_id)
    SELECT DISTINCT t.client_id, t.company_id
    FROM
    (
        SELECT client_id, company_id FROM #tmp_account_activity
        UNION
        SELECT client_id, company_id FROM #tmp_activity_breakdown
        UNION
        SELECT client_id, company_id FROM #tmp_referral
        UNION
        SELECT client_id, company_id FROM #tmp_goal
        UNION
        SELECT client_id, company_id FROM #tmp_goal_personal
        UNION
        SELECT client_id, company_id FROM #tmp_assessment
        UNION
        SELECT client_id, company_id FROM #tmp_incident
        UNION
        SELECT client_id, company_id FROM #tmp_relationship
        UNION
        SELECT client_id, company_id FROM #tmp_person_relationship
        UNION
        SELECT client_id, company_id FROM #tmp_interaction
    ) t
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM #tmp_base_clients bc
        WHERE bc.client_id  = t.client_id
          AND bc.company_id = t.company_id
    );

    /* ==========================================================================================
       11. Final insert into data_monitoring.client_obfuscation_status
       ========================================================================================== */
    INSERT INTO data_monitoring.client_obfuscation_status
    (
          client_id
        , company_id
        , as_at_date
        , retention_years
        , obfuscation_cutoff_date
        , last_account_activity_date
        , client_account_activity_created_date
        , client_account_activity_start_date
        , client_account_activity_end_date
        , last_activity_breakdown_date
        , client_activity_breakdown_created_date
        , client_activity_start_date
        , client_activity_end_date
        , client_activity_created_date
        , last_referral_date
        , client_referral_created_date
        , client_referral_discharge_date
        , client_referral_end_date
        , client_referral_person_relationship_end_date
        , client_referral_accepted_date
        , client_referral_decline_date
        , client_referral_pending_date
        , last_goal_date
        , client_referral_goal_start_date
        , client_referral_goal_end_date
        , client_personal_goal_created_date
        , client_personal_plan_start_date
        , client_personal_plan_end_date
        , client_personal_goal_start_date
        , client_personal_goal_due_date
        , client_personal_goal_action_due_date
        , client_personal_goal_action_completed_date
        , client_personal_goal_close_completed_date
        , client_personal_goal_close_not_completed_date
        , client_personal_goal_close_date
        , last_assessment_date
        , response_created_date
        , last_incident_date
        , incident_date
        , incident_created_date
        , last_relationship_date
        , client_person_relationship_start_date
        , client_person_relationship_end_date
        , client_person_relationship_created_date
        , last_client_person_relationship
        , relationship_start_date
        , relationship_end_date
        , last_interaction_date
        , client_interaction_date
        , client_interaction_created_date
        , last_interaction_source
        , should_obfuscate_flag
        , needs_review_flag
    )
    SELECT
          bc.client_id
        , bc.company_id
        , @AsAtDate
        , @RetentionYears
        , @ObfuscationCutoffDate
        , aa.last_account_activity_date
        , aa.client_account_activity_created_date
        , aa.client_account_activity_start_date
        , aa.client_account_activity_end_date
        , ab.last_activity_breakdown_date
        , ab.client_activity_breakdown_created_date
        , ab.client_activity_start_date
        , ab.client_activity_end_date
        , ab.client_activity_created_date
        , rf.last_referral_date
        , rf.client_referral_created_date
        , rf.client_referral_discharge_date
        , rf.client_referral_end_date
        , rf.client_referral_person_relationship_end_date
        , rf.client_referral_accepted_date
        , rf.client_referral_decline_date
        , rf.client_referral_pending_date
        , gl.last_goal_date
        , gl.client_referral_goal_start_date
        , gl.client_referral_goal_end_date
        , glp.client_personal_goal_created_date
        , glp.client_personal_plan_start_date
        , glp.client_personal_plan_end_date
        , glp.client_personal_goal_start_date
        , glp.client_personal_goal_due_date
        , glp.client_personal_goal_action_due_date
        , glp.client_personal_goal_action_completed_date
        , glp.client_personal_goal_close_completed_date
        , glp.client_personal_goal_close_not_completed_date
        , glp.client_personal_goal_close_date
        , asg.last_assessment_date
        , asg.response_created_date
        , inc.last_incident_date
        , inc.incident_date
        , inc.incident_created_date
        , rel.last_relationship_date
        , pr.client_person_relationship_start_date
        , pr.client_person_relationship_end_date
        , pr.client_person_relationship_created_date
        , pr.last_client_person_relationship
        , rel.relationship_start_date
        , rel.relationship_end_date
        , li.last_interaction_date
        , ia.client_interaction_date
        , ia.client_interaction_created_date
        , li.last_interaction_source
        , CASE
              WHEN li.last_interaction_date IS NOT NULL
               AND CAST(li.last_interaction_date AS DATE) <= @ObfuscationCutoffDate
              THEN CAST(1 AS BIT)
              ELSE CAST(0 AS BIT)
          END AS should_obfuscate_flag
        , CASE
              WHEN li.last_interaction_date IS NULL
              THEN CAST(1 AS BIT)
              ELSE CAST(0 AS BIT)
          END AS needs_review_flag
    FROM #tmp_base_clients bc
    LEFT JOIN #tmp_account_activity      aa  ON aa.client_id  = bc.client_id AND aa.company_id  = bc.company_id
    LEFT JOIN #tmp_activity_breakdown    ab  ON ab.client_id  = bc.client_id AND ab.company_id  = bc.company_id
    LEFT JOIN #tmp_referral              rf  ON rf.client_id  = bc.client_id AND rf.company_id  = bc.company_id
    LEFT JOIN #tmp_goal                  gl  ON gl.client_id  = bc.client_id AND gl.company_id  = bc.company_id
    LEFT JOIN #tmp_goal_personal         glp ON glp.client_id = bc.client_id AND glp.company_id = bc.company_id
    LEFT JOIN #tmp_assessment            asg ON asg.client_id = bc.client_id AND asg.company_id = bc.company_id
    LEFT JOIN #tmp_incident              inc ON inc.client_id = bc.client_id AND inc.company_id = bc.company_id
    LEFT JOIN #tmp_relationship          rel ON rel.client_id = bc.client_id AND rel.company_id = bc.company_id
    LEFT JOIN #tmp_person_relationship   pr  ON pr.client_id  = bc.client_id AND pr.company_id  = bc.company_id
    LEFT JOIN #tmp_interaction           ia  ON ia.client_id  = bc.client_id AND ia.company_id  = bc.company_id
    OUTER APPLY
    (
        SELECT TOP (1)
               v.source_name       AS last_interaction_source
             , v.interaction_dt    AS last_interaction_date
        FROM
        (
            VALUES
                  (1, 'account_activity'   , aa.last_account_activity_date)
                , (2, 'activity_breakdown' , ab.last_activity_breakdown_date)
                , (3, 'referral'           , rf.last_referral_date)
                , (4, 'goal'               , gl.last_goal_date)
                , (5, 'assessment'         , asg.last_assessment_date)
                , (6, 'incident'           , inc.last_incident_date)
                , (7, 'relationship'       , rel.last_relationship_date)
        ) v(source_priority, source_name, interaction_dt)
        WHERE v.interaction_dt IS NOT NULL
        ORDER BY v.interaction_dt DESC, v.source_priority ASC
    ) li;

    /* ==========================================================================================
       12. Cleanup
       ========================================================================================== */
    DROP TABLE #tmp_account_activity;
    DROP TABLE #tmp_activity_breakdown;
    DROP TABLE #tmp_referral;
    DROP TABLE #tmp_goal;
    DROP TABLE #tmp_goal_personal;
    DROP TABLE #tmp_assessment;
    DROP TABLE #tmp_incident;
    DROP TABLE #tmp_relationship;
    DROP TABLE #tmp_person_relationship;
    DROP TABLE #tmp_interaction;
    DROP TABLE #tmp_base_clients;

END;