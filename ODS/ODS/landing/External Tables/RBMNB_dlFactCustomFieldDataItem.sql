CREATE EXTERNAL TABLE [landing].[RBMNB_dlFactCustomFieldDataItem] (
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
    LOCATION = N'RBMNB/dlFactCustomFieldDataItem/landing',
    FILE_FORMAT = [parquet]
    );

