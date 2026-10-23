CREATE EXTERNAL TABLE [landing].[kpi_sfa_rollup_areas] (
    [id] INT NULL,
    [title] NVARCHAR (255) NULL,
    [roll_up_id] NVARCHAR (255) NULL,
    [strategic_focus_area] NVARCHAR (255) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'kpi/sfa_rollup_areas/landing',
    FILE_FORMAT = [parquet]
    );

