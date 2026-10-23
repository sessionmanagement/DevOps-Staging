CREATE EXTERNAL TABLE [Akoranga].[mdl_dp_plan] (
    [id] BIGINT NULL,
    [template_id] BIGINT NULL,
    [user_id] BIGINT NULL,
    [name] NVARCHAR (MAX) NULL,
    [description] NVARCHAR (MAX) NULL,
    [start_date] BIGINT NULL,
    [end_date] BIGINT NULL,
    [time_completed] BIGINT NULL,
    [certif_status] BIGINT NULL,
    [created_by] BIGINT NULL,
    [ODSIsCurrent] INT NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1) NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_dp_plan/main',
    FILE_FORMAT = [parquet]
    );

