CREATE EXTERNAL TABLE [staging].[IntelliHR_training_providers] (
    [training_providers_id] NVARCHAR (36) NULL,
    [name] NVARCHAR (500) NULL,
    [isDefault] INT NULL,
    [isEnabled] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/training_providers/staging',
    FILE_FORMAT = [parquet]
    );

