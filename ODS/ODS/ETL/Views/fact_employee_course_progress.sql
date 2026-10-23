--drop view [ETL].fact_employee_course_progress
CREATE VIEW [ETL].[fact_employee_course_progress] AS 

/**********************************************************************************************************
REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		2024-06-11   Manish Singh		Initial creation of View
1.1		2024-07-17   Manish Singh		Changed joining condition to filter Cohot type 
1.2     2024-08-09   Manish Singh		Changed query condition to check default vs complete records 
1.2     2024-08-14	 Manish Singh		Changed flag name as per agrred naming convention
1.4     2024-09-03   Manish Singh		Divided query in sub-queries to handle performance issue
1.5     2024-10-02	 Manish Singh		Handling deleted records 
1.6     2024-10-10   Manish Singh	    Change date columns from UTC to NZT 
1.7     2024-10-29   Manish Singh       New column is_course_linked_to_certification_flag in the SELECT statement
1.8     2024-11-18   Manish Singh       Join newly created view to get missing BU,postion name for missing akoranga records
1.9     2025-09-12   Manish Singh       Remove invalid organisations from Akoranga loads (Feature #11248)
2.0     2025-12-15   Greg Nuthall       Remove test employee   
**********************************************************************************************************/



WITH Base AS (
    SELECT id, user_id, instance_id AS course_id
    FROM [akoranga].[mdl_dp_record_of_learning]
    WHERE type = 1 AND ODSiscurrent = 1 AND [ODSDMLOperation]<>'D'
),
CourseCompletion AS (
    SELECT 
        base.id AS base_id, 
        base.user_id, 
        base.course_id, 
        course_completion.id AS course_completion_id,
        course_completion.time_enrolled,
        course_completion.time_started,
        course_completion.time_completed,
        course_completion.status,
        course_completion.renewal_status,
        course_completion.due_date,
        course_completion.position_id,
        course_completion.organisation_id,
        course_completion.rpl_grade
    FROM Base base
    LEFT JOIN [akoranga].[mdl_course_completions] course_completion 
    ON base.course_id = course_completion.course 
    AND base.user_id = course_completion.user_id 
    AND course_completion.ODSiscurrent = 1 AND course_completion.[ODSDMLOperation]<>'D'
),
EnrolType AS (
    SELECT ue.user_id, e.course_id, STRING_AGG(e.enrol, '|') AS enrol_type
    FROM [Akoranga].[mdl_enrol] e
    JOIN [Akoranga].[mdl_user_enrolments] ue ON ue.enrol_id = e.id
    WHERE e.odsiscurrent = 1 AND ue.odsiscurrent = 1 AND e.[ODSDMLOperation]<>'D' AND ue.[ODSDMLOperation]<>'D'
    GROUP BY ue.user_id, e.course_id
    HAVING STRING_AGG(e.enrol, '|') LIKE '%cohort%'
)
SELECT DISTINCT 
    base.id AS fact_employee_course_progress_id,
    mu.id_number AS employee_course_progress_user_id,
    base.course_id AS employee_course_id,
    Case WHEN mo.id_number IS NULL then reu.businessUnit_name ELSE  mo.id_number END AS employee_organisation_id,
	reu.[businessEntity_name] as employee_primary_company_name,
    course_completion.position_id AS employee_position_id,
    ISNULL(DATEADD(SECOND, course_completion.time_enrolled, '1970-01-01'), '1 January 1900') AS employee_course_enrolled_date,
    ISNULL(DATEADD(SECOND, course_completion.time_started, '1970-01-01'), '1 January 1900') AS employee_course_started_date,
    ISNULL(DATEADD(SECOND, course_completion.time_completed, '1970-01-01'), '31 December 2999 23:59:59') AS employee_course_completed_date,
    course_completion.status AS employee_course_completion_percentage,
    course_completion.renewal_status AS employee_course_renewal_status,
    ISNULL(DATEADD(SECOND, course_completion.due_date, '1970-01-01'), '31 December 2999 23:59:59') AS employee_course_due_date,
    CASE WHEN po.full_name IS NULL THEN reu.position_title_name ELSE po.full_name END   AS employee_position_name,
    CASE WHEN f2f.course IS NOT NULL THEN 1 ELSE 0 END AS is_course_delivered_face_to_face_flag,
    (SELECT COUNT(*) FROM [Akoranga].[mdl_course_completion_history] cch1 
     WHERE cch1.user_id = base.id AND cch1.course_id = base.course_id AND cch1.[ODSDMLOperation]<>'D') AS employee_course_completion_history_previous_completion,
    CASE WHEN course_completion.status = 75 THEN course_completion.rpl_grade ELSE grade_grades.final_grade END AS employee_course_completion_grade,
    CASE WHEN enrol_type.enrol_type IS NOT NULL THEN 1 ELSE 0 END AS is_course_core_training_flag,
	CASE WHEN COALESCE(course_1.data, course_1_field_default.default_data)='Not linked to certification' then 0 else 1 end is_course_linked_to_certification_flag
