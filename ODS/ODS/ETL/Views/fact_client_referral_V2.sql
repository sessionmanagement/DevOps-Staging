CREATE   VIEW [ETL].[fact_client_referral_V2]
as

/**********************************************************************************************************
 View		[ETL].[fact_client_referral_V2]
 Author		Greg Nuthall
 Created	2024/05/06
 Purpose	Used to build the edw.fact_client_referral_V2 table 
 
 **************************************************************************************************************
--REVISIONS:
--Version	 Date		   Author			Description
---------	 ------------  ---------------	--------------------------
--1.0		2024/05/06		Greg Nuthall	Initial version
--1.1		2024/05/06		(TB,GN)			Modified the granularity to only have one row per referral. There are a few CTE's to work out the most relevant case worker  
--1.2		2024/07/18		Greg Nuthall	Added user a CTE_lookup to get the correct employee_number via email and name
--1.3		2024/07/18		Greg Nuthall	Added modified unique key to fix loading bug 
--1.4		2024/07/23		Greg Nuthall	Group on employee CTE to avoid duplicate employees
--1.5		2024/09/06		Greg Nuthall	Modified Added more criteria to CTE_PS to avoid duplicates
--1.6       2025-05-02		Greg Nuthall	Added case worker flag
--1.7       2025-12-23      Greg Nuthall	Remove referrals associated with clients not in dl.dim_Person
**************************************************************************************************************/

WITH
--=====taking any primary caseworker where the relationship is still active (ie personrelationshipenddate is null)
--=====this may not be the latest relationship.  I've asked Simon whether he thinks this is ok given the personalrelationshipisprimarycaseworker flag is so badly
--==== filled in
--==== see referralid 7688

CTE_RBEAL_LATEST_PRIMARY_CASE_WORKER_ACTIVE
AS (SELECT 1 AS type,  --adding order to chaos
			PersonRelationshipID,
			ReferralId,
			UserID,
			PersonID,
			rowno,
			1 as IsCaseWorker
    FROM   (SELECT personrelationshipid,
                   referralid,
                   userid,
                   personid,
                   Row_number()   OVER(partition BY referralid ORDER BY PersonRelationshipEndDate desc) AS RowNo
  --==== orderby by end date for the latest relationship
				FROM   rbeal.dlFactPersonRelationship fpr
				WHERE  PersonRelationshipIsPrimaryCaseworker = 1
					   AND PersonRelationshipEndDate IS NULL) T1
				WHERE  RowNo =1),
     --=========taking any relationship that is open NB it may have begun before the above therefore taking Primary first
    
cte_RBEAL_all_active_relationship
     AS (SELECT 2 AS type,  --adding order to chaos
					PersonRelationshipID,
					ReferralId,
					UserID,
					PersonID,
					IsCaseWorker,
					rowno
         FROM   (SELECT PersonRelationshipID,
                        ReferralId,
                        UserID,
                        PersonID,
                        case when fpr.PersonRelationshipIsPrimaryCaseworker = 1 then 1 else 0 end as IsCaseWorker,
						Row_number() OVER(partition BY ReferralId  ORDER BY PersonRelationshipStartDate DESC ) AS RowNo
						 
                 FROM   rbeal.dlFactPersonRelationship fpr
                 WHERE  PersonRelationshipEndDate IS NULL) AS t2
                 WHERE  rowno = 1)
     

--===== now taking the lastest relationship - it may have ended
     ,cte_RBEAL_all_other_relationship
     AS (SELECT 3 AS type,
					PersonRelationshipID,
					ReferralId,
					UserID,
					PersonID,
					IsCaseWorker,
					rowno
			 FROM (SELECT PersonRelationshipID,
						ReferralId,
						UserID,
						PersonID,
						IsCaseWorker,
						rowno
					FROM (SELECT PersonRelationshipID,
								ReferralId,
								UserID,
								PersonID,
								case when fpr.PersonRelationshipIsPrimaryCaseworker = 1 then 1 else 0 end as IsCaseWorker,
                                Row_number() OVER(partition BY referralid ORDER BY PersonRelationshipEndDate DESC ) AS
                                RowNo
                         FROM   rbeal.dlFactPersonRelationship fpr
                         WHERE  PersonRelationshipEndDate IS NOT NULL) AS t3
                         ) AS T31
				  WHERE  rowno = 1)

