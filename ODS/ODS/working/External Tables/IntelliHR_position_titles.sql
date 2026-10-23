CREATE EXTERNAL TABLE [working].[IntelliHR_position_titles] (
    [position_title_id] VARCHAR (36) NULL,
    [name] VARCHAR (250) NULL,
    [isenabled] INT NULL,
    [code] NVARCHAR (500) NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/position_titles/working',
    FILE_FORMAT = [parquet]
    );

