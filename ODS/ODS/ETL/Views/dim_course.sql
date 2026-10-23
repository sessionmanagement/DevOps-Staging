



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




CREATE  VIEW [ETL].[dim_course]

as
SELECT mc.id AS course_id,
       full_name AS course_full_name,
       short_name AS course_short_name,
       mc.id_number AS course_id_number,
       format AS course_format,
       ISNULL(CONVERT(VARCHAR, DATEADD(SECOND, start_date, '1970-01-01') AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time', 23), '1900-01-01') AS course_start_date,
       ISNULL(CONVERT(VARCHAR, DATEADD(SECOND, end_date, '1970-01-01') AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time', 23), '2999-12-31') AS course_end_date,
       ISNULL(CONVERT(VARCHAR, DATEADD(SECOND, time_created, '1970-01-01') AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time', 23), '1900-01-01') AS course_created_date,
       enable_completion AS is_enable_completion,
       category AS course_category_id,
       name AS course_category_name,
       mcc.id AS course_category_path_id,
       mcc.path AS course_category_path,
       data AS course_linked_to_certification,
       mc.visible AS is_course_visible,
       mc.audience_visible AS course_audience_visible
FROM [Akoranga].mdl_course mc
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
    FROM [Akoranga].[mdl_course_categories] c
    LEFT JOIN [Akoranga].[mdl_course_categories] p1 ON c.parent = p1.id AND p1.ODSIsCurrent = 1 AND p1.[ODSDMLOperation] <> 'D'
    LEFT JOIN [Akoranga].[mdl_course_categories] p2 ON p1.parent = p2.id AND p2.ODSIsCurrent = 1 AND p2.[ODSDMLOperation] <> 'D'
    LEFT JOIN [Akoranga].[mdl_course_categories] p3 ON p2.parent = p3.id AND p3.ODSIsCurrent = 1 AND p3.[ODSDMLOperation] <> 'D'
    LEFT JOIN [Akoranga].[mdl_course_categories] p4 ON p3.parent = p4.id AND p4.ODSIsCurrent = 1 AND p4.[ODSDMLOperation] <> 'D'
    LEFT JOIN [Akoranga].[mdl_course_categories] p5 ON p4.parent = p5.id AND p5.ODSIsCurrent = 1 AND p5.[ODSDMLOperation] <> 'D'
    LEFT JOIN [Akoranga].[mdl_course_categories] p6 ON p5.parent = p6.id AND p6.ODSIsCurrent = 1 AND p6.[ODSDMLOperation] <> 'D'
    LEFT JOIN [Akoranga].[mdl_course_categories] p7 ON p6.parent = p7.id AND p7.ODSIsCurrent = 1 AND p7.[ODSDMLOperation] <> 'D'
    LEFT JOIN [Akoranga].[mdl_course_categories] p8 ON p7.parent = p8.id AND p8.ODSIsCurrent = 1 AND p8.[ODSDMLOperation] <> 'D'
    LEFT JOIN [Akoranga].[mdl_course_categories] p9 ON p8.parent = p9.id AND p9.ODSIsCurrent = 1 AND p9.[ODSDMLOperation] <> 'D'
    WHERE c.ODSIsCurrent = 1 AND c.[ODSDMLOperation] <> 'D'
) mcc ON mc.category = mcc.id AND mc.ODSIsCurrent = 1 AND mc.[ODSDMLOperation] <> 'D'
LEFT OUTER JOIN [Akoranga].[mdl_course_info_data] mcid ON mc.id = mcid.course_id AND mcid.ODSIsCurrent = 1 AND mcid.[ODSDMLOperation] <> 'D'
WHERE mc.ODSIsCurrent = 1 AND mc.[ODSDMLOperation] <> 'D';