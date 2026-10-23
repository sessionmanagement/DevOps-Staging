CREATE EXTERNAL TABLE [landing].[IntelliHR_position_titles] (
    [position_title_id] VARCHAR (36) NULL,
    [name] VARCHAR (250) NULL,
    [isenabled] INT NULL,
    [code] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/position_titles/landing',
    FILE_FORMAT = [parquet]
    );

