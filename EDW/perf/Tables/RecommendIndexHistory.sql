CREATE TABLE [perf].[RecommendIndexHistory] (
    [LogID]              INT             IDENTITY (1, 1) NOT NULL,
    [LogDate]            DATETIME2 (7)   DEFAULT (getdate()) NULL,
    [TableName]          NVARCHAR (500)  NULL,
    [EqualityColumns]    NVARCHAR (4000) NULL,
    [InequalityColumns]  NVARCHAR (4000) NULL,
    [IncludedColumns]    NVARCHAR (4000) NULL,
    [ImprovementMeasure] DECIMAL (18, 2) NULL,
    [UserSeeks]          BIGINT          NULL,
    [UserScans]          BIGINT          NULL,
    [AvgTotalUserCost]   FLOAT (53)      NULL,
    [AvgUserImpact]      FLOAT (53)      NULL,
    [CreateStatement]    NVARCHAR (MAX)  NULL,
    PRIMARY KEY CLUSTERED ([LogID] ASC)
);

