CREATE   view row_level_security_recordbase

AS

select
P.[employeeNumber] as employee_number
, P.[displayName] as employee_display_name
, U.UserEmailAddress as employee_email
, J.name as job_title
, P.isSupervisor as is_supervisor
, T.TeamID as recordbase_team_id
, T.TeamName as recordbase_team_name
, U.UserID
, U.UserUsername
, U.UserFirstName
, U.UserLastName
, U.UserEmailAddress
, U.ReportsToUserID
, U.UserEmployeeNumber
, T.TeamID
, T.TeamName
, T.TeamCode
, 'Emerge Aotearoa Limited' as company_name

from RBEAL.dlDimUser as U


left join [RBEAL].[dlFactUserTeam] as FUT on U.UserID = FUT.USERID and UserTeamDeletedDate is null
left join RBEAL.dlDimTeam as T on T.TeamID = FUT.TeamID 
left join IntelliHR.People as P on U.UserEmailAddress = P.primaryEmailAddress_email and P.ODSIsCurrent=1
left join IntelliHR.Jobs as J on J.person_id = P.people_id and J.ODSIsCurrent = 1 and P.ODSIsCurrent=1
where U.UserDisabledDate is null
and U.UserTypeID <> 2 -- exclude Wildbambo Users

UNION

SELECT
	P.[employeeNumber] as employee_number
	, P.[displayName] as employee_display_name
	, U.UserEmailAddress as employee_email
	, J.name as job_title
	, P.isSupervisor as is_supervisor
	, T.TeamID as recordbase_team_id
	, T.TeamName as recordbase_team_name
	, U.UserID
	, U.UserUsername
	, U.UserFirstName
	, U.UserLastName
	, U.UserEmailAddress
	, U.ReportsToUserID
	, U.UserEmployeeNumber
	, T.TeamID
	, T.TeamName
	, T.TeamCode
	, 'Mind and Body Consultants Ltd' as company_name
from RBMNB.dlDimUser as U


left join RBMNB.[dlFactUserTeam] as FUT on U.UserID = FUT.USERID and UserTeamDeletedDate is null
left join RBMNB.dlDimTeam as T on T.TeamID = FUT.TeamID 
left join IntelliHR.People as P on U.UserEmailAddress = P.primaryEmailAddress_email and P.ODSIsCurrent=1
left join IntelliHR.Jobs as J on J.person_id = P.people_id and J.ODSIsCurrent = 1 and P.ODSIsCurrent=1
where U.UserDisabledDate is null
and U.UserTypeID <> 2 -- exclude Wildbambo Users