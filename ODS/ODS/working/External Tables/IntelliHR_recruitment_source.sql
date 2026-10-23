CREATE EXTERNAL TABLE [working].[IntelliHR_recruitment_source] (
    [recruitment_source_id] NVARCHAR (36) NULL,
    [name] NVARCHAR (500) NULL,
    [parentId] NVARCHAR (36) NULL,
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
    LOCATION = N'IntelliHR/recruitment_source/working',
    FILE_FORMAT = [parquet]
    );

