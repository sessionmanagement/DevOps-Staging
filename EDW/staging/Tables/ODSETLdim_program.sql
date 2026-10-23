CREATE TABLE [staging].[ODSETLdim_program] (
    [dim_program_key]       INT             IDENTITY (1, 1) NOT NULL,
    [program_id]            INT             NULL,
    [program_full_name]     NVARCHAR (200)  NULL,
    [program_short_name]    NVARCHAR (200)  NULL,
    [program_id_number]     NVARCHAR (100)  NULL,
    [available_from_date]   DATETIME2 (7)   NULL,
    [program_end_date]      DATETIME2 (7)   NULL,
    [program_created_date]  DATETIME2 (7)   NULL,
    [program_category_id]   INT             NULL,
    [program_category_name] NVARCHAR (100)  NULL,
    [program_category_path] NVARCHAR (1000) NULL,
    CONSTRAINT [PK_Temp_Staging_ODSETLdim_program] PRIMARY KEY NONCLUSTERED ([dim_program_key] ASC)
);

