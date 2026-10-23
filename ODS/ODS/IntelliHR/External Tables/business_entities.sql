CREATE EXTERNAL TABLE [IntelliHR].[business_entities] (
    [business_entities_id] NVARCHAR (36) NULL,
    [name] NVARCHAR (75) NULL,
    [legalName] NVARCHAR (65) NULL,
    [number] NVARCHAR (75) NULL,
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
    LOCATION = N'IntelliHR/business_entities/main',
    FILE_FORMAT = [parquet]
    );

