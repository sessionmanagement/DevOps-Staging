CREATE TABLE [perf].[ExpensiveQueryHistory] (
    [LogID]             INT             IDENTITY (1, 1) NOT NULL,
    [LogDate]           DATETIME2 (7)   DEFAULT (getdate()) NULL,
    [QueryID]           INT             NULL,
    [QueryHash]         BINARY (8)      NULL,
    [QueryText]         NVARCHAR (MAX)  NULL,
    [ExecutionCount]    BIGINT          NULL,
    [AvgDurationSec]    DECIMAL (18, 2) NULL,
    [AvgCPUSec]         DECIMAL (18, 2) NULL,
    [AvgLogicalReads]   BIGINT          NULL,
    [AvgPhysicalReads]  BIGINT          NULL,
    [TotalCPUSeconds]   DECIMAL (18, 2) NULL,
    [LastExecutionTime] DATETIME2 (7)   NULL,
    PRIMARY KEY CLUSTERED ([LogID] ASC)
);

