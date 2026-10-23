> **Audience** Data Engineers, BI Developers, and Analysts who need to understand how dictionary‑driven data‑quality (DQ) checks are executed and surfaced inside the Enterprise Data‑Warehouse (EDW).
> **Scope** Covers object purpose, integration flow, and the complete creation scripts (hidden in collapsible blocks for easy copy/paste).

---

## 1  Architecture at a Glance

**Important**: The data quality process is orchestrated by Azure Data Factory (ADF) which runs daily. The stored procedures return result sets that ADF captures and inserts into the manager database tables. Manual execution of stored procedures will show results but will not update the database.

::: mermaid
flowchart TB
    subgraph Manager Database [sqldb-prod-manager]
        DQDictionary["[dq].[dq_dictionary]<br/>(catalogue of rules)"]
        DQResults["[dq].[dq_results]<br/>(fact of check outcomes)"]
        ViewFlags["[dq].[view_column_flags]<br/>(column usage flags)"]
        Detail["[dq].[vw_kpi_data_quality_detail]"]
        Score["[dq].[vw_kpi_data_quality_score]"]
    end
    subgraph Production Database [sqldb-prod-datawarehouse-01]
        ProcPopulate["[meta_data].[populate_dq_from_dictionary]"]
        ProcFlags["[meta_data].[usp_refresh_view_column_flags]"]
    end
    subgraph ADF [Azure Data Factory - Daily Execution]
        ADFPipeline["ADF Pipeline"]
    end
    
    ADFPipeline -->|executes| ProcPopulate
    ADFPipeline -->|executes| ProcFlags
    DQDictionary -->|reads rules| ProcPopulate
    ProcPopulate -->|returns results| ADFPipeline
    ADFPipeline -->|inserts results| DQResults
    ProcFlags -->|returns lineage data| ADFPipeline
    ADFPipeline -->|inserts lineage| ViewFlags
    ViewFlags --> Detail
    DQResults --> Detail
    Detail --> Score
:::

### Production Environment Details
- **Production Server**: `sql-prod-aus-svc-datawarehouse-01.database.windows.net`
- **Production Database**: `sqldb-prod-datawarehouse-01` (where stored procedures execute)
- **Manager Database**: `sqldb-prod-manager` (where DQ tables and views reside)

### Key Components:
1. **Dictionary** – holds one row per check rule in the manager database.
2. **Populate proc** – loops the dictionary, executes each rule in production database, returns results to ADF.
3. **ADF Pipeline** – executes stored procedures daily and inserts their results into manager database tables.
4. **Flagging proc** – discovers which KPI views touch which source columns and how (runs in production database, returns data to ADF).
5. **KPI views** – join lineage to the latest DQ results to expose detail & % score (all in manager database).

---

## 2  Object Detail & Scripts

<details>
<summary><strong>2.1  [dq].[dq_dictionary] – Rules Catalogue</strong></summary>

### Purpose

Stores the metadata required to execute a DQ check: target table/column, friendly name, the dynamic SQL fragment to run, and the expected shape of the result. Located in the **manager database** (`sqldb-prod-manager`).

### Script

```sql
CREATE TABLE [dq].[dq_dictionary](
	[dictionary_id] [int] IDENTITY(1,1) NOT NULL,
	[table_name] [nvarchar](200) NOT NULL,
	[column_name] [nvarchar](200) NULL,
	[check_name] [nvarchar](200) NOT NULL,
	[filter_clause] [nvarchar](max) NULL,
	[check_SQL] [nvarchar](max) NOT NULL,
	[expected_result] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[dictionary_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
```
</details>

---

<details>
<summary><strong>2.2  [meta_data].[populate_dq_from_dictionary] – Execution Engine</strong></summary>

### Purpose

Iterates every rule in **[dq].[dq_dictionary]** (from manager database), executes its `check_sql`, captures the returned issue count, and **returns results as a result set**. Azure Data Factory then takes these results and inserts them into **[dq].[dq_results]** in the manager database. Optionally suppresses results where the count is 0. This procedure runs in the **production database** (`sqldb-prod-datawarehouse-01`) via Azure Data Factory daily.

**Important**: When executed manually, this procedure returns results but does not update the manager database. Only ADF executions update the manager database tables.

### Script

