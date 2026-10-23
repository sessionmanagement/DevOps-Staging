CREATE TABLE [staging].[ODSETLdim_client_incident_severity] (
    [ODSdim_client_incident_severityID] INT            IDENTITY (1, 1) NOT NULL,
    [company_key_severity_id]           BIGINT         NULL,
    [company_key]                       INT            NOT NULL,
    [incident_severity_id]              INT            NULL,
    [incident_severity_value]           NVARCHAR (200) NULL,
    [incident_severity_text]            NVARCHAR (200) NULL,
    [is_incident_severity_active]       INT            NULL,
    CONSTRAINT [PK_Temp_Staging_ODSETLdim_client_incident_severity] PRIMARY KEY NONCLUSTERED ([ODSdim_client_incident_severityID] ASC)
);

