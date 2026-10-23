CREATE TABLE [reference].[edw_Fact_mapping] (
    [edw_Fact_mapping_Key] INT           IDENTITY (1, 1) NOT NULL,
    [CompanyName]          NVARCHAR (40) NOT NULL,
    [RowKey]               INT           NOT NULL,
    [TableName]            NVARCHAR (40) NOT NULL,
    [BUDGET_HOLDER]        INT           NULL,
    [CUSTOMER]             INT           NULL,
    [CONTRACT]             INT           NULL,
    [DEPARTMENT]           INT           NULL,
    [DISTRICT]             INT           NULL,
    [FUNDER]               INT           NULL,
    [FUNDING_AGENCY]       INT           NULL,
    [LOCATE]               INT           NULL,
    [REGION]               INT           NULL,
    [SERVICE_NAME]         INT           NULL,
    [SERVICE_TYPE]         INT           NULL,
    [VENDOR]               INT           NULL,
    PRIMARY KEY CLUSTERED ([edw_Fact_mapping_Key] ASC)
);

