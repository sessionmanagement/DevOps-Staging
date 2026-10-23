CREATE EXTERNAL TABLE [landing].[RBEAL_dlDimPreferredContactMethod] (
    [PreferredContactMethodID] INT NULL,
    [PreferredContactMethodValue] NVARCHAR (200) NULL,
    [PreferredContactMethodText] NVARCHAR (200) NULL,
    [PreferredContactMethodParentId] INT NULL,
    [PreferredContactMethodIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimPreferredContactMethod/landing',
    FILE_FORMAT = [parquet]
    );

