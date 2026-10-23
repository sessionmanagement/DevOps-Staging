CREATE PROC [staging].[insert_staging_dim_course]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_course]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2024-07-01    ?				Initial version

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_course]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_course] (
	 [course_id] 	,[course_full_name] 	,[course_short_name] 	,[course_id_number] 	,[course_format] 	,[course_start_date] 	,[course_end_date] 	,[course_created_date] 	,[is_enable_completion] 	,[course_category_id] 	,[course_category_name] 	,[course_category_path_id] 	,[course_category_path] 	,[course_linked_to_certification] 	,[is_course_visible] 	,[course_audience_visible] 
	)
SELECT
	 [course_id] 	,[course_full_name] 	,[course_short_name] 	,[course_id_number] 	,[course_format] 	,[course_start_date] 	,[course_end_date] 	,[course_created_date] 	,[is_enable_completion] 	,[course_category_id] 	,[course_category_name] 	,[course_category_path_id] 	,[course_category_path] 	,[course_linked_to_certification] 	,[is_course_visible] 	,[course_audience_visible] 
from [Landing].[edw_dim_course]