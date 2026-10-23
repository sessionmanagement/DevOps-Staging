CREATE TABLE [data_monitoring].[client_obfuscation_field] (
    [client_obfuscation_field_id] BIGINT         IDENTITY (1, 1) NOT NULL,
    [table_name]                  NVARCHAR (50)  NOT NULL,
    [column_name]                 NVARCHAR (100) NOT NULL,
    [column_type]                 INT            NOT NULL
);

