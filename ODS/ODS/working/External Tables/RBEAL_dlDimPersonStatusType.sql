CREATE EXTERNAL TABLE [working].[RBEAL_dlDimPersonStatusType] (
    [PersonStatusTypeID] INT NULL,
    [PersonStatusTypeCode] NVARCHAR (20) NULL,
    [PersonStatusTypeText] NVARCHAR (50) NULL,
    [PersonStatusTypeDescription] VARCHAR (300) NULL,
    [PersonStatusTypeGroup] NVARCHAR (50) NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimPersonStatusType/working',
    FILE_FORMAT = [parquet]
    );

