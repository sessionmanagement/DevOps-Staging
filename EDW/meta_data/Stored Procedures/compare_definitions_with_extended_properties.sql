
-- =============================================
-- Create procedure to compare data_definitions with extended properties
-- =============================================
CREATE   PROCEDURE [meta_data].[compare_definitions_with_extended_properties]
    @schema_name    VARCHAR(128) = NULL,
    @table_name     VARCHAR(128) = NULL
AS
/**********************************************************************************************************
 Procedure: [meta_data].[compare_definitions_with_extended_properties]
 Author:    Greg Nuthall
 Created:   2025-12-19
 Purpose:   Compare data_definitions table with actual extended properties to identify discrepancies
 
 Returns three result sets:
    1. Definitions that need to be added to extended properties
    2. Definitions that exist but values differ
    3. Extended properties that should be removed (orphaned)

 Example:
    EXEC [meta_data].[compare_definitions_with_extended_properties] 
        @schema_name = 'edw',
        @table_name = 'dim_employee';
**********************************************************************************************************/
BEGIN
    SET NOCOUNT ON;

    -- 1. Definitions that need to be ADDED (in data_definitions but not in extended properties)
    SELECT 
        'MISSING IN EXTENDED PROPERTIES' AS Status,
        dd.data_definition_id,
        dd.schema_name,
        dd.table_name,
        dd.column_name,
        dd.data_definition_type,
        'DataDef_' + dd.data_definition_type AS property_name,
        dd.data_definition AS definition_value,
        NULL AS extended_property_value
    FROM [meta_data].[data_definitions] dd
    WHERE dd.is_active = 1
        AND (@schema_name IS NULL OR dd.schema_name = @schema_name)
        AND (@table_name IS NULL OR dd.table_name = @table_name)
        AND NOT EXISTS (
            SELECT 1 
            FROM sys.extended_properties ep
            INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
            INNER JOIN sys.tables t ON c.object_id = t.object_id
            INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
            WHERE s.name = dd.schema_name
                AND t.name = dd.table_name
                AND c.name = dd.column_name
                AND ep.name = 'DataDef_' + dd.data_definition_type
                AND ep.class = 1
        )
    ORDER BY dd.schema_name, dd.table_name, dd.column_name, dd.data_definition_type;

    -- 2. Definitions with DIFFERENT VALUES
    SELECT 
        'VALUE MISMATCH' AS Status,
        dd.data_definition_id,
        dd.schema_name,
        dd.table_name,
        dd.column_name,
        dd.data_definition_type,
        'DataDef_' + dd.data_definition_type AS property_name,
        dd.data_definition AS definition_value,
        CAST(ep.value AS NVARCHAR(MAX)) AS extended_property_value
    FROM [meta_data].[data_definitions] dd
    INNER JOIN sys.schemas s ON dd.schema_name = s.name
    INNER JOIN sys.tables t ON dd.table_name = t.name AND t.schema_id = s.schema_id
    INNER JOIN sys.columns c ON dd.column_name = c.name AND c.object_id = t.object_id
    INNER JOIN sys.extended_properties ep 
        ON ep.major_id = c.object_id 
        AND ep.minor_id = c.column_id
        AND ep.name = 'DataDef_' + dd.data_definition_type
        AND ep.class = 1
    WHERE dd.is_active = 1
        AND (@schema_name IS NULL OR dd.schema_name = @schema_name)
        AND (@table_name IS NULL OR dd.table_name = @table_name)
        AND CAST(ep.value AS NVARCHAR(MAX)) <> dd.data_definition
    ORDER BY dd.schema_name, dd.table_name, dd.column_name, dd.data_definition_type;

    -- 3. Extended properties that should be REMOVED (orphaned)
    SELECT 
        'ORPHANED EXTENDED PROPERTY' AS Status,
        s.name AS schema_name,
        t.name AS table_name,
        c.name AS column_name,
        ep.name AS property_name,
        CAST(ep.value AS NVARCHAR(MAX)) AS extended_property_value
    FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE ep.class = 1
        AND ep.name LIKE 'DataDef_%'
        AND (@schema_name IS NULL OR s.name = @schema_name)
        AND (@table_name IS NULL OR t.name = @table_name)
        AND NOT EXISTS (
            SELECT 1 
            FROM [meta_data].[data_definitions] dd
            WHERE dd.schema_name = s.name
                AND dd.table_name = t.name
                AND dd.column_name = c.name
                AND 'DataDef_' + dd.data_definition_type = ep.name
                AND dd.is_active = 1
        )
    ORDER BY s.name, t.name, c.name, ep.name;
END