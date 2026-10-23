CREATE EXTERNAL TABLE [landing].[RBMNB_dlDimUserType] (
    [UserTypeID] INT NULL,
    [UserTypeName] NVARCHAR (50) NULL,
    [UserTypeDescription] NVARCHAR (300) NULL,
    [UserTypeIsHidden] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimUserType/landing',
    FILE_FORMAT = [parquet]
    );

