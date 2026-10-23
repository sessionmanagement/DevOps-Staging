CREATE EXTERNAL TABLE [staging].[RBEAL_dlFactCustomFieldDataItem] (
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
    [CustomFieldDataItemDiscriminator] NVARCHAR (MAX) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactCustomFieldDataItem/staging',
    FILE_FORMAT = [parquet]
    );

