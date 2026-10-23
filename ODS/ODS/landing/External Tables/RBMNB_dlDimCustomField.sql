CREATE EXTERNAL TABLE [landing].[RBMNB_dlDimCustomField] (
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
    LOCATION = N'RBMNB/dlDimCustomField/landing',
    FILE_FORMAT = [parquet]
    );

