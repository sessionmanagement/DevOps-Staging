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

