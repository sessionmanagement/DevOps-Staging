CREATE TABLE [meta_data].[duplicate_check] (
    [duplicate_check_id] INT           IDENTITY (1, 1) NOT NULL,
    [schema_name]        NVARCHAR (30) NULL,
    [table_name]         NVARCHAR (80) NULL,
    [business_id]        INT           NULL,
    [company_id]         INT           NULL,
    [duplicate_count]    INT           NULL,
    [check_date]         DATETIME      NULL,
    CONSTRAINT [PK_duplicate_check] PRIMARY KEY CLUSTERED ([duplicate_check_id] ASC)
);

