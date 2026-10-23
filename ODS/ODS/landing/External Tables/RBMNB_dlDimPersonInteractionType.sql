CREATE EXTERNAL TABLE [landing].[RBMNB_dlDimPersonInteractionType] (
    [PersonInteractionTypeId] INT NULL,
    [PersonInteractionTypeCode] NVARCHAR (MAX) NULL,
    [PersonInteractionTypeName] NVARCHAR (MAX) NULL,
    [PersonInteractionTypeParentId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimPersonInteractionType/landing',
    FILE_FORMAT = [parquet]
    );
