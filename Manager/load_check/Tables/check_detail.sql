CREATE TABLE [load_check].[check_detail] (
    [check_detail_id]                         INT             IDENTITY (1, 1) NOT NULL,
    [source_system_id]                        INT             NULL,
    [table_name]                              NVARCHAR (100)  NULL,
    [datalanding_load_query]                  NVARCHAR (2000) NULL,
    [datalanding_load_dataset]                NVARCHAR (30)   NULL,
    [datalanding_load_database]               NVARCHAR (70)   NULL,
    [source_load_query]                       NVARCHAR (2000) NULL,
    [source_load_dataset]                     NVARCHAR (30)   NULL,
    [source_load_database]                    NVARCHAR (70)   NULL,
    [ods_load_query]                          NVARCHAR (2000) NULL,
    [edw_load_query]                          NVARCHAR (2000) NULL,
    [IsActive]                                BIT             NULL,
    [source_ods_acceptable_difference]        INT             NULL,
    [ods_edw_acceptable_difference]           INT             NULL,
    [source_ods_acceptable_difference_reason] NVARCHAR (100)  NULL,
    [ods_edw_acceptable_difference_reason]    NVARCHAR (100)  NULL,
    [data_load_id]                            INT             NULL,
    CONSTRAINT [PK_check_detail] PRIMARY KEY CLUSTERED ([check_detail_id] ASC),
    CONSTRAINT [FK_check_detail_source_system] FOREIGN KEY ([source_system_id]) REFERENCES [meta_data].[source_system] ([source_system_id]),
    CONSTRAINT [IX_check_detail_table_name] UNIQUE NONCLUSTERED ([table_name] ASC)
);








GO
CREATE NONCLUSTERED INDEX [IX_check_detail_source_system_id]
    ON [load_check].[check_detail]([source_system_id] ASC);

