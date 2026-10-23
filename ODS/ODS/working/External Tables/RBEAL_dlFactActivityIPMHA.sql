CREATE EXTERNAL TABLE [working].[RBEAL_dlFactActivityIPMHA] (
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactActivityIPMHA/working',
    FILE_FORMAT = [parquet]
    );
GO

