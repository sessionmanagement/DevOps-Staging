CREATE EXTERNAL TABLE [IntelliHR].[locations] (
    [locations_id] NVARCHAR (36) NULL,
    [parentId] NVARCHAR (36) NULL,
    [name] NVARCHAR (150) NULL,
    [address] NVARCHAR (100) NULL,
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
    LOCATION = N'IntelliHR/locations/main',
    FILE_FORMAT = [parquet]
    );

