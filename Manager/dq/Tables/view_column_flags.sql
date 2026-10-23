CREATE TABLE [dq].[view_column_flags] (
    [view_name]          [sysname]     NOT NULL,
    [source_table]       [sysname]     NOT NULL,
    [source_column]      [sysname]     NOT NULL,
    [is_in_select]       TINYINT       NOT NULL,
    [is_distinct_select] TINYINT       NOT NULL,
    [is_in_where]        TINYINT       NOT NULL,
    [is_in_join]         TINYINT       NOT NULL,
    [is_in_group_by]     TINYINT       NOT NULL,
    [is_in_having]       TINYINT       NOT NULL,
    [is_in_order_by]     TINYINT       NOT NULL,
    [is_aggregated]      TINYINT       NOT NULL,
    [is_in_outer_apply]  TINYINT       NOT NULL,
    [is_in_cross_apply]  TINYINT       NOT NULL,
    [is_in_window]       TINYINT       NOT NULL,
    [is_in_case]         TINYINT       NOT NULL,
    [is_in_function]     TINYINT       NOT NULL,
    [is_in_expression]   TINYINT       NOT NULL,
    [has_select_star]    TINYINT       NOT NULL,
    [load_dtm]           DATETIME2 (3) CONSTRAINT [DF_view_column_flags_load_dtm] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_view_column_flags] PRIMARY KEY CLUSTERED ([view_name] ASC, [source_table] ASC, [source_column] ASC)
);

