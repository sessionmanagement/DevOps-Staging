
CREATE PROC [staging].[insert_staging_fact_employee_user_session]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_fact_employee_user_session]
PURPOSE:  Import fact_employee_user_session to the DWH

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2026-09-02    Greg Nuthall		Initial version

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLfact_employee_user_session]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLfact_employee_user_session] (
	 [employee_session_id]
	,[dim_employee_key]
	,[user_id]
	,[company_id]
	,[sign_on_date] 
	,[IP_address] 
	,[browser_name] 
	,[browser_version] 
	,[application_id] 
	,[user_agent] 
	,[impersonator_id] 
	,[identity_sign_on_session] 
	,[employee_id] 
	,[employee_email] 
	,[employee_role] 
	,[session_location] 
	
	)
SELECT
	 u.[employee_session_id] 
	 ,case when isnull(u.employee_id,0) <> 0 
			    then ISNULL(e.dim_employee_key,isnull(em.dim_employee_key,-1)) 
		else 0 end 
	as dim_employee_key
	,u.[user_id]
	,u.[company_id]
	,u.[sign_on_date] 
	,u.[IP_address] 
	,u.[browser_name] 
	,u.[browser_version] 
	,u.[application_id] 
	,u.[user_agent] 
	,u.[impersonator_id] 
	,u.[identity_sign_on_session] 
	,u.[employee_id] 
	,u.[employee_email] 
	,u.[employee_role] 
	,u.[session_location] 
	
from [Landing].[edw_fact_employee_user_session] u
left outer join edw.dim_employee e on u.employee_id = e.employee_id and e.DWHIsCurrent = 1
left outer join edw.dim_employee em on u.employee_email = em.employee_primary_email_address and em.DWHIsCurrent = 1