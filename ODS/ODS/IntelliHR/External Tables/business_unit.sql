CREATE EXTERNAL TABLE [IntelliHR].[business_unit] (
    [business_unit_id] NVARCHAR (36) NULL,
    [identifier] NVARCHAR (70) NULL,
    [name] NVARCHAR (100) NULL,
    [code] NVARCHAR (200) NULL,
    [parentId] NVARCHAR (36) NULL,
    [notes] NVARCHAR (50) NULL,
    [isEnabled] INT NULL,
    [ODSIsCurrent] INT NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1) NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/business_unit/main',
    FILE_FORMAT = [parquet]
    );



