CREATE TABLE [dq].[dq_results] (
    [results_id]     INT             IDENTITY (1, 1) NOT NULL,
    [check_id]       INT             NULL,
    [table_name]     NVARCHAR (200)  NOT NULL,
    [column_name]    NVARCHAR (200)  NULL,
    [check_name]     NVARCHAR (200)  NOT NULL,
    [status_message] NVARCHAR (4000) NOT NULL,
    [record_count]   INT             NOT NULL,
    [run_date_time]  DATETIME        DEFAULT (((getutcdate() AT TIME ZONE 'UTC') AT TIME ZONE 'New Zealand Standard Time')) NOT NULL,
    PRIMARY KEY CLUSTERED ([results_id] ASC)
);

