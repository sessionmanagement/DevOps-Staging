CREATE TABLE [edw].[dim_region] (
    [dim_region_key]                 INT            IDENTITY (0, 1) NOT NULL,
    [region_dimension_value_id]      INT            NOT NULL,
    [region_code]                    VARCHAR (20)   NULL,
    [region_name]                    VARCHAR (100)  NULL,
    [region_company_name]            VARCHAR (50)   NULL,
    [region_last_modified_date_time] DATETIME2 (7)  NULL,
    [DWHSourceSystem]                NVARCHAR (500) NOT NULL,
    [DWHBatchId]                     INT            NOT NULL,
    [DWHDMLOperation]                CHAR (1)       NOT NULL,
    [DWHEffectiveFrom]               DATETIME       NOT NULL,
    [DWHEffectiveTo]                 DATETIME       NOT NULL,
    [DWHIsCurrent]                   INT            NOT NULL,
    CONSTRAINT [PK_EDW_dim_region] PRIMARY KEY NONCLUSTERED ([dim_region_key] ASC)
);



