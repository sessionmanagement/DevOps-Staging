CREATE EXTERNAL TABLE [landing].[RBMNB_dlDimLegalStatus] (
    [LegalStatusID] INT NULL,
    [LegalStatusValue] NVARCHAR (200) NULL,
    [LegalStatusText] NVARCHAR (200) NULL,
    [LegalStatusParentId] INT NULL,
    [LegalStatusIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimLegalStatus/landing',
    FILE_FORMAT = [parquet]
    );

