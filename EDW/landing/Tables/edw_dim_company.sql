CREATE TABLE [landing].[edw_dim_company] (
    [name]                  NVARCHAR (129) NULL,
    [short_code]            VARCHAR (4)    NULL,
    [intellihr_company_id]  NVARCHAR (36)  NULL,
    [datapay_company_id]    NVARCHAR (50)  NULL,
    [datapay_code]          INT            NULL,
    [sort_index]            INT            NULL,
    [recordbase_company_id] INT            NULL,
    [recordbase_udf_2]      NVARCHAR (MAX) NULL,
    [recordbase_udf_1]      NVARCHAR (MAX) NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [BK_Landing_edw_dim_company]
    ON [landing].[edw_dim_company]([short_code] ASC);

