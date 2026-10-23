CREATE EXTERNAL TABLE [working].[Akoranga_mdl_prog_courseset_course] (
    [id] BIGINT NULL,
    [courseset_id] BIGINT NULL,
    [course_id] BIGINT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_prog_courseset_course/working',
    FILE_FORMAT = [parquet]
    );

