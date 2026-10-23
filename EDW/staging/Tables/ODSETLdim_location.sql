CREATE TABLE [staging].[ODSETLdim_location] (
    [location_dimension_value_id]      INT           NOT NULL,
    [location_code]                    NVARCHAR (30) NOT NULL,
    [location_name]                    VARCHAR (75)  NOT NULL,
    [location_company_name]            VARCHAR (50)  NOT NULL,
    [location_last_modified_date_time] DATETIME2 (7) NOT NULL,
    [DWHDMLOperation]                  NVARCHAR (1)  NOT NULL,
    [DWHIsCurrent]                     BIT           NULL,
    [DWHEffectiveFrom]                 DATETIME      NOT NULL,
    [DWHEffectiveTo]                   DATETIME      NOT NULL
);



