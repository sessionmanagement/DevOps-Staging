CREATE   VIEW [ETL].[fact_employee_program_progress] AS 

/**********************************************************************************************************
REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		2024-06-11   Manish Singh		Initial creation of View
1.1		2024-07-17   Manish Singh		Changed joining condition to filter Cohot type 
1.2     2024-08-09   Manish Singh		Changed query condition to check default vs complete records 
1.3     2024-08-14	 Manish Singh		Changed flag name as per agrred naming convention
1.4     2024-10-02	 Manish Singh		Handling deleted records 
1.5     2024-10-10   Manish Singh	    Change date columns from UTC to NZT 
2.0     2024-11-18    Manish Singh     Join newly created view to get missing BU,postion name for missing akoranga records

**********************************************************************************************************/

SELECT DISTINCT 
       program_completion.id AS fact_employee_program_progress_id,
       Case WHEN mo.id_number IS NULL then reu.businessUnit_name ELSE mo.id_number END AS employee_organisation_id,
	   reu.[businessEntity_name] as employee_primary_company_name,
       program_completion.position_id AS employee_position_id,
       program_completion.program_id AS employee_program_id,
       mu.id_number AS employee_program_progress_user_id,
       program_completion.course_set_id AS employee_course_set_id,
       program_completion.certif_status AS employee_program_status,
       ISNULL(CONVERT(VARCHAR, DATEADD(SECOND, program_completion.time_started, '1970-01-01') AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time', 23), '1 January 1900') AS employee_program_started_date,
       ISNULL(CONVERT(VARCHAR, DATEADD(SECOND, program_completion.time_due, '1970-01-01') AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time', 23), '31 December 2999 23:59:59') AS employee_program_due_date,
       ISNULL(CONVERT(VARCHAR, DATEADD(SECOND, program_completion.time_completed, '1970-01-01') AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time', 23), '31 December 2999 23:59:59') AS employee_program_completed_date,
       ISNULL(CONVERT(VARCHAR, DATEADD(SECOND, program_completion.time_created, '1970-01-01') AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time', 23), '31 December 2999 23:59:59') AS employee_program_created_date,
       CASE WHEN po.full_name IS NULL THEN reu.position_title_name ELSE po.full_name END   AS employee_position_name,
       ctx.context_level AS employee_context_level,
       ctx.path AS employee_program_path,
       ctx.depth AS employee_program_depth,
       ctx.parent_id AS employee_parent_program_id,
       ISNULL(CONVERT(VARCHAR, DATEADD(SECOND, prog_user_assignment.time_assigned, '1970-01-01') AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time', 23), '31 December 2999 23:59:59') AS employee_program_assigned_date,
       prog_user_assignment.exception_status AS employee_program_exception_status,
       CASE WHEN f2f.course IS NOT NULL THEN 1 ELSE 0 END AS is_program_delivered_face_to_face_flag
FROM [Akoranga].[mdl_prog] base
    INNER JOIN [Akoranga].[mdl_prog_completion] program_completion
        ON base.id = program_completion.program_id AND program_completion.course_set_id = 0 AND program_completion.odsiscurrent = 1 AND program_completion.[ODSDMLOperation]<>'D'
    INNER JOIN [Akoranga].[mdl_context] ctx
        ON ctx.instance_id = base.id AND ctx.context_level = 45 AND ctx.odsiscurrent = 1 AND ctx.[ODSDMLOperation]<>'D'
    LEFT JOIN (SELECT pua2.*
                  FROM (SELECT MAX(id) AS id, program_id, user_id
                        FROM [Akoranga].[mdl_prog_user_assignment]
                        WHERE odsiscurrent = 1 AND [ODSDMLOperation]<>'D'
                        GROUP BY user_id, program_id) AS pua
                  INNER JOIN [Akoranga].[mdl_prog_user_assignment] AS pua2
                    ON pua2.id = pua.id AND pua2.odsiscurrent = 1 AND pua2.[ODSDMLOperation]<>'D') prog_user_assignment
        ON program_completion.program_id = prog_user_assignment.program_id AND program_completion.user_id = prog_user_assignment.user_id
LEFT OUTER JOIN (
    SELECT DISTINCT id, id_number
    FROM [Akoranga].[mdl_org]
    WHERE odsiscurrent = 1 AND [ODSDMLOperation]<>'D'
    --Remove invalid services (will get it from IntelliHR join instead)
    and id_number not in ('Southern Community Services'
                                        ,'Mind & Body'
                                        ,'Emerge Aotearoa Housing Trust'
                                        ,'Kainga Ake Ake'
                                        ,'EH Christchurch'
                                        ,'Previous Business Unit/s'
                                        ,'Kaimahi'
                                        ,'TEST')



) AS mo
    ON program_completion.organisation_id = mo.id
LEFT JOIN [Akoranga].[mdl_pos] AS po
    ON program_completion.position_id = po.id AND po.odsiscurrent = 1 AND po.[ODSDMLOperation]<>'D'
LEFT OUTER JOIN (
    SELECT DISTINCT id, id_number
    FROM [Akoranga].[mdl_user]
    WHERE odsiscurrent = 1 AND [ODSDMLOperation]<>'D'
) AS mu
    ON program_completion.user_id = mu.id
LEFT OUTER JOIN (SELECT DISTINCT course FROM [Akoranga].[mdl_facetoface] WHERE odsiscurrent = 1 AND [ODSDMLOperation]<>'D') AS f2f 
    ON base.id = f2f.course
	LEFT JOIN [dbo].[reference_employee_business_unit] reu on cast(mu.id_number as nvarchar(50))=cast(reu.person_employeeNumber as nvarchar(50))
WHERE (1 = 1)
   AND (base.category != 0  AND CASE WHEN prog_user_assignment.exception_status IN (1,2)
                THEN 1 ELSE 0 END = 0)
    AND ((( ( base.id IN ( SELECT map.program_id AS id
                 FROM [Akoranga].[mdl_totara_core_program_vis_map] map
                 JOIN (
                     SELECT vh_ctx.instance_id AS id, vh_ra.role_id
                       FROM [Akoranga].[mdl_context] vh_ctx
                       JOIN [Akoranga].[mdl_context_map] vh_cm ON vh_cm.child_id = vh_ctx.id
                       JOIN (
                             SELECT 7 AS role_id, 1 AS context_id
                             UNION
                             SELECT 8 AS role_id, 2 AS context_id
                             UNION
                             SELECT role_id, context_id FROM [Akoranga].[mdl_role_assignments] uq_role_ass_alias_1 
                       ) vh_ra ON vh_ra.context_id = vh_cm.parent_id
                      WHERE vh_ctx.context_level = 45 AND vh_ctx.odsiscurrent = 1 AND vh_ctx.[ODSDMLOperation]<>'D') vh_x ON vh_x.id = map.program_id AND vh_x.role_id = map.role_id  GROUP BY map.program_id  HAVING COUNT(map.role_id) > 0 )
                       OR ( ( base.audience_visible <> 3 AND ( base.audience_visible = 1 OR ( base.audience_visible = 1 AND EXISTS (
                            SELECT 1
                              FROM [Akoranga].[mdl_cohort_visibility] vw_cv
                              JOIN [Akoranga].[mdl_cohort_members] vw_cm ON vw_cv.cohort_id = vw_cm.cohort_id
                             WHERE vw_cv.instance_id = base.id
                               AND vw_cv.instance_type = 45
                               AND vw_cv.odsiscurrent = 1 AND vw_cv.[ODSDMLOperation]<>'D'
                        ) ) OR ( base.audience_visible IN (0, 1) AND EXISTS (
                    SELECT 1
                      FROM [Akoranga].[mdl_prog_user_assignment] pua
                     WHERE pua.program_id = base.id
                       AND pua.odsiscurrent = 1 AND pua.[ODSDMLOperation]<>'D') ) ) ) AND  ((base.available = 1) AND
                          (base.available_from = 0 OR base.available_from < 1723509756) AND
                          (base.available_until = 0 OR base.available_until > 1723509756)) ) ) )) OR (program_completion.certif_status > 0))
    AND base.certif_id IS NULL AND base.odsiscurrent = 1 AND base.[ODSDMLOperation]<>'D'
;