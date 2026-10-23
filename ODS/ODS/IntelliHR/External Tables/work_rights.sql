CREATE EXTERNAL TABLE [IntelliHR].[work_rights] (
    [work_rights_id] NVARCHAR (36) NULL,
    [name] NVARCHAR (500) NULL,
    [countryId] NVARCHAR (36) NULL,
    [country] NVARCHAR (500) NULL,
    [ODSIsCurrent] INT,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1),
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/work_rights/main',
    FILE_FORMAT = [parquet]
    );

