CREATE EXTERNAL TABLE [working].[On_Call_call_log_kaimahi] (
    [kaimahi_id] INT NULL,
    [kaimahi_name] NVARCHAR (100) NULL,
    [kaimahi_unique_id] NVARCHAR (40) NULL,
    [kaimahi_email] NVARCHAR (200) NULL,
    [ODSSourceSystem] NVARCHAR (100) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'On_Call/call_log_kaimahi/working',
    FILE_FORMAT = [parquet]
    );

