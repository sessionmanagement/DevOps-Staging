CREATE EXTERNAL TABLE [working].[RBEAL_dlFactCustomFieldDataItem] (
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
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactCustomFieldDataItem/working',
    FILE_FORMAT = [parquet]
    );

