CREATE EXTERNAL TABLE [working].[RBEAL_dlDimLookupGroup] (
    [LookupGroupID] INT NULL,
    [LookupGroupName] NVARCHAR (50) NULL,
    [LookupGroupKey] NVARCHAR (50) NULL,
    [LookupGroupDescription] NVARCHAR (MAX) NULL,
    [LookupGroupOldTable] NVARCHAR (50) NULL,
    [LookupGroupIconEnabled] INT NULL,
    [LookupGroupRequiresUniqueValues] INT NULL,
    [LookupGroupComments] NVARCHAR (MAX) NULL,
    [LookupGroupRestrictedToWildBamboo] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimLookupGroup/working',
    FILE_FORMAT = [parquet]
    );

