CREATE EXTERNAL TABLE [staging].[Akoranga_mdl_context_map] (
    [id] BIGINT NULL,
    [parent_id] BIGINT NULL,
    [child_id] BIGINT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_context_map/staging',
    FILE_FORMAT = [parquet]
    );

