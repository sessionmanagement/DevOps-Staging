CREATE EXTERNAL TABLE [staging].[EmpLive_services] (
    [id] NVARCHAR (36) NULL,
    [reference_number] NVARCHAR (255) NULL,
    [name] NVARCHAR (255) NULL,
    [cost_code] NVARCHAR (255) NULL,
    [entity_id] NVARCHAR (36) NULL,
    [state] NVARCHAR (100) NULL,
    [country] NVARCHAR (100) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpLive/services/staging',
    FILE_FORMAT = [parquet]
    );

