CREATE EXTERNAL TABLE [staging].[RBEAL_dlDimPersonInteractionType] (
    [PersonInteractionTypeId] INT NULL,
    [PersonInteractionTypeCode] NVARCHAR (MAX) NULL,
    [PersonInteractionTypeName] NVARCHAR (MAX) NULL,
    [PersonInteractionTypeParentId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimPersonInteractionType/staging',
    FILE_FORMAT = [parquet]
    );
