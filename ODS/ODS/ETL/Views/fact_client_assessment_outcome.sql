CREATE   view [ETL].[fact_client_assessment_outcome]

/****************************************************************************************************************
 View		[ETL].[fact_client_assessment_outcome]
 Author		Greg Nuthall
 Created	2024/10/15
 Purpose	Used to build the edw.fact_client_assessment_outcome table 

 ***************************************************************************************************************
--REVISIONS:
--Version	Date			Author			Description
---------	------------	------------	--------------------------
--1.0		2023/09/14 		Greg Nuthall	Initial version
--1.1       2026-06-24      Greg Nuthall    Added SDQ questions
--1.2       2026-07-09      Malhar Badheka  added coalesce to bring values from response ans
--1.3       2026-07-13      Malhar Badheka  added Q13 to Q25 in sum
--1.4       2026-07-29      Malhar Badheka  converting non answered question to NULL
****************************************************************************************************************/

as 


with main_data_query AS (
    select 1 as CompanyID
        ,'EAL' + ',' + cast(resp.PersonID AS nvarchar(10)) AS personidkey
		,cast(Resp.PersonID as nvarchar)  + '_' +  cast(Resp.OutcomeToolResponseID as nvarchar)  + '_' +  format(Resp.ResponseCreatedDate,'yyyyMMdd')  + '_' + '1' AS fact_client_assessment_outcome_id
        ,Resp.PersonID
        ,Resp.ResponseCreatedDate
        ,usr.UserFirstName + ' ' + Usr.UserLastName AS AssessmentCompletedBy
        ,Resp.OutcomeToolResponseID AS AssessmentId
        ,Resp.ReferralID
        ,isnull(Answer.OutcomeToolQuestionID,'') as OutcomeToolQuestionID
        ,OutcomeToolTitle
        ,isnull(try_cast(coalesce(ResponseAnswerSelectedValue,ResponseAnswer) as tinyint),0)  AS ResponseAnswerSelectedValue
		,Referral.TeamID
		,Team.TeamName
		,isnull(Resp.ResponseSecuredAgainstReferral, 0) AS ResponseSecuredAgainstReferral
    from
        rbeal.otFactOutcomeToolResponse Resp
        inner join rbeal.otDimOutcomeToolTemplate Template ON Resp.OutcomeToolTemplateID = Template.OutcomeToolTemplateID
        and (Template.OutcomeToolQuestionID IN ('q1','q2','q3','q4','q5','q6','q7','q8','q9','q10','q11','q12','q1A'
		,'q2A','q3A','q4A','q1B','q2B','q3B','q4B','q1C','q2C','q3C','q4C','q1D','q2D','q3D','q4D')
        and OutcomeToolTitle IN (
            'kessler 10',
            'matrix',
            'Hua Oranga - Primary Care'
        )  or (OutcomeToolTitle like 'SDQ%' and Template.OutcomeToolQuestionID IN (
            'Q1','Q2','Q3','Q4','Q5','Q6','Q7','Q8','Q9','Q10','Q11','Q12','Q13','Q14','Q15','Q16','Q17','Q18','Q19','Q20','Q21','Q22','Q23','Q24','Q25'
        ,'Prosocial'
        ,'Peer'
        ,'Hyperactivity'
        ,'Emotional'
        ,'Conduct'
        ,'Assessor'
        ,'AssessmentDate'
        ,'TotalDifficulties')))


        inner join rbeal.otFactOutcomeToolResponseAnswer Answer ON Template.OutcomeToolTemplateID = Answer.OutcomeToolTemplateID
        and Template.OutcomeToolQuestionID = Answer.outcometoolquestionid
        and Resp.OutcomeToolResponseID = Answer.OutcomeToolResponseID
		left outer join rbeal.dlFactReferral Referral on Resp.ReferralID = Referral.ReferralID
		left outer join rbeal.dlDimUser usr ON Resp.ResponseCreatedUserID = usr.UserID
		left outer join rbeal.dlDimTeam Team on Referral.TeamID = Team.TeamID
		
    union all
    select 5 as CompanyID,
        'MNB' + ',' + cast(resp.PersonID AS nvarchar(10)) AS personidkey
		,cast(Resp.PersonID as nvarchar)  + '_' +  cast(Resp.OutcomeToolResponseID as nvarchar)  + '_' +  format(Resp.ResponseCreatedDate,'yyyyMMdd')  + '_' + '1' AS fact_client_assessment_outcome_id
        ,Resp.PersonID
        ,Resp.ResponseCreatedDate
        ,usr.UserFirstName + ' ' + Usr.UserLastName AS AssessmentCompletedBy
        ,Resp.OutcomeToolResponseID AS AssessmentId
        ,Resp.ReferralID
        ,isnull(Answer.OutcomeToolQuestionID,'') as OutcomeToolQuestionID
        ,OutcomeToolTitle
        ,isnull(try_cast(coalesce(ResponseAnswerSelectedValue,ResponseAnswer) as tinyint),0)  AS ResponseAnswerSelectedValue
		,Referral.TeamID
		,Team.TeamName
		,isnull(Resp.ResponseSecuredAgainstReferral, 0) AS ResponseSecuredAgainstReferral
    from
        rbmnb.otFactOutcomeToolResponse Resp
        inner join rbmnb.otDimOutcomeToolTemplate Template ON Resp.OutcomeToolTemplateID = Template.OutcomeToolTemplateID
        and (Template.OutcomeToolQuestionID IN ('q1','q2','q3','q4','q5','q6','q7','q8','q9','q10','q11','q12','q1A'
		,'q2A','q3A','q4A','q1B','q2B','q3B','q4B','q1C','q2C','q3C','q4C','q1D','q2D','q3D','q4D')
        and OutcomeToolTitle IN (
            'kessler 10',
            'matrix',
            'Hua Oranga - Primary Care'
        )  or (OutcomeToolTitle like 'SDQ%' and Template.OutcomeToolQuestionID IN (
            'Q1','Q2','Q3','Q4','Q5','Q6','Q7','Q8','Q9','Q10','Q11','Q12','Q13','Q14','Q15','Q16','Q17','Q18','Q19','Q20','Q21','Q22','Q23','Q24','Q25'
        ,'Prosocial'
        ,'Peer'
        ,'Hyperactivity'
        ,'Emotional'
        ,'Conduct'
        ,'Assessor'
        ,'AssessmentDate'
        ,'TotalDifficulties')))
        inner join rbmnb.otFactOutcomeToolResponseAnswer Answer ON Template.OutcomeToolTemplateID = Answer.OutcomeToolTemplateID
        and Template.OutcomeToolQuestionID = Answer.outcometoolquestionid
        and Resp.OutcomeToolResponseID = Answer.OutcomeToolResponseID
		left outer join rbmnb.dlFactReferral Referral on Resp.ReferralID = Referral.ReferralID
		left outer join rbmnb.dlDimUser usr ON Resp.ResponseCreatedUserID = usr.UserID
		left outer join rbmnb.dlDimTeam Team on Referral.TeamID = Team.TeamID

		)


	,data_block_pivot AS (
    SELECT
        CompanyID,
		PersonID,
        AssessmentId,
        ResponseCreatedDate,
        AssessmentCompletedBy,
        OutcomeToolTitle,
		ReferralID,
		TeamID,
		TeamName,
		PersonIDkey,
		fact_client_assessment_outcome_id,
        cast([q1] as smallint) as q1,
        cast([q2] as smallint) as q2,
        cast([q3] as smallint) as q3,
        cast([q4] as smallint) as q4,
        cast([q5] as smallint) as q5,
        cast([q6] as smallint) as q6,
        cast([q7] as smallint) as q7,
        cast([q8] as smallint) as q8,
        cast([q9] as smallint) as q9,
        cast([q10] as smallint) as q10,
        cast([q11] as smallint) as q11,
        cast([q12] as smallint) as q12,
        cast([q13] as smallint) as q13,
        cast([q14] as smallint) as q14,
        cast([q15] as smallint) as q15,
        cast([q16] as smallint) as q16,
        cast([q17] as smallint) as q17,
        cast([q18] as smallint) as q18,
        cast([q19] as smallint) as q19,
        cast([q20] as smallint) as q20,
        cast([q21] as smallint) as q21,
        cast([q22] as smallint) as q22,
        cast([q23] as smallint) as q23,
        cast([q24] as smallint) as q24,
        cast([q25] as smallint) as q25,

        cast([Prosocial] as smallint) as prosocial,
        cast(Peer as smallint) as peer,
        cast(Hyperactivity as smallint) as hyperactivity,
        cast(Emotional as smallint) as emotional,
        cast(Conduct as smallint) as conduct,
        cast(Assessor as smallint) as assessor,
        cast(AssessmentDate as smallint) as assessment_date,
        cast(TotalDifficulties as smallint) as total_difficulties,


        cast([q1a] as smallint) as q1a,
        cast([q1b] as smallint) as q1b,
        cast([q1c] as smallint) as q1c,
        cast([q1d] as smallint) as q1d,
        cast([q2a] as smallint) as q2a,
        cast([q2b] as smallint) as q2b,
        cast([q2c] as smallint) as q2c,
        cast([q2d] as smallint) as q2d,
        cast([q3a] as smallint) as q3a,
        cast([q3b] as smallint) as q3b,
        cast([q3c] as smallint) as q3c,
        cast([q3d] as smallint) as q3d,
        cast([q4a] as smallint) as q4a,
        cast([q4b] as smallint) as q4b,
        cast([q4c] as smallint) as q4c,
        cast([q4d] as smallint) as q4d
    from
        (select CompanyID
                ,PersonID 
                ,ReferralID 
				,TeamID 
				,OutcomeToolTitle 
				,AssessmentId
                ,OutcomeToolQuestionID
                ,ResponseAnswerSelectedValue
                ,ResponseCreatedDate
				,AssessmentCompletedBy
				,TeamName
				,personidkey 
				,fact_client_assessment_outcome_id

            FROM
                main_data_query
        ) AS DATA1 PIVOT (
            MAX(ResponseAnswerSelectedValue) --doesn't make a difference because there should only be one value per line
            FOR OutcomeToolQuestionID IN ([Q1],[Q2],[Q3],[Q4],[Q5],[Q6],[Q7],[Q8],[Q9],[Q10],[Q11],[Q12],[Q13]
                                         ,[Q14],[Q15],[Q16],[Q17],[Q18],[Q19],[Q20],[Q21],[Q22],[Q23],[Q24],[Q25]
                                         ,[Q1A],[Q2A],[Q3A],[Q4A],[Q1B],[Q2B],[Q3B],[Q4B],[Q1C],[Q2C],[Q3C],[Q4C]
                                         ,[Q1D],[Q2D],[Q3D],[Q4D],[Prosocial]
                                         ,[Peer]
                                         ,[Hyperactivity]
                                         ,[Emotional]
                                         ,[Conduct]
                                         ,[Assessor]
                                         ,[AssessmentDate]
                                         ,[TotalDifficulties]) 
		
        
        
        ) AS Pvt)

	,data_block_averages AS (
    select
        
				CompanyID as company_id
				,fact_client_assessment_outcome_id
				,PersonID as client_id
                ,ReferralID as client_referral_id
				,TeamID as client_team_id
				,OutcomeToolTitle as client_outcome_tool_title
				,AssessmentId as assessment_id
                ,ResponseCreatedDate as response_created_date
				,AssessmentCompletedBy as assessment_completed_by
				,TeamName as client_team_name
				

		,Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8,Q9,Q10,Q11,Q12,Q13,Q14,Q15,Q16,Q17,Q18,Q19,Q20,Q21,Q22,Q23,Q24,Q25
        ,Q1A,Q1B,Q1C,Q1D,Q2A,Q2B,Q2C,Q2D,Q3A,Q3B,Q3C,Q3D,Q4A,Q4B,Q4C,Q4D,[Prosocial]
        ,[peer]
        ,[hyperactivity]
        ,[emotional]
        ,[conduct]
        ,[assessor]
        ,[assessment_date]
        ,[total_difficulties],

		cast(isnull (q1, 0) as smallint) + cast(isnull (q2, 0) as smallint) + cast(isnull (q3, 0) as smallint) + cast(isnull (q4, 0) as smallint) + cast(isnull (q5, 0) as smallint) + cast(isnull (q6, 0) as smallint) + cast(isnull (q7, 0) as smallint) + cast(isnull (q8, 0) as smallint) + cast(isnull (q9, 0) as smallint) + cast(isnull (q10, 0) as smallint) + cast(isnull(q11, 0) as smallint) + cast(isnull(q12, 0) as smallint) + cast(isnull(q13, 0) as smallint) + cast(isnull(q14, 0) as smallint) + cast(isnull(q15, 0) as smallint) + cast(isnull(q16, 0) as smallint) + cast(isnull(q17, 0) as smallint) + cast(isnull(q18, 0) as smallint) + cast(isnull(q19, 0) as smallint)+ cast(isnull(q20, 0) as smallint) + cast(isnull(q21, 0) as smallint) + cast(isnull(q22, 0) as smallint) + cast(isnull(q23, 0) as smallint) + cast(isnull(q24, 0) as smallint) + cast(isnull(q25, 0) as smallint) + cast(isnull (q1a, 0) as smallint) + cast(isnull (q1b, 0) as smallint) + cast(isnull (q1c, 0) as smallint) + cast(isnull (q1d, 0) as smallint) + cast(isnull (q2a, 0) as smallint) + cast(isnull (q2b, 0) as smallint) + cast(isnull (q2c, 0) as smallint) + cast(isnull (q2d, 0) as smallint) + cast(isnull (q3a, 0) as smallint) + cast(isnull (q3b, 0) as smallint) + cast(isnull (q3c, 0) as smallint) + cast(isnull (q3d, 0) as smallint) + cast(isnull (q4a, 0) as smallint) + cast(isnull (q4b, 0) as smallint) + cast(isnull (q4c, 0) as smallint) + cast(isnull (q4d, 0) as smallint) as total_score --====average is the total divided by the number of questions
		,case
        when outcometooltitle like 'kes%' then (
            cast(isnull(q1, 0) as smallint) + cast(isnull(q2, 0) as smallint) + cast(isnull(q3, 0) as smallint) + cast(isnull(q4, 0) as smallint) + cast(isnull(q5, 0) as smallint) + cast(isnull(q6, 0) as smallint) + cast(isnull(q7, 0) as smallint) + cast(isnull(q8, 0) as smallint) + cast(isnull(q9, 0) as smallint) + cast(isnull(q10, 0) as smallint)
        ) * 1.0 / 10 * 1.0
        when outcometooltitle = 'matrix' then (
            cast(isnull(q1, 0) as smallint) + cast(isnull(q2, 0) as smallint) + cast(isnull(q3, 0) as smallint) + cast(isnull(q4, 0) as smallint) + cast(isnull(q5, 0) as smallint) + cast(isnull(q6, 0) as smallint) + cast(isnull(q7, 0) as smallint) + cast(isnull(q8, 0) as smallint) + cast(isnull(q9, 0) as smallint) + cast(isnull(q10, 0) as smallint) + cast(isnull(q11, 0) as smallint) + cast(isnull(q12, 0) as smallint)
        ) * 1.0 / 12 * 1.0
        when outcometooltitle = 'hua oranga - primary care' then (
            cast(isnull(q1a, 0) as smallint) + cast(isnull(q1b, 0) as smallint) + cast(isnull(q1c, 0) as smallint) + cast(isnull(q1d, 0) as smallint) + cast(isnull(q2a, 0) as smallint) + cast(isnull(q2b, 0) as smallint) + cast(isnull(q2c, 0) as smallint) + cast(isnull(q2d, 0) as smallint) + cast(isnull(q3a, 0) as smallint) + cast(isnull(q3b, 0) as smallint) + cast(isnull(q3c, 0) as smallint) + cast(isnull(q3d, 0) as smallint) + cast(isnull(q4a, 0) as smallint) + cast(isnull(q4b, 0) as smallint) + cast(isnull(q4c, 0) as smallint) + cast(isnull(q4d, 0) as smallint)
        ) * 1.0 / 16
         when outcometooltitle like 'SDQ%' then (
            cast(isnull(q1, 0) as smallint) + cast(isnull(q2, 0) as smallint) + cast(isnull(q3, 0) as smallint) + cast(isnull(q4, 0) as smallint) + cast(isnull(q5, 0) as smallint) + cast(isnull(q6, 0) as smallint) + cast(isnull(q7, 0) as smallint) + cast(isnull(q8, 0) as smallint) + cast(isnull(q9, 0) as smallint) + cast(isnull(q10, 0) as smallint) + cast(isnull(q11, 0) as smallint) + cast(isnull(q12, 0) as smallint) + cast(isnull(q13, 0) as smallint) + cast(isnull(q14, 0) as smallint) + cast(isnull(q15, 0) as smallint) + cast(isnull(q16, 0) as smallint) + cast(isnull(q17, 0) as smallint) + cast(isnull(q18, 0) as smallint) + cast(isnull(q19, 0) as smallint) + cast(isnull(q20, 0) as smallint) + cast(isnull(q21, 0) as smallint) + cast(isnull(q22, 0) as smallint)+ cast(isnull(q23, 0) as smallint)+ cast(isnull(q24, 0) as smallint)+ cast(isnull(q25, 0) as smallint)
          ) * 1.0 / 25
		end as avg_score,
        CASE
            WHEN outcometooltitle = 'Hua Oranga - Primary Care' THEN (
                CAST(ISNULL(Q1A, 0) AS SMALLINT) + CAST(ISNULL(Q1B, 0) AS SMALLINT) + CAST(ISNULL(Q1C, 0) AS SMALLINT) + CAST(ISNULL(Q1D, 0) AS SMALLINT) + CAST(ISNULL(Q2A, 0) AS SMALLINT) + CAST(ISNULL(Q2B, 0) AS SMALLINT) + CAST(ISNULL(Q2C, 0) AS SMALLINT) + CAST(ISNULL(Q2D, 0) AS SMALLINT) + CAST(ISNULL(Q3A, 0) AS SMALLINT) + CAST(ISNULL(Q3B, 0) AS SMALLINT) + CAST(ISNULL(Q3C, 0) AS SMALLINT) + CAST(ISNULL(Q3D, 0) AS SMALLINT) + CAST(ISNULL(Q4A, 0) AS SMALLINT) + CAST(ISNULL(Q4B, 0) AS SMALLINT) + CAST(ISNULL(Q4C, 0) AS SMALLINT) + CAST(ISNULL(Q4D, 0) AS SMALLINT)
            ) * 1.0 / 4
        END AS avg_Score_HOP,
        q1a + q1b + q1c + q1d AS HOPQ1,
        q2a + q2b + q2c + q2d AS HOPQ2,
        q3a + q3b + q3c + q3d AS HOPQ3,
        q4a + q4b + q4c + q4d AS HOPQ4,

		--adding row count for each person.
		row_number() over (partition by personidkey,outcometooltitle order by personidkey,responsecreateddate) as row_count,
        
		-- row count for each person desc
        row_number() over (partition by personidkey, outcometooltitle order by personidkey, responsecreateddate desc) as row_count_desc,
        
		--row count by referral
        row_number() over (partition by personidkey, outcometooltitle, referralid  
		order by  personidkey, outcometooltitle,  referralid,  responsecreateddate) as row_count_ref, --row count by referral desc

        row_number() over (partition by personidkey,outcometooltitle,referralid
		order by personidkey,outcometooltitle,referralid,responsecreateddate desc) as row_count_ref_desc

    FROM
        data_block_pivot
)

	--Final selection 
	Select	fact_client_assessment_outcome_id
			,company_id
			,client_id
            ,client_referral_id
			,client_team_id
			,client_outcome_tool_title
			,assessment_id
            ,response_created_date
			,assessment_completed_by
			,client_team_name
			,Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8,Q9,Q10,Q11,Q12,Q13,Q14,Q15,Q16,Q17,Q18,Q19,Q20,Q21,Q22,Q23,Q24,Q25
            ,Q1A,Q1B,Q1C,Q1D,Q2A,Q2B,Q2C,Q2D,Q3A,Q3B,Q3C,Q3D,Q4A,Q4B,Q4C,Q4D 
            ,prosocial
            ,peer
            ,hyperactivity
            ,emotional
            ,conduct
            ,assessor
            ,assessment_date
            ,total_difficulties
			,total_score
			,avg_score
			,avg_score_HOP
			,HOPQ1
			,HOPQ2
			,HOPQ3
			,HOPQ4
			,row_count
			,row_count_desc
			,row_count_ref
			,row_count_ref_desc
	
	from data_block_averages 
	where total_score <> 0