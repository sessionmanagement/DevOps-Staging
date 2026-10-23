CREATE PROC [staging].[insert_staging_dim_client_outcome_questions]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_client_outcome_questions]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2026-08-05    ?				Initial version

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_client_outcome_questions]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_client_outcome_questions] (
	 [company_key] 	,[outcome_tool_template_id] 	,[outcome_tool_title] 	,[outcome_tool_type] 	,[outcome_tool_question_id] 	,[question_text] 	,[question_type] 
	)
SELECT
	 [company_key] 	,[outcome_tool_template_id] 	,[outcome_tool_title] 	,[outcome_tool_type] 	,[outcome_tool_question_id] 	,[question_text] 	,[question_type] 
from [Landing].[edw_dim_client_outcome_questions]