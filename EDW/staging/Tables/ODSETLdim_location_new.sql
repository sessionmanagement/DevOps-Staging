CREATE TABLE [staging].[ODSETLdim_location_new] (
    [ODSdim_locationID]              INT             IDENTITY (1, 1) NOT NULL,
    [dim_location_code_company_key]  NVARCHAR (4000) NULL,
    [dim_company_key]                INT             NOT NULL,
    [intelliHR_location_id]          NVARCHAR (36)   NULL,
    [business_central_location_id]   NVARCHAR (MAX)  NULL,
    [location_code]                  NVARCHAR (4000) NULL,
    [intelliHR_location_name]        NVARCHAR (150)  NULL,
    [business_central_location_name] NVARCHAR (MAX)  NULL,
    [parent_location_id]             NVARCHAR (36)   NULL,
    [parent_location_code]           NVARCHAR (100)  NULL,
    [parent_location_name]           NVARCHAR (150)  NULL,
    [last_modified_datetime]         DATETIME2 (7)   NULL,
    [exists_in_intelliHR]            INT             NULL,
    [exists_in_business_central]     INT             NULL,
    [company_name]                   NVARCHAR (4000) NULL,
    CONSTRAINT [PK_Temp_Staging_ODSETLdim_location] PRIMARY KEY NONCLUSTERED ([ODSdim_locationID] ASC)
);

