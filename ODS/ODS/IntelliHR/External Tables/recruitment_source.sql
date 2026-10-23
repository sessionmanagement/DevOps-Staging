CREATE EXTERNAL TABLE [IntelliHR].[recruitment_source] (
    [recruitment_source_id] NVARCHAR (36) NULL,
    [name] NVARCHAR (500) NULL,
    [parentId] NVARCHAR (36) NULL,
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
    LOCATION = N'IntelliHR/recruitment_source/main',
    FILE_FORMAT = [parquet]
    );

