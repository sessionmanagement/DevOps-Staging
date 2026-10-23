


CREATE   view [ETL].[dim_property_inspection_detail]

/**********************************************************************************************************
 View		etl.dim_property_inspection_detail
 Author		Greg Nuthall
 Created	2026-08-03
 Purpose	To report on property inspection detail data from the EDW.  
  **************************************************************************************************************

--REVISIONS:
--Version	 Date			Author			Description
---------	 ------------	---------------	--------------------------
--1.0		 2026-08-03		Greg Nuthall	Initial version
--1.1        2026-08-06     Greg Nuthall    Reduced size of comments
**************************************************************************************************************/

AS

WITH optionHashTable AS
(
    SELECT
        [OptionSetName],
        [Option],
        [EntityName],
        HASHBYTES('MD5', [OptionSetName] + CAST([Option] AS nvarchar(100)) + [EntityName]) AS optionHash,
        [LocalizedLabel]
    FROM
        [Zavanti].[vw_GlobalOptionsetMetadata]

    UNION

    SELECT
        [OptionSetName],
        [Option],
        [EntityName],
        HASHBYTES('MD5', [OptionSetName] + CAST([Option] AS nvarchar(100)) + [EntityName]) AS optionHash,
        [LocalizedLabel]
    FROM
        [Zavanti].[vw_OptionsetMetadata]

    UNION

    SELECT
        'statuscodename' AS [OptionSetName],
        [status] AS [Option],
        [EntityName],
        HASHBYTES('MD5', 'statuscodename' + CAST([status] AS nvarchar(100)) + [EntityName]) AS optionHash,
        [LocalizedLabel]
    FROM
        [Zavanti].[vw_StatusMetadata]

    UNION

    SELECT
        'statecodename' AS [OptionSetName],
        [state] AS [Option],
        [EntityName],
        HASHBYTES('MD5', 'statecodename' + CAST([state] AS nvarchar(100)) + [EntityName]) AS optionHash,
        [LocalizedLabel]
    FROM
        [Zavanti].[vw_StateMetadata]
),
RecentInspectionDetails AS (
       select i.zav_inspectiondetailid,
        pa.zav_property,
        i.zav_assetcondition,
        i.zav_clean,
        i.zav_undamaged,
        i.zav_working,
        i.zav_comments,
        i.zav_inspectionid,
        i.zav_assetsname,
        i.zav_areaname,
        i.zav_propertyassetsname,
        i.SinkModifiedOn,
        ROW_NUMBER() OVER (PARTITION BY zav_inspectiondetailid ORDER BY i.SinkModifiedOn DESC) AS rn
    FROM
        [Zavanti].[vw_zav_inspectiondetail] i
        left outer join Zavanti.vw_zav_propertyassets pa on i.zav_propertyassets = pa.id and isnull(pa.Isdelete,'false') = 'false'
WHERE
zav_inspectiondetailid IS NOT NULL
)
SELECT 
    rid.zav_property as property_id,
    rid.zav_inspectiondetailid as property_inspection_detail_id,
    rid.zav_assetcondition as asset_condition_id,
    t1.LocalizedLabel as asset_condition,
    t2.LocalizedLabel as property_is_clean,
    left(rid.zav_comments,500) as inspection_comments,
    rid.zav_inspectionid as property_inspection_id,
    t3.LocalizedLabel as property_undamaged,
    t4.LocalizedLabel as property_working,
    rid.zav_assetsname as asset_name,
    rid.zav_areaname as inspection_area,
    rid.zav_propertyassetsname as property_asset_name
FROM
    RecentInspectionDetails rid
LEFT OUTER JOIN
    optionHashTable t1 ON t1.optionHash = HASHBYTES('MD5', 'zav_assetcondition' + CAST(rid.zav_assetcondition AS nvarchar(100)) + 'zav_inspectiondetail')
LEFT OUTER JOIN
    optionHashTable t2 ON t2.optionHash = HASHBYTES('MD5', 'zav_clean' + CAST(rid.zav_clean AS nvarchar(100)) + 'zav_inspectiondetail')
LEFT OUTER JOIN
    optionHashTable t3 ON t3.optionHash = HASHBYTES('MD5', 'zav_undamaged' + CAST(rid.zav_undamaged AS nvarchar(100)) + 'zav_inspectiondetail')
LEFT OUTER JOIN
    optionHashTable t4 ON t4.optionHash = HASHBYTES('MD5', 'zav_working' + CAST(rid.zav_working AS nvarchar(100)) + 'zav_inspectiondetail')
WHERE
    rid.rn = 1;