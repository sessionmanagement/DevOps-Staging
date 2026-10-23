CREATE EXTERNAL TABLE [RBEAL].[dlDimLookupGroup] (
    [LookupGroupID] INT NULL,
    [LookupGroupName] NVARCHAR (50) NULL,
    [LookupGroupKey] NVARCHAR (50) NULL,
    [LookupGroupDescription] NVARCHAR (MAX) NULL,
    [LookupGroupOldTable] NVARCHAR (50) NULL,
    [LookupGroupIconEnabled] INT NULL,
    [LookupGroupRequiresUniqueValues] INT NULL,
    [LookupGroupComments] NVARCHAR (MAX) NULL,
    [LookupGroupRestrictedToWildBamboo] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimLookupGroup/main',
    FILE_FORMAT = [parquet]
    );

