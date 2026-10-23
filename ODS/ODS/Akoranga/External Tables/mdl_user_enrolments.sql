CREATE EXTERNAL TABLE [Akoranga].[mdl_user_enrolments] (
    [id] BIGINT NULL,
    [status] BIGINT NULL,
    [enrol_id] BIGINT NULL,
    [user_id] BIGINT NULL,
    [time_start] BIGINT NULL,
    [time_end] BIGINT NULL,
    [modifier_id] BIGINT NULL,
    [time_created] BIGINT NULL,
    [time_modified] BIGINT NULL,
    [ODSIsCurrent] INT NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1) NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_user_enrolments/main',
    FILE_FORMAT = [parquet]
    );

