CREATE EXTERNAL TABLE [working].[Akoranga_mdl_course_info_field] (
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
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_course_info_field/working',
    FILE_FORMAT = [parquet]
    );

