CREATE EXTERNAL TABLE [BusinessCentral].[accountingPeriods] (
    [systemId] NVARCHAR (MAX) NULL,
    [averageCostCalcType] NVARCHAR (MAX) NULL,
    [averageCostPeriod] NVARCHAR (MAX) NULL,
    [closed] BIT NULL,
    [dateLocked] BIT NULL,
    [name] NVARCHAR (MAX) NULL,
    [newFiscalYear] BIT NULL,
    [startingDate] DATETIME2 (7) NULL,
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
    LOCATION = N'BusinessCentral/accountingPeriods/main',
    FILE_FORMAT = [delta]
    );

