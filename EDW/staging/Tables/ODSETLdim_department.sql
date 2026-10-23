CREATE TABLE [staging].[ODSETLdim_department] (
    [department_dimension_value_id]      INT           NOT NULL,
    [department_code]                    NVARCHAR (20) NOT NULL,
    [department_name]                    VARCHAR (100) NOT NULL,
    [department_company_name]            VARCHAR (50)  NOT NULL,
    [department_last_modified_date_time] DATETIME2 (7) NOT NULL,
    [DWHDMLOperation]                    NVARCHAR (1)  NOT NULL,
    [DWHIsCurrent]                       BIT           NULL,
    [DWHEffectiveFrom]                   DATETIME      NOT NULL,
    [DWHEffectiveTo]                     DATETIME      NOT NULL
);



