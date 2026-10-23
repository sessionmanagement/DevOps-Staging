CREATE TABLE [edw].[dim_employee_qualification_type] (
    [dim_employee_qualification_type_key] INT            IDENTITY (1, 1) NOT NULL,
    [employee_qualification_type_id]      NVARCHAR (36)  NULL,
    [employee_qualification_type]         NVARCHAR (30)  NULL,
    [DWHBatchId]                          INT            NOT NULL,
    [DWHEffectiveFrom]                    DATETIME       NOT NULL,
    [DWHEffectiveTo]                      DATETIME       NOT NULL,
    [DWHDMLOperation]                     CHAR (1)       NOT NULL,
    [DWHIsCurrent]                        BIT            NOT NULL,
    [DWHSourceSystem]                     NVARCHAR (100) NOT NULL,
    CONSTRAINT [PK__edw_dim_employee_qualification_type] PRIMARY KEY NONCLUSTERED ([dim_employee_qualification_type_key] ASC)
);

