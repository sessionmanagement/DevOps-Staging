

CREATE           view [ETL].[fact_client_incident]

as

/**********************************************************************************************************
 View		[ETL].[fact_client_incident]
 Author		Pankaj Bhatt
 Created	2025-11-05
 Purpose	Used to build the edw.fact_client_incident table 

 **************************************************************************************************************
--REVISIONS:
--Version	 Date			Author			Description
---------	 ------------	---------------	--------------------------
--1.0		 2025-11-05		Pankaj Bhatt	Initial version
--1.1		 2025-11-27		Pankaj Bhatt	Added IncidentStatus

**************************************************************************************************************/

WITH
RBEALOriginator AS (
select a.IncidentID,
b.UserEmployeeNumber OriginatorUserID,
b.UserEmailAddress OriginatorUserEmailAddress
from
(SELECT 
IncidentID, 
max(OriginatorUserID) OriginatorUserID -- ther's only one OriginatorUserID but added max for defensive code
FROM RBEAL.incidentFactIncidentStatistics
WHERE ODSIsCurrent = 1
group by IncidentID) a
left outer join RBEAL.dlDimUser b
on a.OriginatorUserID = b.userid
), 
RBMNBOriginator AS (
select a.IncidentID,
b.UserEmployeeNumber OriginatorUserID,
b.UserEmailAddress OriginatorUserEmailAddress
from
(SELECT 
IncidentID, 
max(OriginatorUserID) OriginatorUserID -- ther's only one OriginatorUserID but added max for defensive code
FROM RBMNB.incidentFactIncidentStatistics
WHERE ODSIsCurrent = 1
group by IncidentID) a
left outer join RBMNB.dlDimUser b
on a.OriginatorUserID = b.userid
),
RBEALSeverity AS (
select
a.IncidentID,
max(a.IncidentSeverityID) IncidentSeverityID
FROM RBEAL.dlFactIncidentAssessment A
INNER JOIN (
SELECT
IncidentID,
MAX(IncidentAssessmentCreatedDate) AS MaxDate
FROM RBEAL.dlFactIncidentAssessment
GROUP BY IncidentID) B
ON A.IncidentID = B.IncidentID AND A.IncidentAssessmentCreatedDate = B.MaxDate
group by a.IncidentID
),
RBMNBSeverity AS (
select
a.IncidentID,
max(a.IncidentSeverityID) IncidentSeverityID
FROM RBMNB.dlFactIncidentAssessment A
INNER JOIN (
SELECT
IncidentID,
MAX(IncidentAssessmentCreatedDate) AS MaxDate
FROM RBMNB.dlFactIncidentAssessment
GROUP BY IncidentID) B
ON A.IncidentID = B.IncidentID AND A.IncidentAssessmentCreatedDate = B.MaxDate
group by a.IncidentID
)
,
RBEALIncidentCategory AS (
select
a.IncidentID,
max(a.IncidentCategoryTypeID) IncidentCategoryTypeID
FROM RBEAL.dlFactIncidentCategory A
INNER JOIN (
SELECT
IncidentID,
MAX(IncidentCategoryCreatedDate) AS MaxDate
FROM RBEAL.dlFactIncidentCategory
GROUP BY IncidentID) B
ON A.IncidentID = B.IncidentID AND A.IncidentCategoryCreatedDate = B.MaxDate
group by a.IncidentID
),
RBMNBIncidentCategory AS (
select
a.IncidentID,
max(a.IncidentCategoryTypeID) IncidentCategoryTypeID
FROM RBMNB.dlFactIncidentCategory A
INNER JOIN (
SELECT
IncidentID,
MAX(IncidentCategoryCreatedDate) AS MaxDate
FROM RBMNB.dlFactIncidentCategory
GROUP BY IncidentID) B
ON A.IncidentID = B.IncidentID AND A.IncidentCategoryCreatedDate = B.MaxDate
group by a.IncidentID
),
RBEALIncidentStatus AS (
select
a.IncidentID,
max(a.IncidentStatusTypeID) IncidentStatusTypeID,
max(a.IncidentStatusCreatedDate) IncidentStatusCreatedDate
FROM RBEAL.dlFactIncidentStatus A
INNER JOIN (
SELECT
IncidentID,
MAX(IncidentStatusCreatedDate) AS MaxDate
FROM RBEAL.dlFactIncidentStatus
GROUP BY IncidentID) B
ON A.IncidentID = B.IncidentID AND A.IncidentStatusCreatedDate = B.MaxDate
group by a.IncidentID
),
RBMNBIncidentStatus AS (
select
a.IncidentID,
max(a.IncidentStatusTypeID) IncidentStatusTypeID,
max(a.IncidentStatusCreatedDate) IncidentStatusCreatedDate
FROM RBMNB.dlFactIncidentStatus A
INNER JOIN (
SELECT
IncidentID,
MAX(IncidentStatusCreatedDate) AS MaxDate
FROM RBMNB.dlFactIncidentStatus
GROUP BY IncidentID) B
ON A.IncidentID = B.IncidentID AND A.IncidentStatusCreatedDate = B.MaxDate
group by a.IncidentID
)

