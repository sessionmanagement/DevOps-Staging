CREATE EXTERNAL TABLE [landing].[RBMNB_dlDimIncidentLikelihood] (
    [IncidentLikelihoodID] INT NULL,
    [IncidentLikelihoodValue] NVARCHAR (200) NULL,
    [IncidentLikelihoodText] NVARCHAR (200) NULL,
    [IncidentLikelihoodParentId] INT NULL,
    [IncidentLikelihoodIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimIncidentLikelihood/landing',
    FILE_FORMAT = [parquet]
    );

