CREATE EXTERNAL TABLE [staging].[RBMNB_dlDimGender] (
    [GenderID] INT NULL,
    [GenderValue] NVARCHAR (200) NULL,
    [GenderText] NVARCHAR (200) NULL,
    [GenderParentId] INT NULL,
    [GenderIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimGender/staging',
    FILE_FORMAT = [parquet]
    );

