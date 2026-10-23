CREATE EXTERNAL TABLE [IntelliHR].[skill_disciplines] (
    [skill_disciplines_id] NVARCHAR (36) NULL,
    [name] NVARCHAR (500) NULL,
    [skill_id] NVARCHAR (36) NULL,
    [skill_name] NVARCHAR (500) NULL,
    [ODSIsCurrent] INT,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1),
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/skill_disciplines/main',
    FILE_FORMAT = [parquet]
    );

