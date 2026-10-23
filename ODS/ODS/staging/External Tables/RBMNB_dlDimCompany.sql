CREATE EXTERNAL TABLE [staging].[RBMNB_dlDimCompany] (
    [CompanyID] INT NULL,
    [CompanyCompanyName] NVARCHAR (200) NULL,
    [CompanyDescription] NVARCHAR (MAX) NULL,
    [CompanyUDF1] NVARCHAR (MAX) NULL,
    [CompanyUDF2] NVARCHAR (MAX) NULL,
    [CompanyUDF3] NVARCHAR (MAX) NULL,
    [CompanyUDF4] NVARCHAR (MAX) NULL,
    [CompanyUDF5] NVARCHAR (MAX) NULL,
    [CompanyDisabledDate] DATETIME NULL,
    [DisabledUserID] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimCompany/staging',
    FILE_FORMAT = [parquet]
    );

