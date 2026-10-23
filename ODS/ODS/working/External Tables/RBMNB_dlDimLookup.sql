CREATE EXTERNAL TABLE [working].[RBMNB_dlDimLookup] (
    [LookupID] INT NULL,
    [LookupGroupID] INT NULL,
    [LookupValue] NVARCHAR (50) NULL,
    [LookupText] NVARCHAR (200) NULL,
    [LookupSortIndex] INT NULL,
    [LookupParentID] INT NULL,
    [HistoricalID] INT NULL,
    [LookupNotes] VARCHAR (MAX) NULL,
    [IconID] INT NULL,
    [LookupIsDefault] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimLookup/working',
    FILE_FORMAT = [parquet]
    );

