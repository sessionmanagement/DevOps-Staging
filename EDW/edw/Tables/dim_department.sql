CREATE TABLE [edw].[dim_department] (
    [dim_department_key]                 INT            IDENTITY (0, 1) NOT NULL,
    [department_dimension_value_id]      INT            NOT NULL,
    [department_code]                    VARCHAR (20)   NULL,
    [department_name]                    VARCHAR (100)  NULL,
    [department_company_name]            VARCHAR (50)   NULL,
    [department_last_modified_date_time] DATETIME2 (7)  NULL,
    [DWHSourceSystem]                    NVARCHAR (500) NOT NULL,
    [DWHBatchId]                         INT            NOT NULL,
    [DWHDMLOperation]                    CHAR (1)       NOT NULL,
    [DWHEffectiveFrom]                   DATETIME       NOT NULL,
    [DWHEffectiveTo]                     DATETIME       NOT NULL,
    [DWHIsCurrent]                       INT            NOT NULL,
    CONSTRAINT [PK_EDW_dim_department] PRIMARY KEY NONCLUSTERED ([dim_department_key] ASC)
);





