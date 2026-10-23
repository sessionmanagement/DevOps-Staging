CREATE TABLE [meta_data].[data_definitions_history] (
    [data_definition_id]         INT            NOT NULL,
    [schema_name]                VARCHAR (128)  NOT NULL,
    [table_name]                 VARCHAR (128)  NOT NULL,
    [column_name]                VARCHAR (128)  NOT NULL,
    [data_definition_type]       VARCHAR (50)   NOT NULL,
    [data_definition]            NVARCHAR (MAX) NOT NULL,
    [is_active]                  BIT            NOT NULL,
    [last_modified_by]           VARCHAR (100)  NULL,
    [EffectiveFrom]              DATETIME2 (7)  NOT NULL,
    [EffectiveTo]                DATETIME2 (7)  NOT NULL,
    [PII_override]               TINYINT        NULL,
    [PII_override_justification] NVARCHAR (100) NULL
)
WITH (DATA_COMPRESSION = PAGE);




GO
CREATE CLUSTERED INDEX [ix_data_definitions_history]
    ON [meta_data].[data_definitions_history]([EffectiveTo] ASC, [EffectiveFrom] ASC) WITH (DATA_COMPRESSION = PAGE);

