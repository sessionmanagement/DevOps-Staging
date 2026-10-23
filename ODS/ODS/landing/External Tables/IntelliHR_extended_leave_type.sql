CREATE EXTERNAL TABLE [landing].[IntelliHR_extended_leave_type] (
    [extended_leave_type_id] NVARCHAR (36) NULL,
    [name] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/extended_leave_type/landing',
    FILE_FORMAT = [parquet]
    );

