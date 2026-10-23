
CREATE      view [ETL].[dim_employee_incident]

as

/**********************************************************************************************************
 View		[ETL].[dim_employee_incident]
 Author		Pankaj Bhatt
 Created	2025-12-17
 Purpose	Used to build the edw.dim_employee_incident table 

 **************************************************************************************************************
--REVISIONS:
--Version	 Date			Author			Description
---------	 ------------	---------------	--------------------------
--1.0		 2025-12-17		Pankaj Bhatt	Initial version

**************************************************************************************************************/


with incident_investigations as
(
select *
FROM [EcoPortal].[incident_investigations]
where ODSIsCurrent = 1
),
locations_list as
(
select 
    ii.page_uid,
    STRING_AGG(json_element.ename, ' | ') AS pipe_separated_location_names
FROM incident_investigations ii
CROSS APPLY OPENJSON(ii.locations_raw_json)
WITH (
    ename NVARCHAR(1000) '$.name'
) AS json_element
WHERE
    ii.locations_raw_json IS NOT NULL
GROUP BY
        ii.page_uid
),
primary_location AS
(
    SELECT
        ii.page_uid,
        json_element.ename AS location_name
    FROM incident_investigations ii
    CROSS APPLY OPENJSON(ii.locations_raw_json, '$[0]')
    WITH (
        ename NVARCHAR(1000) '$.name'
    ) AS json_element
    WHERE
        ii.locations_raw_json IS NOT NULL
),
tags_list as
(
select 
    ii.page_uid,
    STRING_AGG(json_element.[value], ' | ') AS pipe_separated_tag_names
FROM incident_investigations ii
CROSS APPLY OPENJSON(ii.tags_raw_json) AS json_element
WHERE
    ii.tags_raw_json IS NOT NULL
GROUP BY
        ii.page_uid
),
location_tag_list as 
(
select
    ii.page_uid,
    STRING_AGG(json_element.ename, ' | ') as pipe_separated_location_tag
from incident_investigations ii
CROSS APPLY OPENJSON(isnull(ii.rpt_null_location_tagfield,ii.rpt_empty_location_tagfield))
WITH (
    ename NVARCHAR(1000) '$.name'
    ) as json_element
where 
    isnull(ii.rpt_null_location_tagfield,ii.rpt_empty_location_tagfield) IS NOT NULL
group by ii.page_uid
),
severity_details as
(
select
    ii.page_uid,
    -- Parsing Likelihood Guidance
    likelihood_guidance.ename as actual_likelihood_guidance,
    -- Parsing Likelihood Occurrence
    likelihood_occurrence.ename as actual_likelihood_occurrence,
    -- Parsing Severity Level
    severity_level.ename as actual_severity_level,
    -- Parsing Severity Consequence
    severity_consequence.ename as actual_severity_consequence
FROM incident_investigations ii
-- Likelihood Guidance
OUTER APPLY (
    SELECT ename
    FROM OPENJSON(ii.ai_actual_severity_likelihood_guidance_select)
    WITH (
        ename NVARCHAR(255) '$.name',
        selected BIT '$.selected'
    )
    WHERE selected = 1
) AS likelihood_guidance

-- Likelihood Occurrence
OUTER APPLY (
    SELECT ename
    FROM OPENJSON(ii.ai_actual_severity_likelihood_occurrence_select)
    WITH (
        ename NVARCHAR(255) '$.name',
        selected BIT '$.selected'
    )
    WHERE selected = 1
) AS likelihood_occurrence

-- Severity Level
OUTER APPLY (
    SELECT ename
    FROM OPENJSON(ii.ai_actual_severity_level_select)
    WITH (
        ename NVARCHAR(255) '$.name',
        selected BIT '$.selected'
    )
    WHERE selected = 1
) AS severity_level

-- Severity Consequence
OUTER APPLY (
    SELECT ename
    FROM OPENJSON(ii.ai_actual_severity_consequence_select)
    WITH (
        ename NVARCHAR(255) '$.name',
        selected BIT '$.selected'
    )
    WHERE selected = 1
) AS severity_consequence
),
ongoing_risk_details as
(
select
    ii.page_uid,
    -- Parsing Ongoing Risk Likelihood Guidance (ai_ongoing_risk_likelihood_guidance_select)
    ongoing_likelihood_guidance.ename as ongoing_risk_likelihood_guidance,
    -- Parsing Ongoing Risk Expected Outcome (ai_ongoing_risk_expected_outcome_select)
    ongoing_expected_outcome.ename as ongoing_risk_expected_outcome,
    -- Parsing Ongoing Risk Level (ai_ongoing_risk_level_select)
    ongoing_risk_level.ename as ongoing_risk_level,
    -- Parsing Ongoing Risk Reoccurrence Likelihood (ai_ongoing_risk_reoccurrence_likelihood_select)
    ongoing_reoccurrence_likelihood.ename as ongoing_risk_reoccurrence_likelihood
FROM incident_investigations ii
-- 1. Ongoing Risk Likelihood Guidance
OUTER APPLY (
    SELECT ename
    FROM OPENJSON(ii.ai_ongoing_risk_likelihood_guidance_select)
    WITH (
        ename NVARCHAR(255) '$.name',
        selected BIT '$.selected'
    )
    WHERE selected = 1
) AS ongoing_likelihood_guidance

-- 2. Ongoing Risk Expected Outcome
OUTER APPLY (
    SELECT ename
    FROM OPENJSON(ii.ai_ongoing_risk_expected_outcome_select)
    WITH (
        ename NVARCHAR(255) '$.name',
        selected BIT '$.selected'
    )
    WHERE selected = 1
) AS ongoing_expected_outcome

-- 3. Ongoing Risk Level
OUTER APPLY (
    SELECT ename
    FROM OPENJSON(ii.ai_ongoing_risk_level_select)
    WITH (
        ename NVARCHAR(255) '$.name',
        selected BIT '$.selected'
    )
    WHERE selected = 1
) AS ongoing_risk_level

-- 4. Ongoing Risk Reoccurrence Likelihood
OUTER APPLY (
    SELECT ename
    FROM OPENJSON(ii.ai_ongoing_risk_reoccurrence_likelihood_select)
    WITH (
        ename NVARCHAR(255) '$.name',
        selected BIT '$.selected'
    )
    WHERE selected = 1
) AS ongoing_reoccurrence_likelihood
),
org_details as
(
select
    ii.page_uid,
    -- Parsing business unit
    business_unit.ename as incident_business_unit,
    -- Parsing sub unit
    sub_unit.ename as incident_sub_unit,
    -- Parsing team
    team.ename as incident_team

FROM incident_investigations ii
-- business unit
OUTER APPLY (
    SELECT ename
    FROM OPENJSON(isnull(ii.rpt_null_business_unit_select, ii.rpt_empty_business_unit_select))
    WITH (
        ename NVARCHAR(255) '$.name',
        selected BIT '$.selected'
    )
    WHERE selected = 1
) AS business_unit

-- sub unit
OUTER APPLY (
    SELECT ename
    FROM OPENJSON(isnull(ii.rpt_null_sub_unit_select, ii.rpt_empty_sub_unit_select))
    WITH (
        ename NVARCHAR(255) '$.name',
        selected BIT '$.selected'
    )
    WHERE selected = 1
) AS sub_unit

-- team
OUTER APPLY (
    SELECT ename
    FROM OPENJSON(isnull(ii.rpt_null_team_select, ii.rpt_empty_team_select))
    WITH (
        ename NVARCHAR(255) '$.name',
        selected BIT '$.selected'
    )
    WHERE selected = 1
) AS team
),
selected_attributes_list AS
(
    SELECT
        ii.page_uid,
        involved.pipe_separated_who_involved,
        eyewitness.pipe_separated_eyewitnesses
    FROM
        incident_investigations ii
    -- OUTER APPLY for rpt_null_who_involved_select
    OUTER APPLY (
        SELECT
            STRING_AGG(json_element.name, ' | ') AS pipe_separated_who_involved
        FROM
            OPENJSON(ii.rpt_null_who_involved_select)
            WITH (
                name NVARCHAR(1000) '$.name',
                selected BIT '$.selected'
            ) AS json_element
        WHERE json_element.selected = 1
    ) AS involved
    -- OUTER APPLY for rpt_null_nature_eyewitnesses_select
    OUTER APPLY (
        SELECT
            STRING_AGG(json_element.name, ' | ') AS pipe_separated_eyewitnesses
        FROM
            OPENJSON(ii.rpt_null_nature_eyewitnesses_select)
            WITH (
                name NVARCHAR(1000) '$.name',
                selected BIT '$.selected'
            ) AS json_element
        WHERE json_element.selected = 1
    ) AS eyewitness    
),
selected_checklist_status AS 
(
    SELECT
        ii.page_uid,
        -- 1. Abuse Checklist
        CASE 
            WHEN JSON_VALUE(ii.ai_abuse_null_checklist, '$[0].checked') = 'true' THEN 'Y'
            WHEN JSON_VALUE(ii.ai_abuse_null_checklist, '$[0].checked') = 'false' THEN 'N'
            ELSE NULL
        END AS is_abuse_procedure_in_place,
        -- 2. Assault Checklist
        CASE 
            WHEN JSON_VALUE(ii.ai_assault_null_checklist, '$[0].checked') = 'true' THEN 'Y'
            WHEN JSON_VALUE(ii.ai_assault_null_checklist, '$[0].checked') = 'false' THEN 'N'
            ELSE NULL
        END AS is_assault_procedure_in_place,    
        -- 3. Fire Risk (Cooking) Checklist
        CASE 
            WHEN JSON_VALUE(ii.ai_fire_risk_cooking_null_checklist, '$[0].checked') = 'true' THEN 'Y'
            WHEN JSON_VALUE(ii.ai_fire_risk_cooking_null_checklist, '$[0].checked') = 'false' THEN 'N'
            ELSE NULL
        END AS is_fire_risk_cooking_procedure_in_place,
        -- 4. Fire Risk (Other) Checklist
        CASE 
            WHEN JSON_VALUE(ii.ai_fire_risk_other_null_checklist, '$[0].checked') = 'true' THEN 'Y'
            WHEN JSON_VALUE(ii.ai_fire_risk_other_null_checklist, '$[0].checked') = 'false' THEN 'N'
            ELSE NULL
        END AS is_fire_risk_other_procedure_in_place,
        -- 5. Smoking Checklist
        CASE 
            WHEN JSON_VALUE(ii.ai_smoking_null_checklist, '$[0].checked') = 'true' THEN 'Y'
            WHEN JSON_VALUE(ii.ai_smoking_null_checklist, '$[0].checked') = 'false' THEN 'N'
            ELSE NULL
        END AS is_smoking_procedure_in_place,
         -- 6. Investigation Completed Select
        CASE 
            (SELECT ename
            FROM OPENJSON(ii.ai_investigation_completed_select)
            WITH (
                ename NVARCHAR(255) '$.name',
                selected BIT '$.selected'
            )
            WHERE selected = 1)
         WHEN 'Yes' THEN 'Y' 
         WHEN 'No' THEN 'N' 
         ELSE NULL END AS is_investigation_completed,
         -- 7. Incident in Recordbase
         CASE 
            (SELECT ename
            FROM OPENJSON(ii.rpt_incident_details_in_recordbase_select)
            WITH (
                ename NVARCHAR(255) '$.name',
                selected BIT '$.selected'
            )
            WHERE selected = 1)
         WHEN 'Yes' THEN 'Y' 
         WHEN 'No' THEN 'N' 
         ELSE NULL END AS is_incident_in_recordbase
    FROM
        incident_investigations ii
)

