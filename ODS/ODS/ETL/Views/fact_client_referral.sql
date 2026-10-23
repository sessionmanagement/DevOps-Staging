CREATE     view [ETL].[fact_client_referral]
as


/**********************************************************************************************************
 View		[ETL].[fact_client_referral]
 Author		????
 Created	2023/02/10	
 Purpose	Used to build the edw.dim_employee table 

 **************************************************************************************************************
--REVISIONS:
--Version	 Date		   Author			Description
---------	 ------------  ---------------	--------------------------
--1.0		 2023/02/10		?????			Initial version
--1.1		 2024/09/06		Greg Nuthall	Modified Added more criteria to CTE_PS to avoid duplicates
--1.2        2025/12/23     Greg Nuthall	Remove referrals associated with clients not in dl.dim_Person
**************************************************************************************************************/

WITH CTE_PS_RBEAL (
	PersonID
	,PersonStatusTypeID
	,PersonStatusStartDate
	,PersonStatusEndDate
	,DateDifference
	)
AS (
	SELECT ps.PersonID
		,ps.PersonStatusTypeID
		,ps.PersonStatusStartDate
		,ps.PersonStatusEndDate
		,DATEDIFF(DAY, PS.PersonStatusStartDate, ps.PersonStatusEndDate)
	FROM rbeal.dlFactPersonStatus PS
	WHERE ps.PersonStatusTypeID IN (
			1
			,2
			)
		AND CAST(ps.PersonStatusStartDate AS DATE) != CAST(PS.PersonStatusEndDate AS DATE)
	)
	,CTE_PS_RBMNB (
	PersonID
	,PersonStatusTypeID
	,PersonStatusStartDate
	,PersonStatusEndDate
	,DateDifference
	)
AS (
	SELECT ps.PersonID
		,ps.PersonStatusTypeID
		,ps.PersonStatusStartDate
		,ps.PersonStatusEndDate
		,DATEDIFF(DAY, PS.PersonStatusStartDate, ps.PersonStatusEndDate)
	FROM rbmnb.dlFactPersonStatus PS
	WHERE ps.PersonStatusTypeID IN (
			1
			,2
			)
		AND CAST(ps.PersonStatusStartDate AS DATE) != CAST(PS.PersonStatusEndDate AS DATE)
	),

	CTE_EMPLOYEE_LOOKUP_RBEAL
	AS (
			Select du.UserID
			, max(h2.employeeNumber) as employeeNumber
		
			from RBEAL.dlDimUser du
			left outer join [IntelliHR].[people] hp on cast(du.UserEmployeeNumber as nvarchar) = cast(hp.employeeNumber as nvarchar)
			left outer join [IntelliHR].[people] h2 on Upper(trim(du.UserFirstName)) = Upper(trim(h2.firstName)) 
												   and Upper(trim( du.UserLastName)) = Upper(trim(h2.lastName)) 
			where isnull(hp.people_id,'') = ''
			and isnull(du.UserEmailAddress,'') <> ''
			and h2.ODSIsCurrent = 1
			group by du.UserID),

	CTE_EMPLOYEE_LOOKUP_RBMNB
	AS (
		Select du.UserID
		, max(h2.employeeNumber) as employeeNumber
		
		from RBMNB.dlDimUser du
		left outer join [IntelliHR].[people] hp on cast(du.UserEmployeeNumber as nvarchar) = cast(hp.employeeNumber as nvarchar)
		left outer join [IntelliHR].[people] h2 on Upper(trim(du.UserFirstName)) = Upper(trim(h2.firstName)) 
											   and Upper(trim( du.UserLastName)) = Upper(trim(h2.lastName)) 
		where isnull(hp.people_id,'') = ''
		and isnull(du.UserEmailAddress,'') <> ''
		and h2.ODSIsCurrent = 1
		group by du.UserID)



