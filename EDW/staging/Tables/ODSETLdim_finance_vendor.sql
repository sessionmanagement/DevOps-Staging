CREATE TABLE [staging].[ODSETLdim_finance_vendor] (
    [finance_vendor_dimension_value_id]      INT           NOT NULL,
    [finance_vendor_code]                    NVARCHAR (30) NOT NULL,
    [finance_vendor_name]                    VARCHAR (75)  NOT NULL,
    [finance_vendor_company_name]            VARCHAR (50)  NOT NULL,
    [finance_vendor_last_modified_date_time] DATETIME2 (7) NOT NULL,
    [DWHDMLOperation]                        NVARCHAR (1)  NOT NULL,
    [DWHIsCurrent]                           BIT           NULL,
    [DWHEffectiveFrom]                       DATETIME      NOT NULL,
    [DWHEffectiveTo]                         DATETIME      NOT NULL,
    [DimensionCheckSum]                      INT           CONSTRAINT [DF_staging_dim_vendor_DimensionCheckSum] DEFAULT ((-1)) NOT NULL
);

