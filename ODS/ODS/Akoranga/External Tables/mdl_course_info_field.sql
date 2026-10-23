CREATE EXTERNAL TABLE [Akoranga].[mdl_course_info_field] (
    [id] BIGINT NULL,
    [full_name] NVARCHAR (MAX) NULL,
    [short_name] NVARCHAR (MAX) NULL,
    [data_type] NVARCHAR (MAX) NULL,
    [description] NVARCHAR (MAX) NULL,
    [sort_order] BIGINT NULL,
    [hidden] BIGINT NULL,
    [locked] BIGINT NULL,
    [required] BIGINT NULL,
    [force_unique] BIGINT NULL,
    [default_data] NVARCHAR (MAX) NULL,
    [param_1] NVARCHAR (MAX) NULL,
    [param_2] NVARCHAR (MAX) NULL,
    [param_3] NVARCHAR (MAX) NULL,
    [param_4] NVARCHAR (MAX) NULL,
    [param_5] NVARCHAR (MAX) NULL,
    [ODSIsCurrent] INT NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1) NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_course_info_field/main',
    FILE_FORMAT = [parquet]
    );

