CREATE EXTERNAL TABLE [working].[IntelliHR_locations] (
    [locations_id] NVARCHAR (36) NULL,
    [parentId] NVARCHAR (36) NULL,
    [name] NVARCHAR (150) NULL,
    [address] NVARCHAR (100) NULL,
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
    LOCATION = N'IntelliHR/locations/working',
    FILE_FORMAT = [parquet]
    );

