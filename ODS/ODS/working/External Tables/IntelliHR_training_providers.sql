CREATE EXTERNAL TABLE [working].[IntelliHR_training_providers] (
    [training_providers_id] NVARCHAR (36) NULL,
    [name] NVARCHAR (500) NULL,
    [isDefault] INT NULL,
    [isEnabled] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/training_providers/working',
    FILE_FORMAT = [parquet]
    );

