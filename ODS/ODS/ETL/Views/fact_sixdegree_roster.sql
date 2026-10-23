


CREATE VIEW [ETL].[fact_sixdegree_roster] as


/**********************************************************************************************************
 View		[ETL].[fact_six_degree_roster]
 Author		Malhar Badheka
 Created	2026/03/16	
 Purpose	six_degree_roaster_fact

 Filter Notes:
 	year_key     = 140246  --> Roster
 	entity_key   = 116310  --> 'MAURI ORA' this is for test example
 	staff_key    = 122157  --> 'Roster'
 	position_key = 122162  --> this position filter helps clean data where position <> NA

 **************************************************************************************************************
--REVISIONS:
--Version	 Date			Author				Description
---------	 ------------	---------------		--------------------------
--1.0		 2026/03/16		Malhar Badheka		Initial version
--1.1		 2026/04/16		Malhar Badheka		entity_code added to later match on service_dim


**************************************************************************************************************/




WITH    [Period] AS (
    SELECT 114993 AS period_hierarchy_key, 'Spread Amount' AS period_hierarchy_code
    UNION ALL SELECT 114994, 'monday'
    UNION ALL SELECT 114996, 'tuesday'
    UNION ALL SELECT 114998, 'wednesday'
    UNION ALL SELECT 114999, 'thursday'
    UNION ALL SELECT 115000, 'friday'
    UNION ALL SELECT 115001, 'saturday'
    UNION ALL SELECT 115002, 'sunday'
    UNION ALL SELECT 115003, 'FEBRUARY'
    UNION ALL SELECT 115004, 'MARCH'
    UNION ALL SELECT 115005, 'Adjustment'
    UNION ALL SELECT 115006, 'APRIL'
    UNION ALL SELECT 115007, 'MAY'
    UNION ALL SELECT 115008, 'JUNE'
    UNION ALL SELECT 115009, 'Spread Method'
    UNION ALL SELECT 115010, 'Spread Behaviour'
    UNION ALL SELECT 115011, 'total shift/week'
    UNION ALL SELECT 115016, 'Spreading'
    UNION ALL SELECT 115017, 'Full Year'
    UNION ALL SELECT 120288, 'Opening'
    UNION ALL SELECT 122167, 'Roster'
    UNION ALL SELECT 122168, 'roster - fte/week'
),
[Entity] as (
SELECT
     b.entity_hierarchy_code        AS entity_parent_code
    ,b.entity_hierarchy_key         AS parent_key
    ,a.entity_hierarchy_key         AS entity_key
    ,a.[entity_hierarchy_code]      AS entity_code
    ,a.[entity_hierarchy_description] AS entity_description
FROM [sixdegrees].[entity] a
LEFT JOIN [sixdegrees].[entity] b ON a.entity_hierarchy_parent_key = b.entity_hierarchy_key
),

BaseData AS (
    SELECT
         p.period_hierarchy_code
        ,sf.entity_key
        ,e.entity_code
        ,e.entity_parent_code
        ,sf.fte_percent
        ,sf.casual_percent
        ,sf.fte_pa
        ,sf.am_support_workers
        ,sf.pm_support_workers
        ,sf.pt_support_workers
        ,sf.wake_support_workers
        ,sf.sleep_support_workers
        ,sf.total_support_workers
        ,sf.am_hp as am_health_professional
        ,sf.pm_hp as pm_health_professional
        ,sf.pt_hp as pt_health_professional
        ,sf.wake_hp as wake_health_professional
        ,sf.sleep_hp as sleep_health_professional
        ,sf.total_hp as total_health_professional
    FROM [sixdegrees].[personnel_roster] sf
    LEFT JOIN [Period]   p  ON sf.period_key   = p.period_hierarchy_key
    LEFT JOIN [Entity] E on e.entity_key = sf.entity_key
    WHERE
        sf.year_key  = '140246'            
        --AND sf.entity_key = 116310          
        AND sf.staff_key  = 122157        
        AND sf.position_key = '122162' 
)
SELECT
     entity_key
    ,entity_code
    ,entity_parent_code
    ,metric_name as roster_shifts
    ,[monday]
    ,[tuesday]
    ,[wednesday]
    ,[thursday]
    ,[friday]
    ,[saturday]
    ,[sunday]
    ,[total shift/week]
    ,[roster - fte/week]
FROM (
    SELECT
         entity_key
        ,entity_code
        ,entity_parent_code
        ,period_hierarchy_code
        ,am_support_workers
        ,pm_support_workers
        ,pt_support_workers
        ,wake_support_workers
        ,sleep_support_workers
        ,total_support_workers
        ,am_health_professional
        ,pm_health_professional
        ,pt_health_professional
        ,wake_health_professional
        ,sleep_health_professional
        ,total_health_professional
    FROM BaseData
    WHERE period_hierarchy_code IN (
        'monday', 'tuesday', 'wednesday', 'thursday',
        'friday', 'saturday', 'sunday',
        'total shift/week', 'roster - fte/week'
    )
) AS SourceData
UNPIVOT (
    metric_value FOR metric_name IN (
        am_support_workers, pm_support_workers, pt_support_workers,
        wake_support_workers, sleep_support_workers, total_support_workers,
        am_health_professional, pm_health_professional, pt_health_professional,
        wake_health_professional, sleep_health_professional, total_health_professional
    )
) AS unpvt
PIVOT (
    MAX(metric_value)
    FOR period_hierarchy_code IN (
        [monday], [tuesday], [wednesday], [thursday],
        [friday], [saturday], [sunday],
        [total shift/week], [roster - fte/week]
    )
) AS pvt