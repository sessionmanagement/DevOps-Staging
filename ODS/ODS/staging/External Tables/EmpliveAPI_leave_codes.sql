CREATE EXTERNAL TABLE [staging].[EmpliveAPI_leave_codes] (
    [leave_code] NVARCHAR (50) NULL,
    [name] NVARCHAR (255) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpliveAPI/leave_codes/staging',
    FILE_FORMAT = [parquet]
    );

