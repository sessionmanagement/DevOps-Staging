CREATE EXTERNAL TABLE [landing].[Akoranga_mdl_context_map] (
    [id] BIGINT NULL,
    [parent_id] BIGINT NULL,
    [child_id] BIGINT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_context_map/landing',
    FILE_FORMAT = [parquet]
    );

