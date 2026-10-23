
CREATE   PROCEDURE perf.[CaptureExpensiveQueries]
AS
/**********************************************************************************************************
 Procedure: perf.usp_CaptureExpensiveQueries
 Author: Malhar Badheka
 Created: 2026-02-18
 Purpose: to capture daily expensive queries
        
 REVISIONS:
 Version  Date         Author             Description
 -------  ------------ -----------------  ------------------------------
 1.0      2026-02-18   Malhar Badheka       Initial stored procedure version 
 **********************************************************************************************************/


BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO perf.ExpensiveQueryHistory (
        QueryID, QueryHash, QueryText, ExecutionCount, 
        AvgDurationSec, AvgCPUSec, AvgLogicalReads, AvgPhysicalReads,
        TotalCPUSeconds, LastExecutionTime
    )
    SELECT TOP 20
        q.query_id,
        q.query_hash,
        qt.query_sql_text,
        rs.count_executions,
        rs.avg_duration / 1000000.0 AS avg_duration_ms,
        rs.avg_cpu_time / 1000000.0 AS avg_cpu_ms,
        rs.avg_logical_io_reads,
        rs.avg_physical_io_reads,
        (rs.avg_cpu_time * rs.count_executions) / 1000000.0 AS total_cpu_seconds,
        rs.last_execution_time
    FROM sys.query_store_query q
    JOIN sys.query_store_query_text qt ON q.query_text_id = qt.query_text_id
    JOIN sys.query_store_plan p ON q.query_id = p.query_id
    JOIN sys.query_store_runtime_stats rs ON p.plan_id = rs.plan_id
    WHERE rs.last_execution_time > DATEADD(day, -1, GETUTCDATE())
    ORDER BY rs.avg_cpu_time * rs.count_executions DESC;
    
    PRINT 'Captured ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' expensive queries';
END;