--===== bring CTE Tables Together - should be a drop down Filter and eliminated duplicates
     
,cte_RBEAL_latest_workers
     AS (SELECT type,
				PersonRelationshipID,
				ReferralId,
				UserID,
				PersonID,
				IsCaseWorker

         FROM   (SELECT type,
                    PersonRelationshipID,
					ReferralId,
					UserID,
					PersonID,
					IsCaseWorker

                 FROM   cte_RBEAL_latest_primary_case_worker_active
                 UNION
                 SELECT type,
						PersonRelationshipID,
						ReferralId,
						UserID,
						PersonID,
						IsCaseWorker
                 FROM   cte_RBEAL_all_active_relationship
                 UNION
                 SELECT type,
                    PersonRelationshipID,
					ReferralId,
					UserID,
					PersonID,
					IsCaseWorker
                 FROM   cte_RBEAL_all_other_relationship) AS T4
         WHERE  ReferralId IS NOT NULL)
	
	, CTE_RBEAL_Latest_Case_Worker
     AS (SELECT PersonRelationshipID,
				ReferralId,
				UserID,
				PersonID,
				IsCaseWorker
         FROM   (                
                SELECT Row_number () OVER (partition BY referralid ORDER BY referralid, type) AS Numbering,
                       type,
                       PersonRelationshipID,
						ReferralId,
						UserID,
						PersonID,
						IsCaseWorker

                 FROM   cte_RBEAL_latest_workers
                 AS type5 ) as type5a
						WHERE  numbering = 1)

--=============What happens:
--============= if there's an open primary caseworker this trumps and open person relationship which began AFTER the primary caseworker, and trumps all other relationships
--============= if there's an open relationship where there is no primary caseworker, we take this relationship.  If this starts after the above, we still take the above
--============= if there's no open relationships, we take the latest relationship


,CTE_RBMNB_LATEST_PRIMARY_CASE_WORKER_ACTIVE
AS (SELECT 1 AS type,  --adding order to chaos
			PersonRelationshipID,
			ReferralId,
			UserID,
			PersonID,
			1 as IsCaseWorker,
			rowno
    FROM   (SELECT personrelationshipid,
                   referralid,
                   userid,
                   personid,
                   Row_number()   OVER(partition BY referralid ORDER BY PersonRelationshipEndDate desc) AS RowNo
  --==== orderby by end date for the latest relationship
            FROM   RBMNB.dlFactPersonRelationship fpr
            WHERE  PersonRelationshipIsPrimaryCaseworker = 1
                   AND PersonRelationshipEndDate IS NULL) T1
    WHERE  RowNo =1),
     --=========taking any relationship that is open NB it may have begun before the above therefore taking Primary first
    
cte_RBMNB_all_active_relationship
     AS (SELECT 2 AS type,  --adding order to chaos
					PersonRelationshipID,
					ReferralId,
					UserID,
					PersonID,
					IsCaseWorker,
					rowno
         FROM   (SELECT PersonRelationshipID,
                        ReferralId,
                        UserID,
                        PersonID,
						case when fpr.PersonRelationshipIsPrimaryCaseworker = 1 then 1 else 0 end as IsCaseWorker,
                        Row_number() OVER(partition BY ReferralId  ORDER BY PersonRelationshipStartDate DESC ) AS RowNo
                 FROM   RBMNB.dlFactPersonRelationship fpr
                 WHERE  PersonRelationshipEndDate IS NULL) AS t2
                 WHERE  rowno = 1)
     

--===== now taking the lastest relationship - it may have ended
     ,cte_RBMNB_all_other_relationship
     AS (SELECT 3 AS type,
					PersonRelationshipID,
					ReferralId,
					UserID,
					PersonID,
					IsCaseWorker,
					rowno
         FROM   (SELECT PersonRelationshipID,
					ReferralId,
					UserID,
					PersonID,
					IsCaseWorker,
                    rowno
                 FROM   (SELECT   PersonRelationshipID,
									ReferralId,
									UserID,
									PersonID,
									case when fpr.PersonRelationshipIsPrimaryCaseworker = 1 then 1 else 0 end as IsCaseWorker,
                                Row_number() OVER(partition BY referralid ORDER BY PersonRelationshipEndDate DESC ) AS
                                RowNo
                         FROM   RBMNB.dlFactPersonRelationship fpr
                         WHERE  PersonRelationshipEndDate IS NOT NULL) AS t3
                         ) AS T31
WHERE  rowno = 1)

