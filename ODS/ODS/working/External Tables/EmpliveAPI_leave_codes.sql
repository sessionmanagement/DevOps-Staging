CREATE EXTERNAL TABLE [working].[EmpliveAPI_leave_codes] (
    [leave_code] NVARCHAR (50) NULL,
    [name] NVARCHAR (255) NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpliveAPI/leave_codes/working',
    FILE_FORMAT = [parquet]
    );

