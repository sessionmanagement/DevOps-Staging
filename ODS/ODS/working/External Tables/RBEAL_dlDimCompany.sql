CREATE EXTERNAL TABLE [working].[RBEAL_dlDimCompany] (
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
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimCompany/working',
    FILE_FORMAT = [parquet]
    );

