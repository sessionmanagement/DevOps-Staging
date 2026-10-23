CREATE TABLE [staging].[ODSETLdim_service] (
    [service_id]                      INT             NOT NULL,
    [dim_service_unique_key]          NVARCHAR (200)  NOT NULL,
    [service_code]                    NVARCHAR (200)  NULL,
    [service_name]                    NVARCHAR (200)  NULL,
    [intellihr_service_id]            NVARCHAR (200)  NULL,
    [datapay_service_id]              NVARCHAR (200)  NULL,
    [service_type_code]               NVARCHAR (200)  NULL,
    [service_type_name]               NVARCHAR (200)  NULL,
    [department_code]                 NVARCHAR (200)  NULL,
    [department_name]                 NVARCHAR (200)  NULL,
    [district_code]                   NVARCHAR (200)  NULL,
    [district_name]                   NVARCHAR (200)  NULL,
    [region_code]                     NVARCHAR (200)  NULL,
    [region_name]                     NVARCHAR (200)  NULL,
    [location_code]                   NVARCHAR (200)  NULL,
    [location_name]                   NVARCHAR (200)  NULL,
    [finance_funder_code]             NVARCHAR (200)  NULL,
    [finance_funder_name]             NVARCHAR (200)  NULL,
    [finance_funding_agency_code]     NVARCHAR (200)  NULL,
    [finance_funding_agency_name]     NVARCHAR (200)  NULL,
    [finance_budget_holder_code]      NVARCHAR (200)  NULL,
    [finance_budget_holder_name]      NVARCHAR (200)  NULL,
    [finance_contract_code]           NVARCHAR (200)  NULL,
    [finance_contract_name]           NVARCHAR (200)  NULL,
    [company_name]                    NVARCHAR (200)  NOT NULL,
    [service_last_modified_date_time] DATETIME        NULL,
    [is_inactive]                     INT             NULL,
    [latitude]                        DECIMAL (13, 8) NULL,
    [longitude]                       DECIMAL (13, 8) NULL,
    [Functional_Capability]           NVARCHAR (50)   NULL,
    [Functional_Group]                NVARCHAR (50)   NULL,
    [Business_Unit]                   NVARCHAR (50)   NULL,
    [Business_Sub_Unit]               NVARCHAR (50)   NULL,
    [Portfolio]                       NVARCHAR (50)   NULL,
    [Service_Grouping]                NVARCHAR (100)  NULL
);










GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_dim_service]
    ON [staging].[ODSETLdim_service]([dim_service_unique_key] ASC);