```sql
/****** Object:  StoredProcedure [meta_data].[populate_dq_from_dictionary]    Script Date: 8/07/2025 11:53:16 am ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--------------------------------------------------------------------------------
-- v1.0.1 - 2025-04-29 - Mike Gencic
-- Change Notes: Added short, technical comments referencing EDW usage.
--------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- 2) CREATE THE PROCEDURE
--    Purpose: Execute dictionary-based data-quality checks, storing results 
--    in [dq].[dq_results].
------------------------------------------------------------------------------
Create   procedure [meta_data].[populate_dq_from_dictionary]
(
    @OnlyInsertWhenRecordCountPositive BIT = 1,
    @RunDateTimeNZ DATETIME2 = null
)
AS
BEGIN
    SET NOCOUNT ON;
	
    ----------------------------------------------------------------------------
    -- v1.0.1: If no @RunDateTimeNZ, set using DST-safe approach.
    ----------------------------------------------------------------------------
    IF @RunDateTimeNZ IS NULL
    BEGIN
        SET @RunDateTimeNZ = CAST(((GETUTCDATE() AT TIME ZONE 'UTC') AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2);
    END;

    ----------------------------------------------------------------------------
    -- v1.0.1: Loop each dq_dictionary row, run @CheckSQL, store result in dq_results.
    ----------------------------------------------------------------------------
    DECLARE @CheckID       INT;
    DECLARE @TableName     NVARCHAR(200);
    DECLARE @ColumnName    NVARCHAR(200);
    DECLARE @CheckName     NVARCHAR(200);
    DECLARE @CheckSQL      NVARCHAR(MAX);

    CREATE TABLE #Results 
    (
        [ID] [int] IDENTITY(1,1) NOT NULL,
        [CheckID] [int] NULL,
        [TableName] [nvarchar](200) NOT NULL,
        [ColumnName] [nvarchar](200) NULL,
        [CheckName] [nvarchar](200) NOT NULL,
        [StatusMessage] [nvarchar](4000) NOT NULL,
        [RecordCount] [int] NOT NULL,
        [RunDateTime] [datetime2] NOT NULL
    );


    DECLARE checkCursor CURSOR FOR
        SELECT 
            [dictionary_id],
	        [table_name],
	        [column_name],
	        [check_name],
	        [check_sql]
        from meta_data.dq_dictionary
        ORDER BY dictionary_id;

    OPEN checkCursor;
    FETCH NEXT FROM checkCursor 
      INTO @CheckID, @TableName, @ColumnName, @CheckName, @CheckSQL;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        BEGIN TRY
            ----------------------------------------------------------------------------
            -- v1.0.1: Execute dynamic SQL from dictionary and capture IssueCount.
            ----------------------------------------------------------------------------
            DECLARE @tempTable TABLE
            (
                CheckType       NVARCHAR(200),
                IssueCount      INT NULL,
                DuplicateCount  INT NULL,
                NegativeCount   INT NULL
            );

            INSERT INTO @tempTable
            (
                CheckType,
                IssueCount,
                DuplicateCount,
                NegativeCount
            )
            EXEC sp_executesql @CheckSQL;

            ----------------------------------------------------------------------------
            -- v1.0.1: We expect 1 row with 'CheckName' plus a numeric IssueCount.
            ----------------------------------------------------------------------------
            DECLARE @RecordCount INT = 0;
            DECLARE @CheckType   NVARCHAR(200) = '';

            SELECT TOP 1
                @CheckType = ISNULL(CheckType, 'Unknown'),
                @RecordCount = CASE
                                   WHEN IssueCount     IS NOT NULL THEN IssueCount
                                   WHEN DuplicateCount IS NOT NULL THEN DuplicateCount
                                   WHEN NegativeCount  IS NOT NULL THEN NegativeCount
                                   ELSE 0
                               END
            FROM @tempTable
            WHERE CheckType = @CheckName;

            ----------------------------------------------------------------------------
            -- v1.0.1: Insert into dq_results, skip if RecordCount=0 & user only wants >0.
            ----------------------------------------------------------------------------
            IF NOT(@OnlyInsertWhenRecordCountPositive = 1 AND @RecordCount = 0)
            BEGIN
                INSERT INTO #Results
                (
                    CheckID,
                    TableName,
                    ColumnName,
                    CheckName,
                    StatusMessage,
                    RecordCount,
                    RunDateTime
                )
                VALUES
                (
                    @CheckID,
                    @TableName,
                    @ColumnName,
                    @CheckName,
                    CONCAT('Completed: ', @CheckType, ' => FoundCount=', @RecordCount),
                    @RecordCount,
                    @RunDateTimeNZ
                );
            END;
        END TRY
        BEGIN CATCH
            ----------------------------------------------------------------------------
            -- If there's an error, log it in [dq].[dq_results].
            ----------------------------------------------------------------------------
            DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();

            INSERT INTO #Results
            (
                CheckID,
                TableName,
                ColumnName,
                CheckName,
                StatusMessage,
                RecordCount,
                RunDateTime
            )
            VALUES
            (
                @CheckID,
                @TableName,
                @ColumnName,
                @CheckName,
                CONCAT('ERROR: ', @ErrMsg),
                0,
                @RunDateTimeNZ
            );
        END CATCH;

        FETCH NEXT FROM checkCursor 
          INTO @CheckID, @TableName, @ColumnName, @CheckName, @CheckSQL;
    END;

    CLOSE checkCursor;
    DEALLOCATE checkCursor;

    ----------------------------------------------------------------------------
    -- 5) End of procedure - Return result set for ADF to capture
    ----------------------------------------------------------------------------
    SET NOCOUNT OFF;

    SELECT    
        [CheckID] as check_id,
        [TableName] as table_name,
        [ColumnName] as column_name,
        [CheckName] as check_name,
        [StatusMessage] as status_name, 
        [RecordCount] as record_count,
        [RunDateTime] as run_date_time
    
    FROM #Results

END;
GO
```

