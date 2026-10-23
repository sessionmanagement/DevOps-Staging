CREATE TABLE [staging].[ODSETLdim_webexpense] (
    [ODSdim_webexpenseID] INT             IDENTITY (1, 1) NOT NULL,
    [expense_key]         NVARCHAR (62)   NOT NULL,
    [claim_number]        INT             NULL,
    [user_id]             INT             NULL,
    [claimant_login]      NVARCHAR (4000) NULL,
    [claimant_name]       NVARCHAR (4000) NOT NULL,
    [approver_login]      NVARCHAR (255)  NULL,
    [approver_name]       NVARCHAR (201)  NOT NULL,
    [company]             NVARCHAR (4000) NULL,
    [cost_center_id]      INT             NULL,
    [category_id]         INT             NULL,
    [category_name]       NVARCHAR (255)  NULL,
    [gl_code]             NVARCHAR (50)   NULL,
    [description]         NVARCHAR (MAX)  NULL,
    [status]              NVARCHAR (100)  NULL,
    [source]              NVARCHAR (50)   NULL,
    [currency_code]          NVARCHAR (4000) NULL,
    [billing_currency]       NVARCHAR (4000) NULL,
    [receipt_available_flag] NVARCHAR (5)    NULL,
    CONSTRAINT [PK_Temp_Staging_ODSETLdim_webexpense] PRIMARY KEY NONCLUSTERED ([ODSdim_webexpenseID] ASC)
);

