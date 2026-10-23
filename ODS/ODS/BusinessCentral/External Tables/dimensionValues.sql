CREATE EXTERNAL TABLE [BusinessCentral].[dimensionValues] (
    [systemId] NVARCHAR (MAX) NULL,
    [blocked] BIT NULL,
    [code] NVARCHAR (MAX) NULL,
    [consolidationCode] NVARCHAR (MAX) NULL,
    [dimensionCode] NVARCHAR (MAX) NULL,
    [dimensionId] NVARCHAR (MAX) NULL,
    [dimensionValueID] NVARCHAR (MAX) NULL,
    [dimensionValueType] NVARCHAR (MAX) NULL,
    [globalDimensionNo] NVARCHAR (MAX) NULL,
    [indentation] NVARCHAR (MAX) NULL,
    [lastModifiedDateTime] DATETIME2 (7) NULL,
    [mapToICDimensionCode] NVARCHAR (MAX) NULL,
    [mapToICDimensionValueCode] NVARCHAR (MAX) NULL,
    [name] NVARCHAR (MAX) NULL,
    [systemCreatedAt] NVARCHAR (MAX) NULL,
    [systemCreatedBy] NVARCHAR (MAX) NULL,
    [systemModifiedAt] DATETIME2 (7) NULL,
    [systemModifiedBy] NVARCHAR (MAX) NULL,
    [totaling] NVARCHAR (MAX) NULL,
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
    LOCATION = N'BusinessCentral/dimensionValues/main',
    FILE_FORMAT = [delta]
    );



