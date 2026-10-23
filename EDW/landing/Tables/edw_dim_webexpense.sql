CREATE TABLE [landing].[edw_dim_webexpense] (
    [expense_key]      NVARCHAR (62)   NULL,
    [claim_number]     INT             NULL,
    [user_id]          INT             NULL,
    [claimant_login]   NVARCHAR (4000) NULL,
    [claimant_name]    NVARCHAR (4000) NULL,
    [approver_login]   NVARCHAR (255)  NULL,
    [approver_name]    NVARCHAR (201)  NULL,
    [company]          NVARCHAR (4000) NULL,
    [cost_center_id]   INT             NULL,
    [category_id]      INT             NULL,
    [category_name]    NVARCHAR (255)  NULL,
    [gl_code]          NVARCHAR (50)   NULL,
    [description]      NVARCHAR (MAX)  NULL,
    [status]           NVARCHAR (100)  NULL,
    [source]           NVARCHAR (50)   NULL,
    [currency_code]        NVARCHAR (4000) NULL,
    [billing_currency]     NVARCHAR (4000) NULL,
    [receipt_available_flag] NVARCHAR (5)  NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [dim_webexpense_key]
    ON [landing].[edw_dim_webexpense]([expense_key] ASC, [user_id] ASC);

