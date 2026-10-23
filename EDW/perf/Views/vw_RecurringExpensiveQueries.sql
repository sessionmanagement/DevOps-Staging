CREATE VIEW perf.[vw_RecurringExpensiveQueries] AS

WITH RecurringExpensiveQueries AS (
    SELECT 
        QueryHash,
        MAX(QueryText) AS QueryText,
        COUNT(DISTINCT CAST(LogDate AS DATE)) AS DaysInTop20,
        AVG(AvgDurationSec) AS AvgDuration,
        AVG(AvgCPUSec) AS AvgCPU,
        AVG(TotalCPUSeconds) AS AvgTotalCPU,
        MAX(LogDate) AS LastSeen
    FROM perf.ExpensiveQueryHistory
    WHERE LogDate >= DATEADD(DAY, -14, GETDATE())
    GROUP BY QueryHash
)
SELECT top 10000
    DaysInTop20,
    AvgDuration AS AvgDurationSec,
    AvgCPU AS AvgCPUSec,
    AvgTotalCPU AS AvgTotalCPUSeconds,
    LastSeen,
    SUBSTRING(QueryText, 1, 200) AS QueryPreview,
    CASE 
        WHEN DaysInTop20 >= 7 THEN 'CRITICAL - Optimize immediately'
        WHEN DaysInTop20 >= 5 THEN 'HIGH - Needs attention this week'
        WHEN DaysInTop20 >= 3 THEN 'MEDIUM - Monitor closely'
        ELSE 'LOW '
    END AS Priority
FROM RecurringExpensiveQueries
ORDER BY DaysInTop20 DESC, AvgTotalCPU DESC;