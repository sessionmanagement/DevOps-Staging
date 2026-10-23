CREATE EXTERNAL TABLE [staging].[Akoranga_mdl_context] (
    [id] BIGINT NULL,
    [context_level] BIGINT NULL,
    [instance_id] BIGINT NULL,
    [path] NVARCHAR (MAX) NULL,
    [depth] BIGINT NULL,
    [parent_id] BIGINT NULL,
    [tenant_id] BIGINT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_context/staging',
    FILE_FORMAT = [parquet]
    );

