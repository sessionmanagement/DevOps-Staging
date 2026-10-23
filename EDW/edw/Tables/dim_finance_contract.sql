CREATE TABLE [edw].[dim_finance_contract] (
    [dim_finance_contract_key]                 INT            IDENTITY (0, 1) NOT NULL,
    [finance_contract_dimension_value_id]      INT            NOT NULL,
    [finance_contract_code]                    VARCHAR (20)   NULL,
    [finance_contract_name]                    VARCHAR (100)  NULL,
    [finance_contract_company_name]            VARCHAR (50)   NULL,
    [finance_contract_last_modified_date_time] DATETIME2 (7)  NULL,
    [DWHSourceSystem]                          NVARCHAR (500) NOT NULL,
    [DWHBatchId]                               INT            NOT NULL,
    [DWHDMLOperation]                          CHAR (1)       NOT NULL,
    [DWHEffectiveFrom]                         DATETIME       NOT NULL,
    [DWHEffectiveTo]                           DATETIME       NOT NULL,
    [DWHIsCurrent]                             INT            NOT NULL,
    CONSTRAINT [PK_EDW_dim_finance_contract] PRIMARY KEY NONCLUSTERED ([dim_finance_contract_key] ASC)
);

