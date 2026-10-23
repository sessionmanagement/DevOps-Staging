CREATE TABLE [staging].[ODSETLfact_property_tenancy_breach] (
    [fact_property_tenancy_breach_key] INT              IDENTITY (1, 1) NOT NULL,
    [tenancy_breach_id]                UNIQUEIDENTIFIER NULL,
    [dim_property_tenancy_key]         INT              NULL,
    [property_tenancy_id]              UNIQUEIDENTIFIER NULL,
    [breach]                           VARCHAR (400)    NULL,
    [tenancy_breach]                   VARCHAR (400)    NULL,
    [breach_date]                      DATETIME2 (7)    NULL,
    [breach_id]                        VARCHAR (400)    NULL,
    [breach_status]                    VARCHAR (700)    NULL,
    [tribunal_order_id]                UNIQUEIDENTIFIER NULL,
    [tribunal_order]                   VARCHAR (400)    NULL,
    [breach_end_date]                  DATETIME2 (7)    NULL,
    [breach_start_date]                DATETIME2 (7)    NULL,
    [tribunal_outcome_id]              UNIQUEIDENTIFIER NULL,
    [tribunal_outcome]                 VARCHAR (400)    NULL,
    [case_number]                      VARCHAR (800)    NULL,
    [tribunal_outcome_reason]          VARCHAR (400)    NULL,
    CONSTRAINT [PK_Temp_Staging_ODSETLfact_property_tenancy_breach] PRIMARY KEY NONCLUSTERED ([fact_property_tenancy_breach_key] ASC)
);

