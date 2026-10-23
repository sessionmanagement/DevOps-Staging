CREATE TABLE [edw].[dim_gender] (
    [dim_gender_key]       INT            IDENTITY (1, 1) NOT NULL,
    [gender_id]            INT            NULL,
    [gender_code]          NVARCHAR (10)  NOT NULL,
    [gender_name]          NVARCHAR (100) NOT NULL,
    [intellihr_gender_key] NVARCHAR (100) NULL,
    [datapay_gender_key]   NVARCHAR (100) NULL,
    [zavanti_gender_key]   NVARCHAR (100) NULL,
    [emplive_gender_key]   NVARCHAR (100) NULL,
    [DWHBatchId]           INT            NOT NULL,
    [DWHCreatedAt]         DATETIME       NOT NULL,
    [DWHModifiedOn]        DATETIME       NOT NULL,
    [DWHDMLOperation]      CHAR (1)       NOT NULL,
    [DWHSourceSystem]      NVARCHAR (500) NOT NULL,
    CONSTRAINT [PK__edw_dim_gender] PRIMARY KEY NONCLUSTERED ([dim_gender_key] ASC)
);



