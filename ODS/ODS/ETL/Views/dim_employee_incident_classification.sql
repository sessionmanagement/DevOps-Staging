
CREATE      view [ETL].[dim_employee_incident_classification]

as

/**********************************************************************************************************
 View		[ETL].[dim_employee_incident_classification]
 Author		Pankaj Bhatt
 Created	2026-01-08
 Purpose	Used to build the edw.dim_employee_incident_classification table
 An incident can have multiple classification and further sub classifications.
 This table acts a bridge table and combines all the classifications assigned to an incident
 This struture helps the reporting layer to find the relevant details in a quick and structured manner
 Other design considerations:
 - We also considered having a master list of dimension table 
 but then we need to store every classification/sub-classification combination which would be an over kill
 - Also discussed creating DIM for classifications by scanning transacton data as we don't have a master list. 
 Then create a seperate Factless Fact/Bridge table to store the many-to-many relationship. But considered current design due to small dimension size, no need to create a new design pattern and have simple design
 
 **************************************************************************************************************
--REVISIONS:
--Version	 Date			Author			Description
---------	 ------------	---------------	--------------------------
--1.0		 2026-01-08		Pankaj Bhatt	Initial version

**************************************************************************************************************/


with incident_investigations as
(
select *
FROM [EcoPortal].[incident_investigations]
where ODSIsCurrent = 1
),
L1_Classes AS (
    SELECT
        ii.page_uid,
        json_element.ename AS Level_1_Class_Name,
        json_element.evalue AS Level_1_Code
    FROM
        incident_investigations ii
    
    -- Parse the Level 1 (rpt_incident_class_type_incident_select)
    CROSS APPLY
        OPENJSON(ii.rpt_incident_class_type_incident_select)
        WITH (
            ename  NVARCHAR(1000) '$.name',
            evalue NVARCHAR(100)  '$.value',
            selected BIT         '$.selected'
        ) AS json_element
    WHERE
        -- Filter to only include elements where 'selected' is true (i.e., = 1)
        json_element.selected = 1
),
L2_Classes AS (
    -- L2 data is only extracted for the L1 categories that have L2 fields.  
    -- 1. Harm -> rpt_incident_class_type_harm_select
    SELECT
        L1.page_uid,
        L1.Level_1_Code,
        L1.Level_1_Class_Name,
        json_element_l2.ename AS Level_2_Class_Name,
        json_element_l2.evalue AS Level_2_Code
    FROM
        L1_Classes L1
    JOIN
        incident_investigations ii ON L1.page_uid = ii.page_uid
    CROSS APPLY
        OPENJSON(ii.rpt_incident_class_type_harm_select)
        WITH (
            ename  NVARCHAR(1000) '$.name',
            evalue NVARCHAR(100)  '$.value',
            selected BIT         '$.selected'
        ) AS json_element_l2
    WHERE
        L1.Level_1_Code = 'inc'
        AND json_element_l2.selected = 1

    UNION ALL

    -- 2. Near Miss -> rpt_incident_class_type_near_miss_select
    SELECT
        L1.page_uid,
        L1.Level_1_Code,
        L1.Level_1_Class_Name,
        json_element_l2.ename AS Level_2_Class_Name,
        json_element_l2.evalue AS Level_2_Code
    FROM
        L1_Classes L1
    JOIN
        incident_investigations ii ON L1.page_uid = ii.page_uid
    CROSS APPLY
        OPENJSON(ii.rpt_incident_class_type_near_miss_select)
        WITH (
            ename  NVARCHAR(1000) '$.name',
            evalue NVARCHAR(100)  '$.value',
            selected BIT         '$.selected'
        ) AS json_element_l2
    WHERE
        L1.Level_1_Code = 'nm'
        AND json_element_l2.selected = 1

    UNION ALL

    -- 3. Abuse -> rpt_incident_class_type_abuse_select
    SELECT
        L1.page_uid,
        L1.Level_1_Code,
        L1.Level_1_Class_Name,
        json_element_l2.ename AS Level_2_Class_Name,
        json_element_l2.evalue AS Level_2_Code
    FROM
        L1_Classes L1
    JOIN
        incident_investigations ii ON L1.page_uid = ii.page_uid
    CROSS APPLY
        OPENJSON(ii.rpt_incident_class_type_abuse_select)
        WITH (
            ename  NVARCHAR(1000) '$.name',
            evalue NVARCHAR(100)  '$.value',
            selected BIT         '$.selected'
        ) AS json_element_l2
    WHERE
        L1.Level_1_Code = 'abu'
        AND json_element_l2.selected = 1

    UNION ALL

    -- 4. Property Damage -> rpt_incident_class_type_property_damage_select
    SELECT
        L1.page_uid,
        L1.Level_1_Code,
        L1.Level_1_Class_Name,
        json_element_l2.ename AS Level_2_Class_Name,
        json_element_l2.evalue AS Level_2_Code
    FROM
        L1_Classes L1
    JOIN
        incident_investigations ii ON L1.page_uid = ii.page_uid
    CROSS APPLY
        OPENJSON(ii.rpt_incident_class_type_property_damage_select)
        WITH (
            ename  NVARCHAR(1000) '$.name',
            evalue NVARCHAR(100)  '$.value',
            selected BIT         '$.selected'
        ) AS json_element_l2
    WHERE
        L1.Level_1_Code = 'pd'
        AND json_element_l2.selected = 1

    UNION ALL

    -- 5. Fire Risk Incidents -> rpt_incident_class_type_fire_risk_select
    SELECT
        L1.page_uid,
        L1.Level_1_Code,
        L1.Level_1_Class_Name,
        json_element_l2.ename AS Level_2_Class_Name,
        json_element_l2.evalue AS Level_2_Code
    FROM
        L1_Classes L1
    JOIN
        incident_investigations ii ON L1.page_uid = ii.page_uid
    CROSS APPLY
        OPENJSON(ii.rpt_incident_class_type_fire_risk_select)
        WITH (
            ename  NVARCHAR(1000) '$.name',
            evalue NVARCHAR(100)  '$.value',
            selected BIT         '$.selected'
        ) AS json_element_l2
    WHERE
        L1.Level_1_Code = 'fire'
        AND json_element_l2.selected = 1
),
L3_Classes AS (
    -- L3 data is extracted for specific L1/L2 combinations only.    
    -- 1. Illness Sub-classification -> rpt_incident_class_type_illness_select
    SELECT
        L2.page_uid,
        L2.Level_1_Code,
        L2.Level_2_Code,
        json_element_l3.ename AS Level_3_Class_Name,
        json_element_l3.evalue AS Level_3_Code
    FROM
        L2_Classes L2
    JOIN
        incident_investigations ii ON L2.page_uid = ii.page_uid
    CROSS APPLY
        OPENJSON(ii.rpt_incident_class_type_illness_select)
        WITH (
            ename  NVARCHAR(1000) '$.name',
            evalue NVARCHAR(100)  '$.value',
            selected BIT         '$.selected'
        ) AS json_element_l3
    WHERE
        -- Condition 1: Harm AND Illness 
        L2.Level_1_Code = 'inc'
        AND L2.Level_2_Code = 'ill' 
        AND json_element_l3.selected = 1

    UNION ALL

    -- 2. Property Damage Sub-classification -> rpt_incident_class_type_property_damage_select
    SELECT
        L2.page_uid,
        L2.Level_1_Code,
        L2.Level_2_Code,
        json_element_l3.ename AS Level_3_Class_Name,
        json_element_l3.evalue AS Level_3_Code
    FROM
        L2_Classes L2
    JOIN
        incident_investigations ii ON L2.page_uid = ii.page_uid
    CROSS APPLY
        OPENJSON(ii.rpt_incident_class_type_property_damage_select)
        WITH (
            ename  NVARCHAR(1000) '$.name',
            evalue NVARCHAR(100)  '$.value',
            selected BIT         '$.selected'
        ) AS json_element_l3
    WHERE
        -- Condition 2: Near Miss AND Potential Property Damage
        L2.Level_1_Code = 'nm'
        AND L2.Level_2_Code = 'pot-pro'
        AND json_element_l3.selected = 1
)
-- ensure incidents without L2/L3 classifications still appear with NULLs in the L2/L3 columns
select
    l1.page_uid AS incident_id,
    l1.Level_1_Code as incident_classification_level1_code,
    l1.Level_1_Class_Name as incident_classification_level1_name,
    l2.Level_2_Code as incident_classification_level2_code,
    l2.Level_2_Class_Name as incident_classification_level2_name,
    l3.Level_3_Code as incident_classification_level3_code,    
    l3.Level_3_Class_Name as incident_classification_level3_name,
    --  extraction of the 'Other' plaintext field as Notes
    CASE
        -- Condition: Fire -> Other
        WHEN l1.Level_1_Code = 'fire' AND l2.Level_2_Code = 'oth'
        THEN ii.rpt_incident_class_other_specify_plaintext
        ELSE NULL
    END as incident_classification_notes

/*
TEST incidents
select * from [ETL].[dim_employee_incident_classification]
--where incident_id in ('EVN-01859','EVN-04346','EVN-03757','EVN-04560','EVN-04567','EVN-03074')
--where incident_id in ('EVN-02428','EVN-03512')
--where incident_id in ('EVN-03512')
--where incident_id in ('EVN-04314')
order by incident_id
*/

from L1_Classes l1
left outer join incident_investigations ii
on l1.page_uid = ii.page_uid
left outer join L2_Classes l2
on l1.page_uid = l2.page_uid
AND l1.Level_1_Code = l2.Level_1_Code
left outer join L3_Classes l3
on l2.page_uid = l3.page_uid
AND l2.Level_1_Code = l3.Level_1_Code
AND l2.Level_2_Code = l3.Level_2_Code