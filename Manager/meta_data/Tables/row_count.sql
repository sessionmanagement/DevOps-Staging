CREATE TABLE [meta_data].[row_count] (
    [row_count_id]   INT            IDENTITY (1, 1) NOT NULL,
    [schema_name]    NVARCHAR (100) NULL,
    [table_name]     NVARCHAR (100) NULL,
    [row_count]      INT            NULL,
    [row_count_date] DATETIME       NULL,
    CONSTRAINT [PK_meta_data_row_count_row_count_id] PRIMARY KEY CLUSTERED ([row_count_id] ASC)
);

