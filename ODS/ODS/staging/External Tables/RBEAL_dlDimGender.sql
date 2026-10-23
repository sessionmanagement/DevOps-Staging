CREATE EXTERNAL TABLE [staging].[RBEAL_dlDimGender] (
    [GenderID] INT NULL,
    [GenderValue] NVARCHAR (200) NULL,
    [GenderText] NVARCHAR (200) NULL,
    [GenderParentId] INT NULL,
    [GenderIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimGender/staging',
    FILE_FORMAT = [parquet]
    );

