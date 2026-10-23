CREATE view [ETL].[dim_client_outcome_questions]

/****************************************************************************************************************
 View		[ETL].[dim_client_outcome_questions]
 Author		Malhar Badheka
 Created	2026-07-31
 Purpose	Lookup of question text for the outcome tool questions pivoted into columns (Q1-Q25, Q1A-Q4D etc.)
			on ETL.fact_client_assessment_outcome. Built from RBEAL/RBMNB.otDimOutcomeToolTemplate.

 ***************************************************************************************************************
--REVISIONS:
--Version	Date			Author			Description
---------	------------	------------	--------------------------
--1.0		2026-07-31 		Malhar Badheka	Initial version
****************************************************************************************************************/

as

select 1 as company_key
	,Template.OutcomeToolTemplateID as outcome_tool_template_id
	,Template.OutcomeToolTitle as outcome_tool_title
	--OutcomeToolTitle groups multiple SDQ variants (SDQ%) under one type
	,case
		when Template.OutcomeToolTitle like 'SDQ%' then 'SDQ'
		else Template.OutcomeToolTitle
	end as outcome_tool_type
	,Template.OutcomeToolQuestionID as outcome_tool_question_id
	,Template.QuestionText as question_text
	,Template.QuestionType as question_type
from rbeal.otDimOutcomeToolTemplate Template
where (Template.OutcomeToolQuestionID IN ('q1','q2','q3','q4','q5','q6','q7','q8','q9','q10','q11','q12','q1A'
	,'q2A','q3A','q4A','q1B','q2B','q3B','q4B','q1C','q2C','q3C','q4C','q1D','q2D','q3D','q4D')
	and Template.OutcomeToolTitle IN (
		'kessler 10',
		'matrix',
		'Hua Oranga - Primary Care'
	) or (Template.OutcomeToolTitle like 'SDQ%' and Template.OutcomeToolQuestionID IN (
		'Q1','Q2','Q3','Q4','Q5','Q6','Q7','Q8','Q9','Q10','Q11','Q12','Q13','Q14','Q15','Q16','Q17','Q18','Q19','Q20','Q21','Q22','Q23','Q24','Q25'
	,'Prosocial'
	,'Peer'
	,'Hyperactivity'
	,'Emotional'
	,'Conduct'
	,'Assessor'
	,'AssessmentDate'
	,'TotalDifficulties')))

union all
select 5 as company_key
	,Template.OutcomeToolTemplateID as outcome_tool_template_id
	,Template.OutcomeToolTitle as outcome_tool_title
	,case
		when Template.OutcomeToolTitle like 'SDQ%' then 'SDQ'
		else Template.OutcomeToolTitle
	end as outcome_tool_type
	,Template.OutcomeToolQuestionID as outcome_tool_question_id
	,Template.QuestionText as question_text
	,Template.QuestionType as question_type
from rbmnb.otDimOutcomeToolTemplate Template
where (Template.OutcomeToolQuestionID IN ('q1','q2','q3','q4','q5','q6','q7','q8','q9','q10','q11','q12','q1A'
	,'q2A','q3A','q4A','q1B','q2B','q3B','q4B','q1C','q2C','q3C','q4C','q1D','q2D','q3D','q4D')
	and Template.OutcomeToolTitle IN (
		'kessler 10',
		'matrix',
		'Hua Oranga - Primary Care'
	) or (Template.OutcomeToolTitle like 'SDQ%' and Template.OutcomeToolQuestionID IN (
		'Q1','Q2','Q3','Q4','Q5','Q6','Q7','Q8','Q9','Q10','Q11','Q12','Q13','Q14','Q15','Q16','Q17','Q18','Q19','Q20','Q21','Q22','Q23','Q24','Q25'
	,'Prosocial'
	,'Peer'
	,'Hyperactivity'
	,'Emotional'
	,'Conduct'
	,'Assessor'
	,'AssessmentDate'
	,'TotalDifficulties')))