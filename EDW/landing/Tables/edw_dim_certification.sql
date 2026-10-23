CREATE TABLE [landing].[edw_dim_certification] (
    [certification_id]            INT             NULL,
    [certification_full_name]     NVARCHAR (100)  NULL,
    [certification_short_name]    NVARCHAR (100)  NULL,
    [certification_id_number]     NVARCHAR (100)  NULL,
    [available_from_date]         DATETIME2 (7)   NULL,
    [certification_end_date]      DATETIME2 (7)   NULL,
    [certification_created_date]  DATETIME2 (7)   NULL,
    [certification_category_id]   INT             NULL,
    [certification_category_name] NVARCHAR (300)  NULL,
    [certification_category_path] NVARCHAR (1000) NULL
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [BK_Landing_dim_certification]
    ON [landing].[edw_dim_certification]([certification_id] ASC);

