CREATE EXTERNAL TABLE [landing].[IntelliHR_training_providers] (
    [training_providers_id] NVARCHAR (36) NULL,
    [name] NVARCHAR (500) NULL,
    [isDefault] INT NULL,
    [isEnabled] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/training_providers/landing',
    FILE_FORMAT = [parquet]
    );

