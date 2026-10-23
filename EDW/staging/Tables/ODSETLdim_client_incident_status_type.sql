CREATE TABLE [staging].[ODSETLdim_client_incident_status_type] (
    [ODSdim_client_incident_status_typeID] INT            IDENTITY (1, 1) NOT NULL,
    [company_key_status_type_id]           BIGINT         NULL,
    [company_key]                          INT            NOT NULL,
    [incident_status_type_id]              INT            NULL,
    [incident_status_type_code]            NVARCHAR (30)  NULL,
    [incident_status_type_text]            NVARCHAR (100) NULL,
    [incident_status_type_description]     NVARCHAR (500) NULL,
    [incident_status_type_group]           NVARCHAR (100) NULL,
    CONSTRAINT [PK_Temp_Staging_ODSETLdim_client_incident_status_type] PRIMARY KEY NONCLUSTERED ([ODSdim_client_incident_status_typeID] ASC)
);

