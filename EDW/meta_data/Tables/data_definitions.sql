CREATE TABLE [meta_data].[data_definitions] (
    [data_definition_id]         INT                                         IDENTITY (1, 1) NOT NULL,
    [schema_name]                VARCHAR (128)                               NOT NULL,
    [table_name]                 VARCHAR (128)                               NOT NULL,
    [column_name]                VARCHAR (128)                               NOT NULL,
    [data_definition_type]       VARCHAR (50)                                NOT NULL,
    [data_definition]            NVARCHAR (MAX)                              NOT NULL,
    [is_active]                  BIT                                         DEFAULT ((1)) NOT NULL,
    [last_modified_by]           VARCHAR (100)                               NULL,
    [EffectiveFrom]              DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [EffectiveTo]                DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    [PII_override]               TINYINT                                     DEFAULT ((0)) NULL,
    [PII_override_justification] NVARCHAR (100)                              NULL,
    CONSTRAINT [PK_meta_data_data_definitions] PRIMARY KEY CLUSTERED ([data_definition_id] ASC),
    PERIOD FOR SYSTEM_TIME ([EffectiveFrom], [EffectiveTo])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[meta_data].[data_definitions_history], DATA_CONSISTENCY_CHECK=ON));




GO
CREATE NONCLUSTERED INDEX [IX_data_definitions_active]
    ON [meta_data].[data_definitions]([is_active] ASC)
    INCLUDE([schema_name], [table_name], [column_name], [data_definition_type]);


GO
CREATE NONCLUSTERED INDEX [IX_data_definitions_type]
    ON [meta_data].[data_definitions]([data_definition_type] ASC) WHERE ([is_active]=(1));


GO
CREATE NONCLUSTERED INDEX [IX_data_definitions_schema_table_column]
    ON [meta_data].[data_definitions]([schema_name] ASC, [table_name] ASC, [column_name] ASC)
    INCLUDE([data_definition_type], [data_definition], [is_active]);

