CREATE EXTERNAL TABLE [EmpLive].[roster_codes] (
    [id] NVARCHAR (36) NULL,
    [name] NVARCHAR (255) NULL,
    [code] NVARCHAR (255) NULL,
    [sent_code] NVARCHAR (255) NULL,
    [message] NVARCHAR (1000) NULL,
    [is_working] INT NULL,
    [ODSIsCurrent] INT,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1),
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpLive/roster_codes/main',
    FILE_FORMAT = [parquet]
    );

