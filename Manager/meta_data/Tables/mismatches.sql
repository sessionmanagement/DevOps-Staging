CREATE TABLE [meta_data].[mismatches] (
    [mismatches_id]                INT            IDENTITY (1, 1) NOT NULL,
    [schema_name]                  NVARCHAR (100) NULL,
    [table_name]                   NVARCHAR (100) NULL,
    [column_name]                  NVARCHAR (100) NULL,
    [mismatches_count]             INT            NULL,
    [mismatch_invalid_data_count]  INT            NULL,
    [mismatch_invalid_data_reason] NVARCHAR (100) NULL,
    [mismatches_date]              DATETIME       NULL,
    CONSTRAINT [PK_meta_data_mismatches_mismatches_id] PRIMARY KEY CLUSTERED ([mismatches_id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_mismatches_table_name]
    ON [meta_data].[mismatches]([table_name] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_mismatches_schema_name]
    ON [meta_data].[mismatches]([schema_name] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_mismatches_date]
    ON [meta_data].[mismatches]([mismatches_date] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_mismatches_column_name]
    ON [meta_data].[mismatches]([column_name] ASC);

