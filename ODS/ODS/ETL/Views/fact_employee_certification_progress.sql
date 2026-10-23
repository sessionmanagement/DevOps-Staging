CREATE VIEW [ETL].[fact_employee_certification_progress] AS 

/**********************************************************************************************************
REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		2024-06-11   Manish Singh		Initial creation of View
1.1		2024-07-17   Manish Singh		Changed joining condition to filter Cohot type 
1.2     2024-08-09   Manish Singh		Changed query condition to check default vs complete records 
1.3     2024-08-14	 Manish Singh		Changed flag name as per agrred naming convention
1.4     2024-10-02	 Manish Singh		Handling deleted records 
1.5 	2024-10-10   Manish Singh		Added certification assigned date column in view
1.6     2024-10-10   Manish Singh	    Change date columns from UTC to NZT 
2.0     2024-11-18   Manish Singh       Join newly created view to get missing BU,postion name for missing akoranga records
2.1     2025-02-27   Manish Singh		For Program completion ODSiscurrent need to apply 
2.2     2025-09-12   Greg Nuthall       Remove course completion organisations which are not services
2.3     2025-12-16   Greg Nuthall       Remove test employee
**********************************************************************************************************/

SELECT DISTINCT
       certif_completion.id AS fact_employee_certification_progress_id,
       base.full_name,
       Case WHEN mo.id_number IS NULL then reu.businessUnit_name ELSE  mo.id_number END AS employee_organisation_id,
	   reu.[businessEntity_name] as employee_primary_company_name,
       prog_completion.position_id   AS employee_position_id,
       mu.id_number AS employee_certification_progress_user_id,
       prog_completion.course_set_id AS employee_course_set_id,
       certif_completion.status AS employee_certification_status,
       certif_completion.certif_path AS is_recertification,
       certif_completion.unassigned AS is_unassigned_to_employee_flag,
       CAST(CASE 
            WHEN prog_completion.time_created IS NULL OR prog_completion.time_created = 0 THEN '1900-01-01'
            ELSE CONVERT(VARCHAR, DATEADD(SECOND, prog_completion.time_created, '1970-01-01') AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time', 23)
       END AS DATE) AS employee_certification_assigned_date,
       CAST(CASE 
            WHEN prog_completion.time_due IS NULL OR prog_completion.time_due = 0 THEN '1900-01-01'
            ELSE CONVERT(VARCHAR, DATEADD(SECOND, prog_completion.time_due, '1970-01-01') AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time', 23)
       END AS DATE) AS employee_certification_due_date,
       CAST(CASE 
            WHEN certif_completion.time_expires IS NULL OR certif_completion.time_expires = 0 THEN '1900-01-01'
            ELSE CONVERT(VARCHAR, DATEADD(SECOND, certif_completion.time_expires, '1970-01-01') AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time', 23)
       END AS DATE) AS employee_certification_expiry_date,
       CAST(CASE 
            WHEN certif_completion.time_window_opens IS NULL OR certif_completion.time_window_opens = 0 THEN '1900-01-01'
            ELSE CONVERT(VARCHAR, DATEADD(SECOND, certif_completion.time_window_opens, '1970-01-01') AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time', 23)
       END AS DATE) AS employee_certification_window_opens_date,
       CAST(CASE 
            WHEN certif_completion.time_completed IS NULL OR certif_completion.time_completed = 0 THEN '1900-01-01'
            ELSE CONVERT(VARCHAR, DATEADD(SECOND, certif_completion.time_completed, '1970-01-01') AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time', 23)
       END AS DATE) AS employee_certification_completed_date,
       certif_completion.renewal_status AS employee_certification_renewal_status,
       certif_completion_history.historycount AS employee_certification_completion_history_link,
       certif_completion.certif_id AS employee_certification_id,
       CAST(CASE 
            WHEN certif_completion_history.time_completed IS NULL OR certif_completion_history.time_completed = 0 
                THEN '1900-01-01'
            ELSE CONVERT(VARCHAR, DATEADD(SECOND, certif_completion_history.time_completed, '1970-01-01') 
                AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time', 23)
       END AS DATE) AS employee_certification_completed_history_date,
       ctx.context_level AS employee_context_level,
       ctx.path AS employee_certification_path,
       ctx.depth AS employee_certification_depth,
       ctx.parent_id AS employee_parent_certification_id,
       CASE WHEN po.full_name IS NULL THEN reu.position_title_name ELSE po.full_name END   AS employee_position_name,
       CASE WHEN f2f.course IS NOT NULL THEN 1 ELSE 0 END AS is_cerification_delivered_face_to_face_flag
 FROM [Akoranga].[mdl_prog] base
    INNER JOIN (SELECT CONCAT('active', cc.id) AS uniqueid,
                        cc.id,
                        cc.certif_id,
                        cc.user_id,
                        cc.certif_path,
                        cc.status,
                        cc.renewal_status,
                        cc.time_window_opens,
                        cc.time_expires,
                        cc.time_completed,
                        cc.time_modified,
                        0 as unassigned
                    FROM [Akoranga].[mdl_certif_completion] cc
                    WHERE cc.odsiscurrent = 1 AND cc.ODSDMLOperation<>'D'
                    UNION ALL
                    SELECT CONCAT('history', cch.id) AS uniqueid,
                        cch.id,
                        cch.certif_id,
                        cch.user_id,
                        cch.certif_path,
                        cch.certif_status,
                        cch.renewal_status,
                        cch.time_window_opens,
                        cch.time_expires,
                        cch.time_completed,
                        cch.time_modified,
                        cch.unassigned
                    FROM [Akoranga].[mdl_certif_completion_history] cch
                    LEFT JOIN [Akoranga].[mdl_certif_completion] cc 
                        ON cc.certif_id = cch.certif_id AND cc.user_id = cch.user_id
                    WHERE cch.unassigned = 1
                    AND cc.id IS NULL
                    AND cch.odsiscurrent = 1 AND cch.ODSDMLOperation<>'D') certif_completion
        ON (certif_completion.certif_id = base.certif_id)
		  INNER JOIN [Akoranga].[mdl_context] ctx
        ON ctx.instance_id = base.id AND ctx.context_level = 45 AND ctx.ODSDMLOperation<>'D' AND ctx.ODSIsCurrent=1
    LEFT JOIN [Akoranga].[mdl_prog_completion] prog_completion
        ON (prog_completion.program_id = base.id
                    AND prog_completion.course_set_id = 0
                    AND prog_completion.user_id = certif_completion.user_id 
                    AND prog_completion.ODSDMLOperation<>'D' 
                    AND prog_completion.ODSIsCurrent=1 )
			
    LEFT OUTER JOIN (
        SELECT DISTINCT id, id_number
        FROM [Akoranga].[mdl_org]
        WHERE odsiscurrent = 1 AND ODSDMLOperation<>'D'
        --Remove invalid services (will get it from IntelliHR join instead)
        and id_number not in ('Southern Community Services'
                                        ,'Mind & Body'
                                        ,'Emerge Aotearoa Housing Trust'
                                        ,'Kainga Ake Ake'
                                        ,'EH Christchurch'
                                        ,'Previous Business Unit/s'
                                        ,'Kaimahi'
                                        ,'TEST')
    ) mo
        ON prog_completion.organisation_id = mo.id
    LEFT JOIN [Akoranga].[mdl_pos] AS po
        ON prog_completion.position_id = po.id AND po.odsiscurrent = 1 AND po.ODSDMLOperation<>'D'
   		LEFT OUTER JOIN (
        SELECT DISTINCT id, id_number
        FROM [Akoranga].[mdl_user]
        WHERE odsiscurrent = 1 AND ODSDMLOperation<>'D'
    ) AS mu
        ON prog_completion.user_id = mu.id
    LEFT JOIN (SELECT CONCAT(user_id, certif_id) AS uniqueid,
                    user_id,
                    certif_id,
                    COUNT(id) AS historycount,
                    MAX(time_completed) AS time_completed
                    FROM [Akoranga].[mdl_certif_completion_history]
                    WHERE unassigned = 0
                    AND odsiscurrent = 1 AND ODSDMLOperation<>'D'
                    GROUP BY user_id, certif_id) certif_completion_history
        ON (certif_completion_history.certif_id = base.certif_id
                    AND certif_completion_history.user_id = certif_completion.user_id) 
  LEFT OUTER JOIN (
        SELECT DISTINCT course
        FROM [Akoranga].[mdl_facetoface]
        WHERE odsiscurrent = 1 AND ODSDMLOperation<>'D'
    ) AS f2f
        ON certif_completion.certif_id = f2f.course   
		left outer join [dbo].[reference_employee_business_unit] reu 
            on cast(mu.id_number as nvarchar(50))=cast(reu.person_employeeNumber as nvarchar(50))

WHERE (1=1)
    AND (base.category != 0)
    AND ((( ( base.id IN ( SELECT map.program_id AS id
                 FROM [Akoranga].[mdl_totara_core_certification_vis_map] map
                 JOIN (
                     SELECT vh_ctx.instance_id AS id, vh_ra.role_id
                       FROM [Akoranga].[mdl_context] vh_ctx
                       JOIN [Akoranga].[mdl_context_map] vh_cm ON vh_cm.child_id = vh_ctx.id
                       JOIN (
                             SELECT 7 AS role_id, 1 AS contextid
                             UNION
                             SELECT 8 AS role_id, 2 AS contextid
                             UNION
                             SELECT role_id, context_id AS contextid
                             FROM [Akoranga].[mdl_role_assignments] uq_role_ass_alias_1
                             WHERE uq_role_ass_alias_1.user_id = 2639
                       ) vh_ra ON vh_ra.contextid = vh_cm.parent_id
                      WHERE vh_ctx.context_level = 45 AND vh_ctx.ODSDMLOperation<>'D') vh_x
                 ON vh_x.id = map.program_id AND vh_x.role_id = map.role_id 
                 GROUP BY map.program_id
                 HAVING COUNT(map.role_id) > 0 ) 
                 OR ( ( base.audience_visible <> 3
                        AND ( base.audience_visible = 2
                              OR ( base.audience_visible = 1
                                   AND EXISTS (
                                       SELECT 1
                                       FROM [Akoranga].[mdl_cohort_visibility] vw_cv
                                       JOIN [Akoranga].[mdl_cohort_members] vw_cm ON vw_cv.cohort_id = vw_cm.cohort_id
                                       WHERE vw_cv.instance_id = base.id
                                       AND vw_cv.instance_type = 55 AND vw_cv.ODSDMLOperation<>'D'
                                   ) )
                              OR ( base.audience_visible IN (1, 0)
                                   AND EXISTS (
                                       SELECT 1
                                       FROM [Akoranga].[mdl_prog_user_assignment] pua
                                       WHERE pua.program_id = base.id AND pua.ODSDMLOperation<>'D'
                                   ) ) ) )
                        AND ((base.available = 1)
                             AND (base.available_from = 0 OR base.available_from < 1723154869)
                             AND (base.available_until = 0 OR base.available_until > 1723154869)) ) ) ))
    OR (certif_completion.status > 1))
    AND (base.certif_id > 0) 
    AND base.odsiscurrent = 1 
    AND base.ODSDMLOperation<>'D'
    and mu.id_number <> '5000001' --test employee