CREATE EXTERNAL TABLE [EmpliveAPI].[leave_codes] (
    [leave_code] NVARCHAR (50) NULL,
    [name] NVARCHAR (255) NULL,
    [ODSIsCurrent] INT NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1) NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpliveAPI/leave_codes/main',
    FILE_FORMAT = [parquet]
    );

