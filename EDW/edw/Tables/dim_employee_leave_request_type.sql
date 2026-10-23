CREATE TABLE [edw].[dim_employee_leave_request_type] (
    [dim_employee_leave_request_type_key] INT            IDENTITY (1, 1) NOT NULL,
    [leave_request_type_id]               NVARCHAR (36)  NULL,
    [leave_request_type_code]             NVARCHAR (255) NULL,
    [leave_request_type]                  NVARCHAR (255) NULL,
    [DWHBatchId]                          INT            NOT NULL,
    [DWHEffectiveFrom]                    DATETIME       NOT NULL,
    [DWHEffectiveTo]                      DATETIME       NOT NULL,
    [DWHDMLOperation]                     CHAR (1)       NOT NULL,
    [DWHIsCurrent]                        BIT            NOT NULL,
    [DWHSourceSystem]                     NVARCHAR (500) NOT NULL,
    CONSTRAINT [PK__edw_dim_employee_leave_request_type] PRIMARY KEY NONCLUSTERED ([dim_employee_leave_request_type_key] ASC)
);

