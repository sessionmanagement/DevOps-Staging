CREATE TABLE [landing].[edw_fact_property_tenancy_breach] (
    [tenancy_breach_id]       UNIQUEIDENTIFIER NOT NULL,
    [property_tenancy_id]     UNIQUEIDENTIFIER NULL,
    [breach]                  VARCHAR (400)    NULL,
    [tenancy_breach]          VARCHAR (400)    NULL,
    [breach_date]             DATETIME2 (7)    NULL,
    [breach_id]               VARCHAR (400)    NULL,
    [breach_status]           VARCHAR (700)    NULL,
    [tribunal_order_id]       UNIQUEIDENTIFIER NULL,
    [tribunal_order]          VARCHAR (400)    NULL,
    [breach_end_date]         DATETIME2 (7)    NULL,
    [breach_start_date]       DATETIME2 (7)    NULL,
    [tribunal_outcome_id]     UNIQUEIDENTIFIER NULL,
    [tribunal_outcome]        VARCHAR (400)    NULL,
    [case_number]             VARCHAR (800)    NULL,
    [tribunal_outcome_reason] VARCHAR (400)    NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [fact_tenancy_breach]
    ON [landing].[edw_fact_property_tenancy_breach]([tenancy_breach_id] ASC, [tribunal_order_id] ASC);

