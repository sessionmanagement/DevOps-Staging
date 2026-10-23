CREATE TABLE [meta_data].[source_system] (
    [source_system_id]     INT          IDENTITY (1, 1) NOT NULL,
    [source_system_name]   VARCHAR (40) NULL,
    [provider_name]        VARCHAR (40) NULL,
    [data_landing_type_id] INT          NULL,
    CONSTRAINT [PK_source_system] PRIMARY KEY CLUSTERED ([source_system_id] ASC)
);

