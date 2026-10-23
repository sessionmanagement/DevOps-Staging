CREATE EXTERNAL TABLE [RBEAL].[dlDimPreferredContactMethod] (
    [PreferredContactMethodID] INT NULL,
    [PreferredContactMethodValue] NVARCHAR (200) NULL,
    [PreferredContactMethodText] NVARCHAR (200) NULL,
    [PreferredContactMethodParentId] INT NULL,
    [PreferredContactMethodIsActive] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimPreferredContactMethod/main',
    FILE_FORMAT = [parquet]
    );

