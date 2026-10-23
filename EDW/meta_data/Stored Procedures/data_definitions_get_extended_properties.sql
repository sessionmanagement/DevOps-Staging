
-- =============================================
-- Create helper procedure to view extended properties
-- =============================================
CREATE   PROCEDURE [meta_data].[data_definitions_get_extended_properties]
    @schema_name    VARCHAR(128) = NULL,
    @table_name     VARCHAR(128) = NULL,
    @column_name    VARCHAR(128) = NULL,
    @property_name  VARCHAR(128) = NULL
AS
/**********************************************************************************************************
 Procedure: [meta_data].[get_extended_properties]
 Author:    Greg Nuthall
 Created:   2025-12-19
 Purpose:   View extended properties for columns, filtered by various criteria
 
 Example:
    EXEC [meta_data].[get_extended_properties] 
        @schema_name = 'edw',
        @table_name = 'dim_employee';
**********************************************************************************************************/
BEGIN
    SET NOCOUNT ON;

    SELECT 
        s.name AS schema_name,
        t.name AS table_name,
        c.name AS column_name,
        c.column_id,
        UPPER(ty.name) + 
            CASE 
                WHEN ty.name IN ('varchar', 'nvarchar', 'char', 'nchar') 
                THEN '(' + CASE WHEN c.max_length = -1 THEN 'MAX' ELSE CAST(c.max_length AS VARCHAR) END + ')'
                WHEN ty.name IN ('decimal', 'numeric')
                THEN '(' + CAST(c.precision AS VARCHAR) + ',' + CAST(c.scale AS VARCHAR) + ')'
                ELSE ''
            END AS column_type,
        CASE WHEN c.is_nullable = 1 THEN 'NULL' ELSE 'NOT NULL' END AS nullable,
        ep.name AS property_name,
        CAST(ep.value AS NVARCHAR(MAX)) AS property_value
    FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    INNER JOIN sys.types ty ON c.user_type_id = ty.user_type_id
    WHERE ep.class = 1  -- Object or column
        AND (@schema_name IS NULL OR s.name = @schema_name)
        AND (@table_name IS NULL OR t.name = @table_name)
        AND (@column_name IS NULL OR c.name = @column_name)
        AND (@property_name IS NULL OR ep.name = @property_name)
    ORDER BY 
        s.name,
        t.name,
        c.column_id,
        ep.name;
END