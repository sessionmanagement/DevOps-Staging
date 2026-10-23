CREATE TABLE [landing].[edw_fact_property_arrears_transaction] (
    [transaction_id]                  UNIQUEIDENTIFIER   NULL,
    [property_arrears_arrangement_id] UNIQUEIDENTIFIER   NULL,
    [property_tenancy_id]             UNIQUEIDENTIFIER   NULL,
    [property_id]                     UNIQUEIDENTIFIER   NULL,
    [property_program_id]             UNIQUEIDENTIFIER   NULL,
    [property_subprogram_id]          UNIQUEIDENTIFIER   NULL,
    [transaction_detail_id]           UNIQUEIDENTIFIER   NULL,
    [transaction_number]              VARCHAR (100)      NULL,
    [transaction_name]                VARCHAR (500)      NULL,
    [transaction_description]         VARCHAR (800)      NULL,
    [transaction_date]                DATETIME2 (7)      NULL,
    [transaction_date_id]             INT                NULL,
    [arrear_amount]                   NUMERIC (16, 4)    NULL,
    [paid_amount]                     NUMERIC (16, 4)    NULL,
    [state_label]                     VARCHAR (50)       NULL,
    [status_label]                    VARCHAR (50)       NULL,
    [owner_id]                        UNIQUEIDENTIFIER   NULL,
    [created_datetime]                DATETIMEOFFSET (7) NULL,
    [modified_datetime]               DATETIME2 (7)      NULL,
    [is_delete_flag]                  INT                NULL
);

