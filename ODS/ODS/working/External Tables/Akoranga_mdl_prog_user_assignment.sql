CREATE EXTERNAL TABLE [working].[Akoranga_mdl_prog_user_assignment] (
    [id] BIGINT NULL,
    [program_id] BIGINT NULL,
    [user_id] BIGINT NULL,
    [assignment_id] BIGINT NULL,
    [time_assigned] BIGINT NULL,
    [exception_status] BIGINT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_prog_user_assignment/working',
    FILE_FORMAT = [parquet]
    );



