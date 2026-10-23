

CREATE   VIEW [edw].[vw_dim_void_category]
AS
SELECT				void_category_id
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

					,[DWHBatchId] 
					,[DWHEffectiveFrom] 
					,[DWHEffectiveTo] 
					,[DWHDMLOperation] 
					,[DWHIsCurrent] 
					,[DWHSourceSystem] 

FROM				[edw].[dim_void_category]