FROM Base base
INNER JOIN [akoranga].[mdl_course] course ON course.id = base.course_id AND course.ODSiscurrent = 1 AND course.[ODSDMLOperation]<>'D'
LEFT JOIN CourseCompletion course_completion ON base.id = course_completion.base_id
LEFT JOIN [akoranga].[mdl_grade_items] grade_items ON grade_items.course_id = base.course_id AND grade_items.item_type = 'course' AND grade_items.ODSiscurrent = 1 AND grade_items.[ODSDMLOperation]<>'D'
LEFT JOIN [akoranga].[mdl_grade_grades] grade_grades ON grade_grades.item_id = grade_items.id AND grade_grades.user_id = base.user_id AND grade_grades.ODSiscurrent = 1 AND grade_grades.[ODSDMLOperation]<>'D'
LEFT JOIN [akoranga].[mdl_course_info_data] course_1 ON course_1.course_id = course.id AND course_1.field_id = 1 AND course_1.ODSiscurrent = 1 AND course_1.[ODSDMLOperation]<>'D'
LEFT JOIN [akoranga].[mdl_course_info_field] course_1_field_default ON course_1_field_default.id = 1 AND course_1_field_default.ODSiscurrent = 1 AND course_1_field_default.[ODSDMLOperation]<>'D'
LEFT JOIN [akoranga].[mdl_context] ctx ON ctx.instance_id = course.id AND ctx.context_level = 50 AND ctx.ODSiscurrent = 1 AND ctx.[ODSDMLOperation]<>'D'
LEFT JOIN (SELECT DISTINCT course FROM [Akoranga].[mdl_facetoface] WHERE ODSiscurrent = 1 AND [ODSDMLOperation]<>'D') AS f2f ON base.course_id = f2f.course
LEFT JOIN [Akoranga].[mdl_pos] AS po ON course_completion.position_id = po.id AND po.ODSiscurrent = 1 AND po.[ODSDMLOperation]<>'D'
LEFT JOIN (SELECT DISTINCT id, id_number FROM [Akoranga].[mdl_user] WHERE odsiscurrent = 1 AND [ODSDMLOperation]<>'D') AS mu ON base.user_id = mu.id
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
    ) mo ON course_completion.organisation_id = mo.id
LEFT JOIN EnrolType enrol_type ON base.user_id = enrol_type.user_id AND base.course_id = enrol_type.course_id
LEFT JOIN [dbo].[reference_employee_business_unit] reu on cast(mu.id_number as nvarchar(50))=cast(reu.person_employeeNumber as nvarchar(50))
WHERE --COALESCE(course_1.data, course_1_field_default.default_data) = 'Not linked to certification'
--AND 
(course_completion.status > 10 OR (
    course.id IN (
        SELECT map.course_id
        FROM [akoranga].[mdl_totara_core_course_vis_map] map
        JOIN (
            SELECT vh_ctx.instance_id, vh_ra.role_id
            FROM [akoranga].[mdl_context] vh_ctx
            JOIN [akoranga].[mdl_context_map] vh_cm ON vh_cm.child_id = vh_ctx.id
            JOIN (
                SELECT 7 AS role_id, 1 AS context_id
                UNION
                SELECT 8 AS role_id, 2 AS context_id
                UNION
                SELECT role_id, context_id FROM [akoranga].[mdl_role_assignments] uq_role_ass_alias_1
            ) vh_ra ON vh_ra.context_id = vh_cm.parent_id
            WHERE vh_ctx.context_level = 50 AND vh_ctx.ODSiscurrent = 1 AND vh_ctx.[ODSDMLOperation]<>'D'
        ) vh_x ON vh_x.instance_id = map.course_id AND vh_x.role_id = map.role_id
        GROUP BY map.course_id
        HAVING COUNT(map.role_id) > 0
    ) OR (
        course.audience_visible <> 3 AND (
            course.audience_visible = 2 OR (
                course.audience_visible = 1 AND EXISTS (
                    SELECT 1
                    FROM [akoranga].[mdl_cohort_visibility] vw_cv
                    JOIN [akoranga].[mdl_cohort_members] vw_cm ON vw_cv.cohort_id = vw_cm.cohort_id
                    WHERE vw_cv.instance_id = course.id
                    AND vw_cv.instance_type = 50
                    AND vw_cv.ODSiscurrent = 1 AND vw_cv.[ODSDMLOperation]<>'D'
                    AND vw_cm.ODSiscurrent = 1 AND vw_cm.[ODSDMLOperation]<>'D'
                )
            ) OR (
                course.audience_visible IN (1) AND EXISTS (
                    SELECT 1
                    FROM [akoranga].[mdl_user_enrolments] ua_ue
                    JOIN [akoranga].[mdl_enrol] ua_e ON ua_e.id = ua_ue.enrol_id
                    WHERE ua_e.course_id = course.id
                    AND ua_e.ODSiscurrent = 1 AND ua_e.[ODSDMLOperation]<>'D'
                    AND ua_ue.ODSiscurrent = 1 AND ua_ue.[ODSDMLOperation]<>'D'
                )
            )
        )
    )
)
)

and mu.id_number <> '5000001'
--AND  base.user_id=3644