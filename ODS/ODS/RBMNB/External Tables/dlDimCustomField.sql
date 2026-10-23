CREATE EXTERNAL TABLE [RBMNB].[dlDimCustomField] (
    [CustomFieldId] INT NULL,
    [EntityTypeId] INT NULL,
    [CustomFieldDataType] NVARCHAR (MAX) NULL,
    [CustomFieldName] NVARCHAR (MAX) NULL,
    [CustomFieldDescription] NVARCHAR (MAX) NULL,
    [CustomFieldLength] INT NULL,
    [LookupGroupId] INT NULL,
    [CustomFieldValidator] NVARCHAR (MAX) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimCustomField/main',
    FILE_FORMAT = [parquet]
    );

