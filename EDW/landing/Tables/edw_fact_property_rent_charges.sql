CREATE TABLE [landing].[edw_fact_property_rent_charges] (
    [rent_charge_id]    UNIQUEIDENTIFIER NULL,
    [rent_charge_name]  VARCHAR (200)    NULL,
    [property_id]       UNIQUEIDENTIFIER NULL,
    [property_name]     VARCHAR (100)    NULL,
    [provider_name]     VARCHAR (100)    NULL,
    [company_name]      VARCHAR (50)     NULL,
    [agreed_rent]       NUMERIC (18, 4)  NULL,
    [market_rent]       NUMERIC (18, 4)  NULL,
    [supplement_amount] NUMERIC (18, 4)  NULL,
    [start_date]        DATETIME2 (7)    NULL,
    [end_date]          DATETIME2 (7)    NULL,
    [employee_name]     VARCHAR (100)    NULL,
    [employee_email]    VARCHAR (200)    NULL
);

