create   view [edw].[vw_dim_property_breach_type]

as

    select [dim_property_breach_type_key]
      ,[breach_type_id]
      ,[breach_type]
      ,[DWHBatchId]
      ,[DWHEffectiveFrom]
      ,[DWHEffectiveTo]
      ,[DWHDMLOperation]
      ,[DWHIsCurrent]
      ,[DWHSourceSystem]
    from [edw].[dim_property_breach_type]