SELECT 
	1 AS company_key
    ,fi.IncidentID as incident_id
    ,fi.IncidentDate as incident_date
    ,fi.IncidentCreatedDate as incident_created_date
	,du1.UserEmployeeNumber as current_owner_user_id
    ,du2.UserEmployeeNumber as current_investigator_user_id
    ,du3.UserEmployeeNumber as current_reporter_user_id
    ,du4.UserEmployeeNumber as incident_created_user_id
    ,du1.UserEmailAddress as current_owner_user_email_address
    ,du2.UserEmailAddress as current_investigator_user_email_address
    ,du3.UserEmailAddress as current_reporter_user_email_address
    ,du4.UserEmailAddress as incident_created_user_email_address
    ,fist.IncidentStatusTypeID as current_incident_status_type_id
    ,fist.IncidentStatusCreatedDate as current_incident_status_created_date
    ,TeamID as team_id
    ,fio.OriginatorUserID as originator_user_id
    ,fio.OriginatorUserEmailAddress as originator_user_email_address
    ,fis.IncidentSeverityID as current_incident_severity_id
    ,fic.IncidentCategoryTypeID as incident_category_type_id
FROM RBEAL.dlFactIncident fi
LEFT OUTER JOIN RBEAL.dlDimUser du1 on fi.CurrentOwnerUserID = du1.userid
LEFT OUTER JOIN RBEAL.dlDimUser du2 on fi.CurrentInvestigatorUserID = du2.userid
LEFT OUTER JOIN RBEAL.dlDimUser du3 on fi.CurrentReporterUserID = du3.userid
LEFT OUTER JOIN RBEAL.dlDimUser du4 on fi.IncidentCreatedUserID = du4.userid
LEFT OUTER JOIN RBEALOriginator fio ON fi.IncidentID = fio.IncidentID
LEFT OUTER JOIN RBEALSeverity fis ON fi.IncidentID = fis.IncidentID
LEFT OUTER JOIN RBEALIncidentCategory fic ON fi.IncidentID = fic.IncidentID
LEFT OUTER JOIN RBEALIncidentStatus fist ON fi.IncidentID = fist.IncidentID
union all
SELECT 
	5 AS company_key
    ,fi.IncidentID as incident_id
    ,fi.IncidentDate as incident_date
    ,fi.IncidentCreatedDate as incident_created_date
	,du1.UserEmployeeNumber as current_owner_user_id
    ,du2.UserEmployeeNumber as current_investigator_user_id
    ,du3.UserEmployeeNumber as current_reporter_user_id
    ,du4.UserEmployeeNumber as incident_created_user_id
    ,du1.UserEmailAddress as current_owner_user_email_address
    ,du2.UserEmailAddress as current_investigator_user_email_address
    ,du3.UserEmailAddress as current_reporter_user_email_address
    ,du4.UserEmailAddress as incident_created_user_email_address
    ,fist.IncidentStatusTypeID as current_incident_status_type_id
    ,fist.IncidentStatusCreatedDate as current_incident_status_created_date
    ,TeamID as team_id
    ,fio.OriginatorUserID as originator_user_id
    ,fio.OriginatorUserEmailAddress as originator_user_email_address
    ,fis.IncidentSeverityID as current_incident_severity_id
    ,fic.IncidentCategoryTypeID as incident_category_type_id
FROM RBMNB.dlFactIncident fi
LEFT OUTER JOIN RBMNB.dlDimUser du1 on fi.CurrentOwnerUserID = du1.userid
LEFT OUTER JOIN RBMNB.dlDimUser du2 on fi.CurrentInvestigatorUserID = du2.userid
LEFT OUTER JOIN RBMNB.dlDimUser du3 on fi.CurrentReporterUserID = du3.userid
LEFT OUTER JOIN RBMNB.dlDimUser du4 on fi.IncidentCreatedUserID = du4.userid
LEFT OUTER JOIN RBMNBOriginator fio ON fi.IncidentID = fio.IncidentID
LEFT OUTER JOIN RBMNBSeverity fis ON fi.IncidentID = fis.IncidentID
LEFT OUTER JOIN RBMNBIncidentCategory fic ON fi.IncidentID = fic.IncidentID
LEFT OUTER JOIN RBMNBIncidentStatus fist ON fi.IncidentID = fist.IncidentID