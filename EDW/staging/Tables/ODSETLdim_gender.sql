CREATE TABLE [staging].[ODSETLdim_gender] (
    [gender_id]            INT            NULL,
    [gender_code]          NVARCHAR (10)  NOT NULL,
    [gender_name]          NVARCHAR (100) NOT NULL,
    [intellihr_gender_key] NVARCHAR (100) NULL,
    [datapay_gender_key]   NVARCHAR (100) NULL,
    [zavanti_gender_key]   NVARCHAR (100) NULL,
    [emplive_gender_key]   NVARCHAR (100) NULL
);

