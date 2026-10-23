CREATE EXTERNAL TABLE [working].[EmpliveAPI_leave_types] (
    [leave_type_id] NVARCHAR (36) NULL,
    [abbreviation] NVARCHAR (255) NULL,
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
    LOCATION = N'EmpliveAPI/leave_types/working',
    FILE_FORMAT = [parquet]
    );

