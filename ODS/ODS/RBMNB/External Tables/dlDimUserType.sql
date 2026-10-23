CREATE EXTERNAL TABLE [RBMNB].[dlDimUserType] (
    [UserTypeID] INT NULL,
    [UserTypeName] NVARCHAR (50) NULL,
    [UserTypeDescription] NVARCHAR (300) NULL,
    [UserTypeIsHidden] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimUserType/main',
    FILE_FORMAT = [parquet]
    );

