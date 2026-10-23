CREATE EXTERNAL TABLE [landing].[RBMNB_dlDimLookupGroup] (
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
    LOCATION = N'RBMNB/dlDimLookupGroup/landing',
    FILE_FORMAT = [parquet]
    );

