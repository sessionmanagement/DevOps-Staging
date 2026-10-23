CREATE EXTERNAL TABLE [working].[Akoranga_mdl_user_enrolments] (
    [id] BIGINT NULL,
    [status] BIGINT NULL,
    [enrol_id] BIGINT NULL,
    [user_id] BIGINT NULL,
    [time_start] BIGINT NULL,
    [time_end] BIGINT NULL,
    [modifier_id] BIGINT NULL,
    [time_created] BIGINT NULL,
    [time_modified] BIGINT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_user_enrolments/working',
    FILE_FORMAT = [parquet]
    );

