CREATE EXTERNAL TABLE [BusinessCentral].[dimensionHierarchies] (
    [systemId] NVARCHAR (MAX) NULL,
    [dimensionSetID] BIGINT NULL,
    [level1DimensionCode] NVARCHAR (MAX) NULL,
    [level1DimensionName] NVARCHAR (MAX) NULL,
    [level1DimensionValueCode] NVARCHAR (MAX) NULL,
    [level1DimensionValueName] NVARCHAR (MAX) NULL,
    [level2DimensionCode] NVARCHAR (MAX) NULL,
    [level2DimensionName] NVARCHAR (MAX) NULL,
    [level2DimensionValueCode] NVARCHAR (MAX) NULL,
    [level2DimensionValueName] NVARCHAR (MAX) NULL,
    [systemCreatedAt] NVARCHAR (MAX) NULL,
    [systemCreatedBy] NVARCHAR (MAX) NULL,
    [systemModifiedAt] DATETIME2 (7) NULL,
    [systemModifiedBy] NVARCHAR (MAX) NULL,
    [Company_Name] NVARCHAR (100) NULL,
    [Company_Id] NVARCHAR (100) NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'BusinessCentral/dimensionHierarchies/main',
    FILE_FORMAT = [delta]
    );



