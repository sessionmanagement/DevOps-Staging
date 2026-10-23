CREATE TABLE [staging].[ODSETLdim_district] (
    [district_dimension_value_id]      INT           NOT NULL,
    [district_code]                    NVARCHAR (30) NOT NULL,
    [district_name]                    VARCHAR (75)  NOT NULL,
    [district_company_name]            VARCHAR (50)  NOT NULL,
    [district_last_modified_date_time] DATETIME2 (7) NOT NULL,
    [DWHDMLOperation]                  NVARCHAR (1)  NOT NULL,
    [DWHIsCurrent]                     BIT           NULL,
    [DWHEffectiveFrom]                 DATETIME      NOT NULL,
    [DWHEffectiveTo]                   DATETIME      NOT NULL
);



