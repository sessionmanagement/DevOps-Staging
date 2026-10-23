CREATE EXTERNAL TABLE [landing].[IntelliHR_work_classes] (
    [work_classes_id] NVARCHAR (36) NULL,
    [name] NVARCHAR (500) NULL,
    [isEnabled] INT NULL,
    [worktype_id] NVARCHAR (36) NULL,
    [worktype_name] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/work_classes/landing',
    FILE_FORMAT = [parquet]
    );

