




CREATE    VIEW [ETL].[fact_client_person_relationship]
as
	
--View			[ETL].[fact_client_person_relationship]
--Author		Greg Nuthall
--Created		2024/06/06
--Purpose		client record base dlFactPersonRelationship to generate fact_client_person_relationship
				
--=========================================================================================================
--REVISIONS:
--Version	 Date		   Author			Description
---------	 ------------  ---------------	--------------------------
--1.0		 2024/06/06	   Greg Nuthall     Initial version 		

--**********************************************************************************************************/

	SELECT 1 AS company_id ,
		[PersonRelationshipID] as client_person_relationship_id,
		fr.[PersonID] as client_id,
		fr.[UserID] as client_responsible_user_id,
		[UserFirstName] as client_first_name,
		[UserLastName] as client_last_name,
		r.[TeamID] as client_team_id,
		t.TeamName as client_team_name,
		[RelationshipTypeText] as client_relationship_type,
		fr.[RelationshipTypeID] as client_relationship_type_id,
		r.ReferralReferralType as client_referral_type
		,FORMAT(cast([PersonRelationshipStartDate] AS DATE), 'yyyyMMdd') AS client_person_relationship_start_date
		,FORMAT(cast(PersonRelationshipEndDate AS DATE), 'yyyyMMdd') AS client_person_relationship_end_date
		,[PersonRelationshipDetail] as client_person_relationship_detail
		,[PersonRelationshipCreatedUserID] as client_person_relationship_user_id
		,FORMAT(cast(PersonRelationshipCreatedDate AS DATE), 'yyyyMMdd') AS client_person_relationship_created_date
		,fr.[ReferralId] as client_referral_id,
		[PersonRelationshipIsPrimaryCaseworker] as client_relationship_is_primary_caseworker
		,COALESCE(p1.employeeNumber, p2.employeeNumber, replace(REPLACE(du.UserEmployeeNumber, '.', ''),'Agency','0')) AS user_employee_number 
		--,COALESCE(p1.employeeNumber, p2.employeeNumber, Convert(INT, replace(REPLACE(du.UserEmployeeNumber, '.', ''),'Agency',0)), 0) AS user_employee_number 
		-- if employee number does not exist join on email address to get employee number

	FROM [RBEAL].[dlFactPersonRelationship] fr
	JOIN [RBEAL].[dlDimRelationshipType] dr
		ON fr.RelationshipTypeID = dr.RelationshipTypeID
	JOIN [RBEAL].[dlDimUser] du
		ON fr.UserID = du.[UserID]

	--LEFT JOIN [IntelliHR].[people] p1 ON p1.employeeNumber = isnull(Convert(INT, replace(REPLACE(du.UserEmployeeNumber, '.', ''),'Agency',0)), 0)
	--AND p1.ODSIsCurrent = 1
	left join [IntelliHR].[people] p1 ON cast(p1.employeeNumber as nvarchar) = isnull(replace(REPLACE(du.UserEmployeeNumber, '.', ''),'Agency','0'), '0')
	and p1.ODSIsCurrent = 1


	LEFT JOIN [IntelliHR].[people] p2 ON p2.primaryEmailAddress_email = du.UserEmailAddress
	AND p2.ODSIsCurrent = 1

	LEFT JOIN [RBEAL].[dlFactReferral] r
		ON r.[PersonID] = fr.personid
			AND r.[ReferralID] = fr.[ReferralID]
	LEFT JOIN [RBEAL].[dlDimTeam] t
		ON t.TeamID = r.[TeamID]
	
	Union All

	SELECT 5 AS company_id,
		[PersonRelationshipID] as client_person_relationship_id,
		fr.[PersonID] as client_id,
		fr.[UserID] as client_responsible_user_id,
		[UserFirstName] as client_first_name,
		[UserLastName] as client_last_name,
		r.[TeamID] as client_team_id,
		t.TeamName as client_team_name,
		[RelationshipTypeText] as client_relationship_type,
		fr.[RelationshipTypeID] as client_relationship_type_id,
		r.ReferralReferralType as client_referral_type
		,FORMAT(cast([PersonRelationshipStartDate] AS DATE), 'yyyyMMdd') AS client_person_relationship_start_date
		,FORMAT(cast(PersonRelationshipEndDate AS DATE), 'yyyyMMdd') AS client_person_relationship_end_date
		,[PersonRelationshipDetail] as client_person_relationship_detail
		,[PersonRelationshipCreatedUserID] as client_person_relationship_user_id
		,FORMAT(cast(PersonRelationshipCreatedDate AS DATE), 'yyyyMMdd') AS client_person_relationship_created_date
		,fr.[ReferralId] as client_referral_id,
		[PersonRelationshipIsPrimaryCaseworker] as client_relationship_is_primary_caseworker
		,COALESCE(p1.employeeNumber, p2.employeeNumber, replace(REPLACE(du.UserEmployeeNumber, '.', ''),'Agency','0')) AS user_employee_number 
		--,COALESCE(p1.employeeNumber, p2.employeeNumber, Convert(INT, replace(REPLACE(du.UserEmployeeNumber, '.', ''),'Agency',0)), 0) AS user_employee_number 
		-- if employee number does not exist join on email address to get employee number

	FROM [RBMNB].[dlFactPersonRelationship] fr
	JOIN [RBMNB].[dlDimRelationshipType] dr
		ON fr.RelationshipTypeID = dr.RelationshipTypeID
	JOIN [RBMNB].[dlDimUser] du
		ON fr.UserID = du.[UserID]

	--LEFT JOIN [IntelliHR].[people] p1 ON p1.employeeNumber = isnull(Convert(INT, replace(REPLACE(du.UserEmployeeNumber, '.', ''),'Agency',0)), 0)
	--AND p1.ODSIsCurrent = 1
	left join [IntelliHR].[people] p1 ON cast(p1.employeeNumber as nvarchar) = isnull(replace(REPLACE(du.UserEmployeeNumber, '.', ''),'Agency','0'), '0')
	and p1.ODSIsCurrent = 1

	LEFT JOIN [IntelliHR].[people] p2 ON p2.primaryEmailAddress_email = du.UserEmailAddress
	AND p2.ODSIsCurrent = 1

	LEFT JOIN [RBMNB].[dlFactReferral] r
		ON r.[PersonID] = fr.personid
			AND r.[ReferralID] = fr.[ReferralID]
	LEFT JOIN [RBMNB].[dlDimTeam] t
		ON t.TeamID = r.[TeamID]
	
	
	--=ORDER BY [PersonRelationshipStartDate]