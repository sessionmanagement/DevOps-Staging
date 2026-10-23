CREATE TABLE [landing].[edw_fact_finance_general_ledger] (
    [PartitionKey]             NVARCHAR (129)   NULL,
    [RowKey]                   NVARCHAR (106)   NULL,
    [BUDGET HOLDER]            INT              NULL,
    [CUSTOMER]                 INT              NULL,
    [CONTRACT]                 INT              NULL,
    [DEPARTMENT]               INT              NULL,
    [DISTRICT]                 INT              NULL,
    [FUNDER]                   INT              NULL,
    [FUNDING AGENCY]           INT              NULL,
    [LOCATE]                   INT              NULL,
    [REGION]                   INT              NULL,
    [SERVICE NAME]             INT              NULL,
    [SERVICE TYPE]             INT              NULL,
    [VENDOR]                   INT              NULL,
    [User_ID]                  NVARCHAR (117)   NULL,
    [Transaction_No_]          INT              NULL,
    [Description]              NVARCHAR (200)   NULL,
    [Document_No_]             NVARCHAR (120)   NULL,
    [G_L_Account_No_]          NVARCHAR (104)   NULL,
    [Source_No_]               NVARCHAR (108)   NULL,
    [No__Series]               NVARCHAR (109)   NULL,
    [Source_Code]              NVARCHAR (110)   NULL,
    [Source_Type]              NVARCHAR (100)   NULL,
    [Document_Type]            NVARCHAR (100)   NULL,
    [Gen__Posting_Type]        NVARCHAR (100)   NULL,
    [G_L_Account_Name]         NVARCHAR (158)   NULL,
    [Gen__Bus__Posting_Group]  NVARCHAR (115)   NULL,
    [Gen__Prod__Posting_Group] NVARCHAR (120)   NULL,
    [Global_Dimension_1_Code]  NVARCHAR (120)   NULL,
    [System_Created_Entry]     INT              NULL,
    [__CompanyName]            NVARCHAR (129)   NULL,
    [Posting_Date]             DATETIME2 (0)    NULL,
    [Document_Date]            DATETIME2 (0)    NULL,
    [Last_Modified_DateTime]   DATETIME2 (0)    NULL,
    [Amount]                   DECIMAL (38, 18) NULL,
    [Credit_Amount]            DECIMAL (38, 18) NULL,
    [Debit_Amount]             DECIMAL (38, 18) NULL,
    [ODSIsCurrent]             INT              NULL,
    [ODSEffectiveFrom]         DATETIME         NULL,
    [ODSEffectiveTo]           DATETIME         NULL,
    [ODSDMLOperation]          VARCHAR (1)      NULL
);






GO
CREATE UNIQUE NONCLUSTERED INDEX [BK_Landing_edw_fact_finance_general_ledger]
    ON [landing].[edw_fact_finance_general_ledger]([RowKey] ASC, [PartitionKey] ASC);

