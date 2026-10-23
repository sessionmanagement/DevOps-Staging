CREATE TABLE [meta_data].[dq_dictionary] (
    [dictionary_id]   INT            NOT NULL,
    [table_name]      NVARCHAR (200) NOT NULL,
    [column_name]     NVARCHAR (200) NULL,
    [check_name]      NVARCHAR (200) NOT NULL,
    [filter_clause]   NVARCHAR (MAX) NULL,
    [check_SQL]       NVARCHAR (MAX) NOT NULL,
    [expected_result] NVARCHAR (50)  NULL,
    PRIMARY KEY CLUSTERED ([dictionary_id] ASC)
);

