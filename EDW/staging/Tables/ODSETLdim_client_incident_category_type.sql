CREATE TABLE [staging].[ODSETLdim_client_incident_category_type] (
    [ODSdim_client_incident_category_typeID] INT            IDENTITY (1, 1) NOT NULL,
    [company_key_category_type_id]           BIGINT         NULL,
    [company_key]                            INT            NOT NULL,
    [incident_category_type_id]              INT            NULL,
    [incident_category_type_text]            NVARCHAR (200) NULL,
    [incident_category_type_parent_Id]       INT            NULL,
    [incident_category_type_parent_text]     NVARCHAR (200) NULL,
    [is_incident_category_type_active]       INT            NULL,
    CONSTRAINT [PK_Temp_Staging_ODSETLdim_client_incident_category_type] PRIMARY KEY NONCLUSTERED ([ODSdim_client_incident_category_typeID] ASC)
);

