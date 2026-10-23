CREATE TABLE [edw].[dim_location] (
    [dim_location_key]                 INT            IDENTITY (0, 1) NOT NULL,
    [location_dimension_value_id]      INT            NOT NULL,
    [location_code]                    VARCHAR (20)   NULL,
    [location_name]                    VARCHAR (100)  NULL,
    [location_company_name]            VARCHAR (50)   NULL,
    [location_last_modified_date_time] DATETIME2 (7)  NULL,
    [DWHSourceSystem]                  NVARCHAR (500) NOT NULL,
    [DWHBatchId]                       INT            NOT NULL,
    [DWHDMLOperation]                  CHAR (1)       NOT NULL,
    [DWHEffectiveFrom]                 DATETIME       NOT NULL,
    [DWHEffectiveTo]                   DATETIME       NOT NULL,
    [DWHIsCurrent]                     INT            NOT NULL,
    CONSTRAINT [PK_EDW_dim_location] PRIMARY KEY NONCLUSTERED ([dim_location_key] ASC)
);



