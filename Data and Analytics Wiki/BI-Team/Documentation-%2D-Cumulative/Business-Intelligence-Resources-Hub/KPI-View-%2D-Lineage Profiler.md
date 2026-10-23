A lightweight, **pure‑T‑SQL** script that inspects every `kpi_*` view in the `edw` schema and flags _how_ each source column is used (e.g. `SELECT`, `WHERE`, `GROUP BY`, `OUTER APPLY`, window functions, etc.).  
Because it relies only on pattern matching with `CHARINDEX`/`PATINDEX`, it requires **no permanent objects, CLR, or third‑party parsers** – drop the batch into SSMS / Azure Data Studio and execute.

* * *

1  Quick‑start
--------------

    /* paste entire block – it self‑cleans any temp tables */
    <copy the script from §4 below>
    

_Run time_: 1‑5 s for ~100 views (depends on text size).  
_Output_: one row per **view × column** with a `BIT` flag for each clause.

* * *

2  What problem does it solve?
------------------------------

*   **Our KPI views** frequently contain 10 + CTEs. Manually answering _“Is this column used for filtering?”_ or _“Which tables are used by this view?”_ is error‑prone.
    
*   Purview isn't available in dev environments.
    
*   This script provides an **80‑20** snapshot for everyday debugging:
    
| Example question | Scan the flag(s) |
| --- | --- |
| “Which columns participate in the new `GROUP BY`?” | `IsInGroupBy = 1` |
| “Does the view hide a `SELECT *` dinosaur?” | `HasSelectStar = 1` |
| “Why is my filter column missing from execution plans?” | `IsInWhere = 0` (probably filtered upstream, not here) |

* * *

3  Prerequisites & conventions
------------------------------

| Requirement | Notes |
| --- | --- |
| Azure SQL Database / SQL DW | Uses `sys.dm_sql_referenced_entities` and `sys.sql_modules`. |
| Login can read metadata | Membership in `db_datareader` or higher. |
| Schema conventions | Views live in **`edw`**, start with **`kpi_`**, but not `kpi_snapshot_%`. Adjust the `WHERE` clause if naming changes. |
| Source columns must remain _exact_ names | Aliased columns can’t be resolved by native text search. |

* * *

