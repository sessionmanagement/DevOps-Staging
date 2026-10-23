create view edw.vw_dim_client_outcome_questions 
as 
select 
      [dim_client_outcome_questions_key]
      ,[company_key]
      ,[outcome_tool_template_id]
      ,[outcome_tool_title]
      ,[outcome_tool_type]
      ,[outcome_tool_question_id]
      ,[question_text]
      ,[question_type]
      ,[DWHBatchId]
      ,[DWHEffectiveFrom]
      ,[DWHEffectiveTo]
      ,[DWHDMLOperation]
      ,[DWHIsCurrent]
      ,[DWHSourceSystem]
  FROM [edw].[dim_client_outcome_questions]
GO