select
    base.page_uid as incident_id,
    base.page_name as incident_title,
    base.current_stage_name as current_stage,
    base.active_stage as active_stage_status,

    REPLACE(
        REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(
                        JSON_VALUE(base.rpt_incident_desc_what_happened_unknown, '$.content')
                        -- Replace non-breaking spaces
                               ,'&nbsp;',' '
                                )
                        -- Forces a space between content from different <p> blocks
                            ,'</p>',' </p>'
                            )
                        -- Correct unclosed <br> tags
                        ,'<br>','<br/>'
                        )
                        -- Correct common unclosed self-closing <meta> tag
                ,'charset=UTF-8">','charset=UTF-8"/>'
                )
                        -- Replace common unclosed <br> tag with class attribute.
              ,'<br class="needsclick">','<br class="needsclick"/>'
            )
            
    as incident_details,

    od.incident_business_unit,
    od.incident_sub_unit,
    od.incident_team,

    isnull(base.rpt_null_specific_location_plaintext, base.rpt_empty_specific_location_plaintext) as incident_specific_location,
    base.rpt_null_specific_site_address_geo as incident_site_address, 

    sal.pipe_separated_who_involved as incident_who_is_involved,
    sal.pipe_separated_eyewitnesses as incident_nature_of_eyewitness,

    sd.actual_likelihood_guidance,
    sd.actual_likelihood_occurrence,
    sd.actual_severity_level,
    sd.actual_severity_consequence,

    ord.ongoing_risk_likelihood_guidance,
    ord.ongoing_risk_expected_outcome,
    ord.ongoing_risk_level,
    ord.ongoing_risk_reoccurrence_likelihood,    

    pl.location_name as incident_primary_location,
    ll.pipe_separated_location_names as incident_locations_list,

    scs.is_abuse_procedure_in_place,
    scs.is_assault_procedure_in_place,
    scs.is_fire_risk_cooking_procedure_in_place,
    scs.is_fire_risk_other_procedure_in_place,
    scs.is_smoking_procedure_in_place,
    scs.is_investigation_completed,

    -- get raw content which is in xml form. Synapse doesn't support TYPE XML.
    -- once in EDW, transform content to get text data
    -- rpt_immediate_actions_taken_unknown,
    REPLACE(
        REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(
                        JSON_VALUE(base.rpt_immediate_actions_taken_unknown, '$.content')
                        -- Replace non-breaking spaces
                               ,'&nbsp;',' '
                                )
                        -- Forces a space between content from different <p> blocks
                            ,'</p>',' </p>'
                            )
                        -- Correct unclosed <br> tags
                        ,'<br>','<br/>'
                        )
                        -- Correct common unclosed self-closing <meta> tag
                ,'charset=UTF-8">','charset=UTF-8"/>'
                )
                        -- Replace common unclosed <br> tag with class attribute.
              ,'<br class="needsclick">','<br class="needsclick"/>'
            )
            
    as incident_immediate_actions_taken,

    --uncomment later if needed
    --tl.pipe_separated_tag_names as incident_tags,
    --ltl.pipe_separated_location_tag as incident_location_tags,

    scs.is_incident_in_recordbase,
    base.rpt_incident_details_recordbase_entry_plaintext as incident_recordbase_detail

