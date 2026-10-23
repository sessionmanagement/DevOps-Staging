-- =============================================
-- Stored Procedure: Sync Data Definitions to Extended Properties
-- Author: Greg Nuthall
-- Created: 2025-12-19
-- Modified: 2025-12-22 - Fixed sql_variant type clash with NVARCHAR(MAX)
-- Purpose: Synchronize meta_data.data_definitions to SQL Server extended properties
-- =============================================

CREATE   PROCEDURE [meta_data].[data_definitions_sync_to_extended_properties]
    @schema_name            VARCHAR(128) = NULL,
    @table_name             VARCHAR(128) = NULL,
    @column_name            VARCHAR(128) = NULL,
    @data_definition_id     INT = NULL,
    @sync_all               BIT = 0,
    @remove_orphaned        BIT = 0
AS
/**********************************************************************************************************
 Procedure: [meta_data].[sync_data_definitions_to_extended_properties]
 Author:    Greg Nuthall
 Created:   2025-12-19
 Purpose:   Synchronize data definitions to SQL Server extended properties
 
 Parameters:
    @schema_name            - Optional: Sync specific schema
    @table_name             - Optional: Sync specific table
    @column_name            - Optional: Sync specific column
    @data_definition_id     - Optional: Sync specific definition by ID
    @sync_all               - If 1, sync all active definitions; if 0, use filters
    @remove_orphaned        - If 1, remove extended properties that don't exist in data_definitions

 Extended Property Naming Convention:
    Property Name = 'DataDef_' + [data_definition_type]
    Examples: 'DataDef_Description', 'DataDef_BusinessRule', 'DataDef_DataSource'

 Example 1 - Sync all definitions:
    EXEC [meta_data].[sync_data_definitions_to_extended_properties] @sync_all = 1;

 Example 2 - Sync specific table:
    EXEC [meta_data].[sync_data_definitions_to_extended_properties] 
        @schema_name = 'edw',
        @table_name = 'dim_employee';

 Example 3 - Sync specific column:
    EXEC [meta_data].[sync_data_definitions_to_extended_properties] 
        @schema_name = 'edw',
        @table_name = 'dim_employee',
        @column_name = 'employee_id';

 Example 4 - Sync and remove orphaned properties:
    EXEC [meta_data].[sync_data_definitions_to_extended_properties] 
        @schema_name = 'edw',
        @table_name = 'dim_employee',
        @remove_orphaned = 1;

 REVISIONS:
 Version  Date        Author          Description
 -------  ----------  --------------  --------------------------
 1.0      2025-12-19  Greg Nuthall    Initial creation
 1.1      2025-12-22  Greg Nuthall    Fixed NVARCHAR(MAX) to sql_variant type clash
                                      by casting to NVARCHAR(7500)
**********************************************************************************************************/
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @added_count INT = 0;
    DECLARE @updated_count INT = 0;
    DECLARE @removed_count INT = 0;
    DECLARE @error_count INT = 0;
    DECLARE @current_schema VARCHAR(128);
    DECLARE @current_table VARCHAR(128);
    DECLARE @current_column VARCHAR(128);
    DECLARE @current_type VARCHAR(50);
    DECLARE @current_definition NVARCHAR(MAX);
    DECLARE @property_name VARCHAR(128);
    DECLARE @error_message NVARCHAR(MAX);
    DECLARE @property_value NVARCHAR(4000);  -- Fixed length for sql_variant compatibility

    BEGIN TRY
        -- Validation
        IF @sync_all = 0 AND @data_definition_id IS NULL AND @schema_name IS NULL
        BEGIN
            THROW 50001, 'Must specify @sync_all = 1, @data_definition_id, or at least @schema_name', 1;
        END

        -- Create temp table for definitions to sync
        CREATE TABLE #definitions_to_sync
        (
            data_definition_id INT,
            schema_name VARCHAR(128),
            table_name VARCHAR(128),
            column_name VARCHAR(128),
            data_definition_type VARCHAR(50),
            data_definition NVARCHAR(MAX),
            property_name VARCHAR(128)
        );

        -- Populate definitions to sync
        INSERT INTO #definitions_to_sync
        SELECT 
            dd.data_definition_id,
            dd.schema_name,
            dd.table_name,
            dd.column_name,
            dd.data_definition_type,
            dd.data_definition,
            'DataDef_' + dd.data_definition_type AS property_name
        FROM [meta_data].[data_definitions] dd
        WHERE dd.is_active = 1
            AND (@sync_all = 1 OR @data_definition_id IS NOT NULL OR @schema_name IS NOT NULL)
            AND (@data_definition_id IS NULL OR dd.data_definition_id = @data_definition_id)
            AND (@schema_name IS NULL OR dd.schema_name = @schema_name)
            AND (@table_name IS NULL OR dd.table_name = @table_name)
            AND (@column_name IS NULL OR dd.column_name = @column_name);

        -- Process each definition
        DECLARE definition_cursor CURSOR LOCAL FAST_FORWARD FOR
        SELECT 
            schema_name,
            table_name,
            column_name,
            data_definition_type,
            data_definition,
            property_name
        FROM #definitions_to_sync
        ORDER BY schema_name, table_name, column_name, data_definition_type;

        OPEN definition_cursor;
        FETCH NEXT FROM definition_cursor INTO 
            @current_schema, @current_table, @current_column, 
            @current_type, @current_definition, @property_name;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            BEGIN TRY
                -- Convert NVARCHAR(MAX) to NVARCHAR(7500) for sql_variant compatibility
                -- Truncate if necessary with warning
                IF LEN(@current_definition) > 7500
                BEGIN
                    SET @property_value = LEFT(@current_definition, 7497) + '...';
                    PRINT 'WARNING: Definition truncated for [' + @current_schema + '].[' + @current_table + '].[' + 
                          @current_column + '] - ' + @current_type + ' (Length: ' + CAST(LEN(@current_definition) AS VARCHAR) + ')';
                END
                ELSE
                BEGIN
                    SET @property_value = CAST(@current_definition AS NVARCHAR(4000));
                END

                -- Check if extended property already exists
                IF EXISTS (
                    SELECT 1 
                    FROM sys.extended_properties ep
                    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
                    INNER JOIN sys.tables t ON c.object_id = t.object_id
                    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
                    WHERE s.name = @current_schema
                        AND t.name = @current_table
                        AND c.name = @current_column
                        AND ep.name = @property_name
                        AND ep.class = 1  -- Object or column
                )
                BEGIN
                    -- Update existing property
                    EXEC sys.sp_updateextendedproperty 
                        @name = @property_name,
                        @value = @property_value,  -- Use fixed-length NVARCHAR
                        @level0type = N'SCHEMA',
                        @level0name = @current_schema,
                        @level1type = N'TABLE',
                        @level1name = @current_table,
                        @level2type = N'COLUMN',
                        @level2name = @current_column;

                    SET @updated_count = @updated_count + 1;
                END
                ELSE
                BEGIN
                    -- Add new property
                    EXEC sys.sp_addextendedproperty 
                        @name = @property_name,
                        @value = @property_value,  -- Use fixed-length NVARCHAR
                        @level0type = N'SCHEMA',
                        @level0name = @current_schema,
                        @level1type = N'TABLE',
                        @level1name = @current_table,
                        @level2type = N'COLUMN',
                        @level2name = @current_column;

                    SET @added_count = @added_count + 1;
                END
            END TRY
            BEGIN CATCH
                SET @error_message = ERROR_MESSAGE();
                SET @error_count = @error_count + 1;
                
                -- Log error but continue processing
                PRINT 'Error processing [' + @current_schema + '].[' + @current_table + '].[' + @current_column + '] - ' + 
                      @current_type + ': ' + @error_message;
            END CATCH

            FETCH NEXT FROM definition_cursor INTO 
                @current_schema, @current_table, @current_column, 
                @current_type, @current_definition, @property_name;
        END

        CLOSE definition_cursor;
        DEALLOCATE definition_cursor;

        -- Remove orphaned extended properties if requested
        IF @remove_orphaned = 1
        BEGIN
            DECLARE @orphan_schema VARCHAR(128);
            DECLARE @orphan_table VARCHAR(128);
            DECLARE @orphan_column VARCHAR(128);
            DECLARE @orphan_property VARCHAR(128);

            -- Create temp table for orphaned properties
            CREATE TABLE #orphaned_properties
            (
                schema_name VARCHAR(128),
                table_name VARCHAR(128),
                column_name VARCHAR(128),
                property_name VARCHAR(128)
            );

            -- Find extended properties that start with 'DataDef_' but don't exist in data_definitions
            INSERT INTO #orphaned_properties
            SELECT 
                s.name AS schema_name,
                t.name AS table_name,
                c.name AS column_name,
                ep.name AS property_name
            FROM sys.extended_properties ep
            INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
            INNER JOIN sys.tables t ON c.object_id = t.object_id
            INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
            WHERE ep.class = 1  -- Object or column
                AND ep.name LIKE 'DataDef_%'
                AND (@schema_name IS NULL OR s.name = @schema_name)
                AND (@table_name IS NULL OR t.name = @table_name)
                AND (@column_name IS NULL OR c.name = @column_name)
                AND NOT EXISTS (
                    SELECT 1 
                    FROM [meta_data].[data_definitions] dd
                    WHERE dd.schema_name = s.name
                        AND dd.table_name = t.name
                        AND dd.column_name = c.name
                        AND 'DataDef_' + dd.data_definition_type = ep.name
                        AND dd.is_active = 1
                );

            -- Remove orphaned properties
            DECLARE orphan_cursor CURSOR LOCAL FAST_FORWARD FOR
            SELECT schema_name, table_name, column_name, property_name
            FROM #orphaned_properties;

            OPEN orphan_cursor;
            FETCH NEXT FROM orphan_cursor INTO 
                @orphan_schema, @orphan_table, @orphan_column, @orphan_property;

            WHILE @@FETCH_STATUS = 0
            BEGIN
                BEGIN TRY
                    EXEC sys.sp_dropextendedproperty 
                        @name = @orphan_property,
                        @level0type = N'SCHEMA',
                        @level0name = @orphan_schema,
                        @level1type = N'TABLE',
                        @level1name = @orphan_table,
                        @level2type = N'COLUMN',
                        @level2name = @orphan_column;

                    SET @removed_count = @removed_count + 1;
                END TRY
                BEGIN CATCH
                    SET @error_message = ERROR_MESSAGE();
                    SET @error_count = @error_count + 1;
                    
                    PRINT 'Error removing orphaned property [' + @orphan_schema + '].[' + @orphan_table + '].[' + @orphan_column + '] - ' + 
                          @orphan_property + ': ' + @error_message;
                END CATCH

                FETCH NEXT FROM orphan_cursor INTO 
                    @orphan_schema, @orphan_table, @orphan_column, @orphan_property;
            END

            CLOSE orphan_cursor;
            DEALLOCATE orphan_cursor;

            DROP TABLE #orphaned_properties;
        END

        DROP TABLE #definitions_to_sync;

        -- Return summary
        SELECT 
            'SUCCESS' AS Status,
            @added_count AS PropertiesAdded,
            @updated_count AS PropertiesUpdated,
            @removed_count AS PropertiesRemoved,
            @error_count AS ErrorCount,
            CASE 
                WHEN @error_count = 0 THEN 'All operations completed successfully'
                ELSE 'Completed with ' + CAST(@error_count AS VARCHAR) + ' error(s). Check messages for details.'
            END AS Message;

    END TRY
    BEGIN CATCH
        -- Cleanup cursors if still open
        IF CURSOR_STATUS('local', 'definition_cursor') >= 0
        BEGIN
            CLOSE definition_cursor;
            DEALLOCATE definition_cursor;
        END

        IF CURSOR_STATUS('local', 'orphan_cursor') >= 0
        BEGIN
            CLOSE orphan_cursor;
            DEALLOCATE orphan_cursor;
        END

        -- Return error details
        SELECT 
            'ERROR' AS Status,
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_MESSAGE() AS ErrorMessage,
            ERROR_LINE() AS ErrorLine;

        THROW;
    END CATCH
END