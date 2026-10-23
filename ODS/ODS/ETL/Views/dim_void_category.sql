CREATE    VIEW [ETL].[dim_void_category]

--View			[ETL].[fact_finance_general_ledger]
--Author		Mike Gencic
--Created		2025/02/28
--Purpose		Property void category vw_zav_voidcategory to generate dim_void_category
				
--=========================================================================================================
--REVISIONS:
--Version	 Date		   Author			Description
---------	 ------------  ---------------	--------------------------
--1.0		 2025/02/28    Mike Gencic		Initial version
--											Example selective rename to be consistent with existing naming standards. 
--											Keep or remove whichever columns your business needs
--											in the user story we said "all columns," so we include them below. 
--**********************************************************************************************************/

AS
    SELECT
        -- Primary Key for dimension
        vc.Id AS void_category_id,

        -- Basic metadata
        vc.statecode         AS void_category_state_code,
        vc.statuscode        AS void_category_status_code,

        vc.crba8_void_category  AS void_category_code,
        vc.crba8_targetgroup    AS void_category_target_group,

		vc.owninguser          as owning_user_id,
        vc.ownerid             AS owner_id,

        vc.overriddencreatedon     AS overridden_created_on,
        vc.owneridname         AS owner_id_name,
        vc.owneridyominame     AS owner_id_yomi_name,
        vc.owningbusinessunitname AS owning_business_unit_name,
        vc.timezoneruleversionnumber AS time_zone_rule_version_number,
        vc.utcconversiontimezonecode AS utc_conversion_timezone_code,
        vc.versionnumber       AS version_number,

        -- Actual void category columns
        vc.zav_comments       AS void_category_comments,
        vc.zav_daysvacantkpi  AS void_category_days_vacant_kpi,
        vc.zav_daysvoidkpi    AS void_category_days_void_kpi,
        vc.zav_description    AS void_category_description,
        vc.zav_name           AS void_category_name,
        vc.zav_totaldayskpi   AS void_category_total_days_kpi,

        -- Deleted flag
        CAST(CAST(vc.IsDelete AS BIT) AS INT) AS void_category_is_delete_flag

    FROM [Zavanti].[vw_zav_voidcategory] vc;