from [EcoPortal].[incident_investigations] base

left outer join locations_list ll
on base.page_uid = ll.page_uid

left outer join primary_location pl
on base.page_uid = pl.page_uid

--uncomment later if needed
--left outer join tags_list tl
--on base.page_uid = tl.page_uid

left outer join severity_details sd
on base.page_uid = sd.page_uid

left outer join ongoing_risk_details ord
on base.page_uid = ord.page_uid

left outer join org_details od
on base.page_uid = od.page_uid

--uncomment later if needed
--left outer join location_tag_list ltl
--on base.page_uid = ltl.page_uid

left outer join selected_attributes_list sal
on base.page_uid = sal.page_uid

left outer join selected_checklist_status scs
on base.page_uid = scs.page_uid

/*
TEST incidents
--select * from [ETL].[dim_employee_incident] 
--where incident_id in ('EVN-01859','EVN-04346','EVN-03757','EVN-04560','EVN-04567','EVN-03074')
where incident_id = 'EVN-04343' --'EVN-02346' --'EVN-04314' --'EVN-03512' --'EVN-03677'
--where incident_id in ('EVN-04677','EVN-04680','EVN-04681','EVN-04682')
--where incident_immediate_actions_taken like '%Checked any cable lying down but found nothing%'
--order by incident_id
*/

where base.ODSIsCurrent = 1