CREATE EXTERNAL TABLE [landing].[IntelliHR_skill_disciplines] (
    [skill_disciplines_id] NVARCHAR (36) NULL,
    [name] NVARCHAR (500) NULL,
    [skill_id] NVARCHAR (36) NULL,
    [skill_name] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/skill_disciplines/landing',
    FILE_FORMAT = [parquet]
    );

