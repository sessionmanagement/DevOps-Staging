CREATE EXTERNAL TABLE [RBMNB].[dlFactPersonStatus] (
    [PersonStatusID] INT NULL,
    [PersonID] INT NULL,
    [PersonStatusTypeID] INT NULL,
    [PersonStatusStartDate] DATETIME NULL,
    [PersonStatusEndDate] DATETIME NULL,
    [PersonStatusDetail] VARCHAR (300) NULL,
    [PersonStatusCreatedUserID] INT NULL,
    [PersonStatusCreatedDate] DATETIME NULL,
    [PersonStatusAbsenceApprovedByFunder] INT NULL,
    [AbsenceReasonId] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactPersonStatus/main',
    FILE_FORMAT = [parquet]
    );

