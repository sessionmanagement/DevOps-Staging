CREATE TABLE [landing].[edw_fact_finance_budget] (
    [PartitionKey]            NVARCHAR (130)   NULL,
    [RowKey]                  NVARCHAR (110)   NULL,
    [BUDGET HOLDER]           INT              NULL,
    [CONTRACT]                INT              NULL,
    [CUSTOMER]                INT              NULL,
    [DEPARTMENT]              INT              NULL,
    [DISTRICT]                INT              NULL,
    [FUNDER]                  INT              NULL,
    [FUNDING AGENCY]          INT              NULL,
    [LOCATE]                  INT              NULL,
    [REGION]                  INT              NULL,
    [SERVICE NAME]            INT              NULL,
    [SERVICE TYPE]            INT              NULL,
    [VENDOR]                  INT              NULL,
    [Dimension_Set_ID]        INT              NULL,
    [Entry_No_]               INT              NULL,
    [Budget_Name]             NVARCHAR (MAX)   NULL,
    [Date]                    DATETIME2 (0)    NULL,
    [Last_Date_Modified]      DATETIME2 (0)    NULL,
    [G_L_Account_No_]         NVARCHAR (MAX)   NULL,
    [Description]             NVARCHAR (MAX)   NULL,
    [Global_Dimension_1_Code] NVARCHAR (MAX)   NULL,
    [Amount]                  DECIMAL (38, 18) NULL,
    [__CompanyName]           NVARCHAR (MAX)   NULL
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [BK_Landing_edw_fact_finance_budget]
    ON [landing].[edw_fact_finance_budget]([RowKey] ASC, [PartitionKey] ASC);

