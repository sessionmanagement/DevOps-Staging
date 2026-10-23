CREATE EXTERNAL TABLE [landing].[RBEAL_dlDimUserType] (
    [UserTypeID] INT NULL,
    [UserTypeName] NVARCHAR (50) NULL,
    [UserTypeDescription] NVARCHAR (300) NULL,
    [UserTypeIsHidden] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimUserType/landing',
    FILE_FORMAT = [parquet]
    );

