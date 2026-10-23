CREATE EXTERNAL TABLE [working].[IntelliHR_work_rights] (
    [work_rights_id] NVARCHAR (36) NULL,
    [name] NVARCHAR (500) NULL,
    [countryId] NVARCHAR (36) NULL,
    [country] NVARCHAR (500) NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/work_rights/working',
    FILE_FORMAT = [parquet]
    );

