CREATE EXTERNAL TABLE [Akoranga].[mdl_pos] (
    [id] BIGINT NULL,
    [id_number] NVARCHAR (MAX) NULL,
    [depth_level] BIGINT NULL,
    [description] NVARCHAR (MAX) NULL,
    [framework_id] BIGINT NULL,
    [full_name] NVARCHAR (MAX) NULL,
    [parent_id] BIGINT NULL,
    [path] NVARCHAR (MAX) NULL,
    [short_name] NVARCHAR (MAX) NULL,
    [sort_thread] NVARCHAR (MAX) NULL,
    [time_created] BIGINT NULL,
    [time_modified] BIGINT NULL,
    [time_valid_from] BIGINT NULL,
    [time_valid_to] BIGINT NULL,
    [totara_sync] BIGINT NULL,
    [type_id] BIGINT NULL,
    [user_modified] BIGINT NULL,
    [visible] BIGINT NULL,
    [ODSIsCurrent] INT NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1) NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_pos/main',
    FILE_FORMAT = [parquet]
    );

