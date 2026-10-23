
CREATE   view [ETL].[fact_client_activity_breakdown]

/****************************************************************************************************************
 View		[ETL].[fact_client_activity_breakdown]
 Author		????
 Created	????
 Purpose	Used to build the edw.fact_client_activity_breakdown table 

 ***************************************************************************************************************
--REVISIONS:
--Version	 Date		   Author			Description
---------	 ------------  ---------------	--------------------------
--1.0		2023/09/14 		???????			Initial version
--1.1		2024/05/06		(TB,GN)			User a CTE_lookup to get the correct employee_number via email and name
--1.2		2024/07/30		Greg Nuthall	Added activity whanau involvement flag
--2.0		2024/09/16		(TB,GN)			Restructured with layers of CTE's to get the correct joining and data from parent layer
--2.1       2026-03-26      (TB,GN)			Added two descriptions and renamed client_activity_name to client_activity_type_name
****************************************************************************************************************/

as
	
	with Fap_User_EAL as
	(
	select  fap.ActivityID
		   ,fap.Referralid
		   ,u.userid 
		   ,u.UserEmployeeNumber
		   ,u.UserFirstName
		   ,u.UserLastName
		   ,p.employeeNumber as ReserveEmployeeNumber
	   
		from rbeal.dlFactActivityParticipant fap
		left join rbeal.dldimuser u on fap.EntityID = u.userid 
		left join (Select max(employeeNumber) as employeeNumber, primaryEmailAddress_email 
				   from IntelliHR.people where ODSIsCurrent = 1 
				   group by primaryEmailAddress_email) p 
		on u.UserEmailAddress = p.primaryEmailAddress_email
		where activityparticipantentitytype = 'user'
		and fap.ActivityID in (Select distinct ActivityID from rbeal.dlfactactivity where ActivityCreatedDate >= DateAdd(MONTH,-24,GetDate()))
		)

	,Fap_Person_EAL as
	(
	select  fap.ActivityID,
		   fap.Referralid,
		   fap.EntityID as personid,
		   dldimperson.PersonFirstName,
		   dlDimPerson.personlastname 
	 	 
		from rbeal.dlFactActivityParticipant fap
		left join rbeal.dldimperson on fap.entityid = dldimperson.personid 
		where activityparticipantentitytype = 'Person'
		and fap.ActivityID in (Select distinct ActivityID from rbeal.dlfactactivity where ActivityCreatedDate >= DateAdd(MONTH,-24,GetDate()))
		)


	,Fap_User_MNB as
	(
	select  fap.ActivityID
		   ,fap.Referralid
		   ,u.userid 
		   ,u.UserEmployeeNumber
		   ,u.UserFirstName
		   ,u.UserLastName
		   ,p.employeeNumber as ReserveEmployeeNumber
	   
		from rbmnb.dlFactActivityParticipant fap
		left join rbmnb.dldimuser u on fap.EntityID = u.userid 
		left join (Select max(employeeNumber) as employeeNumber, primaryEmailAddress_email 
				   from IntelliHR.people where ODSIsCurrent = 1 
				   group by primaryEmailAddress_email) p 
		on u.UserEmailAddress = p.primaryEmailAddress_email
		where activityparticipantentitytype = 'user'
		and fap.ActivityID in (Select distinct ActivityID from rbmnb.dlfactactivity where ActivityCreatedDate >= DateAdd(MONTH,-24,GetDate()))
		)

	,Fap_Person_MNB as
	(
	select  fap.ActivityID,
		   fap.Referralid,
		   fap.EntityID as personid,
		   dldimperson.PersonFirstName,
		   dlDimPerson.personlastname 
	 	 
		from rbmnb.dlFactActivityParticipant fap
		left join rbmnb.dldimperson on fap.entityid = dldimperson.personid 
		where activityparticipantentitytype = 'Person'
		and fap.ActivityID in (Select distinct ActivityID from rbmnb.dlfactactivity where ActivityCreatedDate >= DateAdd(MONTH,-24,GetDate()))
		)

	,EAL_activity as
	(
	select 
	1 as company_key
	,fab.activitybreakdownid as client_activity_breakdown_id
	,fa.activityid as client_activity_id
	,fa.primaryactivityid as client_parent_activity_id
	,fa.teamid as client_team_id
	,fab.activitybreakdowntypeid as client_activity_breakdown_type_id
	,dat.activitytypecode as client_activity_type_code
	,dat.activitytypename as client_activity_type_name  --client_activity_name
	,dat.ActivityTypeDescription as client_activity_type_description
	,dac.activityclassificationcode as client_activity_classification_code
	,dac.activityclassificationname as client_activity_classification_name
	,dac.ActivityClassificationDescription as client_activity_classification_description
	,fa.activitycreateddate as client_activity_created_date
	,fa.activitystartdate as client_activity_start_date
	,fa.activityenddate as client_activity_end_date
	,fab.activitybreakdowncreateddate as client_activity_breakdown_created_date
	,(case when isnull(fab.activitybreakdownid,0) = 0 
		then datediff(minute,fa.activitystartdate,fa.activityenddate )
		else fab.activitybreakdownduration end) as client_activity_duration
	,isnull(fa.activitywhanauinvolvement,0) as client_activity_whanau_involvement
	,fa.GroupActivityID as client_group_activity_id
	,fa.ActivitySubject as client_activity_subject
	,fa.ActivityDescription as client_activity_description
	


	from rbeal.dlfactactivity as fa
	left join rbeal.dlfactactivitybreakdown fab on fab.activityid = fa.activityid
	left join rbeal.dldimactivitybreakdowntype dab on fab.activitybreakdowntypeid = dab.activitybreakdowntypeid
	left join rbeal.dldimactivitytype dat on fa.activitytypeid = dat.activitytypeid
	left join rbeal.dldimactivityclassification dac on fa.activityclassificationid = dac.activityclassificationid
	
	--dldimactivityclassification
	--dldimactivityclassification

	where fa.ActivityCreatedDate >= DateAdd(MONTH,-24,GetDate())

	group by fab.activitybreakdownid
	,fa.activityid
	,fa.primaryactivityid
	,fa.teamid
	,fab.activitybreakdowntypeid 
	,dat.activitytypecode
	,dat.activitytypename
	,dat.ActivityTypeDescription
	,dac.activityclassificationcode 
	,dac.activityclassificationname
	,dac.ActivityClassificationDescription
	,fa.activitycreateddate 
	,fa.activitystartdate 
	,fa.activityenddate 
	,fab.activitybreakdowncreateddate 
	,(case when isnull(fab.activitybreakdownid,0) = 0 
		then datediff(minute,fa.activitystartdate,fa.activityenddate)
		else fab.activitybreakdownduration end) 
	,isnull(fa.activitywhanauinvolvement,0) 
	,fa.GroupActivityID 
	,fa.ActivitySubject 
	,fa.ActivityDescription 
	)

	, MNB_activity as
	(
	select 
	5 as company_key
	,fab.activitybreakdownid as client_activity_breakdown_id
	,fa.activityid as client_activity_id
	,fa.primaryactivityid as client_parent_activity_id
	
	,fa.teamid as client_team_id
	,fab.activitybreakdowntypeid as client_activity_breakdown_type_id
	,dat.activitytypecode as client_activity_type_code
	,dat.activitytypename as client_activity_type_name  --client_activity_name
	,dat.ActivityTypeDescription as client_activity_type_description
	,dac.activityclassificationcode as client_activity_classification_code
	,dac.activityclassificationname as client_activity_classification_name
	,dac.ActivityClassificationDescription as client_activity_classification_description
	,fa.activitycreateddate as client_activity_created_date
	,fa.activitystartdate as client_activity_start_date
	,fa.activityenddate as client_activity_end_date
	,fab.activitybreakdowncreateddate as client_activity_breakdown_created_date
	,(case when isnull(fab.activitybreakdownid,0) = 0 
		then datediff(minute,fa.activitystartdate,fa.activityenddate)
		else fab.activitybreakdownduration end) as client_activity_duration
	,isnull(fa.activitywhanauinvolvement,0) as client_activity_whanau_involvement
	,fa.GroupActivityID as client_group_activity_id
	,fa.ActivitySubject as client_activity_subject
	,fa.ActivityDescription as client_activity_description
	

	from rbmnb.dlfactactivity as fa
	left join rbmnb.dlfactactivitybreakdown fab on fab.activityid = fa.activityid
	left join rbmnb.dldimactivitybreakdowntype dab on fab.activitybreakdowntypeid = dab.activitybreakdowntypeid
	left join rbmnb.dldimactivitytype dat on fa.activitytypeid = dat.activitytypeid
	left join rbmnb.dldimactivityclassification dac on fa.activityclassificationid = dac.activityclassificationid
	
	where fa.ActivityCreatedDate >= DateAdd(Month,-24,GetDate())

	group by fab.activitybreakdownid
	,fa.activityid
	,fa.primaryactivityid
	,fa.teamid
	,fab.activitybreakdowntypeid 
	,dat.activitytypecode
	,dat.activitytypename
	,dat.ActivityTypeDescription
	,dac.activityclassificationcode 
	,dac.activityclassificationname
	,dac.ActivityClassificationDescription
	,fa.activitycreateddate 
	,fa.activitystartdate 
	,fa.activityenddate 
	,fab.activitybreakdowncreateddate 
	,(case when isnull(fab.activitybreakdownid,0) = 0 
		then datediff(minute,fa.activitystartdate,fa.activityenddate)
		else fab.activitybreakdownduration end) 
	,isnull(fa.activitywhanauinvolvement,0) 
	,fa.GroupActivityID 
	,fa.ActivitySubject 
	,fa.ActivityDescription 


	)
	
	--===creating activities by using the primary activity parts
	,EAL_parts as (	
	select  
	activitystartdate
	,activityenddate 
	,a.activityid 
	,PrimaryActivityID
	,teamid
	,fu.UserEmployeeNumber
	,fu.UserFirstName
	,fu.UserLastName
	
	from rbeal.dlfactactivity a
	--left join Fap_User_EAL fu on a.ActivityID = fu.ActivityID
	--where a.ActivityID in (select PrimaryActivityID from EAL_activity)
	--and a.ActivityCreatedDate >= '2021-01-01'
	inner join EAL_activity ea on a.ActivityID = ea.client_parent_activity_id
    left join Fap_User_EAL fu on a.ActivityID = fu.ActivityID
    WHERE a.ActivityCreatedDate >= DateAdd(Month,-24,GetDate())

	group by activitystartdate
	,activityenddate 
	,a.activityid 
	,PrimaryActivityID
	,teamid
	,fu.UserEmployeeNumber
	,fu.UserFirstName
	,fu.UserLastName

	)
	
	--===creating activities by using the primary activity parts
	,MNB_parts as (	
	select  
	a.activitystartdate
	,a.activityenddate 
	,a.activityid 
	,PrimaryActivityID
	,a.TeamID 
	,fu.UserEmployeeNumber
	,fu.UserFirstName
	,fu.UserLastName
	
	from rbmnb.dlfactactivity a
	--left join Fap_User_MNB fu on a.ActivityID = fu.ActivityID
	--where a.ActivityID in (select PrimaryActivityID from MNB_activity)
	inner join MNB_activity ma on a.ActivityID = ma.client_parent_activity_id
    left join Fap_User_MNB fu on a.ActivityID = fu.ActivityID
    WHERE a.ActivityCreatedDate >= DateAdd(Month,-24,GetDate())

	group by activitystartdate
	,activityenddate 
	,a.activityid 
	,PrimaryActivityID
	,teamid
	,fu.UserEmployeeNumber
	,fu.UserFirstName
	,fu.UserLastName

	)
	


	SELECT
	1 as company_key
	,a.client_activity_breakdown_id as client_activity_breakdown_id
	,a.client_activity_id
	,a.client_parent_activity_id
	,fp.ReferralID as client_referral_id
	,fp.personid as client_id
	,coalesce(fu.userid, u2.userid,0) as client_activity_user_id
	,coalesce(
        nullif(fu.UserEmployeeNumber, ''),
        nullif(u2.UserEmployeeNumber, ''),
        nullif(fu.ReserveEmployeeNumber, ''),
        u2.ReserveEmployeeNumber
    ) AS user_employee_number
	,a.client_team_id
	,a.client_activity_breakdown_type_id
	,a.client_activity_type_code
	,a.client_activity_type_name
	,a.client_activity_type_description
	,a.client_activity_classification_code
	,a.client_activity_classification_name
	,a.client_activity_classification_description
	,a.client_activity_created_date
	,a.client_activity_start_date
	,a.client_activity_end_date
	,a.client_activity_breakdown_created_date
	,a.client_activity_duration
	,a.client_activity_whanau_involvement
	,a.client_group_activity_id
	,a.client_activity_subject
	,a.client_activity_description
	

	from EAL_activity a
	left join EAL_parts p on a.client_parent_activity_id = p.ActivityID
	left join Fap_Person_EAL fp on a.client_activity_id = fp.ActivityID
	left join Fap_User_EAL fu on a.client_parent_activity_id = fu.ActivityID 
	left join Fap_User_EAL u2 on a.client_activity_id = u2.ActivityID
	
	group by a.client_activity_breakdown_id
	,client_activity_id
	,client_parent_activity_id
	,fp.ReferralID
	,fp.personid
	,coalesce(fu.userid, u2.userid,0)
	,coalesce(
        nullif(fu.UserEmployeeNumber, ''),
        nullif(u2.UserEmployeeNumber, ''),
        nullif(fu.ReserveEmployeeNumber, ''),
        u2.ReserveEmployeeNumber
    ) 
	,client_team_id
	,client_activity_breakdown_type_id
	,client_activity_type_code
	,client_activity_type_name
	,client_activity_type_description
	,client_activity_classification_code
	,client_activity_classification_name
	,client_activity_classification_description
	,client_activity_created_date
	,client_activity_start_date
	,client_activity_end_date
	,client_activity_breakdown_created_date
	,client_activity_duration
	,client_activity_whanau_involvement
	,client_group_activity_id
	,client_activity_subject
	,client_activity_description

	union all

	SELECT 
	5 as company_key
	,a.client_activity_breakdown_id as client_activity_breakdown_id
	,a.client_activity_id
	,a.client_parent_activity_id
	,fp.ReferralID as client_referral_id
	,fp.personid as client_id
	,coalesce(fu.userid, u2.userid,0) as client_activity_user_id
	,coalesce(
        nullif(fu.UserEmployeeNumber, ''),
        nullif(u2.UserEmployeeNumber, ''),
        nullif(fu.ReserveEmployeeNumber, ''),
        u2.ReserveEmployeeNumber
    ) AS user_employee_number
	,a.client_team_id
	,a.client_activity_breakdown_type_id
	,a.client_activity_type_code
	,a.client_activity_type_name
	,a.client_activity_type_description
	,a.client_activity_classification_code
	,a.client_activity_classification_name
	,a.client_activity_classification_description
	,a.client_activity_created_date
	,a.client_activity_start_date
	,a.client_activity_end_date
	,a.client_activity_breakdown_created_date
	,a.client_activity_duration
	,a.client_activity_whanau_involvement
	,a.client_group_activity_id
	,a.client_activity_subject
	,a.client_activity_description
	

	from MNB_activity a
	left join MNB_parts p on a.client_parent_activity_id = p.ActivityID
	left join Fap_Person_MNB fp on a.client_activity_id = fp.ActivityID
	left join Fap_User_MNB fu on a.client_parent_activity_id = fu.ActivityID 
	left join Fap_User_MNB u2 on a.client_activity_id = u2.ActivityID

	group by a.client_activity_breakdown_id
	,client_activity_id
	,client_parent_activity_id
	,fp.ReferralID
	,fp.personid
	,coalesce(fu.userid, u2.userid,0)
	,coalesce(
        nullif(fu.UserEmployeeNumber, ''),
        nullif(u2.UserEmployeeNumber, ''),
        nullif(fu.ReserveEmployeeNumber, ''),
        u2.ReserveEmployeeNumber
    ) 
	,client_team_id
	,client_activity_breakdown_type_id
	,client_activity_type_code
	,client_activity_type_name
	,client_activity_type_description
	,client_activity_classification_code
	,client_activity_classification_name
	,client_activity_classification_description
	,client_activity_created_date
	,client_activity_start_date
	,client_activity_end_date
	,client_activity_breakdown_created_date
	,client_activity_duration
	,client_activity_whanau_involvement
	,client_group_activity_id
	,client_activity_subject
	,client_activity_description;