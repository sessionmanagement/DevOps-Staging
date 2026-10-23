CREATE EXTERNAL TABLE [landing].[EmpliveAPI_leave_types] (
    [leave_type_id] NVARCHAR (36) NULL,
    [abbreviation] NVARCHAR (255) NULL,
    [name] NVARCHAR (255) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpliveAPI/leave_types/landing',
    FILE_FORMAT = [parquet]
    );

