CREATE VIEW perf.vw_IndexRecommend as 

WITH RecentRecommendations AS (
    SELECT 
        TableName,
        EqualityColumns,
        InequalityColumns,
        IncludedColumns,
        COUNT(DISTINCT CAST(LogDate AS DATE)) AS DaysRecommended,
        AVG(ImprovementMeasure) AS AvgImprovementMeasure,
        MAX(ImprovementMeasure) AS MaxImprovementMeasure,
        SUM(UserSeeks) AS TotalUserSeeks,
        SUM(UserScans) AS TotalUserScans,
        MAX(CreateStatement) AS CreateStatement
    FROM perf.RecommendIndexHistory
    WHERE LogDate >= DATEADD(DAY, -14, GETDATE())
    GROUP BY TableName, EqualityColumns, InequalityColumns, IncludedColumns
)
SELECT top 10000
    DaysRecommended,
    AvgImprovementMeasure,
    MaxImprovementMeasure,
    TotalUserSeeks,
    TotalUserScans,
    TableName,
    EqualityColumns,
    InequalityColumns,
    IncludedColumns,
    CreateStatement,
    CASE 
        WHEN DaysRecommended >= 7 AND AvgImprovementMeasure > 15000 THEN 'CRITICAL - Create immediately'
        WHEN DaysRecommended >= 5 AND AvgImprovementMeasure > 10000 THEN 'HIGH - Create this week'
        WHEN DaysRecommended >= 4 AND AvgImprovementMeasure > 5000 THEN 'MEDIUM - Create next week'
        WHEN DaysRecommended >= 7 THEN 'LOW - Persistent but low impact'
        ELSE 'TEMPORARY - Skip for now'
    END AS Recommendation
FROM RecentRecommendations
WHERE DaysRecommended >= 3  -- Only show recommendations that appeared 3+ days
ORDER BY DaysRecommended DESC, AvgImprovementMeasure DESC