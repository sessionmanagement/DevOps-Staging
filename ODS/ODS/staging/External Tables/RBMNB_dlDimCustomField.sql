CREATE EXTERNAL TABLE [staging].[RBMNB_dlDimCustomField] (
    [CustomFieldId] INT NULL,
    [EntityTypeId] INT NULL,
    [CustomFieldDataType] NVARCHAR (MAX) NULL,
    [CustomFieldName] NVARCHAR (MAX) NULL,
    [CustomFieldDescription] NVARCHAR (MAX) NULL,
    [CustomFieldLength] INT NULL,
    [LookupGroupId] INT NULL,
    [CustomFieldValidator] NVARCHAR (MAX) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimCustomField/staging',
    FILE_FORMAT = [parquet]
    );

