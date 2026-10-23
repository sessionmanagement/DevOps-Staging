CREATE EXTERNAL TABLE [working].[RBEAL_dlDimCustomField] (
    [CustomFieldId] INT NULL,
    [EntityTypeId] INT NULL,
    [CustomFieldDataType] NVARCHAR (MAX) NULL,
    [CustomFieldName] NVARCHAR (MAX) NULL,
    [CustomFieldDescription] NVARCHAR (MAX) NULL,
    [CustomFieldLength] INT NULL,
    [LookupGroupId] INT NULL,
    [CustomFieldValidator] NVARCHAR (MAX) NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimCustomField/working',
    FILE_FORMAT = [parquet]
    );

