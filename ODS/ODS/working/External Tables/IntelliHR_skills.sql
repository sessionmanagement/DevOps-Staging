CREATE EXTERNAL TABLE [working].[IntelliHR_skills] (
    [skills_id] NVARCHAR (36) NULL,
    [name] NVARCHAR (500) NULL,
    [description] NVARCHAR (500) NULL,
    [isBusinessCritical] INT NULL,
    [skillDisciplineId] NVARCHAR (36) NULL,
    [skillDisciplineName] NVARCHAR (500) NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/skills/working',
    FILE_FORMAT = [parquet]
    );

