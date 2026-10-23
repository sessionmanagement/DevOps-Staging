CREATE EXTERNAL TABLE [working].[IntelliHR_permission_groups] (
    [permission_groups_id] NVARCHAR (36) NULL,
    [name] NVARCHAR (150) NULL,
    [isEnabled] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/permission_groups/working',
    FILE_FORMAT = [parquet]
    );

