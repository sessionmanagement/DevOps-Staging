

CREATE view [edw].[vw_dim_employee_on_call_log]
as 

SELECT [dim_employee_on_call_log_key]
      ,[on_call_id]
      ,[on_call_title]
      ,[event_name]
      ,[call_received_from]
      ,[issue_description]
      ,[outcome]
      ,[escalation_comments]
      ,[DWHBatchId]
      ,[DWHCreatedAt]
      ,[DWHModifiedOn]
      ,[DWHDMLOperation]
      ,[DWHSourceSystem]
  FROM [edw].[dim_employee_on_call_log]