CREATE EXTERNAL TABLE [RBMNB].[dlDimCompany] (
    [CompanyID] INT NULL,
    [CompanyCompanyName] NVARCHAR (200) NULL,
    [CompanyDescription] NVARCHAR (MAX) NULL,
    [CompanyUDF1] NVARCHAR (MAX) NULL,
    [CompanyUDF2] NVARCHAR (MAX) NULL,
    [CompanyUDF3] NVARCHAR (MAX) NULL,
    [CompanyUDF4] NVARCHAR (MAX) NULL,
    [CompanyUDF5] NVARCHAR (MAX) NULL,
    [CompanyDisabledDate] DATETIME NULL,
    [DisabledUserID] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimCompany/main',
    FILE_FORMAT = [parquet]
    );

