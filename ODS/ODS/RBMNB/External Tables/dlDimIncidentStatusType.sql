CREATE EXTERNAL TABLE [RBMNB].[dlDimIncidentStatusType] (
    [IncidentStatusTypeID] INT NULL,
    [IncidentStatusTypeCode] NVARCHAR (30) NULL,
    [IncidentStatusTypeText] NVARCHAR (100) NULL,
    [IncidentStatusTypeDescription] NVARCHAR (500) NULL,
    [IncidentStatusTypeGroup] NVARCHAR (100) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimIncidentStatusType/main',
    FILE_FORMAT = [parquet]
    );

