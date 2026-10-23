CREATE TABLE [load_check].[load_execution] (
    [load_execution_id]    BIGINT         IDENTITY (1, 1) NOT NULL,
    [schema_name]          NVARCHAR (10)  NULL,
    [table_name]           NVARCHAR (100) NULL,
    [start_time]           DATETIME       NULL,
    [end_time]             DATETIME       NULL,
    [current_load_status]  NVARCHAR (30)  NULL,
    [load_duration]        TIME (7)       NULL,
    [etl_row_count]        INT            NULL,
    [etl_insert_count]     INT            NULL,
    [etl_update_count]     INT            NULL,
    [etl_delete_count]     INT            NULL,
    [completed]            TINYINT        NULL,
    [total_source_records] INT            NULL,
    [total_target_records] INT            NULL,
    CONSTRAINT [PK_load_execution] PRIMARY KEY CLUSTERED ([load_execution_id] ASC)
);

