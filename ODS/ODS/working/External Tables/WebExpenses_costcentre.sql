CREATE EXTERNAL TABLE [working].[WebExpenses_costcentre] (
    [cost_centre_id] INT NULL,
    [cost_centre_name] NVARCHAR (255) NULL,
    [approver_id] INT NULL,
    [approver_first_name] NVARCHAR (100) NULL,
    [approver_last_name] NVARCHAR (100) NULL,
    [approver_login] NVARCHAR (255) NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'WebExpenses/costcentre/working',
    FILE_FORMAT = [parquet]
    );