4  Full script
--------------

    /* ─────────────────────────  0. House‑keeping  ─────────────────────────── */
    IF OBJECT_ID('tempdb..#view_details')     IS NOT NULL DROP TABLE #view_details;
    IF OBJECT_ID('tempdb..#view_definitions') IS NOT NULL DROP TABLE #view_definitions;
    IF OBJECT_ID('tempdb..#details_flags')    IS NOT NULL DROP TABLE #details_flags;
    
    /* ─────────────────────────  1. Dependency scan  ───────────────────────── */
    SELECT  v.name AS ViewName,
            r.referenced_schema_name + '.' + r.referenced_entity_name AS SourceTable,
            r.referenced_minor_name                                   AS SourceColumn
    INTO    #view_details
    FROM    sys.views AS v
    CROSS   APPLY sys.dm_sql_referenced_entities(
                QUOTENAME(SCHEMA_NAME(v.schema_id))+'.'+QUOTENAME(v.name),
                'OBJECT') AS r
    WHERE   SCHEMA_NAME(v.schema_id) = 'edw'
      AND   v.name LIKE 'kpi_%'
      AND   v.name NOT LIKE 'kpi_snapshot_%';
    
    /* ─────────────────────────  2. Pull & pre‑clean view text  ─────────────── */
    SELECT  v.name                                               AS ViewName,
            UPPER(REPLACE(REPLACE(sm.definition,char(9),' '),char(13)+char(10),' ')) AS ViewDef
    INTO    #view_definitions
    FROM    sys.views       v
    JOIN    sys.sql_modules sm ON sm.object_id = v.object_id
    WHERE   SCHEMA_NAME(v.schema_id) = 'edw'
      AND   v.name LIKE 'kpi_%'
      AND   v.name NOT LIKE 'kpi_snapshot_%';
    
    /* scalar fns to watch                                 */
    DECLARE @fnList varchar(4000) = 'ISNULL|COALESCE|LEN|DATEDIFF|ABS|ROUND';
    
    /* ─────────────────────────  3. Flag enrichment  ───────────────────────── */
    SELECT  vd.ViewName,
            vd.SourceTable,
            vd.SourceColumn,
    
            /* Clause‑level flags */
            CASE WHEN PATINDEX('%SELECT %'+vd.SourceColumn+'%',         d.ViewDef) > 0 THEN 1 ELSE 0 END AS IsInSelect,
            CASE WHEN PATINDEX('%SELECT DISTINCT %'+vd.SourceColumn+'%',d.ViewDef) > 0 THEN 1 ELSE 0 END AS IsDistinctSelect,
            CASE WHEN PATINDEX('%WHERE %'+vd.SourceColumn+'%',          d.ViewDef) > 0 THEN 1 ELSE 0 END AS IsInWhere,
            CASE WHEN PATINDEX('%JOIN %'+vd.SourceColumn+'%',           d.ViewDef) > 0
                   OR PATINDEX('% ON %'+vd.SourceColumn+'%',            d.ViewDef) > 0 THEN 1 ELSE 0 END AS IsInJoin,
            CASE WHEN PATINDEX('%GROUP BY %'+vd.SourceColumn+'%',       d.ViewDef) > 0 THEN 1 ELSE 0 END AS IsInGroupBy,
            CASE WHEN PATINDEX('%HAVING %'+vd.SourceColumn+'%',         d.ViewDef) > 0 THEN 1 ELSE 0 END AS IsInHaving,
            CASE WHEN PATINDEX('%ORDER BY %'+vd.SourceColumn+'%',       d.ViewDef) > 0 THEN 1 ELSE 0 END AS IsInOrderBy,
    
            /* Aggregates */
            CASE WHEN PATINDEX('%SUM(%'+vd.SourceColumn+'%)%',          REPLACE(d.ViewDef,' ','')) > 0
                   OR PATINDEX('%COUNT(%'+vd.SourceColumn+'%)%',        REPLACE(d.ViewDef,' ','')) > 0
                   OR PATINDEX('%AVG(%'+vd.SourceColumn+'%)%',          REPLACE(d.ViewDef,' ','')) > 0
                   OR PATINDEX('%MIN(%'+vd.SourceColumn+'%)%',          REPLACE(d.ViewDef,' ','')) > 0
                   OR PATINDEX('%MAX(%'+vd.SourceColumn+'%)%',          REPLACE(d.ViewDef,' ','')) > 0 THEN 1 ELSE 0 END AS IsAggregated,
    
            /* APPLY */
            CASE WHEN PATINDEX('%OUTER APPLY%'+vd.SourceColumn+'%',     d.ViewDef) > 0 THEN 1 ELSE 0 END AS IsInOuterApply,
            CASE WHEN PATINDEX('%CROSS APPLY%'+vd.SourceColumn+'%',     d.ViewDef) > 0 THEN 1 ELSE 0 END AS IsInCrossApply,
    
            /* Window, CASE, scalar fn, expression */
            CASE WHEN PATINDEX('% OVER (%'+vd.SourceColumn+'%',         d.ViewDef) > 0
                   OR PATINDEX('% OVER(%'+vd.SourceColumn+'%',          d.ViewDef) > 0 THEN 1 ELSE 0 END AS IsInWindow,
            CASE WHEN PATINDEX('%CASE %'+vd.SourceColumn+'%',           d.ViewDef) > 0 THEN 1 ELSE 0 END AS IsInCase,
            CASE WHEN EXISTS (SELECT 1 FROM string_split(@fnList,'|') f
                              WHERE  PATINDEX('%'+value+'(%'+vd.SourceColumn+'%', d.ViewDef) > 0) THEN 1 ELSE 0 END AS IsInFunction,
            CASE WHEN PATINDEX('%'+vd.SourceColumn+'+%',                d.ViewDef) > 0
                   OR PATINDEX('%\+'+vd.SourceColumn+'%',               d.ViewDef) > 0
                   OR PATINDEX('%'+vd.SourceColumn+'-%',                d.ViewDef) > 0
                   OR PATINDEX('%-'+vd.SourceColumn+'%',                d.ViewDef) > 0
                   OR PATINDEX('%'+vd.SourceColumn+'*%',                d.ViewDef) > 0
                   OR PATINDEX('%'+vd.SourceColumn+'/%',                d.ViewDef) > 0
                   OR PATINDEX('%'+vd.SourceColumn+'||%',               d.ViewDef) > 0 THEN 1 ELSE 0 END AS IsInExpression,
    
            /* Whole‑view star select */
            CASE WHEN CHARINDEX('SELECT *', d.ViewDef) > 0 THEN 1 ELSE 0 END AS HasSelectStar
    INTO    #details_flags
    FROM    #view_details    vd
    JOIN    #view_definitions d ON d.ViewName = vd.ViewName;
    
    /* ─────────────────────────  4. Final report  ─────────────────────────── */
    SELECT  ViewName,
            SourceTable,
            SourceColumn,
            IsInSelect, IsDistinctSelect, IsInWhere, IsInJoin,
            IsInGroupBy, IsInHaving, IsInOrderBy, IsAggregated,
            IsInOuterApply, IsInCrossApply, IsInWindow,
            IsInCase, IsInFunction, IsInExpression,
            HasSelectStar
    FROM    #details_flags
    WHERE   SourceColumn IS NOT NULL
      AND   SourceColumn NOT LIKE 'DWH%'           -- skip warehouse audit columns
    ORDER BY ViewName, SourceTable, SourceColumn;
    GO
    

