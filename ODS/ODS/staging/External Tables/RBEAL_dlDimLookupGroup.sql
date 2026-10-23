CREATE EXTERNAL TABLE [staging].[RBEAL_dlDimLookupGroup] (
    [LookupGroupID] INT NULL,
    [LookupGroupName] NVARCHAR (50) NULL,
    [LookupGroupKey] NVARCHAR (50) NULL,
    [LookupGroupDescription] NVARCHAR (MAX) NULL,
    [LookupGroupOldTable] NVARCHAR (50) NULL,
    [LookupGroupIconEnabled] INT NULL,
    [LookupGroupRequiresUniqueValues] INT NULL,
    [LookupGroupComments] NVARCHAR (MAX) NULL,
    [LookupGroupRestrictedToWildBamboo] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimLookupGroup/staging',
    FILE_FORMAT = [parquet]
    );

