CREATE TABLE [landing].[edw_fact_webexpenses] (
    [expense_key]      NVARCHAR (62)   NULL,
    [claim_number]     INT             NULL,
    [claimant_login]   NVARCHAR (4000) NULL,
    [user_id]          INT             NULL,
    [expense_date]     DATETIME2 (0)   NULL,
    [expense_date_key] INT             NULL,
    [posted_on]        DATETIME2 (0)   NULL,
    [posted_on_key]    INT             NULL,
    [upload_date]      DATETIME2 (0)   NULL,
    [upload_date_key]  INT             NULL,
    [amount]           DECIMAL (18, 2) NULL,
    [base_amount]      DECIMAL (18, 2) NULL,
    [exchange_rate]    DECIMAL (18, 6) NULL,
    [billing_amount]   DECIMAL (18, 2) NULL,
    [cc_exchange_rate] DECIMAL (18, 6) NULL,
    [Approver_login]   NVARCHAR (255)  NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [fact_webexpenses_key]
    ON [landing].[edw_fact_webexpenses]([expense_key] ASC, [user_id] ASC);

