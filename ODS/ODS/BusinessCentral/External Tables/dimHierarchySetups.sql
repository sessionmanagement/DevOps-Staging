CREATE EXTERNAL TABLE [BusinessCentral].[dimHierarchySetups] (
    [systemId] NVARCHAR (MAX) NULL,
    [childDimensionCode] NVARCHAR (MAX) NULL,
    [childDimensionName] NVARCHAR (MAX) NULL,
    [childDimensionValueCode] NVARCHAR (MAX) NULL,
    [childDimensionValueName] NVARCHAR (MAX) NULL,
    [parentDimensionCode] NVARCHAR (MAX) NULL,
    [parentDimensionName] NVARCHAR (MAX) NULL,
    [parentDimensionValueCode] NVARCHAR (MAX) NULL,
    [parentDimensionValueName] NVARCHAR (MAX) NULL,
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
    LOCATION = N'BusinessCentral/dimHierarchySetups/main',
    FILE_FORMAT = [delta]
    );

