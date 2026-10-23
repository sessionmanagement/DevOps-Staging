CREATE EXTERNAL TABLE [Akoranga].[mdl_enrol] (
    [id] BIGINT NULL,
    [enrol] NVARCHAR (MAX) NULL,
    [status] BIGINT NULL,
    [course_id] BIGINT NULL,
    [sortorder] BIGINT NULL,
    [name] NVARCHAR (MAX) NULL,
    [enrol_period] BIGINT NULL,
    [enrol_start_date] BIGINT NULL,
    [enrol_end_date] BIGINT NULL,
    [ODSIsCurrent] INT NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1) NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_enrol/main',
    FILE_FORMAT = [parquet]
    );

