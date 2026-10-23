CREATE EXTERNAL TABLE [staging].[WebExpenses_costcentre] (
    [cost_centre_id] INT NULL,
    [cost_centre_name] NVARCHAR (255) NULL,
    [approver_id] INT NULL,
    [approver_first_name] NVARCHAR (100) NULL,
    [approver_last_name] NVARCHAR (100) NULL,
    [approver_login] NVARCHAR (255) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'WebExpenses/costcentre/staging',
    FILE_FORMAT = [parquet]
    );

