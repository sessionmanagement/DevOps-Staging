CREATE EXTERNAL TABLE [staging].[RBEAL_dlFactDynamicFormInstance] (
    [DynamicFormInstanceID] INT NULL,
    [DynamicFormTemplateID] INT NULL,
    [DynamicFormInstanceEntityType] VARCHAR (50) NULL,
    [EntityID] INT NULL,
    [DynamicFormInstanceResponse] NVARCHAR (MAX) NULL,
    [DynamicFormInstanceCompletedDate] DATETIME NULL,
    [DynamicFormInstanceCreatedDate] DATETIME NULL,
    [DynamicFormInstanceCreatedUserID] INT NULL,
    [ReferralID] INT NULL,
    [DynamicFormInstanceSecuredAgainstReferral] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactDynamicFormInstance/staging',
    FILE_FORMAT = [parquet]
    );

