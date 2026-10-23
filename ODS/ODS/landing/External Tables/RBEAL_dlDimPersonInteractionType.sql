CREATE EXTERNAL TABLE [landing].[RBEAL_dlDimPersonInteractionType] (
    [PersonInteractionTypeId] INT NULL,
    [PersonInteractionTypeCode] NVARCHAR (MAX) NULL,
    [PersonInteractionTypeName] NVARCHAR (MAX) NULL,
    [PersonInteractionTypeParentId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimPersonInteractionType/landing',
    FILE_FORMAT = [parquet]
    );
