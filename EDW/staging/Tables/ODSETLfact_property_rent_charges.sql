CREATE TABLE [staging].[ODSETLfact_property_rent_charges] (
    [ODSfact_property_rent_chargesID] INT              IDENTITY (1, 1) NOT NULL,
    [dim_property_key]                INT              NOT NULL,
    [dim_company_key]                 INT              NULL,
    [dim_employee_key]                INT              NULL,
    [rent_charge_id]                  UNIQUEIDENTIFIER NULL,
    [rent_charge_name]                VARCHAR (200)    NULL,
    [property_id]                     UNIQUEIDENTIFIER NULL,
    [property_name]                   VARCHAR (100)    NULL,
    [provider_name]                   VARCHAR (100)    NULL,
    [company_name]                    VARCHAR (50)     NULL,
    [agreed_rent]                     NUMERIC (18, 4)  NULL,
    [market_rent]                     NUMERIC (18, 4)  NULL,
    [supplement_amount]               NUMERIC (18, 4)  NULL,
    [start_date]                      DATETIME2 (7)    NULL,
    [end_date]                        DATETIME2 (7)    NULL,
    [employee_id]                     INT              NULL,
    [employee_name]                   VARCHAR (80)     NULL,
    CONSTRAINT [PK_Temp_Staging_ODSETLfact_property_rent_charges] PRIMARY KEY NONCLUSTERED ([ODSfact_property_rent_chargesID] ASC)
);

