CREATE TABLE [landing].[edw_dim_finance_general_ledger_account] (
    [PartitionKey]                    NVARCHAR (129) NULL,
    [RowKey]                          NVARCHAR (115) NULL,
    [AccountNo]                       NVARCHAR (104) NULL,
    [Account_Group]                   INT            NULL,
    [Indentation]                     INT            NULL,
    [Name]                            NVARCHAR (158) NULL,
    [Parent_Account_No]               NVARCHAR (104) NULL,
    [Parent_Account_Name]             NVARCHAR (158) NULL,
    [CompanyName]                     NVARCHAR (129) NULL,
    [Account_Category]                INT            NULL,
    [Account_Category_Name]           VARCHAR (18)   NULL,
    [Account_Type]                    INT            NULL,
    [Account_Type_Name]               VARCHAR (20)   NULL,
    [Direct_Posting]                  INT            NULL,
    [General_Bussiness_Posting_Group] NVARCHAR (109) NULL,
    [General_Posting_Type]            NVARCHAR (100) NULL,
    [General_Prod_Posting_Group]      NVARCHAR (110) NULL,
    [Subcategory_Entry_No]            INT            NULL,
    [Subcategory_Description]         NVARCHAR (250) NULL
);






GO
CREATE UNIQUE NONCLUSTERED INDEX [BK_Landing_edw_dim_general_ledger_account]
    ON [landing].[edw_dim_finance_general_ledger_account]([CompanyName] ASC, [AccountNo] ASC);

