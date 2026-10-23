CREATE EXTERNAL TABLE [RBEAL].[dlDimSubstanceType] (
    [SubstanceTypeID] INT NULL,
    [SubstanceTypeValue] NVARCHAR (200) NULL,
    [SubstanceTypeText] NVARCHAR (200) NULL,
    [SubstanceTypeParentId] INT NULL,
    [SubstanceTypeIsActive] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimSubstanceType/main',
    FILE_FORMAT = [parquet]
    );

