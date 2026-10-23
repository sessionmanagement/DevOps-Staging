CREATE TABLE [staging].[ODSETLfact_finance_budget] (
    [fact_finance_budget_partition_key]        NVARCHAR (200)   NULL,
    [fact_finance_budget_row_key]              NVARCHAR (200)   NULL,
    [finance_budget_holder_id]                 INT              NULL,
    [finance_contract_id]                      INT              NULL,
    [finance_customer_id]                      INT              NULL,
    [department_id]                            INT              NULL,
    [district_id]                              INT              NULL,
    [finance_funder_id]                        INT              NULL,
    [finance_funding_agency_id]                INT              NULL,
    [location_id]                              INT              NULL,
    [region_id]                                INT              NULL,
    [service_id]                               INT              NULL,
    [finance_vendor_id]                        INT              NULL,
    [finance_budget_company_name]              NVARCHAR (200)   NULL,
    [finance_budget_general_ledger_account_no] NVARCHAR (200)   NULL,
    [finance_budget_dimension_set_id]          INT              NULL,
    [finance_budget_budget_name]               NVARCHAR (500)   NULL,
    [finance_budget_description]               NVARCHAR (200)   NULL,
    [finance_budget_global_dimension_1_code]   NVARCHAR (200)   NULL,
    [finance_budget_entry_no]                  INT              NULL,
    [finance_budget_date_key]                  INT              NULL,
    [finance_budget_last_modified_date_time]   DATETIME2 (0)    NULL,
    [finance_budget_amount]                    DECIMAL (38, 18) NULL
);



