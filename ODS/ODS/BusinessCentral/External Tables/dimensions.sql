CREATE EXTERNAL TABLE [BusinessCentral].[dimensions] (
    [systemId] NVARCHAR (MAX) NULL,
    [blocked] BIT NULL,
    [code] NVARCHAR (MAX) NULL,
    [codeCaption] NVARCHAR (MAX) NULL,
    [consolidationCode] NVARCHAR (MAX) NULL,
    [description] NVARCHAR (MAX) NULL,
    [filterCaption] NVARCHAR (MAX) NULL,
    [lastModifiedDateTime] DATETIME2 (7) NULL,
    [mapToICDimensionCode] NVARCHAR (MAX) NULL,
    [name] NVARCHAR (MAX) NULL,
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
    LOCATION = N'BusinessCentral/dimensions/main',
    FILE_FORMAT = [delta]
    );

