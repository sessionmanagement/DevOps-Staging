CREATE EXTERNAL TABLE [staging].[EmpliveAPI_leave_requests] (
    [leave_request_id] NVARCHAR (36) NULL,
    [employee_id] NVARCHAR (36) NULL,
    [start_date_time] DATETIME2 (7) NULL,
    [end_date_time] DATETIME2 (7) NULL,
    [default_leave_type] NVARCHAR (36) NULL,
    [status] NVARCHAR (255) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpliveAPI/leave_requests/staging',
    FILE_FORMAT = [parquet]
    );

