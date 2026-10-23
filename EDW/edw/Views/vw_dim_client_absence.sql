


CREATE VIEW [edw].[vw_dim_client_absence]
AS
	  Select 
	  dim_client_absence_key
      ,[company_id]
      ,[dim_client_key]
      ,[dim_client_unique_key]
      ,[client_id]
      ,[client_absence_approved_by_funder_flag]
      ,[client_absence_start_date_time]
      ,[client_absence_end_date_time]
      ,[client_absence_type]
      ,[client_absence_reason_id]
      ,[client_absence_reason]
      ,[DWHBatchId]
      ,[DWHEffectiveFrom]
      ,[DWHEffectiveTo]
      ,[DWHDMLOperation]
      ,[DWHIsCurrent]
      ,[DWHSourceSystem]
	  FROM [edw].[dim_client_absence]