**Note**: This procedure runs in the production database and reads from the manager database's dictionary table via linked server or cross-database query. It returns a result set that ADF captures and inserts into the manager database's dq_results table.
</details>

---

<details>
<summary><strong>2.3  [dq].[dq_results] – Fact of Outcomes</strong></summary>

### Purpose

Stores one row per rule execution with its record count and status message. Views look at the **latest calendar day** to calculate health. Located in the **manager database** (`sqldb-prod-manager`).

### Script

```sql
CREATE TABLE [dq].[dq_results](
	[results_id] [int] IDENTITY(1,1) NOT NULL,
	[check_id] [int] NULL,
	[table_name] [nvarchar](200) NOT NULL,
	[column_name] [nvarchar](200) NULL,
	[check_name] [nvarchar](200) NOT NULL,
	[status_message] [nvarchar](4000) NOT NULL,
	[record_count] [int] NOT NULL,
	[run_date_time] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[results_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dq].[dq_results] ADD  DEFAULT (((getutcdate() AT TIME ZONE 'UTC') AT TIME ZONE 'New Zealand Standard Time')) FOR [run_date_time]
GO
```
</details>

---

<details>
<summary><strong>2.4  [meta_data].[usp_refresh_view_column_flags] – Lineage Parser</strong></summary>

### Purpose

Scans every KPI view (`edw.kpi_%`) using `sys.dm_sql_referenced_entities`, flags where each source column appears (SELECT, WHERE, JOIN, etc.), and reloads **[dq].[view_column_flags]** in the manager database. This procedure runs in the **production database** (`sqldb-prod-datawarehouse-01`) via Azure Data Factory.

### Script

