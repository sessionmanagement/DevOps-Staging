CREATE   VIEW [dq].[vw_kpi_data_quality_score]

/*─────────────────────────────────────────────────────────────────────────
  Name      : dq.vw_KPI_DataQualityScore
  Purpose   : For each KPI view, return a % score that reflects how many
              of the source columns passed ALL data‑quality checks for
              each DQResults run date (historical tracking enabled).
              ‑ 100 %  = every referenced column had zero failed checks
              ‑   0 %  = every referenced column had ≥ 1 failed check
  Author    : Mike Gencic
  Created   : 2025‑06‑12
  Modified  : 2025‑10‑23 - Added historical tracking (all run dates)
  Notes     : Columns not in dq_dictionary are considered unmonitored.
              The score is based only on monitored columns.
              Historical scores use current view_column_flags definitions.
─────────────────────────────────────────────────────────────────────────*/

AS
/*------------------------------------------------------------------------
  0. Identify all distinct DQ run dates (by calendar day, not timestamp)
------------------------------------------------------------------------*/
WITH AllRunDates AS
(
    SELECT DISTINCT CAST(run_date_time AS date) AS RunDate
    FROM   dq.dq_results
),
/*------------------------------------------------------------------------
  1. Collapse all check rows for each day to a single health flag
     1 = column healthy (every check had record_count = 0)
     0 = column compromised (≥ 1 check had record_count > 0)
------------------------------------------------------------------------*/
ColumnHealth AS
(
    SELECT   CAST(r.run_date_time AS date)          AS RunDate,
             r.table_name,
             r.column_name,
             CASE WHEN SUM(CASE WHEN r.record_count > 0 THEN 1 ELSE 0 END) > 0
                  THEN 0 ELSE 1 END                  AS IsHealthy
    FROM     dq.dq_results            r
    WHERE    r.column_name IS NOT NULL              -- ignore table‑level checks
    GROUP BY CAST(r.run_date_time AS date),
             r.table_name,
             r.column_name
),
/*------------------------------------------------------------------------
  2. Bring in every column used by every KPI view
------------------------------------------------------------------------*/
ViewColumns AS
(
    SELECT   v.view_name,
             v.source_table  AS table_name,
             v.source_column AS column_name
    FROM     dq.view_column_flags v
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
  4. Combine (CROSS JOIN with all dates, LEFT JOIN) to attach the IsHealthy flag and IsMonitored flag.
     Columns without any DQResult row on a given day default to IsHealthy = 1.
------------------------------------------------------------------------*/
ViewColumnHealth AS
(
    SELECT   ard.RunDate,
             vc.view_name,
             vc.table_name,
             vc.column_name,
             ISNULL(ch.IsHealthy,1) AS IsHealthy,
             CASE WHEN mc.table_name IS NOT NULL THEN 1 ELSE 0 END AS IsMonitored
    FROM     AllRunDates ard
    CROSS JOIN ViewColumns  vc
    LEFT JOIN ColumnHealth ch
           ON ch.RunDate      = ard.RunDate
          AND ch.table_name  = vc.table_name
          AND ch.column_name = vc.column_name
    LEFT JOIN MonitoredColumns mc
           ON mc.table_name  = vc.table_name
          AND mc.column_name = vc.column_name
),
/*------------------------------------------------------------------------
  5. Aggregate column health to the view level by date
     - Separates monitored vs. unmonitored columns
     - Only monitored columns contribute to the health score
------------------------------------------------------------------------*/
Scores AS
(
    SELECT  vch.RunDate,
            vch.view_name,
            COUNT(*)                                                    AS TotalColumns,
            SUM(CASE WHEN vch.IsMonitored = 1 THEN 1 ELSE 0 END)        AS MonitoredColumns,
            SUM(CASE WHEN vch.IsMonitored = 0 THEN 1 ELSE 0 END)        AS UnmonitoredColumns,
            SUM(CASE WHEN vch.IsMonitored = 1 AND vch.IsHealthy = 1
                     THEN 1 ELSE 0 END)                                 AS HealthyMonitoredColumns,
            SUM(CASE WHEN vch.IsMonitored = 1 AND vch.IsHealthy = 0
                     THEN 1 ELSE 0 END)                                 AS CompromisedMonitoredColumns
    FROM    ViewColumnHealth vch
    GROUP BY vch.RunDate, vch.view_name
),
/*------------------------------------------------------------------------
  6. Count the number of checks defined for each KPI view
     - Joins view columns with dq_dictionary to count all checks
------------------------------------------------------------------------*/
ViewCheckCounts AS
(
    SELECT   vc.view_name,
             COUNT(d.dictionary_id) AS TotalChecks
    FROM     ViewColumns vc
    INNER JOIN dq.dq_dictionary d
            ON d.table_name  = vc.table_name
           AND d.column_name = vc.column_name
    GROUP BY vc.view_name
)
/*------------------------------------------------------------------------
  7. Final SELECT with percentage, check counts, and scoring date
     - Score is calculated as: HealthyMonitoredColumns / MonitoredColumns
     - TotalChecks shows the number of checks defined in dq_dictionary
     - ScoreDate included for all historical run dates
------------------------------------------------------------------------*/
SELECT  s.RunDate                                         AS ScoreDate,
        s.view_name,
        s.TotalColumns,
        s.MonitoredColumns,
        s.UnmonitoredColumns,
        s.HealthyMonitoredColumns,
        s.CompromisedMonitoredColumns,
        ISNULL(vcc.TotalChecks, 0)                        AS TotalChecks,
        CAST( (1.0 * s.HealthyMonitoredColumns) / NULLIF(s.MonitoredColumns,0) * 100
              AS decimal(5,2))                            AS DataQualityScorePct
FROM    Scores s
LEFT JOIN ViewCheckCounts vcc
       ON vcc.view_name = s.view_name;
