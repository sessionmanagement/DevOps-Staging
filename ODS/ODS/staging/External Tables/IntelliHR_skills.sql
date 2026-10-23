CREATE EXTERNAL TABLE [staging].[IntelliHR_skills] (
    [skills_id] NVARCHAR (36) NULL,
    [name] NVARCHAR (500) NULL,
    [description] NVARCHAR (500) NULL,
    [isBusinessCritical] INT NULL,
    [skillDisciplineId] NVARCHAR (36) NULL,
    [skillDisciplineName] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/skills/staging',
    FILE_FORMAT = [parquet]
    );

