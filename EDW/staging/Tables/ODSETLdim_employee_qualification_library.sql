CREATE TABLE [staging].[ODSETLdim_employee_qualification_library] (
    [ODSdim_employee_qualification_libraryID] INT            IDENTITY (1, 1) NOT NULL,
    [employee_qualification_library_id]       NVARCHAR (36)  NULL,
    [employee_qualification_library]          NVARCHAR (100) NULL,
    [job_requirement_usage_count]             INT            NULL,
    CONSTRAINT [PK_Temp_Staging_ODSETLdim_employee_qualification_library] PRIMARY KEY NONCLUSTERED ([ODSdim_employee_qualification_libraryID] ASC)
);

