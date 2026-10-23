
CREATE VIEW [ETL].[dim_client_person_relationship]
as
	
--View			[ETL].[dim_client_person_relationship]
--Author		Greg Nuthall
--Created		2024/06/06
--Purpose		client record base dlFactPersonRelationship to generate dim_client_person_relationship
				
--=========================================================================================================
--REVISIONS:
--Version	 Date		   Author			Description
---------	 ------------  ---------------	--------------------------
--1.0		 2024/06/06	   Greg Nuthall     Initial version 		

--**********************************************************************************************************/

	SELECT 1 AS company_id ,
	    [PersonRelationshipID] as client_person_relationship_id,
		cast([PersonRelationshipID] as nvarchar) + '_' + isnull(cast(rs.ReferralStatusID as nvarchar),'NA') + '_1' as  client_person_relationship_unique_key,
		fr.[PersonID] as client_id,
		fr.[UserID] as client_responsible_user_id,
		[UserFirstName] as client_first_name,
		[UserLastName] as client_last_name,
		r.[TeamID] as client_team_id,
		t.TeamName as client_team_name,
		[RelationshipTypeText] as client_relationship_type,
		r.ReferralReferralType as client_referral_type
		,cast([PersonRelationshipStartDate] AS DATE) AS client_person_relationship_start_date
		,cast(PersonRelationshipEndDate AS DATE) AS client_person_relationship_end_date
		,[PersonRelationshipDetail] as client_person_relationship_detail
		,[PersonRelationshipCreatedUserID] as client_person_relationship_user_id
		,cast(PersonRelationshipCreatedDate AS DATE) AS client_person_relationship_created_date
		,fr.[ReferralId] as client_referral_id,
		[PersonRelationshipIsPrimaryCaseworker] as client_relationship_is_primary_caseworker
		,COALESCE(p1.employeeNumber, p2.employeeNumber, replace(REPLACE(du.UserEmployeeNumber, '.', ''),'Agency','0')) AS user_employee_number 
		--,COALESCE(p1.employeeNumber, p2.employeeNumber, Convert(INT, replace(REPLACE(du.UserEmployeeNumber, '.', ''),'Agency',0)), 0) AS user_employee_number 
		-- if employee number does not exist join on email address to get employee number
		,rst.ReferralStatusTypeDescription as client_referral_status_type_description
		,rst.ReferralStatusTypeCode as client_referral_status_type_code
		,rst.ReferralStatusTypeGroup as client_referral_status_type_group
		,isnull(p1.displayName,p2.displayName) as client_referral_caseworker
		,dr.RelationshipTypeText as client_relationship_type_text
		,dr.RelationshipTypeValue as client_relationship_type_value
		
	from [RBEAL].[dlFactPersonRelationship] fr
	join [RBEAL].[dlDimRelationshipType] dr	ON fr.RelationshipTypeID = dr.RelationshipTypeID
	join [RBEAL].[dlDimUser] du ON fr.UserID = du.[UserID]
	--left join [IntelliHR].[people] p1 ON p1.employeeNumber = isnull(Convert(INT, replace(REPLACE(du.UserEmployeeNumber, '.', ''),'Agency',0)), 0)
	--and p1.ODSIsCurrent = 1
	left join [IntelliHR].[people] p1 ON cast(p1.employeeNumber as nvarchar) = isnull(replace(REPLACE(du.UserEmployeeNumber, '.', ''),'Agency','0'), '0')
	and p1.ODSIsCurrent = 1
	left join [IntelliHR].[people] p2 ON p2.primaryEmailAddress_email = du.UserEmailAddress
	and p2.ODSIsCurrent = 1
	
	left join [RBEAL].[dlFactReferral] r ON r.[PersonID] = fr.personid	AND r.[ReferralID] = fr.[ReferralID]
	left join [RBEAL].[dlDimTeam] t	ON t.TeamID = r.[TeamID]
	left join [RBEAL].[dlFactReferralStatus] rs on r.ReferralID = rs.ReferralID
	left join [RBEAL].[dlDimReferralStatusType] rst on rs.ReferralStatusTypeID = rst.ReferralStatusTypeID

Union all 

	SELECT 5 AS company_id ,
		[PersonRelationshipID] as client_person_relationship_id,
		cast([PersonRelationshipID] as nvarchar) + '_' + isnull(cast(rs.ReferralStatusID as nvarchar),'NA') + '_5' as  client_person_relationship_unique_key,
		fr.[PersonID] as client_id,
		fr.[UserID] as client_responsible_user_id,
		[UserFirstName] as client_first_name,
		[UserLastName] as client_last_name,
		r.[TeamID] as client_team_id,
		t.TeamName as client_team_name,
		[RelationshipTypeText] as client_relationship_type,
		r.ReferralReferralType as client_referral_type
		,cast([PersonRelationshipStartDate] AS DATE) AS client_person_relationship_start_date
		,cast(PersonRelationshipEndDate AS DATE) AS client_person_relationship_end_date
		,[PersonRelationshipDetail] as client_person_relationship_detail
		,[PersonRelationshipCreatedUserID] as client_person_relationship_user_id
		,cast(PersonRelationshipCreatedDate AS DATE) AS client_person_relationship_created_date
		,fr.[ReferralId] as client_referral_id,
		[PersonRelationshipIsPrimaryCaseworker] as client_relationship_is_primary_caseworker
		,COALESCE(p1.employeeNumber, p2.employeeNumber, replace(REPLACE(du.UserEmployeeNumber, '.', ''),'Agency','0')) AS user_employee_number 
		--,COALESCE(p1.employeeNumber, p2.employeeNumber, Convert(INT, replace(REPLACE(du.UserEmployeeNumber, '.', ''),'Agency',0)), 0) AS user_employee_number 
		-- if employee number does not exist join on email address to get employee number
		,rst.ReferralStatusTypeDescription as client_referral_status_type_description
		,rst.ReferralStatusTypeCode as client_referral_status_type_code
		,rst.ReferralStatusTypeGroup as client_referral_status_type_group
		,isnull(p1.displayName,p2.displayName) as client_referral_caseworker
		,dr.RelationshipTypeText as client_relationship_type_text
		,dr.RelationshipTypeValue as client_relationship_type_value
		
	from [RBMNB].[dlFactPersonRelationship] fr
	join [RBMNB].[dlDimRelationshipType] dr	ON fr.RelationshipTypeID = dr.RelationshipTypeID
	join [RBMNB].[dlDimUser] du ON fr.UserID = du.[UserID]
	--left join [IntelliHR].[people] p1 ON p1.employeeNumber = isnull(Convert(INT, replace(REPLACE(du.UserEmployeeNumber, '.', ''),'Agency',0)), 0)
	--and p1.ODSIsCurrent = 1
	left join [IntelliHR].[people] p1 ON cast(p1.employeeNumber as nvarchar) = isnull(replace(REPLACE(du.UserEmployeeNumber, '.', ''),'Agency','0'), '0')
	and p1.ODSIsCurrent = 1
	left join [IntelliHR].[people] p2 ON p2.primaryEmailAddress_email = du.UserEmailAddress
	and p2.ODSIsCurrent = 1
	left join [RBMNB].[dlFactReferral] r ON r.[PersonID] = fr.personid	AND r.[ReferralID] = fr.[ReferralID]
	left join [RBMNB].[dlDimTeam] t	ON t.TeamID = r.[TeamID]
	left join [RBMNB].[dlFactReferralStatus] rs on r.ReferralID = rs.ReferralID
	left join [RBMNB].[dlDimReferralStatusType] rst on rs.ReferralStatusTypeID = rst.ReferralStatusTypeID




