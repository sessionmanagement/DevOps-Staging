CREATE TABLE [logging].[pipeline_runs] (
    [run_id]         NVARCHAR (36)   NULL,
    [pipeline_name]  NVARCHAR (255)  NULL,
    [run_start]      DATETIME2 (7)   NULL,
    [run_end]        DATETIME2 (7)   NULL,
    [duration_in_ms] INT             NULL,
    [status]         NVARCHAR (50)   NULL,
    [message]        NVARCHAR (1000) NULL,
    [last_updated]   DATETIME2 (7)   NULL
);

