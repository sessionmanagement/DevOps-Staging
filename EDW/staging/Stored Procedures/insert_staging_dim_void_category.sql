CREATE PROC [staging].[insert_staging_dim_void_category]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_void_category]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2025-02-27    ?				Initial version

****************************************************************************/

--  clear the staging table before loading
	TRUNCATE TABLE [Staging].[ODSETLdim_void_category]

-- insert data from landing table into staging table
	INSERT INTO [Staging].[ODSETLdim_void_category] (
					void_category_id
				    ,void_category_state_code
					,void_category_status_code
					,void_category_code
					,void_category_target_group
					,owning_user_id
					,owner_id
					,overridden_created_on
					,owner_id_name
					,owner_id_yomi_name
					,owning_business_unit_name
					,time_zone_rule_version_number
					,utc_conversion_timezone_code
					,version_number
					,void_category_comments
					,void_category_days_vacant_kpi
					,void_category_days_void_kpi
					,void_category_description
					,void_category_name
					,void_category_total_days_kpi
					,void_category_is_delete_flag
	)
			SELECT
					void_category_id
				    ,void_category_state_code
					,void_category_status_code
					,void_category_code
					,void_category_target_group
					,owning_user_id
					,owner_id
					,overridden_created_on
					,owner_id_name
					,owner_id_yomi_name
					,owning_business_unit_name
					,time_zone_rule_version_number
					,utc_conversion_timezone_code
					,version_number
					,void_category_comments
					,void_category_days_vacant_kpi
					,void_category_days_void_kpi
					,void_category_description
					,void_category_name
					,void_category_total_days_kpi
					,void_category_is_delete_flag
		from [Landing].[edw_dim_void_category]