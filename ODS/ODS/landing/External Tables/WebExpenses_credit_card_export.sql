CREATE EXTERNAL TABLE [landing].[WebExpenses_credit_card_export] (
    [company] NVARCHAR (200) NULL,
    [claimant_name] NVARCHAR (200) NULL,
    [expense_date] DATE NULL,
    [posted_on] DATE NULL,
    [claim_number] INT NULL,
    [status] NVARCHAR (50) NULL,
    [description] NVARCHAR (500) NULL,
    [category] NVARCHAR (100) NULL,
    [gl_code] NVARCHAR (50) NULL,
    [currency] NVARCHAR (10) NULL,
    [amount] DECIMAL (10, 3) NULL,
    [base_amount] DECIMAL (10, 3) NULL,
    [exchange_rate] NUMERIC (18, 3) NULL,
    [billing_currency] NVARCHAR (10) NULL,
    [billing_amount] DECIMAL (10, 3) NULL,
    [cc_exchange_rate] NUMERIC (18, 3) NULL,
    [source] NVARCHAR (50) NULL,
    [upload_date] DATE NULL,
    [approver_name] NVARCHAR (200) NULL,
    [billing_account] NVARCHAR (200) NULL,
    [billing_period] NVARCHAR (200) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'WebExpenses/credit_card_export/landing',
    FILE_FORMAT = [parquet]
    );

