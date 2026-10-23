CREATE EXTERNAL TABLE [on_call].[call_log_kaimahi] (
    [kaimahi_id] INT NULL,
    [kaimahi_name] NVARCHAR (100) NULL,
    [kaimahi_unique_id] NVARCHAR (40) NULL,
    [kaimahi_email] NVARCHAR (200) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'On_Call/call_log_kaimahi/main',
    FILE_FORMAT = [parquet]
    );

