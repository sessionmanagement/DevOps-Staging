CREATE TABLE [staging].[ODSETLdim_client_interaction_type] (
    [ODSdim_client_interaction_typeID]    INT            IDENTITY (1, 1) NOT NULL,
    [company_key]                         INT            NOT NULL,
    [client_interaction_type_id]          INT            NULL,
    [client_interaction_type_code]        NVARCHAR (20) NULL,
    [client_interaction_type_name]        NVARCHAR (50) NULL,
    [client_parent_interaction_type_code] NVARCHAR (20) NULL,
    [client_parent_interaction_type_name] NVARCHAR (20) NULL
);
GO

ALTER TABLE [staging].[ODSETLdim_client_interaction_type]
    ADD CONSTRAINT [PK_Temp_Staging_ODSETLdim_client_interaction_type] PRIMARY KEY NONCLUSTERED ([ODSdim_client_interaction_typeID] ASC);
GO

