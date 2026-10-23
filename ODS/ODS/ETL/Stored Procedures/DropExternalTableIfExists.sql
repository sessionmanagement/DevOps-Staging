CREATE   PROCEDURE [ETL].[DropExternalTableIfExists] @TableName SYSNAME, @SchemaName SYSNAME = 'dbo'
AS BEGIN
    IF (0 <> (SELECT COUNT(*) FROM sys.external_tables t
                                                       INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
                           WHERE s.name = @SchemaName and t.name = @TableName))
    BEGIN
        DECLARE @drop_stmt NVARCHAR(200) = N'DROP EXTERNAL TABLE ' + @SchemaName + '.' + @TableName; 
        EXEC sp_executesql @tsql = @drop_stmt;
    END
END