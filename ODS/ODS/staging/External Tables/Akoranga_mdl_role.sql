CREATE EXTERNAL TABLE [staging].[Akoranga_mdl_role] (
    [id] BIGINT NULL,
    [name] NVARCHAR (MAX) NULL,
    [short_name] NVARCHAR (MAX) NULL,
    [description] NVARCHAR (MAX) NULL,
    [sort_order] BIGINT NULL,
    [archetype_id] NVARCHAR (MAX) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_role/staging',
    FILE_FORMAT = [parquet]
    );

