CREATE EXTERNAL TABLE [BusinessCentral].[defaultDimensions] (
    [systemId] NVARCHAR (MAX) NULL,
    [allowedValuesFilter] NVARCHAR (MAX) NULL,
    [dimensionCode] NVARCHAR (MAX) NULL,
    [dimensionValueCode] NVARCHAR (MAX) NULL,
    [dimensionId] NVARCHAR (MAX) NULL,
    [dimensionValueId] NVARCHAR (MAX) NULL,
    [multiSelectionAction] NVARCHAR (MAX) NULL,
    [no] NVARCHAR (MAX) NULL,
    [parentType] NVARCHAR (MAX) NULL,
    [parentId] NVARCHAR (MAX) NULL,
    [systemCreatedAt] DATETIME2 (7) NULL,
    [systemCreatedBy] NVARCHAR (MAX) NULL,
    [systemModifiedAt] DATETIME2 (7) NULL,
    [systemModifiedBy] NVARCHAR (MAX) NULL,
    [tableCaption] NVARCHAR (MAX) NULL,
    [tableID] BIGINT NULL,
    [valuePosting] NVARCHAR (MAX) NULL,
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
    LOCATION = N'BusinessCentral/defaultDimensions/main',
    FILE_FORMAT = [delta]
    );

