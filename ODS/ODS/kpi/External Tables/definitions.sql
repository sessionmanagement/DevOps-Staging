CREATE EXTERNAL TABLE [kpi].[definitions] (
    [id] INT NULL,
    [title] NVARCHAR (255) NULL,
    [strategic_pillar] NVARCHAR (255) NULL,
    [rollup_area] NVARCHAR (255) NULL,
    [outcome] NVARCHAR (255) NULL,
    [rollup_area_sfs] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'kpi/definitions/main',
    FILE_FORMAT = [parquet]
    );

