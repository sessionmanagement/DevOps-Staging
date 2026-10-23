CREATE EXTERNAL TABLE [landing].[RBMNB_dlDimSubstanceType] (
    [SubstanceTypeID] INT NULL,
    [SubstanceTypeValue] NVARCHAR (200) NULL,
    [SubstanceTypeText] NVARCHAR (200) NULL,
    [SubstanceTypeParentId] INT NULL,
    [SubstanceTypeIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimSubstanceType/landing',
    FILE_FORMAT = [parquet]
    );

