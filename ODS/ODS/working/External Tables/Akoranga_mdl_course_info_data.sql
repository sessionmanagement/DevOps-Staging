CREATE EXTERNAL TABLE [working].[Akoranga_mdl_course_info_data] (
    [id] BIGINT NULL,
    [field_id] BIGINT NULL,
    [course_id] BIGINT NULL,
    [data] NVARCHAR (MAX) NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_course_info_data/working',
    FILE_FORMAT = [parquet]
    );

