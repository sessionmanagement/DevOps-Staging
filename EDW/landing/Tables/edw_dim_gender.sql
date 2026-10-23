CREATE TABLE [landing].[edw_dim_gender] (
    [gender_id]            INT            NULL,
    [gender_value]         NVARCHAR (10)  NOT NULL,
    [gender_text]          NVARCHAR (100) NOT NULL,
    [intellihr_gender_key] NVARCHAR (100) NULL,
    [datapay_gender_key]   NVARCHAR (100) NULL,
    [zavanti_gender_key]   NVARCHAR (100) NULL,
    [emplive_gender_key]   NVARCHAR (100) NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [BK_Landing_edw_dim_gender]
    ON [landing].[edw_dim_gender]([gender_id] ASC);

