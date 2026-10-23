CREATE EXTERNAL TABLE [Akoranga].[mdl_prog_user_assignment] (
    [id] BIGINT NULL,
    [program_id] BIGINT NULL,
    [user_id] BIGINT NULL,
    [assignment_id] BIGINT NULL,
    [time_assigned] BIGINT NULL,
    [exception_status] BIGINT NULL,
    [ODSIsCurrent] INT NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1) NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_prog_user_assignment/main',
    FILE_FORMAT = [parquet]
    );





