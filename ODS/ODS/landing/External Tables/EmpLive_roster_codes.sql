CREATE EXTERNAL TABLE [landing].[EmpLive_roster_codes] (
    [id] NVARCHAR (36) NULL,
    [name] NVARCHAR (255) NULL,
    [code] NVARCHAR (255) NULL,
    [sent_code] NVARCHAR (255) NULL,
    [message] NVARCHAR (1000) NULL,
    [is_working] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpLive/roster_codes/landing',
    FILE_FORMAT = [parquet]
    );

