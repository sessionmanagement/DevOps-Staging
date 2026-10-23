
CREATE PROC [staging].[insert_staging_dim_outcome_indicator]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_outcome_indicator]
PURPOSE:  

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2026-08-11    Greg Nuthall		Initial version
****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_outcome_indicator]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_outcome_indicator] (
	 [indicator_id] 
	,[indicator] 
	,[specific_outcome_id] 
	,[priority_outcome_id] 
	,[wellbeing_domain_id] 
	,[priority_outcome] 
	,[specific_outcome] 
	,[relates_to_outcome] 
	,[wellbeing_domain] 
	,[data_type] 
	,[measure_type] 
	,[indicator_description] 
	,[indicator_definition_status] 
	,[relates_to] 
	,[measure_logic] 
	,[enrolled_teams_or_services] 
	,[enrolled_sub_programme_id] 
	,[enrolled_sub_programme_value] 
	,[considerations] 
	,[delivery_phasing] 
	,[datasource_1] 
	,[datasource_2] 
	,[datasource_3] 
	,[leading_sign] 
	,[trailing_sign] 
	,[rounding_dp] 
	,[description_positive] 
	,[qualifier_text] 
	,[qualifier_text_part2] 
	,[qualifier_number_logic] 
	,[example_of_this_reported] 
	,[include_in_macroview] 
	)
SELECT
	 [indicator_id] 
	,[indicator] 
	,[specific_outcome_id] 
	,[priority_outcome_id] 
	,[wellbeing_domain_id] 
	,[priority_outcome] 
	,[specific_outcome] 
	,[relates_to_outcome] 
	,[wellbeing_domain] 
	,[data_type] 
	,[measure_type] 
	,[indicator_description] 
	,[indicator_definition_status] 
	,[relates_to] 
	,[measure_logic] 
	,[enrolled_teams_or_services] 
	,[enrolled_sub_programme_id] 
	,[enrolled_sub_programme_value] 
	,[considerations] 
	,[delivery_phasing] 
	,[datasource_1] 
	,[datasource_2] 
	,[datasource_3] 
	,[leading_sign] 
	,[trailing_sign] 
	,[rounding_dp] 
	,[description_positive] 
	,[qualifier_text] 
	,[qualifier_text_part2] 
	,[qualifier_number_logic] 
	,[example_of_this_reported] 
	,[include_in_macroview] 
from [Landing].[edw_dim_outcome_indicator]