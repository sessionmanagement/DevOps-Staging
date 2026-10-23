CREATE EXTERNAL TABLE [working].[Akoranga_mdl_dp_record_of_learning] (
    [id] BIGINT NULL,
    [user_id] BIGINT NULL,
    [instance_id] BIGINT NULL,
    [type] BIGINT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_dp_record_of_learning/working',
    FILE_FORMAT = [parquet]
    );