```sql
/****** Object:  StoredProcedure [meta_data].[usp_refresh_view_column_flags]    Script Date: 8/07/2025 11:55:17 am ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


Create   PROCEDURE [meta_data].[usp_refresh_view_column_flags]
AS
BEGIN
    SET NOCOUNT ON;

    /*---------------------------------------------------------------
      0. Ensure persistent table exists (note: table is created in manager database)
    ----------------------------------------------------------------*/
    --IF OBJECT_ID('dq.view_column_flags','U') IS NULL
    --BEGIN
    --    CREATE TABLE dq.view_column_flags
    --    (
    --        view_name          sysname       NOT NULL,
    --        source_table       sysname       NOT NULL,
    --        source_column      sysname       NOT NULL,
    --        is_in_select        bit           NOT NULL,
    --        is_distinct_select  bit           NOT NULL,
    --        is_in_where         bit           NOT NULL,
    --        is_in_join          bit           NOT NULL,
    --        is_in_group_by       bit           NOT NULL,
    --        is_in_having        bit           NOT NULL,
    --        is_in_order_by       bit           NOT NULL,
    --        is_aggregated      bit           NOT NULL,
    --        is_in_outer_apply    bit           NOT NULL,
    --        is_in_cross_apply    bit           NOT NULL,
    --        is_in_window        bit           NOT NULL,
    --        is_in_case          bit           NOT NULL,
    --        is_in_function      bit           NOT NULL,
    --        is_in_expression    bit           NOT NULL,
    --        has_select_star     bit           NOT NULL,
    --        load_dtm           datetime2(3)  NOT NULL DEFAULT SYSUTCDATETIME(),
    --        CONSTRAINT PK_view_column_flags
    --            PRIMARY KEY (view_name, source_table, source_column)
    --    );
    --END

    BEGIN TRY
        BEGIN TRAN;

        /*-----------------------------------------------------------
          1. House‑keeping
        -----------------------------------------------------------*/
        IF OBJECT_ID('tempdb..#view_details')     IS NOT NULL DROP TABLE #view_details;
        IF OBJECT_ID('tempdb..#view_definitions') IS NOT NULL DROP TABLE #view_definitions;
        IF OBJECT_ID('tempdb..#details_flags')    IS NOT NULL DROP TABLE #details_flags;

        /*-----------------------------------------------------------
          2. Dependency scan
        -----------------------------------------------------------*/
        SELECT  v.name AS view_name,
                r.referenced_schema_name + N'.' + r.referenced_entity_name AS source_table,
                r.referenced_minor_name                                   AS source_column
        INTO    #view_details
        FROM    sys.views AS v
        CROSS   APPLY sys.dm_sql_referenced_entities(
                    QUOTENAME(SCHEMA_NAME(v.schema_id))+'.'+QUOTENAME(v.name),
                    'OBJECT') AS r
        WHERE   SCHEMA_NAME(v.schema_id) = N'edw'
          AND   v.name LIKE N'kpi_%'
          AND   v.name NOT LIKE N'kpi_snapshot_%';

        /*-----------------------------------------------------------
          3. Pull & pre‑clean view text
        -----------------------------------------------------------*/
        SELECT  v.name AS view_name,
                UPPER(REPLACE(REPLACE(sm.definition,CHAR(9),N' '),
                              CHAR(13)+CHAR(10),N' ')) AS view_def
        INTO    #view_definitions
        FROM    sys.views       v
        JOIN    sys.sql_modules sm ON sm.object_id = v.object_id
        WHERE   SCHEMA_NAME(v.schema_id) = N'edw'
          AND   v.name LIKE N'kpi_%'
          AND   v.name NOT LIKE N'kpi_snapshot_%';

        /* List of scalar functions to flag */
        DECLARE @fnList varchar(4000) = 'ISNULL|COALESCE|LEN|DATEDIFF|ABS|ROUND';

        /*-----------------------------------------------------------
          4. Flag enrichment
        -----------------------------------------------------------*/
        SELECT  vd.view_name,
                vd.source_table,
                vd.source_column,

                /* Clause‑level flags */
                CASE WHEN PATINDEX('%SELECT %'+vd.source_column+'%',         d.view_def) > 0 THEN 1 ELSE 0 END AS is_in_select,
                CASE WHEN PATINDEX('%SELECT DISTINCT %'+vd.source_column+'%',d.view_def) > 0 THEN 1 ELSE 0 END AS is_distinct_select,
                CASE WHEN PATINDEX('%WHERE %'+vd.source_column+'%',          d.view_def) > 0 THEN 1 ELSE 0 END AS is_in_where,
                CASE WHEN PATINDEX('%JOIN %'+vd.source_column+'%',           d.view_def) > 0
                       OR PATINDEX('% ON %'+vd.source_column+'%',            d.view_def) > 0 THEN 1 ELSE 0 END AS is_in_join,
                CASE WHEN PATINDEX('%GROUP BY %'+vd.source_column+'%',       d.view_def) > 0 THEN 1 ELSE 0 END AS is_in_group_by,
                CASE WHEN PATINDEX('%HAVING %'+vd.source_column+'%',         d.view_def) > 0 THEN 1 ELSE 0 END AS is_in_having,
                CASE WHEN PATINDEX('%ORDER BY %'+vd.source_column+'%',       d.view_def) > 0 THEN 1 ELSE 0 END AS is_in_order_by,

                /* Aggregates */
                CASE WHEN PATINDEX('%SUM(%'+vd.source_column+'%)%',          REPLACE(d.view_def,N' ',N'')) > 0
                       OR PATINDEX('%COUNT(%'+vd.source_column+'%)%',        REPLACE(d.view_def,N' ',N'')) > 0
                       OR PATINDEX('%AVG(%'+vd.source_column+'%)%',          REPLACE(d.view_def,N' ',N'')) > 0
                       OR PATINDEX('%MIN(%'+vd.source_column+'%)%',          REPLACE(d.view_def,N' ',N'')) > 0
                       OR PATINDEX('%MAX(%'+vd.source_column+'%)%',          REPLACE(d.view_def,N' ',N'')) > 0 THEN 1 ELSE 0 END AS is_aggregated,

                /* APPLY */
                CASE WHEN PATINDEX('%OUTER APPLY%'+vd.source_column+'%',     d.view_def) > 0 THEN 1 ELSE 0 END AS is_in_outer_apply,
                CASE WHEN PATINDEX('%CROSS APPLY%'+vd.source_column+'%',     d.view_def) > 0 THEN 1 ELSE 0 END AS is_in_cross_apply,

                /* Window, CASE, scalar fn, expression */
                CASE WHEN PATINDEX('% OVER (%'+vd.source_column+'%',         d.view_def) > 0
                       OR PATINDEX('% OVER(%'+vd.source_column+'%',          d.view_def) > 0 THEN 1 ELSE 0 END AS is_in_window,
                CASE WHEN PATINDEX('%CASE %'+vd.source_column+'%',           d.view_def) > 0 THEN 1 ELSE 0 END AS is_in_case,
                CASE WHEN EXISTS (SELECT 1 FROM STRING_SPLIT(@fnList,'|') f
                                  WHERE PATINDEX('%'+value+'(%'+vd.source_column+'%', d.view_def) > 0) THEN 1 ELSE 0 END AS is_in_function,
                CASE WHEN PATINDEX('%'+vd.source_column+'+%',                d.view_def) > 0
                       OR PATINDEX('%\+'+vd.source_column+'%',               d.view_def) > 0
                       OR PATINDEX('%'+vd.source_column+'-%',                d.view_def) > 0
                       OR PATINDEX('%-'+vd.source_column+'%',                d.view_def) > 0
                       OR PATINDEX('%'+vd.source_column+'*%',                d.view_def) > 0
                       OR PATINDEX('%'+vd.source_column+'/%',                d.view_def) > 0
                       OR PATINDEX('%'+vd.source_column+'||%',               d.view_def) > 0 THEN 1 ELSE 0 END AS is_in_expression,

                /* Whole‑view star select */
                CASE WHEN CHARINDEX('SELECT *', d.view_def) > 0 THEN 1 ELSE 0 END AS has_select_star
        INTO    #details_flags
        FROM    #view_details    vd
        JOIN    #view_definitions d ON d.view_name = vd.view_name;

        /*-----------------------------------------------------------
          5. Return results for ADF to capture and insert into manager database
        -----------------------------------------------------------*/
        -- Note: The SELECT below returns data that ADF will insert into 
        -- the manager database's [dq].[view_column_flags] table
        
        SELECT  view_name
                , source_table
                , source_column
                , is_in_select
                , is_distinct_select
                , is_in_where
                , is_in_join
                , is_in_group_by
                , is_in_having
                , is_in_order_by
                , is_aggregated
                , is_in_outer_apply
                , is_in_cross_apply
                , is_in_window
                , is_in_case
                , is_in_function
                , is_in_expression
                ,has_select_star
        FROM    #details_flags
        WHERE   source_column IS NOT NULL
          AND   source_column NOT LIKE N'DWH%';

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;
        THROW;    -- re‑throw original error with full context
    END CATCH
END
GO
```

