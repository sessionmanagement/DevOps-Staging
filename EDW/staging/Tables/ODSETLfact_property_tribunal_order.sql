CREATE TABLE [staging].[ODSETLfact_property_tribunal_order] (
    [ODSfact_property_tribunal_orderID] INT              IDENTITY (1, 1) NOT NULL,
    [property_tribunal_order_id]        UNIQUEIDENTIFIER NULL,
    [property_tenancy_breach_id]        UNIQUEIDENTIFIER NULL,
    [property_tenancy_id]               UNIQUEIDENTIFIER NULL,
    [property_id]                       UNIQUEIDENTIFIER NULL,
    [dim_property_tenancy_key]          INT              NULL,
    [dim_property_key]                  INT              NULL,
    [tribunal_order]                    VARCHAR (400)    NULL,
    [notes]                             VARCHAR (2000)   NULL,
    [tribunal_outcome]                  VARCHAR (400)    NULL,
    [tribunal_outcome_reason]           VARCHAR (400)    NULL,
    [tribunal_order_start_date]         DATETIME         NULL,
    [tribunal_order_owner]              VARCHAR (60)     NULL,
    [modified_by]                       VARCHAR (60)     NULL,
    [modified_date]                     DATETIME         NULL,
    [created_date]                      DATETIME         NULL,
    [tribunal_order_state]              VARCHAR (20)     NULL,
    [tribunal_order_status]             VARCHAR (20)     NULL,
    CONSTRAINT [PK_Temp_Staging_ODSETLfact_property_tribunal_order] PRIMARY KEY NONCLUSTERED ([ODSfact_property_tribunal_orderID] ASC)
);

