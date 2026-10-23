CREATE EXTERNAL TABLE [landing].[RBEAL_dlDimIncidentLikelihood] (
    [IncidentLikelihoodID] INT NULL,
    [IncidentLikelihoodValue] NVARCHAR (200) NULL,
    [IncidentLikelihoodText] NVARCHAR (200) NULL,
    [IncidentLikelihoodParentId] INT NULL,
    [IncidentLikelihoodIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimIncidentLikelihood/landing',
    FILE_FORMAT = [parquet]
    );