**Note**: This procedure runs in the production database and returns lineage data that ADF then inserts into the manager database's view_column_flags table. Manual execution will return results but won't update the manager database.
</details>

---

<details>
<summary><strong>2.5  [dq].[view_column_flags] – Column‑Usage Flags</strong></summary>

### Purpose

A persistent map of every column referenced by every KPI view, plus booleans that describe *how* it is used (aggregated, in WHERE, etc.). Located in the **manager database** (`sqldb-prod-manager`).

### Script

```sql
CREATE TABLE [dq].[view_column_flags](
	[view_name] [sysname] NOT NULL,
	[source_table] [sysname] NOT NULL,
	[source_column] [sysname] NOT NULL,
	[is_in_select] [tinyint] NOT NULL,
	[is_distinct_select] [tinyint] NOT NULL,
	[is_in_where] [tinyint] NOT NULL,
	[is_in_join] [tinyint] NOT NULL,
	[is_in_group_by] [tinyint] NOT NULL,
	[is_in_having] [tinyint] NOT NULL,
	[is_in_order_by] [tinyint] NOT NULL,
	[is_aggregated] [tinyint] NOT NULL,
	[is_in_outer_apply] [tinyint] NOT NULL,
	[is_in_cross_apply] [tinyint] NOT NULL,
	[is_in_window] [tinyint] NOT NULL,
	[is_in_case] [tinyint] NOT NULL,
	[is_in_function] [tinyint] NOT NULL,
	[is_in_expression] [tinyint] NOT NULL,
	[has_select_star] [tinyint] NOT NULL,
	[load_dtm] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_view_column_flags] PRIMARY KEY CLUSTERED 
(
	[view_name] ASC,
	[source_table] ASC,
	[source_column] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dq].[view_column_flags] ADD  CONSTRAINT [DF_view_column_flags_load_dtm]  DEFAULT (sysutcdatetime()) FOR [load_dtm]
GO
```
</details>

---

<details>
<summary><strong>2.6  [dq].[vw_kpi_data_quality_detail] – Row‑Level Detail</strong></summary>

### Purpose

For the most‑recent DQ run it emits **one row per KPI view × source column × rule**, including healthy (0 issues) and failing (>0 issues) checks plus an `IsHealthy` flag. Located in the **manager database** (`sqldb-prod-manager`).

### Script

```sql
/****** Object:  View [dq].[vw_kpi_data_quality_detail]    Script Date: 8/07/2025 11:59:32 am ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   VIEW [dq].[vw_kpi_data_quality_detail]

/*─────────────────────────────────────────────────────────────────────────
  Name      : dq.vw_kpi_data_quality_detail
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
  3. Combine lineage with daily checks.
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
            dc.run_date_time
    FROM    ViewColumns      vc
    LEFT JOIN DailyChecks    dc
           ON dc.table_name  = vc.table_name
          AND dc.column_name = vc.column_name
)
/*------------------------------------------------------------------------
  4. Final projection with health flags
------------------------------------------------------------------------*/
SELECT
        view_name,
        table_name,
        column_name,
        check_name,
        record_count,                    -- NULL if no check at all
        status_message,
        CAST(run_date_time AS date) AS RunDate,
        /* A column is healthy if EITHER:
           • the check exists AND record_count = 0, OR
           • there was no check row for it (NULL)                           */
        CASE
            WHEN record_count IS NULL       THEN 1
            WHEN record_count = 0           THEN 1
            ELSE 0
        END AS IsHealthy
FROM    Combined;
GO
```
</details>

---

<details>
<summary><strong>2.7  [dq].[vw_kpi_data_quality_score] – % Score per KPI View</strong></summary>

### Purpose

Rolls up **Detail** to a single percentage per KPI view:
`HealthyColumns ÷ TotalColumns × 100`. A column with *no* failing checks (or no checks at all) counts as healthy. Located in the **manager database** (`sqldb-prod-manager`).

### Script

