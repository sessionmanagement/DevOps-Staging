CREATE TABLE [meta_data].[table_business_id] (
    [table_unique_column_id] INT            IDENTITY (1, 1) NOT NULL,
    [schema_name]            NVARCHAR (20)  NOT NULL,
    [table_name]             NVARCHAR (100) NOT NULL,
    [business_id]            NVARCHAR (100) NULL,
    [company_id]             NVARCHAR (100) NULL,
    [is_current_column]      NVARCHAR (100) NULL,
    [dml_operation_column]   NVARCHAR (100) NULL,
    CONSTRAINT [PK_table_business_id] PRIMARY KEY CLUSTERED ([table_unique_column_id] ASC)
);

