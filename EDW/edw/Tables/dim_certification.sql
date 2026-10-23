CREATE TABLE [edw].[dim_certification] (
    [dim_certification_key]             INT             IDENTITY (0, 1) NOT NULL,
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
    [DWHBatchId]                        INT             NOT NULL,
    [DWHEffectiveFrom]                  DATETIME        NOT NULL,
    [DWHEffectiveTo]                    DATETIME        NOT NULL,
    [DWHDMLOperation]                   CHAR (1)        NOT NULL,
    [DWHIsCurrent]                      BIT             NOT NULL,
    [DWHSourceSystem]                   NVARCHAR (500)  NOT NULL,
    CONSTRAINT [PK__edw_dim_certification] PRIMARY KEY NONCLUSTERED ([dim_certification_key] ASC)
);

