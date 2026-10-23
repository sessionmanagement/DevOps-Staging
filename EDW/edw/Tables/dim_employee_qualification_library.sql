CREATE TABLE [edw].[dim_employee_qualification_library] (
    [dim_employee_qualification_library_key] INT            IDENTITY (1, 1) NOT NULL,
    [employee_qualification_library_id]      NVARCHAR (36)  NULL,
    [employee_qualification_library]         NVARCHAR (100) NULL,
    [job_requirement_usage_count]            INT            NULL,
    [DWHBatchId]                             INT            NOT NULL,
    [DWHEffectiveFrom]                       DATETIME       NOT NULL,
    [DWHEffectiveTo]                         DATETIME       NOT NULL,
    [DWHDMLOperation]                        CHAR (1)       NOT NULL,
    [DWHIsCurrent]                           BIT            NOT NULL,
    [DWHSourceSystem]                        NVARCHAR (100) NOT NULL,
    CONSTRAINT [PK__edw_dim_employee_qualification_library] PRIMARY KEY NONCLUSTERED ([dim_employee_qualification_library_key] ASC)
);