--===== bring CTE Tables Together - should be a drop down Filter and eliminated duplicates
     
,cte_RBMNB_latest_workers
     AS (SELECT type,
				PersonRelationshipID,
				ReferralId,
				UserID,
				IsCaseWorker,
				PersonID

         FROM   (SELECT type,
                    PersonRelationshipID,
					ReferralId,
					UserID,
					IsCaseWorker,
					PersonID

                 FROM   cte_RBMNB_latest_primary_case_worker_active
                 UNION
                 SELECT type,
						PersonRelationshipID,
						ReferralId,
						UserID,
						IsCaseWorker,
						PersonID
                 FROM   cte_RBMNB_all_active_relationship
                 UNION
                 SELECT type,
                    PersonRelationshipID,
					ReferralId,
					UserID,
					IsCaseWorker,
					PersonID
                 FROM   cte_RBMNB_all_other_relationship) AS T4
         WHERE  ReferralId IS NOT NULL)
	, CTE_RBMNB_Latest_Case_Worker
     AS (SELECT PersonRelationshipID,
				ReferralId,
				UserID,
				IsCaseWorker,
				PersonID
         FROM   (                
                SELECT Row_number () OVER (partition BY referralid ORDER BY referralid, type) AS Numbering,
                       type,
                       PersonRelationshipID,
						ReferralId,
						UserID,
						IsCaseWorker,
						PersonID
                 FROM   cte_RBMNB_latest_workers
                 AS type5
						) as type5a
						WHERE  numbering = 1
						)

--=============What happens:
--============= if there's an open primary caseworker this trumps and open person relationship which began AFTER the primary caseworker, and trumps all other relationships
--============= if there's an open relationship where there is no primary caseworker, we take this relationship.  If this starts after the above, we still take the above
--============= if there's no open relationships, we take the latest relationship



