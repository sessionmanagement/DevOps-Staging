CREATE TABLE [landing].[edw_fact_finance_vendor_ledger] (
    [PartitionKey]              NVARCHAR (129)   NULL,
    [RowKey]                    NVARCHAR (107)   NULL,
    [BUDGET HOLDER]             INT              NULL,
    [CONTRACT]                  INT              NULL,
    [DEPARTMENT]                INT              NULL,
    [DISTRICT]                  INT              NULL,
    [FUNDER]                    INT              NULL,
    [FUNDING AGENCY]            INT              NULL,
    [LOCATE]                    INT              NULL,
    [REGION]                    INT              NULL,
    [SERVICE NAME]              INT              NULL,
    [SERVICE TYPE]              INT              NULL,
    [VENDOR]                    INT              NULL,
    [Amount]                    DECIMAL (38, 18) NULL,
    [Amount__LCY_]              DECIMAL (38, 18) NULL,
    [Bal__Account_No_]          NVARCHAR (104)   NULL,
    [Bal__Account_Type]         NVARCHAR (100)   NULL,
    [Buy_from_Vendor_No_]       NVARCHAR (107)   NULL,
    [Closed_by_Amount]          DECIMAL (38, 18) NULL,
    [Closed_by_Amount__LCY_]    DECIMAL (38, 18) NULL,
    [Closed_by_Currency_Amount] DECIMAL (38, 18) NULL,
    [Closed_by_Entry_No_]       INT              NULL,
    [Credit_Amount]             DECIMAL (38, 18) NULL,
    [Credit_Amount__LCY_]       DECIMAL (38, 18) NULL,
    [Description]               NVARCHAR (160)   NULL,
    [Dimension_Set_ID]          INT              NULL,
    [Document_Date]             DATETIME2 (0)    NULL,
    [Document_No_]              NVARCHAR (116)   NULL,
    [Document_Type]             NVARCHAR (100)   NULL,
    [Due_Date]                  DATETIME2 (0)    NULL,
    [External_Document_No_]     NVARCHAR (133)   NULL,
    [Global_Dimension_1_Code]   NVARCHAR (120)   NULL,
    [No__Series]                NVARCHAR (108)   NULL,
    [Open]                      INT              NULL,
    [Original_Amount]           DECIMAL (38, 18) NULL,
    [Original_Amt___LCY_]       DECIMAL (38, 18) NULL,
    [Payment_Method_Code]       NVARCHAR (108)   NULL,
    [Posting_Date]              DATETIME2 (0)    NULL,
    [Purchase__LCY_]            DECIMAL (38, 18) NULL,
    [Rem__Amt]                  DECIMAL (38, 18) NULL,
    [Rem__Amt_for_WHT]          DECIMAL (38, 18) NULL,
    [Source_Code]               NVARCHAR (110)   NULL,
    [User_ID]                   NVARCHAR (117)   NULL,
    [Vendor_Name]               NVARCHAR (160)   NULL,
    [Vendor_No_]                NVARCHAR (107)   NULL,
    [__CompanyName]             NVARCHAR (129)   NULL,
    [ODSIsCurrent]              INT              NULL,
    [ODSEffectiveFrom]          DATETIME         NULL,
    [ODSEffectiveTo]            DATETIME         NULL,
    [ODSDMLOperation]           VARCHAR (1)      NULL
);






GO
CREATE UNIQUE NONCLUSTERED INDEX [BK_Landing_edw_fact_finance_vendor_ledger]
    ON [landing].[edw_fact_finance_vendor_ledger]([RowKey] ASC, [PartitionKey] ASC);

