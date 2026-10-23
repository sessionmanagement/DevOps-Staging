CREATE EXTERNAL TABLE [working].[IntelliHR_extended_leave_type] (
    [extended_leave_type_id] NVARCHAR (36) NULL,
    [name] NVARCHAR (500) NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/extended_leave_type/working',
    FILE_FORMAT = [parquet]
    );

