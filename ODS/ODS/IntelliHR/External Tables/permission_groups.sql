CREATE EXTERNAL TABLE [IntelliHR].[permission_groups] (
    [permission_groups_id] NVARCHAR (36) NULL,
    [name] NVARCHAR (150) NULL,
    [isEnabled] INT NULL,
    [ODSIsCurrent] INT,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1),
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/permission_groups/main',
    FILE_FORMAT = [parquet]
    );

