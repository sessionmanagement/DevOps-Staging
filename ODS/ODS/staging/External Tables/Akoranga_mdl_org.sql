CREATE EXTERNAL TABLE [staging].[Akoranga_mdl_org] (
    [id] BIGINT NULL,
    [short_name] NVARCHAR (MAX) NULL,
    [description] NVARCHAR (MAX) NULL,
    [id_number] NVARCHAR (MAX) NULL,
    [framework_id] BIGINT NULL,
    [path] NVARCHAR (MAX) NULL,
    [parent_id] BIGINT NULL,
    [visible] BIGINT NULL,
    [time_created] BIGINT NULL,
    [time_modified] BIGINT NULL,
    [user_modified] BIGINT NULL,
    [full_name] NVARCHAR (MAX) NULL,
    [depth_level] BIGINT NULL,
    [type_id] BIGINT NULL,
    [sort_thread] NVARCHAR (MAX) NULL,
    [totara_sync] BIGINT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_org/staging',
    FILE_FORMAT = [parquet]
    );