```sql
/****** Object:  View [dq].[vw_kpi_data_quality_score]    Script Date: 8/07/2025 12:00:07 pm ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   VIEW [dq].[vw_kpi_data_quality_score]

/*─────────────────────────────────────────────────────────────────────────
  Name      : dq.vw_kpi_data_quality_score
  Purpose   : For each KPI view, return a % score that reflects how many
              of the source columns passed ALL data‑quality checks on the
              most‑recent dq_results day.
              ‑ 100 %  = every referenced column had zero failed checks
              ‑   0 %  = every referenced column had ≥ 1 failed check
  Author    : Mike Gencic
  Created   : 2025‑06‑12
  Notes     : If a KPI column has **no** row in dq_results for
              the latest day, it is counted as "Healthy".
─────────────────────────────────────────────────────────────────────────*/

AS
/*------------------------------------------------------------------------
  0. Identify the latest complete DQ run (by calendar day, not timestamp)
------------------------------------------------------------------------*/
WITH LatestRunDay AS
(
    SELECT MAX(CAST(run_date_time AS date)) AS RunDate
    FROM   dq.dq_results
),
/*------------------------------------------------------------------------
  1. Collapse all check rows for that day to a single health flag
     1 = column healthy (every check had record_count = 0)
     0 = column compromised (≥ 1 check had record_count > 0)
------------------------------------------------------------------------*/
ColumnHealth AS
(
    SELECT   r.table_name,
             r.column_name,
             CASE WHEN SUM(CASE WHEN r.record_count > 0 THEN 1 ELSE 0 END) > 0
                  THEN 0 ELSE 1 END                        AS IsHealthy
    FROM     dq.dq_results            r
    CROSS    JOIN LatestRunDay        d
    WHERE    CAST(r.run_date_time AS date) = d.RunDate
      AND    r.column_name IS NOT NULL              -- ignore table‑level checks
    GROUP BY r.table_name,
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
  3. Combine (LEFT JOIN) to attach the IsHealthy flag; columns without
     any dq_results row on the latest day default to IsHealthy = 1.
------------------------------------------------------------------------*/
ViewColumnHealth AS
(
    SELECT   vc.view_name,
             vc.table_name,
             vc.column_name,
             ISNULL(ch.IsHealthy,1) AS IsHealthy
    FROM     ViewColumns  vc
    LEFT JOIN ColumnHealth ch
           ON ch.table_name  = vc.table_name
          AND ch.column_name = vc.column_name
),
/*------------------------------------------------------------------------
  4. Aggregate column health to the view level
------------------------------------------------------------------------*/
Scores AS
(
    SELECT  vch.view_name,
            COUNT(*)                                        AS TotalColumns,
            SUM(CASE WHEN vch.IsHealthy = 1 THEN 1 ELSE 0 END)
                                                         AS HealthyColumns,
            SUM(CASE WHEN vch.IsHealthy = 0 THEN 1 ELSE 0 END)
                                                         AS CompromisedColumns
    FROM    ViewColumnHealth vch
    GROUP BY vch.view_name
)
/*------------------------------------------------------------------------
  5. Final SELECT with percentage and scoring date
------------------------------------------------------------------------*/
SELECT  s.view_name,
        s.TotalColumns,
        s.HealthyColumns,
        s.CompromisedColumns,
        CAST( (1.0 * s.HealthyColumns) / NULLIF(s.TotalColumns,0) * 100
              AS decimal(5,2))                            AS DataQualityScorePct,
        (SELECT RunDate FROM LatestRunDay)                AS ScoreDate
FROM    Scores s;
GO
```
</details>

---

## 3  Daily Operational Flow

| Step  | Trigger         | Action                                                                                                   |
| ----- | --------------- | -------------------------------------------------------------------------------------------------------- |
| **1** | Azure Data Factory (Daily) | Execute `[meta_data].[usp_refresh_view_column_flags]` on **production database**. ADF captures returned lineage data and inserts into `[dq].[view_column_flags]` in manager database. |
| **2** | Azure Data Factory (Daily) | Execute `[meta_data].[populate_dq_from_dictionary]` on **production database** (optionally pass `@OnlyInsertWhenRecordCountPositive = 1`). ADF captures returned results and inserts into `[dq].[dq_results]` in manager database. |
| **3** | BI layer        | Read `[dq].[vw_kpi_data_quality_detail]` from **manager database** for dashboards / alerts.              |
| **4** | BI layer        | Read `[dq].[vw_kpi_data_quality_score]` from **manager database** for high‑level KPI grids.              |

### Server Connections
- **ADF pipelines** connect to: `sql-prod-aus-svc-datawarehouse-01.database.windows.net/sqldb-prod-datawarehouse-01`
- **BI/Reporting tools** connect to: `sql-prod-aus-svc-datawarehouse-01.database.windows.net/sqldb-prod-manager`

### Important Note on Manual Execution
When executing stored procedures manually (outside of ADF), they will return result sets but **will not update** the manager database tables. Only ADF executions update the manager database.

---

## 4  Extending the Platform

