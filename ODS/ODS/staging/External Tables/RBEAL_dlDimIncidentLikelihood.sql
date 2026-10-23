CREATE EXTERNAL TABLE [staging].[RBEAL_dlDimIncidentLikelihood] (
    [IncidentLikelihoodID] INT NULL,
    [IncidentLikelihoodValue] NVARCHAR (200) NULL,
    [IncidentLikelihoodText] NVARCHAR (200) NULL,
    [IncidentLikelihoodParentId] INT NULL,
    [IncidentLikelihoodIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimIncidentLikelihood/staging',
    FILE_FORMAT = [parquet]
    );

