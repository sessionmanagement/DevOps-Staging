CREATE TABLE [load_check].[row_count] (
    [row_count_id]           INT    IDENTITY (1, 1) NOT NULL,
    [check_detail_id]        INT    NULL,
    [datalanding_load_count] BIGINT NULL,
    [source_load_count]      BIGINT NULL,
    [ods_load_count]         BIGINT NULL,
    [edw_load_count]         BIGINT NULL,
    [load_date]              DATE   NULL,
    CONSTRAINT [PK_row_count] PRIMARY KEY CLUSTERED ([row_count_id] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_row_count_load_date]
    ON [load_check].[row_count]([load_date] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_row_count_check_detail_id]
    ON [load_check].[row_count]([check_detail_id] ASC);

