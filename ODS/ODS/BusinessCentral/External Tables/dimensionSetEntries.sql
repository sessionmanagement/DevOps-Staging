CREATE EXTERNAL TABLE [BusinessCentral].[dimensionSetEntries] (
    [systemId] NVARCHAR (MAX) NULL,
    [dimensionCode] NVARCHAR (MAX) NULL,
    [dimensionName] NVARCHAR (MAX) NULL,
    [dimensionSetID] BIGINT NULL,
    [dimensionValueCode] NVARCHAR (MAX) NULL,
    [dimensionValueID] BIGINT NULL,
    [dimensionValueName] NVARCHAR (MAX) NULL,
    [globalDimensionNo] BIGINT NULL,
    [systemCreatedAt] DATETIME2 (7) NULL,
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
    LOCATION = N'BusinessCentral/dimensionSetEntries/main',
    FILE_FORMAT = [delta]
    );