| Task                        | How‑to                                                                                                                                       |
| --------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| **Add a new rule**          | Insert a row into **[dq].[dq_dictionary]** in the manager database with your `check_sql`. It must return at least `(CheckType, IssueCount)` where `CheckType = check_name`. |
| **On‑board a new KPI view** | Deploy the `edw.kpi_*` view in production database, then run `[meta_data].[usp_refresh_view_column_flags]`. The KPI views auto‑pick up new columns. |
| **Change scoring logic**    | Modify the CTEs in `[dq].[vw_kpi_data_quality_score]` in manager database (e.g., weight by severity) – the underlying tables stay the same. |

---

## 5  Key Design Decisions (FAQ)

<details>
<summary>Why use dynamic SQL in the dictionary instead of hard‑coding checks?</summary>

**Flexibility:** business teams can author sophisticated checks (e.g., joins, window functions) without redeploying the engine.  
**Maintainability:** a new rule = one table row rather than code change + deployment.
</details>

<details>
<summary>Why does the score view look only at the latest *calendar day*?</summary>

Multiple runs could happen per day. Collapsing to the date ensures a clean, single figure for BI; if you need intraday tracking, add a `RunInstance` key.
</details>

<details>
<summary>Which server should I connect to for running manual checks?</summary>

- **To execute stored procedures manually**: Connect to `sql-prod-aus-svc-datawarehouse-01.database.windows.net/sqldb-prod-datawarehouse-01`
- **To query DQ tables and views**: Connect to `sql-prod-aus-svc-datawarehouse-01.database.windows.net/sqldb-prod-manager`
- **To add new dictionary entries**: Connect to the manager database
</details>

<details>
<summary>How does cross-database communication work?</summary>

The stored procedures in the production database (`sqldb-prod-datawarehouse-01`) read from tables in the manager database (`sqldb-prod-manager`) using cross-database queries. They return result sets that Azure Data Factory captures and inserts into the appropriate tables in the manager database. 

**Important**: The stored procedures themselves do not directly insert data into the manager database - they only return results. ADF is responsible for capturing these results and inserting them into the manager database tables.
</details>

<details>
<summary>What happens when I run the stored procedures manually?</summary>

When you execute the stored procedures manually (not through ADF):
- `[meta_data].[populate_dq_from_dictionary]` will return a result set showing the DQ check results
- `[meta_data].[usp_refresh_view_column_flags]` will return the lineage data
- **However**, the manager database tables will NOT be updated

Only executions through Azure Data Factory will update the manager database tables. This is by design to ensure controlled, scheduled updates to the DQ results and lineage data.
</details>

---

## 6  Adding a New Data‑Quality Rule (Dictionary‑Driven)

### 6.1 Rule‑authoring checklist ✅

| Requirement                                                                                                                                                              | Why it matters                                                              |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------- |
| **`table_name` / `column_name`** exactly match the objects in EDW.                                                                                                      | Ensures lineage joins & KPI views resolve.                                  |
| **`check_name`** is unique per table × column.                                                                                                                          | Avoids duplicate rows in the dictionary.                                    |
| **`check_sql` returns exactly one row** with at minimum:<br>  `CheckType NVARCHAR(200)` and<br>  `IssueCount INT`.<br>Optional extras: `DuplicateCount`, `NegativeCount`. | Matches the contract consumed by **`[meta_data].[populate_dq_from_dictionary]`**. |
| Query is **idempotent** (read‑only).                                                                                                                                     | Batch can re‑run safely.                                                    |
| If the table is large, make the query **partition‑prunable** (e.g. date filter).                                                                                         | Keeps nightly runtime low.                                                  |
| Test locally with `EXEC sp_executesql @YourSQL;` and confirm it returns the expected single row.                                                                         | Catches errors before the batch run.                                        |

---

### 6.2 Single‑row INSERT pattern

Use this when you are adding only one or two new checks. **Connect to the manager database** (`sqldb-prod-manager`) to insert.

<details>
<summary><strong>Click to expand — ready‑to‑copy script</strong></summary>

```sql
/******************************************************************************
 Author        : <your‑name>
 Created       : <yyyy‑mm‑dd>
 Purpose       : Null CustomerID check on edw.sales.FactOrderLine.
 Database      : sqldb-prod-manager
******************************************************************************/
INSERT INTO [dq].[dq_dictionary]
(
    table_name,       column_name,   check_name,
    filter_clause,    check_sql,     expected_result
)
VALUES
(
    N'edw.sales.FactOrderLine',                     -- table_name (schema‑qualified)
    N'CustomerID',                                  -- column_name
    N'Null CustomerID',                             -- check_name (friendly)
    N'CustomerID IS NULL',                          -- filter_clause (optional)
    N'
    /* Must return one row with IssueCount */
    SELECT
        CheckType  = N''Null CustomerID'',
        IssueCount = COUNT(*)
    FROM edw.sales.FactOrderLine WITH (NOLOCK)
    WHERE CustomerID IS NULL;
    ',
    N'0'                                            -- expected_result
);
```
</details>

---

### 6.3 Bulk‑load pattern with table‑valued parameter

