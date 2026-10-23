CREATE EXTERNAL TABLE [Akoranga].[mdl_course_info_data] (
    [id] BIGINT NULL,
    [field_id] BIGINT NULL,
    [course_id] BIGINT NULL,
    [data] NVARCHAR (MAX) NULL,
    [ODSIsCurrent] INT NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1) NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_course_info_data/main',
    FILE_FORMAT = [parquet]
    );

