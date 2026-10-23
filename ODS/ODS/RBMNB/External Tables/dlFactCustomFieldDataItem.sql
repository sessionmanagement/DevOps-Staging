CREATE EXTERNAL TABLE [RBMNB].[dlFactCustomFieldDataItem] (
    [CustomFieldDataItemId] INT NULL,
    [EntityId] INT NULL,
    [CustomFieldId] INT NULL,
    [CustomFieldDataItemInteger] INT NULL,
    [CustomFieldDataItemBoolean] INT NULL,
    [CustomFieldDataItemDecimal] DECIMAL (18) NULL,
    [CustomFieldDataItemString] NVARCHAR (MAX) NULL,
    [LookupId] INT NULL,
    [CustomFieldDataItemDateTime] DATETIME NULL,
    [CustomFieldDataItemDateTimeFrom] DATETIME NULL,
    [CustomFieldDataItemDateTimeTo] DATETIME NULL,
    [CustomFieldDataItemDiscriminator] NVARCHAR (MAX) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactCustomFieldDataItem/main',
    FILE_FORMAT = [parquet]
    );

