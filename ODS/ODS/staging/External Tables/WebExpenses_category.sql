CREATE EXTERNAL TABLE [staging].[WebExpenses_category] (
    [category_id] INT NULL,
    [category_name] NVARCHAR (255) NULL,
    [gl_code] NVARCHAR (50) NULL,
    [spend_limit] DECIMAL (18, 2) NULL,
    [company_id] INT NULL,
    [receipts_required] NVARCHAR (10) NULL,
    [vat_id] INT NULL,
    [vat_rate] DECIMAL (5, 2) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'WebExpenses/category/staging',
    FILE_FORMAT = [parquet]
    );