SELECT 1 AS company_key
	,fr.referralid AS client_referral_id
	,fr.personid AS client_id
	,fpr.UserID AS client_responsible_user_id
	,isnull(fr.TeamID, 0) AS client_team_id
	,cast(fr.ReferralID AS NVARCHAR) + '_' + CAST(fr.personid AS NVARCHAR) + '_' + cast(fpr.UserID AS NVARCHAR) + '_' + '1' AS uniquekey
	--,isnull(Convert(INT, REPLACE(du.UserEmployeeNumber, '.', '')), 0) AS user_employee_number
	,COALESCE(p1.employeeNumber, p2.employeeNumber, Convert(INT, REPLACE(du.UserEmployeeNumber, '.', '')), 0) AS user_employee_number -- if employee number does not exist join on email address to get employee number
	,fr.referralreferraltype AS client_referral_type
	,FORMAT(cast(fpr.personrelationshipstartdate AS DATE), 'yyyyMMdd') AS client_person_relationship_start_date
	,FORMAT(cast(fpr.personrelationshipenddate AS DATE), 'yyyyMMdd') AS client_person_relationship_end_date
	,FORMAT(cast(fr.referralreceiveddate AS DATE), 'yyyyMMdd') AS client_referral_received_date
	,FORMAT(cast(fr.referralcreateddate AS DATE), 'yyyyMMdd') AS client_referral_created_date
	,FORMAT(cast(fr.referralenddate AS DATE), 'yyyyMMdd') AS client_referral_end_date
	,FORMAT(cast(max(CASE 
					WHEN frs.referralstatustypeid = 13
						THEN frs.referralstatusstartdate
					END) AS DATE), 'yyyyMMdd') AS client_referral_pending_date
	,FORMAT(cast(max(CASE 
					WHEN frs.referralstatustypeid = 16
						THEN frs.referralstatusstartdate
					END) AS DATE), 'yyyyMMdd') AS client_referral_accepted_date
	,FORMAT(cast(max(CASE 
					WHEN frs.referralstatustypeid = 19
						THEN frs.referralstatusstartdate
					END) AS DATE), 'yyyyMMdd') AS client_referral_discharge_date
	,FORMAT(cast(max(CASE 
					WHEN frs.referralstatustypeid = 15
						THEN frs.referralstatusstartdate
					END) AS DATE), 'yyyyMMdd') AS client_referral_waitlist_date
	,FORMAT(cast(max(CASE 
					WHEN frs.referralstatustypeid = 20
						THEN frs.referralstatusstartdate
					END) AS DATE), 'yyyyMMdd') AS client_referral_decline_date
	,SUM(CASE 
			WHEN PS.PersonStatusTypeID = 1
				THEN DateDifference
			END) AS client_hospital_nights
	,SUM(CASE 
			WHEN PS.PersonStatusTypeID = 2
				THEN DateDifference
			END) AS client_absence
	FROM rbeal.dlfactreferral fr
	LEFT JOIN rbeal.dlfactreferralstatus frs ON fr.referralid = frs.referralid
	
	LEFT JOIN rbeal.dlfactreferralstatus frsa ON fr.referralid = frsa.referralid
		AND frsa.referralstatustypeid = 16
	
	LEFT JOIN rbeal.dlfactreferralstatus frsdis ON fr.referralid = frsdis.referralid
		AND frsdis.referralstatustypeid = 19
	
	LEFT JOIN CTE_PS_RBEAL PS ON fr.PersonID = ps.PersonID
		AND ps.PersonStatusStartDate BETWEEN frsa.ReferralStatusStartDate AND frsdis.ReferralStatusStartDate
		AND ps.PersonStatusEndDate BETWEEN frsa.ReferralStatusStartDate AND frsdis.ReferralStatusStartDate
		and frs.ReferralStatusTypeID not in (16,19)

	LEFT JOIN rbeal.dlfactpersonrelationship fpr ON fr.personid = fpr.personid
		AND fr.referralid = fpr.referralid
	LEFT Join CTE_EMPLOYEE_LOOKUP_RBEAL el on fpr.userid = el.UserID
	LEFT JOIN rbeal.dldimuser DU ON fpr.userid = du.userid
		AND du.userid != 503921
	LEFT JOIN [IntelliHR].[people] p1 ON p1.employeeNumber  = isnull(cast(el.employeeNumber as Int),isnull(Convert(INT, REPLACE(du.UserEmployeeNumber, '.', '')), 0))
	--LEFT JOIN [IntelliHR].[people] p1 ON p1.employeeNumber = isnull(Convert(INT, REPLACE(du.UserEmployeeNumber, '.', '')), 0)
		AND p1.ODSIsCurrent = 1
	LEFT JOIN [IntelliHR].[people] p2 ON p2.primaryEmailAddress_email = du.UserEmailAddress
		AND p2.ODSIsCurrent = 1

	where fr.personid not in (102614,102852,102917,103301,113267,115599)

	GROUP BY fr.personid
		,fr.referralid
		,fr.referralreferraltype
		,fpr.UserID
		,fr.TeamID
		--,du.UserEmployeeNumber
		,COALESCE(p1.employeeNumber, p2.employeeNumber, Convert(INT, REPLACE(du.UserEmployeeNumber, '.', '')), 0)
		,fpr.personrelationshipstartdate
		,fpr.personrelationshipenddate
		,fr.referralreceiveddate
		,fr.referralcreateddate
		,fr.referralenddate

UNION

