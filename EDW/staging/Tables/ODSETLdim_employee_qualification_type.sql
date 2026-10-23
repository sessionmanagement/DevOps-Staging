CREATE TABLE [staging].[ODSETLdim_employee_qualification_type] (
    [ODSdim_employee_qualification_typeID] INT            IDENTITY (1, 1) NOT NULL,
    [employee_qualification_type_id]       NVARCHAR (36)  NULL,
    [employee_qualification_type]          NVARCHAR (200) NULL,
    CONSTRAINT [PK_Temp_Staging_ODSETLdim_employee_qualification_type] PRIMARY KEY NONCLUSTERED ([ODSdim_employee_qualification_typeID] ASC)
);

