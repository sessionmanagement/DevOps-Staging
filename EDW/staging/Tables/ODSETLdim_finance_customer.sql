CREATE TABLE [staging].[ODSETLdim_finance_customer] (
    [finance_customer_dimension_value_id]      INT           NOT NULL,
    [finance_customer_code]                    NVARCHAR (30) NOT NULL,
    [finance_customer_name]                    VARCHAR (75)  NOT NULL,
    [finance_customer_company_name]            VARCHAR (50)  NOT NULL,
    [finance_customer_last_modified_date_time] DATETIME2 (7) NOT NULL,
    [DWHDMLOperation]                          NVARCHAR (1)  NOT NULL,
    [DWHIsCurrent]                             BIT           NULL,
    [DWHEffectiveFrom]                         DATETIME      NOT NULL,
    [DWHEffectiveTo]                           DATETIME      NOT NULL
);



