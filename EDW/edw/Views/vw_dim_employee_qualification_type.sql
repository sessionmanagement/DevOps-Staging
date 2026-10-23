
CREATE   view [edw].[vw_dim_employee_qualification_type]
as

    select [dim_employee_qualification_type_key]
          ,[employee_qualification_type_id]
          ,[employee_qualification_type]
          ,[DWHBatchId]
          ,[DWHEffectiveFrom]
          ,[DWHEffectiveTo]
          ,[DWHDMLOperation]
          ,[DWHIsCurrent]
          ,[DWHSourceSystem]
     from [edw].[dim_employee_qualification_type]