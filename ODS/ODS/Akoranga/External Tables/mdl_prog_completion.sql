CREATE EXTERNAL TABLE [Akoranga].[mdl_prog_completion] (
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
    [ODSIsCurrent] INT NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1) NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_prog_completion/main',
    FILE_FORMAT = [parquet]
    );

