CREATE EXTERNAL TABLE [staging].[WebExpenses_users] (
    [user_id] INT NULL,
    [first_name] NVARCHAR (100) NULL,
    [last_name] NVARCHAR (100) NULL,
    [login] NVARCHAR (255) NULL,
    [claimant_role_flag] NVARCHAR (4000) NULL,
    [approver_role_flag] NVARCHAR (4000) NULL,
    [accounts_role_flag] NVARCHAR (4000) NULL,
    [division_admin_flag] NVARCHAR (4000) NULL,
    [cost_centre_id] NVARCHAR (4000) NULL,
    [cost_centre_code] NVARCHAR (4000) NULL,
    [cost_centre_name] NVARCHAR (4000) NULL,
    [approver_id] INT NULL,
    [approver_first_name] NVARCHAR (100) NULL,
    [approver_last_name] NVARCHAR (100) NULL,
    [approver_login] NVARCHAR (255) NULL,
    [created_date] DATETIME2 (7) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'WebExpenses/users/staging',
    FILE_FORMAT = [parquet]
    );

