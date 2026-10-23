
Create   PROCEDURE [meta_data].[usp_refresh_view_column_flags]
AS
BEGIN
    SET NOCOUNT ON;

    /*---------------------------------------------------------------
      0. Ensure persistent table exists
    ----------------------------------------------------------------*/
    --IF OBJECT_ID('dq.ViewColumnFlags','U') IS NULL
    --BEGIN
    --    CREATE TABLE dq.ViewColumnFlags
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
    --        LoadDtm           datetime2(3)  NOT NULL DEFAULT SYSUTCDATETIME(),
    --        CONSTRAINT PK_ViewColumnFlags
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
          5. Reload persistent table
        -----------------------------------------------------------*/
        --TRUNCATE TABLE dq.ViewColumnFlags;

        --INSERT INTO dq.ViewColumnFlags
        --(
        --    view_name, source_table, source_column,
        --    is_in_select, is_distinct_select, is_in_where, is_in_join,
        --    is_in_group_by, is_in_having, is_in_order_by, is_aggregated,
        --    is_in_outer_apply, is_in_cross_apply, is_in_window,
        --    is_in_case, is_in_function, is_in_expression,
        --    has_select_star
        --)
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