When you need to add many rules at once, you can use a bulk insert approach. **Connect to the manager database** (`sqldb-prod-manager`) to insert.

<details>
<summary><strong>Click to expand — bulk insert script</strong></summary>

```sql
/*---------------------------------------------------------------------------
  Database: sqldb-prod-manager
  Purpose: Bulk insert multiple DQ rules
---------------------------------------------------------------------------*/
-- First, create a temp table for staging
CREATE TABLE #DQBatch
(
    table_name      nvarchar(200),
    column_name     nvarchar(200),
    check_name      nvarchar(200),
    filter_clause   nvarchar(max),
    check_sql       nvarchar(max),
    expected_result nvarchar(50)
);

-- Insert multiple rules
INSERT INTO #DQBatch
(
    table_name,
    column_name,
    check_name,
    filter_clause,
    check_sql,
    expected_result
)
VALUES
(N'edw.fin.DimDate', N'DateKey', N'Key out of range', NULL,
 N'
  SELECT ''Key out of range'' AS CheckType,
         COUNT(*)             AS IssueCount
  FROM edw.fin.DimDate
  WHERE DateKey < 20000101 OR DateKey > 20991231;',
 N'0'),

(N'edw.hr.FactEmployee', N'Salary', N'Negative salary', NULL,
 N'
  SELECT ''Negative salary'' AS CheckType,
         COUNT(*)            AS IssueCount
  FROM edw.hr.FactEmployee
  WHERE Salary < 0;',
 N'0');

-- Insert into the real dictionary
INSERT INTO [dq].[dq_dictionary]
(
    table_name,
    column_name,
    check_name,
    filter_clause,
    check_sql,
    expected_result
)
SELECT
    table_name,
    column_name,
    check_name,
    filter_clause,
    check_sql,
    expected_result
FROM #DQBatch;

-- Clean up
DROP TABLE #DQBatch;
```
</details>

---

### 6.4 Verify the new rule(s)

1. **Option A: Wait for next ADF execution** (Recommended)
   - The daily ADF pipeline will pick up your new rules and populate results in the manager database
   - Check `[dq].[dq_results]` the following day

2. **Option B: Test manually** (for immediate validation)
   ```sql
   -- Connect to: sql-prod-aus-svc-datawarehouse-01.database.windows.net/sqldb-prod-datawarehouse-01
   EXEC [meta_data].[populate_dq_from_dictionary]
        @OnlyInsertWhenRecordCountPositive = 0;          -- include even zero‑issue rows
   ```
   
   **Note**: This will return a result set showing what would be inserted, but **will not update** the manager database. Use this only to validate your check logic is working correctly.

3. **Confirm the results after ADF execution** (from manager database)

   ```sql
   -- Connect to: sql-prod-aus-svc-datawarehouse-01.database.windows.net/sqldb-prod-manager
   SELECT *
   FROM   [dq].[dq_results]
   WHERE  check_name = N'Null CustomerID'          -- or your check name
   ORDER BY run_date_time DESC;
   ```

4. **Refresh lineage (only if you added or modified KPI views)**
   
   The daily ADF pipeline will automatically refresh lineage. For immediate testing:
   ```sql
   -- Connect to: sql-prod-aus-svc-datawarehouse-01.database.windows.net/sqldb-prod-datawarehouse-01
   EXEC [meta_data].[usp_refresh_view_column_flags];
   ```
   
   **Note**: Manual execution returns lineage data but doesn't update the manager database.

5. **Review in KPI views** (from manager database, after ADF execution)

   ```sql
   -- Connect to: sql-prod-aus-svc-datawarehouse-01.database.windows.net/sqldb-prod-manager
   
   -- Row‑level detail:
   SELECT * FROM [dq].[vw_kpi_data_quality_detail];
   
   -- Aggregated scores:
   SELECT * FROM [dq].[vw_kpi_data_quality_score];
   ```

---

### 6.5 Troubleshooting tips

| Symptom                                            | Diagnosis                                                                     | Fix                                                      |
| -------------------------------------------------- | ----------------------------------------------------------------------------- | -------------------------------------------------------- |
| Rule row **missing from `[dq].[dq_results]`**     | `check_sql` errored out or returned zero columns/rows, OR you ran manually instead of via ADF. | Run the SQL stand‑alone in production database; check error. Ensure ADF has executed. |
| **IssueCount always 0** though bad rows exist     | WHERE clause too narrow or wrong table alias.                                 | Debug `check_sql` directly until count > 0.               |
| KPI view shows **healthy** though your rule failed | Column or table name in dictionary doesn't match lineage (`view_column_flags`). | Ensure `table_name` / `column_name` strings are exact.    |
| Nightly batch runtime jumps                        | New rule scans large table without filters.                                   | Add partition‑aligned date filter or supporting index.   |
| Cross-database query fails                         | Permission issues between production and manager databases.                    | Ensure service account has appropriate permissions on both databases. |
| Manual execution shows results but DB not updated  | This is expected behavior - only ADF updates the manager database.            | Wait for next ADF execution or trigger ADF pipeline manually. |