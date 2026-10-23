CREATE EXTERNAL TABLE [RBMNB].[dlFactDynamicFormInstance] (
    [DynamicFormInstanceID] INT NULL,
    [DynamicFormTemplateID] INT NULL,
    [DynamicFormInstanceEntityType] VARCHAR (50) NULL,
    [EntityID] INT NULL,
    [DynamicFormInstanceResponse] NVARCHAR (MAX) NULL,
    [DynamicFormInstanceCompletedDate] DATETIME NULL,
    [DynamicFormInstanceCreatedDate] DATETIME NULL,
    [DynamicFormInstanceCreatedUserID] INT NULL,
    [ReferralID] INT NULL,
    [DynamicFormInstanceSecuredAgainstReferral] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactDynamicFormInstance/main',
    FILE_FORMAT = [parquet]
    );

