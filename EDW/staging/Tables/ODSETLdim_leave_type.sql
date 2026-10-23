CREATE TABLE [staging].[ODSETLdim_leave_type] (
    [ODSdim_leave_typeID]     INT           IDENTITY (1, 1) NOT NULL,
    [leave_type_id]           NVARCHAR (50) NULL,
    [leave_type_name]         NVARCHAR (50) NULL,
    [leave_type_group]        NVARCHAR (50) NULL,
    [leave_type_company_name] NVARCHAR (50) NULL,
    CONSTRAINT [PK_Temp_Staging_ODSETLdim_leave_type] PRIMARY KEY NONCLUSTERED ([ODSdim_leave_typeID] ASC)
);

