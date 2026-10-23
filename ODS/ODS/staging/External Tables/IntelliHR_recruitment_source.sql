CREATE EXTERNAL TABLE [staging].[IntelliHR_recruitment_source] (
    [recruitment_source_id] NVARCHAR (36) NULL,
    [name] NVARCHAR (500) NULL,
    [parentId] NVARCHAR (36) NULL,
    [isEnabled] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/recruitment_source/staging',
    FILE_FORMAT = [parquet]
    );

