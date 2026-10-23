CREATE EXTERNAL TABLE [EmpliveAPI].[leave_types] (
    [leave_type_id] NVARCHAR (36) NULL,
    [abbreviation] NVARCHAR (255) NULL,
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
    LOCATION = N'EmpliveAPI/leave_types/main',
    FILE_FORMAT = [parquet]
    );

