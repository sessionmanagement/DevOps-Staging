CREATE   PROCEDURE perf.[CaptureRecommendIndexes]
AS

/**********************************************************************************************************
 Procedure: perf.usp_CaptureRecommendIndexes
 Author: Malhar Badheka
 Created: 2026-02-18
 Purpose: to capture daily Indexes 
        
 REVISIONS:
 Version  Date         Author             Description
 -------  ------------ -----------------  ------------------------------
 1.0      2026-02-18   Malhar Badheka       Initial stored procedure version 
 **********************************************************************************************************/

BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO perf.RecommendIndexHistory (
        TableName, EqualityColumns, InequalityColumns, IncludedColumns,
        ImprovementMeasure, UserSeeks, UserScans, AvgTotalUserCost, AvgUserImpact,
        CreateStatement
    )
    SELECT 
        d.statement AS TableName,
        d.equality_columns,
        d.inequality_columns,
        d.included_columns,
        ROUND(s.avg_total_user_cost * s.avg_user_impact * (s.user_seeks + s.user_scans), 0) AS improvement_measure,
        s.user_seeks,
        s.user_scans,
        s.avg_total_user_cost,
        s.avg_user_impact,
        'CREATE INDEX IX_' + 
            OBJECT_NAME(d.object_id) + '_' + 
            REPLACE(REPLACE(REPLACE(ISNULL(d.equality_columns, ''), '[', ''), ']', ''), ', ', '_') +
            CASE WHEN d.inequality_columns IS NOT NULL 
                THEN '_' + REPLACE(REPLACE(REPLACE(d.inequality_columns, '[', ''), ']', ''), ', ', '_') 
                ELSE '' END
        + ' ON ' + d.statement + 
        ' (' + ISNULL(d.equality_columns, '') + 
        CASE WHEN d.equality_columns IS NOT NULL AND d.inequality_columns IS NOT NULL THEN ',' ELSE '' END +
        ISNULL(d.inequality_columns, '') + ')' +
        CASE WHEN d.included_columns IS NOT NULL 
            THEN ' INCLUDE (' + d.included_columns + ')' 
            ELSE '' END + 
        ' WITH (DATA_COMPRESSION = PAGE);' AS create_statement
    FROM sys.dm_db_missing_index_details d
    INNER JOIN sys.dm_db_missing_index_groups g ON d.index_handle = g.index_handle
    INNER JOIN sys.dm_db_missing_index_group_stats s ON g.index_group_handle = s.group_handle
    WHERE d.database_id = DB_ID()
        AND ROUND(s.avg_total_user_cost * s.avg_user_impact * (s.user_seeks + s.user_scans), 0) > 1000;
    
    PRINT 'Captured ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' missing index recommendations';
END;