* * *

5  Flag reference
-----------------

| Flag | Meaning (set to **1** when …) |
| --- | --- |
| `IsInSelect` | Column appears in a `SELECT` list. |
| `IsDistinctSelect` | Column appears in a `SELECT DISTINCT` list. |
| `IsInWhere` | Column text is inside any `WHERE` clause. |
| `IsInJoin` | Column occurs in a `JOIN … ON …` predicate. |
| `IsInGroupBy`, `IsInHaving`, `IsInOrderBy` | Obvious. |
| `IsAggregated` | Column is parameter to `SUM/COUNT/AVG/MIN/MAX`. |
| `IsInOuterApply`, `IsInCrossApply` | Column referenced inside those `APPLY` clauses. |
| `IsInWindow` | Column sits inside a window‑function `OVER (…)`. |
| `IsInCase` | Column appears between `CASE` … `END`. |
| `IsInFunction` | Column is first argument to any scalar fn in `@fnList`. |
| `IsInExpression` | Column participates in `+ – * / |
| `HasSelectStar` | The view text contains a literal `SELECT *`. |

* * *

6  Limitations & gotchas
------------------------

*   **Aliases** – The script sees literal names only. `dc.client_id` will _not_ match `client_id`.
    
*   **Dynamic SQL / EXEC()** – Not inspected.
    
*   **Comments & strings** – If a column name is inside a comment it could be a false positive.
    
*   **Sub‑queries** – A column flagged as `IsInWhere` might belong to an inner query.
    
*   **Substring collisions** – Column `id` in `identity` can mis‑hit; add word‑boundary patterns if required.
    

* * *

7  Typical workflow
-------------------

1.  **Dev box** – run script, export CSV.
    
2.  **Filter** – locate un‑grouped columns before committing view changes.
    
3.  **CI pipeline** – execute in a script task; fail build if `HasSelectStar = 1`.
    
4.  **Nightly audit** – store results to a table and diff for unexpected lineage drift.
    

* * *

8  Extending the script
-----------------------

*   **More functions** – append to `@fnList`.
    
*   **Join‑type flags** – duplicate `IsInJoin` check with `%LEFT JOIN %`.
    
*   **Persist results** – replace temp tables with a permanent staging table; schedule via ADF.
    

* * *