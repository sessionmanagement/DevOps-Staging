CREATE TABLE [staging].[ODSETLfact_webexpenses] (
    [ODSfact_webexpensesID]     INT             IDENTITY (1, 1) NOT NULL,
    [expense_key]               NVARCHAR (62)   NOT NULL,
    [dim_webexpense_key]        INT             NULL,
    [claim_number]              INT             NULL,
    [dim_claimant_employee_key] INT             NULL,
    [user_id]                   INT             NULL,
    [expense_date]              DATETIME2 (0)   NULL,
    [expense_date_key]          INT             NULL,
    [posted_on]                 DATETIME2 (0)   NULL,
    [posted_on_key]             INT             NULL,
    [upload_date]               DATETIME2 (0)   NULL,
    [upload_date_key]           INT             NULL,
    [amount]                    DECIMAL (18, 2) NULL,
    [base_amount]               DECIMAL (18, 2) NULL,
    [exchange_rate]             DECIMAL (18, 6) NULL,
    [billing_amount]            DECIMAL (18, 2) NULL,
    [cc_exchange_rate]          DECIMAL (18, 6) NULL,
    [dim_approver_employee_key] INT             NULL,
    CONSTRAINT [PK_Temp_Staging_ODSETLfact_webexpenses] PRIMARY KEY NONCLUSTERED ([ODSfact_webexpensesID] ASC)
);

