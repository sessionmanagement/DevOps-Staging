CREATE EXTERNAL TABLE [landing].[IntelliHR_recruitment_source] (
    [recruitment_source_id] NVARCHAR (36) NULL,
    [name] NVARCHAR (500) NULL,
    [parentId] NVARCHAR (36) NULL,
    [isEnabled] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/recruitment_source/landing',
    FILE_FORMAT = [parquet]
    );

