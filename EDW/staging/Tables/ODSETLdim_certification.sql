CREATE TABLE [staging].[ODSETLdim_certification] (
    [dim_certification_key]             INT             IDENTITY (1, 1) NOT NULL,
    [certification_id]                  INT             NULL,
    [certification_full_name]           NVARCHAR (100)  NULL,
    [certification_short_name]          NVARCHAR (100)  NULL,
    [certification_id_number]           NVARCHAR (100)  NULL,
    [certification_available_from_date] DATETIME2 (7)   NULL,
    [certification_end_date]            DATETIME2 (7)   NULL,
    [certification_created_date]        DATETIME2 (7)   NULL,
    [certification_category_id]         INT             NULL,
    [certification_category_name]       NVARCHAR (300)  NULL,
    [certification_category_path]       NVARCHAR (1000) NULL,
    CONSTRAINT [PK_Temp_Staging_ODSETLdim_certification] PRIMARY KEY NONCLUSTERED ([dim_certification_key] ASC)
);

