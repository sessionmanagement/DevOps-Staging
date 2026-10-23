CREATE EXTERNAL TABLE [working].[Akoranga_mdl_prog_completion] (
    [id] BIGINT NULL,
    [program_id] BIGINT NULL,
    [user_id] BIGINT NULL,
    [course_set_id] BIGINT NULL,
    [certif_status] BIGINT NULL,
    [time_started] BIGINT NULL,
    [time_due] BIGINT NULL,
    [time_completed] BIGINT NULL,
    [organisation_id] BIGINT NULL,
    [position_id] BIGINT NULL,
    [time_created] BIGINT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_prog_completion/working',
    FILE_FORMAT = [parquet]
    );

