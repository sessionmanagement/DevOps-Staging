




CREATE VIEW [ETL].[fact_sixdegree_positionroster] as


/**********************************************************************************************************
 View		[ETL].[fact_sixdegree_positionroster]
 Author		Malhar Badheka
 Created	2026/03/17
 Purpose	Surfaces position-level roster data (hours, FTE, allocated FTE) per entity
            by joining personnel_roster to the position hierarchy.

 Filter Notes:
 	period_key             = 115011  --> Total Shift/Week
 	position_hierarchy_code <> 'NA'  --> Excludes unassigned/placeholder positions

 **************************************************************************************************************
--REVISIONS:
--Version	 Date			Author				Description
---------	 ------------	---------------		--------------------------
--1.0		 2026/03/17		Malhar Badheka		Initial version
--1.1        2026/04/16		Malhar Badheka		entity_code added to later match on service_dim

**************************************************************************************************************/


WITH [Entity] as (
SELECT
     b.entity_hierarchy_code        AS entity_parent_code
    ,b.entity_hierarchy_key         AS parent_key
    ,a.entity_hierarchy_key         AS entity_key
    ,a.[entity_hierarchy_code]      AS entity_code
    ,a.[entity_hierarchy_description] AS entity_description
FROM [sixdegrees].[entity] a
LEFT JOIN [sixdegrees].[entity] b ON a.entity_hierarchy_parent_key = b.entity_hierarchy_key
)


SELECT  
    po.position_hierarchy_code as position_description
   ,po.position_hierarchy_key as sixd_position_key
   ,sf.entity_key
   ,en.entity_code
   ,en.entity_parent_code
   ,sf.hours
   ,sf.fte
   ,sf.allocated_fte
   ,sf.fte_pa
   ,sf.hours_pw   
   
   
FROM [sixdegrees].[personnel_roster] sf

LEFT JOIN [sixdegrees].position po ON po.position_hierarchy_key = sf.position_key
LEFT JOIN entity en on en.entity_key = sf.entity_key
WHERE position_hierarchy_code <> 'NA' and sf.period_key = 115011