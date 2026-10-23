CREATE EXTERNAL TABLE [working].[RBMNB_dlDimIncidentLikelihood] (
    [IncidentLikelihoodID] INT NULL,
    [IncidentLikelihoodValue] NVARCHAR (200) NULL,
    [IncidentLikelihoodText] NVARCHAR (200) NULL,
    [IncidentLikelihoodParentId] INT NULL,
    [IncidentLikelihoodIsActive] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimIncidentLikelihood/working',
    FILE_FORMAT = [parquet]
    );

