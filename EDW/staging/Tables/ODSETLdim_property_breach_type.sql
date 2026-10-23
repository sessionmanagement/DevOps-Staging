CREATE TABLE [staging].[ODSETLdim_property_breach_type] (
    [ODSdim_property_breach_typeID] INT           IDENTITY (1, 1) NOT NULL,
    [breach_type_id]                INT           NULL,
    [breach_type]                   NVARCHAR (80) NULL,
    CONSTRAINT [PK_Temp_Staging_ODSETLdim_property_breach_type] PRIMARY KEY NONCLUSTERED ([ODSdim_property_breach_typeID] ASC)
);

