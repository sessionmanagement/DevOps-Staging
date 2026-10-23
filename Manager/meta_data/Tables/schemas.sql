CREATE TABLE [meta_data].[schemas] (
    [schema_id]   INT          IDENTITY (1, 1) NOT NULL,
    [schema_name] VARCHAR (50) NULL,
    CONSTRAINT [PK_schemas] PRIMARY KEY CLUSTERED ([schema_id] ASC)
);

