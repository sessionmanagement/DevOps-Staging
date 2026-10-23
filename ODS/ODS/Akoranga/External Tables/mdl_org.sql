CREATE EXTERNAL TABLE [Akoranga].[mdl_org] (
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
    [totara_sync] BIGINT NULL,
    [ODSIsCurrent] INT NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1) NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_org/main',
    FILE_FORMAT = [parquet]
    );

