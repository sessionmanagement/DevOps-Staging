

CREATE   view [ETL].[fact_employee_user_session]
as 

/**********************************************************************************************************
 View		[ETL].[fact_employee_user_session]
 Author		Greg Nuthall
 Created	27-08-2026	
 Purpose	Used to build the edw.fact_employee_user_session table 

 **************************************************************************************************************
--REVISIONS:
--Version	 Date			Author			Description
---------	 ------------	---------------	--------------------------
--1.0		 27-08-2026		Greg Nuthall	Initial version
**************************************************************************************************************/


SELECT 10000000 + try_cast(s.[UserSessionID] as int) as [employee_session_id]
      ,1 as company_id
      ,s.[UserID] as [user_id]
      ,s.[UserSessionSignOnDate] as sign_on_date
      ,s.[UserSessionIPAddress] as IP_address 
      ,s.[UserSessionBrowserName] as browser_name
      ,s.[UserSessionBrowserVersion] as browser_version
      ,s.[ApplicationId] as application_id
      ,s.[UserSessionUserAgent] as user_agent
      ,s.[ImpersonatedByUserId] as impersonator_id
      ,s.[UserSessionRecordbaseIdentitySignOnSession] as identity_sign_on_session
      ,try_cast(u.UserEmployeeNumber as int) as employee_id
      ,u.UserEmailAddress as employee_email
      ,r.RoleName as employee_role
      ,'Recordbase EAL' as session_location

  FROM RBEAL.[dlFactUserSession] s
  left outer join RBEAL.dlDimUser u on s.UserID = u.UserID
  left outer join RBEAL.dlFactUserRole ur on s.UserID = ur.UserID 
  left outer join RBEAL.dlDimRole r on ur.RoleID = r.RoleID 

  union 

  SELECT 50000000 + try_cast(s.[UserSessionID] as Int) as [employee_session_id]
      ,5 as company_id
      ,s.[UserID] as [user_id]
      ,s.[UserSessionSignOnDate] as sign_on_date
      ,s.[UserSessionIPAddress] as IP_address 
      ,s.[UserSessionBrowserName] as browser_name
      ,s.[UserSessionBrowserVersion] as browser_version
      ,s.[ApplicationId] as application_id
      ,s.[UserSessionUserAgent] as user_agent
      ,s.[ImpersonatedByUserId] as impersonator_id
      ,s.[UserSessionRecordbaseIdentitySignOnSession] as identity_sign_on_session
      ,try_cast(u.UserEmployeeNumber as int) as employee_id
      ,u.UserEmailAddress as employee_email
      ,r.RoleName as employee_role
      ,'Recordbase MNB' as session_location

  FROM RBMNB.[dlFactUserSession] s
  left outer join RBMNB.dlDimUser u on s.UserID = u.UserID
  left outer join RBMNB.dlFactUserRole ur on s.UserID = ur.UserID 
  left outer join RBMNB.dlDimRole r on ur.RoleID = r.RoleID