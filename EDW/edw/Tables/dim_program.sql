CREATE TABLE [edw].[dim_program] (
    [dim_program_key]       INT             IDENTITY (0, 1) NOT NULL,
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
    [DWHBatchId]            INT             NOT NULL,
    [DWHEffectiveFrom]      DATETIME        NOT NULL,
    [DWHEffectiveTo]        DATETIME        NOT NULL,
    [DWHDMLOperation]       CHAR (1)        NOT NULL,
    [DWHIsCurrent]          INT             NOT NULL,
    [DWHSourceSystem]       NVARCHAR (500)  NOT NULL,
    CONSTRAINT [PK__edw_dim_program] PRIMARY KEY NONCLUSTERED ([dim_program_key] ASC)
);

