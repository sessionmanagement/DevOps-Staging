CREATE EXTERNAL TABLE [working].[EmpLive_roster_codes] (
    [id] NVARCHAR (36) NULL,
    [name] NVARCHAR (255) NULL,
    [code] NVARCHAR (255) NULL,
    [sent_code] NVARCHAR (255) NULL,
    [message] NVARCHAR (1000) NULL,
    [is_working] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpLive/roster_codes/working',
    FILE_FORMAT = [parquet]
    );

