CREATE TABLE [landing].[edw_dim_service] (
    [service_id]              INT             NULL,
    [rowkey]                  NVARCHAR (156)  NULL,
    [service_code]            NVARCHAR (120)  NULL,
    [service_name]            NVARCHAR (150)  NULL,
    [intellihr_service_id]    NVARCHAR (36)   NULL,
    [datapay_service_id]      NVARCHAR (50)   NULL,
    [service_type_code]       NVARCHAR (120)  NULL,
    [service_type_name]       NVARCHAR (150)  NULL,
    [department_code]         NVARCHAR (120)  NULL,
    [department_name]         NVARCHAR (150)  NULL,
    [district_code]           NVARCHAR (120)  NULL,
    [district_name]           NVARCHAR (150)  NULL,
    [region_code]             NVARCHAR (120)  NULL,
    [region_name]             NVARCHAR (150)  NULL,
    [location_code]           NVARCHAR (120)  NULL,
    [location_name]           NVARCHAR (150)  NULL,
    [funder_code]             NVARCHAR (120)  NULL,
    [funder_name]             NVARCHAR (150)  NULL,
    [funding_agency_code]     NVARCHAR (120)  NULL,
    [funding_agency_name]     NVARCHAR (150)  NULL,
    [budget_holder_code]      NVARCHAR (120)  NULL,
    [budget_holder_name]      NVARCHAR (150)  NULL,
    [contract_code]           NVARCHAR (120)  NULL,
    [contract_name]           NVARCHAR (150)  NULL,
    [company]                 NVARCHAR (129)  NULL,
    [last_modified_date_time] DATETIME2 (0)   NULL,
    [is_inactive]             INT             NULL,
    [latitude]                DECIMAL (13, 8) NULL,
    [longitude]               DECIMAL (13, 8) NULL
);








GO
CREATE UNIQUE NONCLUSTERED INDEX [BK_Landing_edw_dim_service]
    ON [landing].[edw_dim_service]([service_id] ASC, [company] ASC);



