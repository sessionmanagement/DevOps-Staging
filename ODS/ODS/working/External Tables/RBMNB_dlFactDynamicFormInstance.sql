CREATE EXTERNAL TABLE [working].[RBMNB_dlFactDynamicFormInstance] (
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
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactDynamicFormInstance/working',
    FILE_FORMAT = [parquet]
    );