, CTE_PS_RBEAL (
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
	,cast(fr.ReferralID AS NVARCHAR) + '_1' AS uniquekey
	,max(lcw.IsCaseWorker) as is_case_worker_flag
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
			left join CTE_RBEAL_Latest_Case_Worker lcw on fr.referralid = lcw.ReferralId and fr.PersonID = lcw.PersonID
			LEFT JOIN rbeal.dlfactreferralstatus frs ON fr.referralid = frs.referralid
			LEFT JOIN rbeal.dlfactreferralstatus frsa ON fr.referralid = frsa.referralid 
			AND frsa.referralstatustypeid = 16
			LEFT JOIN rbeal.dlfactreferralstatus frsdis ON fr.referralid = frsdis.referralid 
			AND frsdis.referralstatustypeid = 19
			LEFT JOIN CTE_PS_RBEAL PS ON  fr.PersonID = ps.PersonID 
			AND ps.PersonStatusStartDate BETWEEN frsa.ReferralStatusStartDate AND frsdis.ReferralStatusStartDate 
			AND ps.PersonStatusEndDate BETWEEN frsa.ReferralStatusStartDate AND frsdis.ReferralStatusStartDate
			and frs.ReferralStatusTypeID not in (16,19)

			--lcw.PersonID = ps.PersonID and
			--inner JOIN rbeal.dlfactpersonrelationship fpr ON lcw.UserID = fpr.UserID and lcw.PersonID = fpr.PersonID and lcw.ReferralId = fpr.ReferralId and fr.personid = fpr.personid AND fr.referralid = fpr.referralid  
			left JOIN rbeal.dlfactpersonrelationship fpr ON lcw.PersonRelationshipID = fpr.PersonRelationshipID and fr.ReferralID = fpr.ReferralId

			LEFT Join CTE_EMPLOYEE_LOOKUP_RBEAL el on lcw.userid = el.UserID
			LEFT JOIN rbeal.dldimuser DU ON lcw.userid = du.userid AND du.userid != 503921
			
			LEFT JOIN [IntelliHR].[people] p1 ON p1.employeeNumber = isnull(cast(el.employeeNumber as Int),isnull(Convert(INT, REPLACE(du.UserEmployeeNumber, '.', '')), 0))
			--LEFT JOIN [IntelliHR].[people] p1 ON p1.employeeNumber = isnull(Convert(INT, REPLACE(du.UserEmployeeNumber, '.', '')), 0)
			AND p1.ODSIsCurrent = 1
			
			LEFT JOIN [IntelliHR].[people] p2 ON p2.primaryEmailAddress_email = du.UserEmailAddress AND p2.ODSIsCurrent = 1

		--FROM rbeal.dlfactreferral fr
		--LEFT JOIN rbeal.dlfactreferralstatus frs ON fr.referralid = frs.referralid
		--LEFT JOIN rbeal.dlfactreferralstatus frsa ON fr.referralid = frsa.referralid
		--	AND frsa.referralstatustypeid = 16
		--LEFT JOIN rbeal.dlfactreferralstatus frsdis ON fr.referralid = frsdis.referralid
		--	AND frsdis.referralstatustypeid = 19
		--LEFT JOIN CTE_PS_RBEAL PS ON fr.PersonID = ps.PersonID
		--	AND ps.PersonStatusStartDate BETWEEN frsa.ReferralStatusStartDate
		--		AND frsdis.ReferralStatusStartDate
		--	AND ps.PersonStatusEndDate BETWEEN frsa.ReferralStatusStartDate
		--		AND frsdis.ReferralStatusStartDate
		--LEFT JOIN rbeal.dlfactpersonrelationship fpr ON fr.personid = fpr.personid
		--	AND fr.referralid = fpr.referralid
		--LEFT JOIN rbeal.dldimuser DU ON fpr.userid = du.userid
		--	AND du.userid != 503921
		--LEFT JOIN [IntelliHR].[people] p1 ON p1.employeeNumber = isnull(Convert(INT, REPLACE(du.UserEmployeeNumber, '.', '')), 0)
		--	AND p1.ODSIsCurrent = 1
		--LEFT JOIN [IntelliHR].[people] p2 ON p2.primaryEmailAddress_email = du.UserEmailAddress
		--	AND p2.ODSIsCurrent = 1

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
	,cast(fr.ReferralID AS NVARCHAR) + '_5' AS uniquekey
	,max(lcw.IsCaseWorker) as is_case_worker_flag
	--,cast(fr.ReferralID AS NVARCHAR) + '_' + CAST(fr.personid AS NVARCHAR) + '_' + cast(fpr.UserID AS NVARCHAR) + '_' + '1' AS uniquekey
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
	left join CTE_RBMNB_Latest_Case_Worker lcw on fr.referralid = lcw.ReferralId and fr.PersonID = lcw.PersonID
	LEFT JOIN rbmnb.dlfactreferralstatus frs ON fr.referralid = frs.referralid
	LEFT JOIN rbmnb.dlfactreferralstatus frsa ON fr.referralid = frsa.referralid
		AND frsa.referralstatustypeid = 16
	LEFT JOIN rbmnb.dlfactreferralstatus frsdis ON fr.referralid = frsdis.referralid
		AND frsdis.referralstatustypeid = 19
	LEFT JOIN CTE_PS_RBMNB PS ON fr.PersonID = ps.PersonID
		AND ps.PersonStatusStartDate BETWEEN frsa.ReferralStatusStartDate AND frsdis.ReferralStatusStartDate
		AND ps.PersonStatusEndDate BETWEEN frsa.ReferralStatusStartDate AND frsdis.ReferralStatusStartDate
		and frs.ReferralStatusTypeID not in (16,19)

	--LEFT JOIN rbmnb.dlfactpersonrelationship fpr ON fr.personid = fpr.personid AND fr.referralid = fpr.referralid
	left JOIN rbmnb.dlfactpersonrelationship fpr ON lcw.PersonRelationshipID = fpr.PersonRelationshipID and fr.ReferralID = fpr.ReferralId
	
	LEFT Join CTE_EMPLOYEE_LOOKUP_RBMNB el on lcw.userid = el.UserID
	LEFT JOIN rbmnb.dldimuser DU ON fpr.userid = du.userid
	LEFT JOIN [IntelliHR].[people] p1 ON p1.employeeNumber = isnull(cast(el.employeeNumber as Int),isnull(Convert(INT, REPLACE(du.UserEmployeeNumber, '.', '')), 0))
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