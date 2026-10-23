CREATE EXTERNAL TABLE [RBEAL].[dlDimIncidentLikelihood] (
    [IncidentLikelihoodID] INT NULL,
    [IncidentLikelihoodValue] NVARCHAR (200) NULL,
    [IncidentLikelihoodText] NVARCHAR (200) NULL,
    [IncidentLikelihoodParentId] INT NULL,
    [IncidentLikelihoodIsActive] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimIncidentLikelihood/main',
    FILE_FORMAT = [parquet]
    );

