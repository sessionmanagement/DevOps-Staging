




create   VIEW [RBEAL].[vw_ReferralHistory]    
as 

WITH CTE_CFDI(PersonID,GPOnly,GPRegistration,LookupID)
as
(Select CFDI.EntityId
,MAX(LookupId)
,MAX(CASE when CFDI.CustomFieldId = 3 then LookupId end) 
,MAX(CASE when CFDI.CustomFieldId = 4 then LookupId end) 
from rbeal.dlFactCustomFieldDataItem CFDI
group by 
	CFDI.EntityId
)

select
fr.personid as client_id
,u.userfirstname+' '+u.userlastname as client_responsible_person
,'' as client_team
,fpr.personrelationshipstartdate as client_person_relationship_start_date
,fpr.personrelationshipenddate as client_person_relationship_end_date
,fr.referralid as client_referral_id
,fr.referralreferraltype as client_referral_type
,r.referrername as client_referrer_name
,t.teamname as client_referral_team
,fr.referralreceiveddate as client_referral_received_date
,fr.referralcreateddate as client_referral_created_date
,fr.referralenddate as client_referral_end_date
,max(case when frs.referralstatustypeid = 19 then frs.referralstatusstartdate end) as client_referral_discharge_date
,max(case when frs.referralstatustypeid = 16 then frs.referralstatusstartdate end) as client_referral_accepted_date
,max(case when frs.referralstatustypeid = 15 then frs.referralstatusstartdate end) as client_referral_waitlist_date
,max(case when frs.referralstatustypeid = 20 then frs.referralstatusstartdate end) as client_referral_decline_date
,max(case when frs.referralstatustypeid = 19 then rstr.referralstatustypereasondescription end) as client_referral_discharge_reason
,max(case when frs.referralstatustypeid = 16 then rstr.referralstatustypereasondescription end) as client_referral_accepted_reason
,max(case when frs.referralstatustypeid = 15 then rstr.referralstatustypereasondescription end) as client_referral_waitlist_reason
,max(case when frs.referralstatustypeid = 20 then rstr.referralstatustypereasondescription end) as client_referral_declined_reason
,MAX(CASE when PLS.PersonID is null then 0 else 1 end) as client_legal_status_indicator
,MAX(case when pc.PersonContactIsEmergencyContact is null then 0 else pc.PersonContactIsEmergencyContact end) as client_emergency_contact_indicator
,MAX(CASE when phc.PersonHealthConditionHealthConditionType = 'MentalHealthCondition' then 1 else 0 end) as client_mental_health_condition_indicator
,MAX(CASE when phc.PersonHealthConditionHealthConditionType = 'PhysicalHealthCondition' then 1 else 0 end) as client_physical_health_condition_indicator
,MAX(CASE when phc.PersonHealthConditionHealthConditionType = 'Substance' then 1 else 0 end) as client_substance_use_indicator
,MAX(CASE when psh.personid is null then 0 else 1 end) as client_smoking_status_indicator
,MAX(CASE when psh.personid is null then 0
		  when psh.PersonSmokingHistoryBriefAdviceGiven = 0 then 0
		  else 1 end) as client_smoking_advice_indicator
,MAX(CASE when psh.personid is null 
or psh.PersonSmokingHistorySupportServicesOffered is null 
or psh.PersonSmokingHistorySupportServicesOffered = '' then 0 else 1 end) as client_smoking_cessation_referral_indicator
,MAX(CASE when phsr.PersonId is null then 0 else 1 end) as client_primhd_review_indicator
,MAX(CASE when DATEDIFF(DAY,GETDATE(),phsr.PrimhdServiceReviewReviewDate)>=90 then 1 else 0 end) as client_primhd_overdue_indicator
,MAX(Case when DATEDIFF(Day,phsr.PrimhdServiceReviewReviewDate,GETDATE())>82 and
			DATEDIFF(Day,phsr.PrimhdServiceReviewReviewDate,GETDATE())<90 then 1 else 0 end) as client_primhd_due_soon_indicator
