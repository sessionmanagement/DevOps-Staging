CREATE EXTERNAL TABLE [landing].[IntelliHR_work_types] (
    [work_types_id] NVARCHAR (36) NULL,
    [name] NVARCHAR (500) NULL,
    [isEnabled] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/work_types/landing',
    FILE_FORMAT = [parquet]
    );

