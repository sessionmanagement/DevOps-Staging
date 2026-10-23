

CREATE PROCEDURE [data_monitoring].[obfuscate_client_data]
AS
BEGIN

    /**********************************************************************************************************
        NAME:      data_monitoring.obfuscate_old_client_data
        PURPOSE:   Obfuscate old client data change dates and ethnicity to be less identifiable.

        Revisions:
        Version   Date         Author          Description
        -------   ----------   --------------  ---------------------------------------
        1.0       2026-05-11   Greg Nuthall    Initial version
        1.1       2026-09-15   (Assistant)     Use client_id + company_id join from client_obfuscation_status
    **********************************************************************************************************/

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @company_key_multiplier INT = 100000000;
    DECLARE @default_schema sysname = N'edw';

    --------------------------------------------------------------------------
    -- 1. Build #old_clients from client_obfuscation_status
    --    Now using client_id + company_id explicitly, not compounded key.
    --------------------------------------------------------------------------
    DROP TABLE IF EXISTS #old_clients;

    CREATE TABLE #old_clients
    (
          compound_client_id BIGINT NOT NULL PRIMARY KEY
        , company_id         INT    NOT NULL
        , client_id          INT    NOT NULL
    );

    INSERT INTO #old_clients (compound_client_id, company_id, client_id)
    SELECT DISTINCT
           cs.company_id * @company_key_multiplier + cs.client_id AS compound_client_id,
           cs.company_id,
           cs.client_id
    FROM data_monitoring.client_obfuscation_status cs
    WHERE cs.should_obfuscate_flag = 1;

    IF NOT EXISTS (SELECT 1 FROM #old_clients)
    BEGIN
        SELECT
            CAST(0 AS BIGINT) AS clients_selected,
            CAST(0 AS BIGINT) AS tables_updated,
            CAST(0 AS BIGINT) AS total_rows_updated;
        RETURN;
    END;

    --------------------------------------------------------------------------
    -- 2. Field map from data_monitoring.client_obfuscation_field
    --------------------------------------------------------------------------
    DROP TABLE IF EXISTS #field_map;

    CREATE TABLE #field_map
    (
          schema_name  sysname NOT NULL
        , table_name   sysname NOT NULL
        , column_name  sysname NOT NULL
        , column_type  INT     NULL
    );

    ;WITH src AS
    (
        SELECT DISTINCT
               REPLACE(REPLACE(LTRIM(RTRIM(f.table_name)),  '[', ''), ']', '')  AS table_name_clean,
               REPLACE(REPLACE(LTRIM(RTRIM(f.column_name)), '[', ''), ']', '')  AS column_name_clean,
               f.column_type
        FROM data_monitoring.client_obfuscation_field f
        WHERE f.table_name IS NOT NULL
          AND f.column_name IS NOT NULL
          AND LTRIM(RTRIM(f.table_name)) <> ''
          AND LTRIM(RTRIM(f.column_name)) <> ''
    )
    INSERT INTO #field_map (schema_name, table_name, column_name, column_type)
    SELECT
        CASE
            WHEN CHARINDEX('.', s.table_name_clean) > 0
                THEN PARSENAME(s.table_name_clean, 2)
            ELSE @default_schema
        END AS schema_name,
        CASE
            WHEN CHARINDEX('.', s.table_name_clean) > 0
                THEN PARSENAME(s.table_name_clean, 1)
            ELSE s.table_name_clean
        END AS table_name,
        s.column_name_clean,
        s.column_type
    FROM src s;

    --------------------------------------------------------------------------
    -- 3. Results table
    --------------------------------------------------------------------------
    DROP TABLE IF EXISTS #update_results;

    CREATE TABLE #update_results
    (
          table_name   NVARCHAR(400) NOT NULL
        , rows_updated BIGINT        NOT NULL
        , note         NVARCHAR(300) NULL
    );

    --------------------------------------------------------------------------
    -- 4. Cursor over distinct target tables
    --------------------------------------------------------------------------
    DECLARE
          @schema_name      sysname
        , @table_name       sysname
        , @object_id        INT
        , @client_column    sysname
        , @company_column   sysname
        , @set_clause       NVARCHAR(MAX)
        , @sql              NVARCHAR(MAX)
        , @rows_updated     BIGINT
        , @eth_rows_updated BIGINT;

    DECLARE table_cursor CURSOR LOCAL FAST_FORWARD FOR
        SELECT DISTINCT fm.schema_name, fm.table_name
        FROM #field_map fm
        ORDER BY fm.schema_name, fm.table_name;

    BEGIN TRY
        BEGIN TRANSACTION;

        OPEN table_cursor;
        FETCH NEXT FROM table_cursor INTO @schema_name, @table_name;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @object_id      = OBJECT_ID(QUOTENAME(@schema_name) + N'.' + QUOTENAME(@table_name));
            SET @client_column  = NULL;
            SET @company_column = NULL;
            SET @set_clause     = NULL;
            SET @rows_updated   = 0;

            IF @object_id IS NULL
            BEGIN
                INSERT INTO #update_results (table_name, rows_updated, note)
                VALUES (QUOTENAME(@schema_name) + N'.' + QUOTENAME(@table_name), 0, N'Table not found');
                FETCH NEXT FROM table_cursor INTO @schema_name, @table_name;
                CONTINUE;
            END;

            ------------------------------------------------------------------
            -- 4a. Detect client & company columns in the target table
            ------------------------------------------------------------------
            IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = @object_id AND name = N'client_id')
                SET @client_column = N'client_id';

            IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = @object_id AND name = N'dim_company_key')
                SET @company_column = N'dim_company_key';
            ELSE IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = @object_id AND name = N'company_id')
                SET @company_column = N'company_id';
            ELSE IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = @object_id AND name = N'company_key')
                SET @company_column = N'company_key';

            ------------------------------------------------------------------
            -- If we have no client_id column, we cannot update this table
            ------------------------------------------------------------------
            IF @client_column IS NULL
            BEGIN
                INSERT INTO #update_results (table_name, rows_updated, note)
                VALUES (QUOTENAME(@schema_name) + N'.' + QUOTENAME(@table_name), 0, N'No client_id column found');
                FETCH NEXT FROM table_cursor INTO @schema_name, @table_name;
                CONTINUE;
            END;

            ------------------------------------------------------------------
            -- 4b. Build SET clause for obfuscation
            ------------------------------------------------------------------
            SELECT
                @set_clause = STRING_AGG(
                    N't.' + QUOTENAME(c.name) + N' = ' +
                    CASE
                        WHEN ty.name IN (N'nvarchar', N'nchar', N'ntext')
                            THEN N'N''' + N''''  -- double single quote -> empty NVARCHAR
                        WHEN ty.name IN (N'varchar', N'char', N'text')
                            THEN N'''' + N''''    -- empty ASCII string
                        ELSE N'NULL'
                    END,
                    N', '
                )
            FROM #field_map fm
            INNER JOIN sys.columns c
                ON c.object_id = @object_id
               AND c.name      = fm.column_name
               AND c.is_computed = 0
            INNER JOIN sys.types ty
                ON ty.user_type_id = c.user_type_id
            WHERE fm.schema_name = @schema_name
              AND fm.table_name  = @table_name
              AND (
                    ty.name IN (N'nvarchar', N'nchar', N'ntext', N'varchar', N'char', N'text')
                    OR c.is_nullable = 1
                  );

            IF @set_clause IS NULL
            BEGIN
                INSERT INTO #update_results (table_name, rows_updated, note)
                VALUES (QUOTENAME(@schema_name) + N'.' + QUOTENAME(@table_name), 0, N'No eligible columns to update');
                FETCH NEXT FROM table_cursor INTO @schema_name, @table_name;
                CONTINUE;
            END;

            ------------------------------------------------------------------
            -- 4c. Build dynamic UPDATE using client_id + company_id where possible
            ------------------------------------------------------------------
            SET @sql =
                N'UPDATE t ' + CHAR(13) +
                N'SET ' + @set_clause + CHAR(13) +
                N'FROM ' + QUOTENAME(@schema_name) + N'.' + QUOTENAME(@table_name) + N' t ' + CHAR(13) +
                N'INNER JOIN #old_clients oc ON ' +
                CASE
                    WHEN @company_column IS NOT NULL THEN
                        N't.' + QUOTENAME(@client_column)  + N' = oc.client_id ' +
                        N'AND t.' + QUOTENAME(@company_column) + N' = oc.company_id'
                    ELSE
                        -- Table has no company column; match on client_id only
                        N't.' + QUOTENAME(@client_column) + N' = oc.client_id'
                END +
                N';';

            EXEC sp_executesql @sql;

            SET @rows_updated = @@ROWCOUNT;

            INSERT INTO #update_results (table_name, rows_updated, note)
            VALUES (QUOTENAME(@schema_name) + N'.' + QUOTENAME(@table_name), @rows_updated, N'Updated');

            FETCH NEXT FROM table_cursor INTO @schema_name, @table_name;
        END; -- cursor loop

        ----------------------------------------------------------------------
        -- 5. Additional old-client standardisation: ethnicity & age in dim_client
        ----------------------------------------------------------------------
        IF @@TRANCOUNT > 0
            COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
    END CATCH;

    CLOSE table_cursor;
    DEALLOCATE table_cursor;

    --------------------------------------------------------------------------
    -- 5. Ethnicity & age obfuscation in edw.dim_client (client_id + company_id)
    --------------------------------------------------------------------------
    UPDATE dc
    SET
        -- Ethnicity banding
        primary_ethnicity_id =
            CASE
                WHEN dc.primary_ethnicity_id BETWEEN 10000 AND 19999 THEN 10000
                WHEN dc.primary_ethnicity_id BETWEEN 20000 AND 29999 THEN 21111
                WHEN dc.primary_ethnicity_id BETWEEN 30000 AND 39999 THEN 30000
                WHEN dc.primary_ethnicity_id BETWEEN 40000 AND 49999 THEN 40000
                WHEN dc.primary_ethnicity_id BETWEEN 50000 AND 59999 THEN 51100
                WHEN dc.primary_ethnicity_id BETWEEN 60000 AND 69999 THEN 61199
                ELSE dc.primary_ethnicity_id
            END,
        secondary_ethnicity_id =
            CASE
                WHEN dc.secondary_ethnicity_id BETWEEN 10000 AND 19999 THEN 10000
                WHEN dc.secondary_ethnicity_id BETWEEN 20000 AND 29999 THEN 21111
                WHEN dc.secondary_ethnicity_id BETWEEN 30000 AND 39999 THEN 30000
                WHEN dc.secondary_ethnicity_id BETWEEN 40000 AND 49999 THEN 40000
                WHEN dc.secondary_ethnicity_id BETWEEN 50000 AND 59999 THEN 51100
                WHEN dc.secondary_ethnicity_id BETWEEN 60000 AND 69999 THEN 61199
                ELSE dc.secondary_ethnicity_id
            END,
        tertiary_ethnicity_id =
            CASE
                WHEN dc.tertiary_ethnicity_id BETWEEN 10000 AND 19999 THEN 10000
                WHEN dc.tertiary_ethnicity_id BETWEEN 20000 AND 29999 THEN 21111
                WHEN dc.tertiary_ethnicity_id BETWEEN 30000 AND 39999 THEN 30000
                WHEN dc.tertiary_ethnicity_id BETWEEN 40000 AND 49999 THEN 40000
                WHEN dc.tertiary_ethnicity_id BETWEEN 50000 AND 59999 THEN 51100
                WHEN dc.tertiary_ethnicity_id BETWEEN 60000 AND 69999 THEN 61199
                ELSE dc.tertiary_ethnicity_id
            END,
        fourth_ethnicity_id =
            CASE
                WHEN dc.fourth_ethnicity_id BETWEEN 10000 AND 19999 THEN 10000
                WHEN dc.fourth_ethnicity_id BETWEEN 20000 AND 29999 THEN 21111
                WHEN dc.fourth_ethnicity_id BETWEEN 30000 AND 39999 THEN 30000
                WHEN dc.fourth_ethnicity_id BETWEEN 40000 AND 49999 THEN 40000
                WHEN dc.fourth_ethnicity_id BETWEEN 50000 AND 59999 THEN 51100
                WHEN dc.fourth_ethnicity_id BETWEEN 60000 AND 69999 THEN 61199
                ELSE dc.fourth_ethnicity_id
            END,
        priority_ethnicity_id =
            CASE
                WHEN dc.priority_ethnicity_id BETWEEN 10000 AND 19999 THEN 10000
                WHEN dc.priority_ethnicity_id BETWEEN 20000 AND 29999 THEN 21111
                WHEN dc.priority_ethnicity_id BETWEEN 30000 AND 39999 THEN 30000
                WHEN dc.priority_ethnicity_id BETWEEN 40000 AND 49999 THEN 40000
                WHEN dc.priority_ethnicity_id BETWEEN 50000 AND 59999 THEN 51100
                WHEN dc.priority_ethnicity_id BETWEEN 60000 AND 69999 THEN 61199
                ELSE dc.priority_ethnicity_id
            END,

        -- Iwi mapping (base hapu bands)
        primary_iwi_id =
            CASE
                WHEN dc.primary_iwi_id BETWEEN 20100 AND 20199 THEN 20100
                WHEN dc.primary_iwi_id BETWEEN 20200 AND 20299 THEN 20200
                WHEN dc.primary_iwi_id BETWEEN 20300 AND 20399 THEN 20300
                WHEN dc.primary_iwi_id BETWEEN 20400 AND 20499 THEN 20400
                WHEN dc.primary_iwi_id BETWEEN 20500 AND 20599 THEN 20500
                WHEN dc.primary_iwi_id BETWEEN 20600 AND 20699 THEN 20600
                WHEN dc.primary_iwi_id BETWEEN 20700 AND 20799 THEN 20700
                WHEN dc.primary_iwi_id BETWEEN 20800 AND 20899 THEN 20800
                WHEN dc.primary_iwi_id BETWEEN 20900 AND 20999 THEN 20900
                WHEN dc.primary_iwi_id BETWEEN 21000 AND 21099 THEN 21000
                WHEN dc.primary_iwi_id BETWEEN 21100 AND 21199 THEN 21100
                WHEN dc.primary_iwi_id BETWEEN 21200 AND 21299 THEN 21200
                WHEN dc.primary_iwi_id BETWEEN 22000 AND 22099 THEN 22000
                WHEN dc.primary_iwi_id BETWEEN 22100 AND 22199 THEN 22100
                WHEN dc.primary_iwi_id BETWEEN 22200 AND 22299 THEN 22200
                WHEN dc.primary_iwi_id BETWEEN 22300 AND 22399 THEN 22300
                ELSE dc.primary_iwi_id
            END,
        secondary_iwi_id =
            CASE
                WHEN dc.secondary_iwi_id BETWEEN 20100 AND 20199 THEN 20100
                WHEN dc.secondary_iwi_id BETWEEN 20200 AND 20299 THEN 20200
                WHEN dc.secondary_iwi_id BETWEEN 20300 AND 20399 THEN 20300
                WHEN dc.secondary_iwi_id BETWEEN 20400 AND 20499 THEN 20400
                WHEN dc.secondary_iwi_id BETWEEN 20500 AND 20599 THEN 20500
                WHEN dc.secondary_iwi_id BETWEEN 20600 AND 20699 THEN 20600
                WHEN dc.secondary_iwi_id BETWEEN 20700 AND 20799 THEN 20700
                WHEN dc.secondary_iwi_id BETWEEN 20800 AND 20899 THEN 20800
                WHEN dc.secondary_iwi_id BETWEEN 20900 AND 20999 THEN 20900
                WHEN dc.secondary_iwi_id BETWEEN 21000 AND 21099 THEN 21000
                WHEN dc.secondary_iwi_id BETWEEN 21100 AND 21199 THEN 21100
                WHEN dc.secondary_iwi_id BETWEEN 21200 AND 21299 THEN 21200
                WHEN dc.secondary_iwi_id BETWEEN 22000 AND 22099 THEN 22000
                WHEN dc.secondary_iwi_id BETWEEN 22100 AND 22199 THEN 22100
                WHEN dc.secondary_iwi_id BETWEEN 22200 AND 22299 THEN 22200
                WHEN dc.secondary_iwi_id BETWEEN 22300 AND 22399 THEN 22300
                ELSE dc.secondary_iwi_id
            END,
        tertiary_iwi_id =
            CASE
                WHEN dc.tertiary_iwi_id BETWEEN 20100 AND 20199 THEN 20100
                WHEN dc.tertiary_iwi_id BETWEEN 20200 AND 20299 THEN 20200
                WHEN dc.tertiary_iwi_id BETWEEN 20300 AND 20399 THEN 20300
                WHEN dc.tertiary_iwi_id BETWEEN 20400 AND 20499 THEN 20400
                WHEN dc.tertiary_iwi_id BETWEEN 20500 AND 20599 THEN 20500
                WHEN dc.tertiary_iwi_id BETWEEN 20600 AND 20699 THEN 20600
                WHEN dc.tertiary_iwi_id BETWEEN 20700 AND 20799 THEN 20700
                WHEN dc.tertiary_iwi_id BETWEEN 20800 AND 20899 THEN 20800
                WHEN dc.tertiary_iwi_id BETWEEN 20900 AND 20999 THEN 20900
                WHEN dc.tertiary_iwi_id BETWEEN 21000 AND 21099 THEN 21000
                WHEN dc.tertiary_iwi_id BETWEEN 21100 AND 21199 THEN 21100
                WHEN dc.tertiary_iwi_id BETWEEN 21200 AND 21299 THEN 21200
                WHEN dc.tertiary_iwi_id BETWEEN 22000 AND 22099 THEN 22000
                WHEN dc.tertiary_iwi_id BETWEEN 22100 AND 22199 THEN 22100
                WHEN dc.tertiary_iwi_id BETWEEN 22200 AND 22299 THEN 22200
                WHEN dc.tertiary_iwi_id BETWEEN 22300 AND 22399 THEN 22300
                ELSE dc.tertiary_iwi_id
            END,
        fourth_iwi_id =
            CASE
                WHEN dc.fourth_iwi_id BETWEEN 20100 AND 20199 THEN 20100
                WHEN dc.fourth_iwi_id BETWEEN 20200 AND 20299 THEN 20200
                WHEN dc.fourth_iwi_id BETWEEN 20300 AND 20399 THEN 20300
                WHEN dc.fourth_iwi_id BETWEEN 20400 AND 20499 THEN 20400
                WHEN dc.fourth_iwi_id BETWEEN 20500 AND 20599 THEN 20500
                WHEN dc.fourth_iwi_id BETWEEN 20600 AND 20699 THEN 20600
                WHEN dc.fourth_iwi_id BETWEEN 20700 AND 20799 THEN 20700
                WHEN dc.fourth_iwi_id BETWEEN 20800 AND 20899 THEN 20800
                WHEN dc.fourth_iwi_id BETWEEN 20900 AND 20999 THEN 20900
                WHEN dc.fourth_iwi_id BETWEEN 21000 AND 21099 THEN 21000
                WHEN dc.fourth_iwi_id BETWEEN 21100 AND 21199 THEN 21100
                WHEN dc.fourth_iwi_id BETWEEN 21200 AND 21299 THEN 21200
                WHEN dc.fourth_iwi_id BETWEEN 22000 AND 22099 THEN 22000
                WHEN dc.fourth_iwi_id BETWEEN 22100 AND 22199 THEN 22100
                WHEN dc.fourth_iwi_id BETWEEN 22200 AND 22299 THEN 22200
                WHEN dc.fourth_iwi_id BETWEEN 22300 AND 22399 THEN 22300
                ELSE dc.fourth_iwi_id
            END,

        -- DOB to 15th of month, age rounded
        client_date_of_birth =
            DATEFROMPARTS(YEAR(dc.client_date_of_birth), MONTH(dc.client_date_of_birth), 15),
        client_age_years =
            CASE
                WHEN isnull(dc.client_date_of_death,'1900-01-01') = '1900-01-01' THEN
                    FLOOR(DATEDIFF(DAY,
                                   dc.client_date_of_birth,
                                   CONVERT(DATETIME, SWITCHOFFSET(
                                       GETDATE() AT TIME ZONE 'New Zealand Standard Time',
                                       DATEPART(TZOFFSET,
                                                GETDATE() AT TIME ZONE 'New Zealand Standard Time')
                                   ))) / 365.25)
                ELSE
                    FLOOR(DATEDIFF(DAY,
                                   dc.client_date_of_birth,
                                   dc.client_date_of_death) / 365.25)
            END
    FROM edw.dim_client dc
    INNER JOIN #old_clients oc
        ON dc.client_id  = oc.client_id
       AND dc.company_id = oc.company_id;

    SET @eth_rows_updated = @@ROWCOUNT;

    INSERT INTO #update_results (table_name, rows_updated, note)
    VALUES (N'[edw].[dim_client]', @eth_rows_updated, N'Generic ethnicity/iwi mapping applied for old clients');

    --------------------------------------------------------------------------
    -- 6. Return summary
    --------------------------------------------------------------------------
    SELECT
        (SELECT COUNT_BIG(1)       FROM #old_clients)       AS clients_selected,
        (SELECT COUNT_BIG(1)       FROM #update_results WHERE rows_updated > 0) AS tables_updated,
        (SELECT COALESCE(SUM(rows_updated), 0) FROM #update_results) AS total_rows_updated;

    SELECT
        ur.table_name,
        ur.rows_updated,
        ur.note
    FROM #update_results ur
    ORDER BY ur.table_name;

END;