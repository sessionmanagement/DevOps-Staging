CREATE TABLE [edw].[dim_district] (
    [dim_district_key]                 INT            IDENTITY (0, 1) NOT NULL,
    [district_dimension_value_id]      INT            NOT NULL,
    [district_code]                    VARCHAR (20)   NULL,
    [district_name]                    VARCHAR (100)  NULL,
    [district_company_name]            VARCHAR (50)   NULL,
    [district_last_modified_date_time] DATETIME2 (7)  NULL,
    [DWHSourceSystem]                  NVARCHAR (500) NOT NULL,
    [DWHBatchId]                       INT            NOT NULL,
    [DWHDMLOperation]                  CHAR (1)       NOT NULL,
    [DWHEffectiveFrom]                 DATETIME       NOT NULL,
    [DWHEffectiveTo]                   DATETIME       NOT NULL,
    [DWHIsCurrent]                     INT            NOT NULL,
    CONSTRAINT [PK_EDW_dim_district] PRIMARY KEY NONCLUSTERED ([dim_district_key] ASC)
);





