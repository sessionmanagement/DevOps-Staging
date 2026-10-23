CREATE TABLE [landing].[edw_dim_location_new] (
    [intelliHR_location_id]          NVARCHAR (36)   NULL,
    [business_central_location_id]   NVARCHAR (MAX)  NULL,
    [location_code]                  NVARCHAR (4000) NULL,
    [intelliHR_location_name]        NVARCHAR (150)  NULL,
    [business_central_location_name] NVARCHAR (MAX)  NULL,
    [parent_location_id]             NVARCHAR (36)   NULL,
    [parent_location_code]           NVARCHAR (100)  NULL,
    [parent_location_name]           NVARCHAR (150)  NULL,
    [last_modified_datetime]         DATETIME2 (7)   NULL,
    [exists_in_intelliHR]            INT             NULL,
    [exists_in_business_central]     INT             NULL,
    [company_name]                   NVARCHAR (4000) NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [dim_location_new]
    ON [landing].[edw_dim_location_new]([location_code] ASC, [company_name] ASC);

