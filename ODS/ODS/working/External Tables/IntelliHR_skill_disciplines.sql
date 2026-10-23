CREATE EXTERNAL TABLE [working].[IntelliHR_skill_disciplines] (
    [skill_disciplines_id] NVARCHAR (36) NULL,
    [name] NVARCHAR (500) NULL,
    [skill_id] NVARCHAR (36) NULL,
    [skill_name] NVARCHAR (500) NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/skill_disciplines/working',
    FILE_FORMAT = [parquet]
    );

