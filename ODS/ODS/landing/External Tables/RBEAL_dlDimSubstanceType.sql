CREATE EXTERNAL TABLE [landing].[RBEAL_dlDimSubstanceType] (
    [SubstanceTypeID] INT NULL,
    [SubstanceTypeValue] NVARCHAR (200) NULL,
    [SubstanceTypeText] NVARCHAR (200) NULL,
    [SubstanceTypeParentId] INT NULL,
    [SubstanceTypeIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimSubstanceType/landing',
    FILE_FORMAT = [parquet]
    );

