CREATE EXTERNAL TABLE [staging].[RBEAL_dlFactPersonStatus] (
    [PersonStatusID] INT NULL,
    [PersonID] INT NULL,
    [PersonStatusTypeID] INT NULL,
    [PersonStatusStartDate] DATETIME NULL,
    [PersonStatusEndDate] DATETIME NULL,
    [PersonStatusDetail] VARCHAR (300) NULL,
    [PersonStatusCreatedUserID] INT NULL,
    [PersonStatusCreatedDate] DATETIME NULL,
    [PersonStatusAbsenceApprovedByFunder] INT NULL,
    [AbsenceReasonId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactPersonStatus/staging',
    FILE_FORMAT = [parquet]
    );

