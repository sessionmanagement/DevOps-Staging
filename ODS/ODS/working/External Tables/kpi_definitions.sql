CREATE EXTERNAL TABLE [working].[kpi_definitions] (
    [id] INT NULL,
    [title] NVARCHAR (255) NULL,
    [strategic_pillar] NVARCHAR (255) NULL,
    [rollup_area] NVARCHAR (255) NULL,
    [outcome] NVARCHAR (255) NULL,
    [rollup_area_sfs] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'kpi/definitions/working',
    FILE_FORMAT = [parquet]
    );

