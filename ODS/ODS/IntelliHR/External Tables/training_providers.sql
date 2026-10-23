CREATE EXTERNAL TABLE [IntelliHR].[training_providers] (
    [training_providers_id] NVARCHAR (36) NULL,
    [name] NVARCHAR (500) NULL,
    [isDefault] INT NULL,
    [isEnabled] INT NULL,
    [ODSIsCurrent] INT,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1),
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/training_providers/main',
    FILE_FORMAT = [parquet]
    );

