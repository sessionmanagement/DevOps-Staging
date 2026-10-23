CREATE EXTERNAL TABLE [landing].[RBMNB_dlDimRelatedContactType] (
    [RelatedContactTypeID] INT NULL,
    [RelatedContactTypeValue] NVARCHAR (200) NULL,
    [RelatedContactTypeText] NVARCHAR (200) NULL,
    [RelatedContactTypeParentId] INT NULL,
    [RelatedContactTypeIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimRelatedContactType/landing',
    FILE_FORMAT = [parquet]
    );

