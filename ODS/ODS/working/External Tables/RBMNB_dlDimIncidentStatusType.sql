CREATE EXTERNAL TABLE [working].[RBMNB_dlDimIncidentStatusType] (
    [IncidentStatusTypeID] INT NULL,
    [IncidentStatusTypeCode] NVARCHAR (30) NULL,
    [IncidentStatusTypeText] NVARCHAR (100) NULL,
    [IncidentStatusTypeDescription] NVARCHAR (500) NULL,
    [IncidentStatusTypeGroup] NVARCHAR (100) NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimIncidentStatusType/working',
    FILE_FORMAT = [parquet]
    );

