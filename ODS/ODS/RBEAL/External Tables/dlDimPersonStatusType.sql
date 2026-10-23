CREATE EXTERNAL TABLE [RBEAL].[dlDimPersonStatusType] (
    [PersonStatusTypeID] INT NULL,
    [PersonStatusTypeCode] NVARCHAR (20) NULL,
    [PersonStatusTypeText] NVARCHAR (50) NULL,
    [PersonStatusTypeDescription] VARCHAR (300) NULL,
    [PersonStatusTypeGroup] NVARCHAR (50) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimPersonStatusType/main',
    FILE_FORMAT = [parquet]
    );

