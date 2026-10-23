CREATE EXTERNAL TABLE [working].[Akoranga_mdl_enrol] (
    [id] BIGINT NULL,
    [enrol] NVARCHAR (MAX) NULL,
    [status] BIGINT NULL,
    [course_id] BIGINT NULL,
    [sortorder] BIGINT NULL,
    [name] NVARCHAR (MAX) NULL,
    [enrol_period] BIGINT NULL,
    [enrol_start_date] BIGINT NULL,
    [enrol_end_date] BIGINT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_enrol/working',
    FILE_FORMAT = [parquet]
    );

