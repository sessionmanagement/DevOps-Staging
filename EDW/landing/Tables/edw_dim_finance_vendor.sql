CREATE TABLE [landing].[edw_dim_finance_vendor] (
    [Dimension_Value_ID]      INT            NULL,
    [Code]                    NVARCHAR (120) NULL,
    [Name]                    NVARCHAR (150) NULL,
    [__CompanyName]           NVARCHAR (129) NULL,
    [Last_Modified_Date_Time] DATETIME2 (0)  NULL,
    [ODSIsCurrent]            INT            NULL,
    [ODSEffectiveFrom]        DATETIME       NULL,
    [ODSEffectiveTo]          DATETIME       NULL,
    [ODSDMLOperation]         VARCHAR (1)    NULL
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [BK_Landing_edw_dim_finance_vendor]
    ON [landing].[edw_dim_finance_vendor]([Dimension_Value_ID] ASC, [__CompanyName] ASC);



