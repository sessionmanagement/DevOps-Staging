CREATE EXTERNAL TABLE [staging].[RBEAL_dlDimIncidentStatusType] (
    [IncidentStatusTypeID] INT NULL,
    [IncidentStatusTypeCode] NVARCHAR (30) NULL,
    [IncidentStatusTypeText] NVARCHAR (100) NULL,
    [IncidentStatusTypeDescription] NVARCHAR (500) NULL,
    [IncidentStatusTypeGroup] NVARCHAR (100) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimIncidentStatusType/staging',
    FILE_FORMAT = [parquet]
    );

