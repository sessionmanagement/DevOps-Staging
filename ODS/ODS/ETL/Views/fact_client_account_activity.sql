/****** Object:  View [ETL].[fact_client_account_activity]    Script Date: 29/01/2026 10:03:37 am ******/
CREATE   view [ETL].[fact_client_account_activity]

/****************************************************************************************************************
 View		[ETL].[fact_client_account_activity]
 Author		Greg Nuthall
 Created	2024/10/17
 Purpose	Used to build the edw.fact_client_account_activity table 

 ***************************************************************************************************************
--REVISIONS:
--Version	Date			Author			Description
---------	------------	------------	--------------------------
--1.0		2024/10/17 		Greg Nuthall	Initial version
--1.1       2025-08-05      Greg Nuthall    Fixed reference to company_id (could use company table but hard coded like the rest).
--1.2       2026-01-22      Greg Nuthall    Added participated_employee_id and created_user_id linked from dlFactAccountActivityParticipant
--                                          Removed client_account_id no need for this field
****************************************************************************************************************/

as

select cast(aa.accountactivityid as nvarchar) + '_' +  format(aa.accountactivityenddate,'yyyyMMdd') + '_1' as fact_client_account_activity_id
	  ,aa.accountactivityid as client_account_activity_id
      --,aa.accountid as client_account_id
      ,aa.accountactivitylocation as client_account_activity_location
      ,aa.accountactivitysubject as client_account_activity_subject
      ,aa.accountactivitydescriptionhtml as client_account_activity_description_html
      ,aa.accountactivitydescriptionraw as client_account_activity_description_raw
      ,aa.accountactivitystartdate as client_account_activity_start_date
      ,aa.accountactivityenddate as client_account_activity_end_date
      ,aa.accountactivitytypeid as client_account_activity_type_id
      ,aa.accountactivityclassificationid as client_account_activity_classification_id
      ,aa.accountactivitycreateddate as client_account_activity_created_date
      ,aa.accountactivitycreateduserid as client_account_activity_created_user_id
      ,aa.accountactivityudf1 as client_account_activity_udf1
      ,aa.accountactivityudf2 as client_account_activity_udf2
      ,aa.accountactivityudf3 as client_account_activity_udf3
      ,aa.accountactivityudf4 as client_account_activity_udf4
      ,aa.accountactivityudf5 as client_account_activity_udf5
      ,aa.accountactivityotherparticipants as client_account_activity_other_participants
      ,aa.teamid as client_team_id
      ,aa.accountactivityaudiencesize as client_account_activity_audience_size
	  ,ac.AccountActivityClassificationText as client_account_activity_classification_text
	  ,t.accountactivitytypetext as client_account_activity_type_text
	  ,a.accountname as client_account_name
	  ,1 as company_id
	  ,a.PrimaryContactID as primary_contact_id
      ,case when isnull(u.UserEmployeeNumber,'') = '' then 0 else cast(u.UserEmployeeNumber as integer) end as participated_employee_id
	  ,case when isnull(u2.UserEmployeeNumber,'') = '' then 0 else cast(u2.UserEmployeeNumber as integer) end as created_employee_id
      --,u2.UserEmployeeNumber as created_employee_id


	from rbeal.dlfactaccountactivity aa
	  left outer join rbeal.dldimaccountactivityclassification ac on aa.accountactivityclassificationid = ac.AccountActivityClassificationID
	  left outer join rbeal.dldimaccountactivitytype t on aa.accountactivitytypeid = t.accountactivitytypeid
	  left outer join rbeal.dldimaccount a on aa.accountid = a.accountid
	  left outer join rbeal.dlFactAccountActivityParticipant ap on aa.accountactivityid = ap.AccountActivityID
      left outer join rbeal.dlDimUser u on ap.userid= u.userid
      left outer join rbeal.dlDimUser u2 on ap.AccountActivityParticipantCreatedUserID = u2.userid

  union all  
	
  select cast(aa.accountactivityid as nvarchar) + '_' +  format(aa.accountactivityenddate,'yyyyMMdd') + '_5' as fact_client_account_activity_id
	  ,aa.accountactivityid as client_account_activity_id
      --,aa.accountid as client_account_id
      ,aa.accountactivitylocation as client_account_activity_location
      ,aa.accountactivitysubject as client_account_activity_subject
      ,aa.accountactivitydescriptionhtml as client_account_activity_description_html
      ,aa.accountactivitydescriptionraw as client_account_activity_description_raw
      ,aa.accountactivitystartdate as client_account_activity_start_date
      ,aa.accountactivityenddate as client_account_activity_end_date
      ,aa.accountactivitytypeid as client_account_activity_type_id
      ,aa.accountactivityclassificationid as client_account_activity_classification_id
      ,aa.accountactivitycreateddate as client_account_activity_created_date
      ,aa.accountactivitycreateduserid as client_account_activity_created_user_id
      ,aa.accountactivityudf1 as client_account_activity_udf1
      ,aa.accountactivityudf2 as client_account_activity_udf2
      ,aa.accountactivityudf3 as client_account_activity_udf3
      ,aa.accountactivityudf4 as client_account_activity_udf4
      ,aa.accountactivityudf5 as client_account_activity_udf5
      ,aa.accountactivityotherparticipants as client_account_activity_other_participants
      ,aa.teamid as client_team_id
      ,aa.accountactivityaudiencesize as client_account_activity_audience_size
	  ,ac.AccountActivityClassificationText as client_account_activity_classification_text
	  ,t.accountactivitytypetext as client_account_activity_type_text
	  ,a.accountname as client_account_name
	  ,5 as company_id
	  ,a.PrimaryContactID as primary_contact_id
      --,u.UserEmployeeNumber as participated_employee_id
	  --,u2.UserEmployeeNumber as created_employee_id
      ,case when isnull(u.UserEmployeeNumber,'') = '' then 0 else cast(u.UserEmployeeNumber as integer) end as participated_employee_id
	  ,case when isnull(u2.UserEmployeeNumber,'') = '' then 0 else cast(u2.UserEmployeeNumber as integer) end as created_employee_id

	  from rbmnb.dlfactaccountactivity aa
	  left outer join rbmnb.dldimaccountactivityclassification ac on aa.accountactivityclassificationid = ac.AccountActivityClassificationID
	  left outer join rbmnb.dldimaccountactivitytype t on aa.accountactivitytypeid = t.accountactivitytypeid
	  left outer join rbmnb.dldimaccount a on aa.accountid = a.accountid
      left outer join rbmnb.dlFactAccountActivityParticipant ap on aa.accountactivityid = ap.AccountActivityID
      left outer join rbmnb.dlDimUser u on ap.userid= u.userid
      left outer join rbmnb.dlDimUser u2 on ap.AccountActivityParticipantCreatedUserID = u2.userid