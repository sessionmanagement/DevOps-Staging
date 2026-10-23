CREATE TABLE [edw].[fact_employee_pay_slip_item] (
    [fact_employee_pay_slip_item_key]   INT             IDENTITY (1, 1) NOT NULL,
    [dim_employee_pay_slip_key]         INT             NULL,
    [dim_company_key_pay_packet_id_key] BIGINT          NULL,
    [dim_employee_key]                  INT             NOT NULL,
    [dim_company_key]                   INT             NOT NULL,
    [pay_packet_id]                     INT             NULL,
    [pay_packet_row_id]                 NVARCHAR (4000) NULL,
    [employee_id]                       INT             NULL,
    [item_type]                         VARCHAR (9)     NOT NULL,
    [item_amount]                       FLOAT (53)      NULL,
    [item_type_detail]                  NVARCHAR (100)  NULL,
    [item_summary]                      NVARCHAR (4000) NULL,
    [company_code]                      INT             NULL,
    [DWHBatchId]                        INT             NOT NULL,
    [DWHCreatedAt]                      DATETIME        NOT NULL,
    [DWHModifiedOn]                     DATETIME        NOT NULL,
    [DWHDMLOperation]                   CHAR (1)        NOT NULL,
    [DWHSourceSystem]                   NVARCHAR (500)  NOT NULL,
    CONSTRAINT [PK__edw_fact_employee_pay_slip_item] PRIMARY KEY NONCLUSTERED ([fact_employee_pay_slip_item_key] ASC)
);

