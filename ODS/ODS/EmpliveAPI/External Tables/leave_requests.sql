CREATE EXTERNAL TABLE [EmpliveAPI].[leave_requests] (
    [leave_request_id] NVARCHAR (36) NULL,
    [employee_id] NVARCHAR (36) NULL,
    [start_date_time] DATETIME2 (7) NULL,
    [end_date_time] DATETIME2 (7) NULL,
    [default_leave_type] NVARCHAR (36) NULL,
    [status] NVARCHAR (255) NULL,
    [ODSIsCurrent] INT NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1) NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpliveAPI/leave_requests/main',
    FILE_FORMAT = [parquet]
    );

