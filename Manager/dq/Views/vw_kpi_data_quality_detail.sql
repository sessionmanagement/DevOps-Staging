
CREATE   VIEW [dq].[vw_kpi_data_quality_detail]

/*─────────────────────────────────────────────────────────────────────────
  Name      : dq.vw_KPI_DataQualityDetail
  Purpose   : List every data‑quality check result for columns referenced
              by KPI views, for the most‑recent daily DQ run.
              • One row per KPI view • per source column • per check rule
              • Includes failing & passing checks plus an IsHealthy flag.
  Author    : (your name)
  Created   : 2025‑06‑12
─────────────────────────────────────────────────────────────────────────*/

AS
/*------------------------------------------------------------------------
  0. Identify the most‑recent calendar day with DQ results
------------------------------------------------------------------------*/
WITH LatestRunDay AS
(
    SELECT MAX(CAST(run_date_time AS date)) AS RunDate
    FROM   dq.dq_results
),
/*------------------------------------------------------------------------
  1. All check rows for that day (table- or column‑level)
------------------------------------------------------------------------*/
DailyChecks AS
(
    SELECT *
    FROM   dq.dq_results r
    CROSS  JOIN LatestRunDay d
    WHERE  CAST(r.run_date_time AS date) = d.RunDate
),
/*------------------------------------------------------------------------
  2. Map KPI lineage (every column used by every KPI view)
------------------------------------------------------------------------*/
ViewColumns AS
(
    SELECT  v.view_name,
            v.source_table  AS table_name,
            v.source_column AS column_name
    FROM    dq.view_column_flags v
),
/*------------------------------------------------------------------------
  3. Identify monitored columns (those in dq_dictionary)
------------------------------------------------------------------------*/
MonitoredColumns AS
(
    SELECT DISTINCT table_name, column_name
    FROM   dq.dq_dictionary
),
/*------------------------------------------------------------------------
  4. Combine lineage with daily checks and monitor status.
     • LEFT JOIN so that columns with zero checks still appear.
------------------------------------------------------------------------*/
Combined AS
(
    SELECT  vc.view_name,
            vc.table_name,
            vc.column_name,
            dc.check_name,
            dc.record_count,
            dc.status_message,
            dc.run_date_time,
            CASE WHEN mc.table_name IS NOT NULL THEN 1 ELSE 0 END AS IsMonitored
    FROM    ViewColumns      vc
    LEFT JOIN MonitoredColumns mc
           ON mc.table_name  = vc.table_name
          AND mc.column_name = vc.column_name
    LEFT JOIN DailyChecks    dc
           ON dc.table_name  = vc.table_name
          AND dc.column_name = vc.column_name
)
/*------------------------------------------------------------------------
  5. Final projection with health flags and monitor status
------------------------------------------------------------------------*/
SELECT
        view_name,
        table_name,
        column_name,
        check_name,
        record_count,                    -- NULL if no check at all
        status_message,
        CAST(run_date_time AS date) AS RunDate,
        IsMonitored,                     -- 1 if in dq_dictionary, 0 if not
        /* A column's health status:
           • -1 = Not monitored in dq_dictionary
           •  1 = Healthy (monitored AND either passed check or no check ran)
           •  0 = Unhealthy (monitored AND check failed)                     */
        CASE
            WHEN IsMonitored = 0            THEN -1  -- Not monitored
            WHEN record_count IS NULL       THEN 1   -- Monitored but no check ran
            WHEN record_count = 0           THEN 1   -- Check passed
            ELSE 0                                   -- Check failed
        END AS IsHealthy
FROM    Combined;