SELECT 5 AS company_key
	,fr.referralid AS client_referral_id
	,fr.personid AS client_id
	,fpr.UserID AS client_responsible_user_id
	,isnull(fr.TeamID, 0) AS client_team_id
	,cast(fr.ReferralID AS NVARCHAR) + '_' + CAST(fr.personid AS NVARCHAR) + '_' + cast(fpr.UserID AS NVARCHAR) + '_' + '1' AS uniquekey
	--,isnull(Convert(INT, REPLACE(du.UserEmployeeNumber, '.', '')), 0) AS user_employee_number
	,COALESCE(p1.employeeNumber, p2.employeeNumber, Convert(INT, REPLACE(du.UserEmployeeNumber, '.', '')), 0) AS user_employee_number -- if employee number does not exist join on email address to get employee number
	,fr.referralreferraltype AS client_referral_type
	,FORMAT(cast(fpr.personrelationshipstartdate AS DATE), 'yyyyMMdd') AS client_person_relationship_start_date
	,FORMAT(cast(fpr.personrelationshipenddate AS DATE), 'yyyyMMdd') AS client_person_relationship_end_date
	,FORMAT(cast(fr.referralreceiveddate AS DATE), 'yyyyMMdd') AS client_referral_received_date
	,FORMAT(cast(fr.referralcreateddate AS DATE), 'yyyyMMdd') AS client_referral_created_date
	,FORMAT(cast(fr.referralenddate AS DATE), 'yyyyMMdd') AS client_referral_end_date
	,FORMAT(cast(max(CASE 
					WHEN frs.referralstatustypeid = 13
						THEN frs.referralstatusstartdate
					END) AS DATE), 'yyyyMMdd') AS client_referral_pending_date
	,FORMAT(cast(max(CASE 
					WHEN frs.referralstatustypeid = 16
						THEN frs.referralstatusstartdate
					END) AS DATE), 'yyyyMMdd') AS client_referral_accepted_date
	,FORMAT(cast(max(CASE 
					WHEN frs.referralstatustypeid = 19
						THEN frs.referralstatusstartdate
					END) AS DATE), 'yyyyMMdd') AS client_referral_discharge_date
	,FORMAT(cast(max(CASE 
					WHEN frs.referralstatustypeid = 15
						THEN frs.referralstatusstartdate
					END) AS DATE), 'yyyyMMdd') AS client_referral_waitlist_date
	,FORMAT(cast(max(CASE 
					WHEN frs.referralstatustypeid = 20
						THEN frs.referralstatusstartdate
					END) AS DATE), 'yyyyMMdd') AS client_referral_decline_date
	,SUM(CASE 
			WHEN PS.PersonStatusTypeID = 1
				THEN DateDifference
			END) AS client_hospital_nights
	,SUM(CASE 
			WHEN PS.PersonStatusTypeID = 2
				THEN DateDifference
			END) AS client_absence
	FROM rbmnb.dlfactreferral fr
	LEFT JOIN rbmnb.dlfactreferralstatus frs ON fr.referralid = frs.referralid
	
	LEFT JOIN rbmnb.dlfactreferralstatus frsa ON fr.referralid = frsa.referralid
		AND frsa.referralstatustypeid = 16
	
	LEFT JOIN rbmnb.dlfactreferralstatus frsdis ON fr.referralid = frsdis.referralid
		AND frsdis.referralstatustypeid = 19
	
	LEFT JOIN CTE_PS_RBMNB PS ON fr.PersonID = ps.PersonID
		AND ps.PersonStatusStartDate BETWEEN frsa.ReferralStatusStartDate AND frsdis.ReferralStatusStartDate
		AND ps.PersonStatusEndDate BETWEEN frsa.ReferralStatusStartDate	AND frsdis.ReferralStatusStartDate
		and frs.ReferralStatusTypeID not in (16,19)

	LEFT JOIN rbmnb.dlfactpersonrelationship fpr ON fr.personid = fpr.personid
		AND fr.referralid = fpr.referralid
	LEFT Join CTE_EMPLOYEE_LOOKUP_RBMNB el on fpr.UserID = el.UserID
	LEFT JOIN rbmnb.dldimuser DU ON fpr.userid = du.userid
	LEFT JOIN [IntelliHR].[people] p1 ON p1.employeeNumber  = isnull(cast(el.employeeNumber as Int),isnull(Convert(INT, REPLACE(du.UserEmployeeNumber, '.', '')), 0))
	--LEFT JOIN [IntelliHR].[people] p1 ON p1.employeeNumber = isnull(Convert(INT, REPLACE(du.UserEmployeeNumber, '.', '')), 0)
		AND p1.ODSIsCurrent = 1
	LEFT JOIN [IntelliHR].[people] p2 ON p2.primaryEmailAddress_email = du.UserEmailAddress
		AND p2.ODSIsCurrent = 1
	GROUP BY fr.personid
		,fr.referralid
		,fr.referralreferraltype
		,fpr.UserID
		,fr.TeamID
		--,du.UserEmployeeNumber
		,COALESCE(p1.employeeNumber, p2.employeeNumber, Convert(INT, REPLACE(du.UserEmployeeNumber, '.', '')), 0)
		,fpr.personrelationshipstartdate
		,fpr.personrelationshipenddate
		,fr.referralreceiveddate
		,fr.referralcreateddate
		,fr.referralenddate