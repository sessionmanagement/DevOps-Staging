CREATE EXTERNAL TABLE [Akoranga].[mdl_prog_courseset_course] (
    [id] BIGINT NULL,
    [courseset_id] BIGINT NULL,
    [course_id] BIGINT NULL,
    [ODSIsCurrent] INT NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1) NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_prog_courseset_course/main',
    FILE_FORMAT = [parquet]
    );

