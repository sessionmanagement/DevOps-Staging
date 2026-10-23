
/**********************************************************************************************************
REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		2024-06-11   Manish Singh		Initial creation of View
2.0		2024-07-17   Manish Singh		Changed joining condition to filter Cohot type 
3.0     2024-08-09   Manish Singh		Changed query condition to check default vs complete records 
4.0     2024-08-14	 Manish Singh		Changed flag name as per agrred naming convention
6.0     2024-10-02	 Manish Singh		Handling deleted records 
7.0     2024-10-10   Manish Singh	    Change date columns from UTC to NZT 

**********************************************************************************************************/


CREATE VIEW [ETL].[dim_program] as 
SELECT mp.id AS program_id,
       full_name AS program_full_name,
       short_name AS program_short_name,
       id_number AS program_id_number,
       CASE 
           WHEN available_from IS NULL OR available_from = 0 THEN '1900-01-01'
           ELSE CONVERT(VARCHAR, DATEADD(SECOND, available_from, '1970-01-01') AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time', 23)
       END AS available_from_date,
       CASE 
           WHEN available_until IS NULL OR available_until = 0 THEN '2999-12-31'
           ELSE CONVERT(VARCHAR, DATEADD(SECOND, available_until, '1970-01-01') AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time', 23)
       END AS program_end_date,
       CASE 
           WHEN time_created IS NULL OR time_created = 0 THEN '1900-01-01'
           ELSE CONVERT(VARCHAR, DATEADD(SECOND, time_created, '1970-01-01') AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time', 23)
       END AS program_created_date,
       category AS program_category_id,
       mcc.name AS program_category_name,
       mcc.path AS program_category_path
FROM [Akoranga].mdl_prog mp
INNER JOIN [Akoranga].mdl_context ctx
    ON ctx.instance_id = mp.id AND ctx.context_level = 45 AND ctx.[ODSDMLOperation] <> 'D'
LEFT OUTER JOIN (
    SELECT c.id,
           c.name,
           c.parent,
           CONCAT(
               COALESCE(CONCAT(p9.name, ' > '), ''),
               COALESCE(CONCAT(p8.name, ' > '), ''),
               COALESCE(CONCAT(p7.name, ' > '), ''),
               COALESCE(CONCAT(p6.name, ' > '), ''),
               COALESCE(CONCAT(p5.name, ' > '), ''),
               COALESCE(CONCAT(p4.name, ' > '), ''),
               COALESCE(CONCAT(p3.name, ' > '), ''),
               COALESCE(CONCAT(p2.name, ' > '), ''),
               COALESCE(CONCAT(p1.name, ' > '), ''),
               c.name
           ) AS path
    FROM [Akoranga].mdl_course_categories c
    LEFT JOIN [Akoranga].mdl_course_categories p1 ON c.parent = p1.id AND p1.ODSIsCurrent = 1 AND p1.[ODSDMLOperation] <> 'D'
    LEFT JOIN [Akoranga].mdl_course_categories p2 ON p1.parent = p2.id AND p2.ODSIsCurrent = 1 AND p2.[ODSDMLOperation] <> 'D'
    LEFT JOIN [Akoranga].mdl_course_categories p3 ON p2.parent = p3.id AND p3.ODSIsCurrent = 1 AND p3.[ODSDMLOperation] <> 'D'
    LEFT JOIN [Akoranga].mdl_course_categories p4 ON p3.parent = p4.id AND p4.ODSIsCurrent = 1 AND p4.[ODSDMLOperation] <> 'D'
    LEFT JOIN [Akoranga].mdl_course_categories p5 ON p4.parent = p5.id AND p5.ODSIsCurrent = 1 AND p5.[ODSDMLOperation] <> 'D'
    LEFT JOIN [Akoranga].mdl_course_categories p6 ON p5.parent = p6.id AND p6.ODSIsCurrent = 1 AND p6.[ODSDMLOperation] <> 'D'
    LEFT JOIN [Akoranga].mdl_course_categories p7 ON p6.parent = p7.id AND p7.ODSIsCurrent = 1 AND p7.[ODSDMLOperation] <> 'D'
    LEFT JOIN [Akoranga].mdl_course_categories p8 ON p7.parent = p8.id AND p8.ODSIsCurrent = 1 AND p8.[ODSDMLOperation] <> 'D'
    LEFT JOIN [Akoranga].mdl_course_categories p9 ON p8.parent = p9.id AND p9.ODSIsCurrent = 1 AND p9.[ODSDMLOperation] <> 'D'
    WHERE c.ODSIsCurrent = 1 AND c.[ODSDMLOperation] <> 'D'
) mcc ON mp.category = mcc.id 
WHERE mp.ODSIsCurrent = 1 AND mp.[ODSDMLOperation] <> 'D' AND mp.certif_id IS NULL;