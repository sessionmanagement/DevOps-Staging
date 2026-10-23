CREATE EXTERNAL TABLE [webexpenses].[costcentre] (
    [cost_centre_id] INT NULL,
    [cost_centre_name] NVARCHAR (255) NULL,
    [approver_id] INT NULL,
    [approver_first_name] NVARCHAR (100) NULL,
    [approver_last_name] NVARCHAR (100) NULL,
    [approver_login] NVARCHAR (255) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'WebExpenses/costcentre/main',
    FILE_FORMAT = [parquet]
    );

