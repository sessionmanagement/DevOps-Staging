CREATE EXTERNAL TABLE [IntelliHR].[qualification_types] (
    [qualification_type_id] NVARCHAR (36) NULL,
    [name] NVARCHAR (200) NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/qualification_types/main',
    FILE_FORMAT = [parquet]
    );

