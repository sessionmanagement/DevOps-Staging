CREATE TABLE [edw].[dim_company] (
    [dim_company_key]           INT            IDENTITY (0, 1) NOT NULL,
    [company_id]                INT            NOT NULL,
    [company_name]              NVARCHAR (50)  NULL,
    [company_short_code]        NVARCHAR (10)  NULL,
    [dim_company_intellihr_key] NVARCHAR (36)  NULL,
    [dim_company_datapay_key]   NVARCHAR (50)  NULL,
    [company_datapay_code]      INT            NULL,
    [company_recordbase_id]     INT            NULL,
    [DWHSourceSystem]           NVARCHAR (500) NOT NULL,
    [DWHBatchId]                INT            NOT NULL,
    [DWHDMLOperation]           CHAR (1)       NOT NULL,
    [DWHEffectiveFrom]          DATETIME       NOT NULL,
    [DWHEffectiveTo]            DATETIME       NOT NULL,
    [DWHIsCurrent]              INT            NOT NULL,
    CONSTRAINT [PK_EDW_dim_company] PRIMARY KEY NONCLUSTERED ([dim_company_key] ASC)
);










GO
CREATE NONCLUSTERED INDEX [idx1_dim_company]
    ON [edw].[dim_company]([company_id] ASC)
    INCLUDE([dim_company_key], [DWHIsCurrent]);

