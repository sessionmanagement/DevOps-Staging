CREATE EXTERNAL TABLE [working].[kpi_sfa_rollup_areas] (
    [id] INT NULL,
    [title] NVARCHAR (255) NULL,
    [roll_up_id] NVARCHAR (255) NULL,
    [strategic_focus_area] NVARCHAR (255) NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'kpi/sfa_rollup_areas/working',
    FILE_FORMAT = [parquet]
    );

