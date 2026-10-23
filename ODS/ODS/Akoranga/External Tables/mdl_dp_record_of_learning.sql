CREATE EXTERNAL TABLE [Akoranga].[mdl_dp_record_of_learning] (
    [id] BIGINT NULL,
    [user_id] BIGINT NULL,
    [instance_id] BIGINT NULL,
    [type] BIGINT NULL,
    [ODSIsCurrent] INT NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1) NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_dp_record_of_learning/main',
    FILE_FORMAT = [parquet]
    );

