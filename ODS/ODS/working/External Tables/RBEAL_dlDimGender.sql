CREATE EXTERNAL TABLE [working].[RBEAL_dlDimGender] (
    [GenderID] INT NULL,
    [GenderValue] NVARCHAR (200) NULL,
    [GenderText] NVARCHAR (200) NULL,
    [GenderParentId] INT NULL,
    [GenderIsActive] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimGender/working',
    FILE_FORMAT = [parquet]
    );

