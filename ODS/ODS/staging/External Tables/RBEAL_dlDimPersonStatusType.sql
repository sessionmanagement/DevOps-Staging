CREATE EXTERNAL TABLE [staging].[RBEAL_dlDimPersonStatusType] (
    [PersonStatusTypeID] INT NULL,
    [PersonStatusTypeCode] NVARCHAR (20) NULL,
    [PersonStatusTypeText] NVARCHAR (50) NULL,
    [PersonStatusTypeDescription] VARCHAR (300) NULL,
    [PersonStatusTypeGroup] NVARCHAR (50) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimPersonStatusType/staging',
    FILE_FORMAT = [parquet]
    );

