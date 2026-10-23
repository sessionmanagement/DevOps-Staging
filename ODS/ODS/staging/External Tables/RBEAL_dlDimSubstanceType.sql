CREATE EXTERNAL TABLE [staging].[RBEAL_dlDimSubstanceType] (
    [SubstanceTypeID] INT NULL,
    [SubstanceTypeValue] NVARCHAR (200) NULL,
    [SubstanceTypeText] NVARCHAR (200) NULL,
    [SubstanceTypeParentId] INT NULL,
    [SubstanceTypeIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimSubstanceType/staging',
    FILE_FORMAT = [parquet]
    );