,MAX(CASE when DATEDIFF(DAY,GETDATE(),phsr.PrimhdServiceReviewReviewDate)<82 then 1 else 0 end) as client_primhd_current_indicator
,MAX(CASE when CFDI.GPOnly is null then 0 else 1 end) as client_gp_only_indicator
,MAX(CASE when CFDI.GPRegistration is null then 0 else 1 end) as client_gp_registration_indicator
from rbeal.dlfactreferral fr
left join rbeal.dlfactreferralstatus frs
on fr.referralid = frs.referralid
	left join rbeal.dldimreferralstatustype rst
	on frs.referralstatustypeid = rst.referralstatustypeid
	left join rbeal.dldimreferralstatustypereason rstr
	on frs.referralstatustypereasonid = rstr.referralstatustypereasonid
	and frs.referralstatustypeid = rstr.referralstatustypeid
left join rbeal.dlfactpersonrelationship fpr
on fr.personid = fpr.personid
	and CAST(fr.ReferralUDF3 as DATE) = CAST(fpr.PersonRelationshipStartDate as DATE)
	and CAST(fr.ReferralEndDate as DATE) = CAST(fpr.PersonRelationshipEndDate as DATE)
	left join rbeal.dldimuser u
	on fpr.userid = u.userid
left join rbeal.dldimteam t
on fr.teamid = t.teamid
	left join rbeal.dldimteamfunction tf
	on t.teamfunctionid = tf.teamfunctionid
left join rbeal.dldimreferrer r
on fr.sourcereferrerid = r.referrerid
left join rbeal.dlFactPersonLegalStatus PLS
on fr.PersonID = PLS.PersonID
and pls.PersonLegalStatusID = (select MAX(PLS1.PersonLegalStatusID) from rbeal.dlFactPersonLegalStatus PLS1 where PLS1.PersonID =PLS.PersonID)
left join rbeal.dlFactPersonContact PC
on fr.PersonID=pc.PersonID
and pc.PersonContactID = (select MAX(PC1.PersonContactID) from rbeal.dlFactPersonContact PC1 where PC1.PersonID =PC.PersonID)
left join RBEAL.dlFactPersonHealthCondition PHC
on fr.PersonID = phc.PersonId
and PHC.PersonHealthConditionId = (select MAX(PHC1.PersonHealthConditionId) from RBEAL.dlFactPersonHealthCondition PHC1 where PHC1.PersonID =PHC.PersonID)
left join RBEAL.dlFactPersonSmokingHistory PSH
on FR.PersonID = PSH.PersonID
and psh.PersonSmokingHistoryID = (select MAX(PSH1.PersonSmokingHistoryID) from RBEAL.dlFactPersonSmokingHistory PSH1 where PSH1.PersonID =PSH.PersonID)
left join RBEAL.dlFactPrimhdServiceReview PHSR
on FR.PersonID = phsr.PersonId
and PHSR.PrimhdServiceReviewCreatedDate >=GETDATE()-365
and phsr.PrimhdServiceReviewReviewDate = (select MAX(phsr1.PrimhdServiceReviewReviewDate) from rbeal.dlFactPrimhdServiceReview phsr1 where phsr1.PrimhdServiceReviewReviewDate=phsr.PrimhdServiceReviewReviewDate)
left join CTE_CFDI CFDI
on fr.PersonID = CFDI.PersonID
where exists(select SourceReferralID from RBEAL.dlFactReferral FR0 where FR0.SourceReferralID = FR.ReferralID) 
group by
fr.personid
,fr.referralid
,fr.referralreceiveddate
,fr.referralcreateddate
,fr.referralreferraltype
,r.referrername
,fr.referralenddate
,t.teamname
,u.userfirstname+' '+u.userlastname
,fpr.personrelationshipstartdate
,fpr.personrelationshipenddate 
,pc.PersonContactIsEmergencyContact
;
