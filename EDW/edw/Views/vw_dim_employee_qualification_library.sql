
create   view edw.vw_dim_employee_qualification_library
as

    select [dim_employee_qualification_library_key]
      ,[employee_qualification_library_id]
      ,[employee_qualification_library]
      ,[job_requirement_usage_count]
      ,[DWHBatchId]
      ,[DWHEffectiveFrom]
      ,[DWHEffectiveTo]
      ,[DWHDMLOperation]
      ,[DWHIsCurrent]
      ,[DWHSourceSystem]
  from [edw].[dim_employee_qualification_library]