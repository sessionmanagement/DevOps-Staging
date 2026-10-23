

CREATE VIEW [ETL].[dim_client_referral] as

--View			[ETL].[fact_finance_general_ledger]
--Author		Shashi Sharma
--Created		2023/06/23
--Purpose		client record base dlfactreferral to generate dim_client_referral
				
--=========================================================================================================
--REVISIONS:
--Version	 Date		   Author			Description
---------	 ------------  ---------------	--------------------------
--1.0		 2023/06/23    Shashi Sharma	Initial version
--1.1		 2024/06/03	   Greg Nuthall     7528 and 7531 Added comment and other columns 		

--**********************************************************************************************************/

	SELECT 1 AS company_key
		,fr.referralid AS client_referral_id
		,fr.personid AS client_id
		,fr.TeamID AS client_team_id
		,fr.referralreferraltype AS client_referral_type
		,r.ReferrerCode AS client_referrer_code
		,r.ReferrerName AS client_referrer_name
		,fr.SourceReferralID AS source_referral_id
		,max(case when frs.referralstatustypeid = 19 then rstr.referralstatustypereasondescription end) as client_referral_discharge_reason
		,max(case when frs.referralstatustypeid = 16 then rstr.referralstatustypereasondescription end) as client_referral_accepted_reason
		,max(case when frs.referralstatustypeid = 15 then rstr.referralstatustypereasondescription end) as client_referral_waitlist_reason
		,max(case when frs.referralstatustypeid = 20 then rstr.referralstatustypereasondescription end) as client_referral_declined_reason
		,max(case when frs.referralstatustypeid = 13 then rstr.referralstatustypereasondescription end) as client_referral_pending_reason   --New Column
		,max(case when frs.referralstatustypeid = 19 then rstr.ReferralStatusTypeReasonCode end) as client_referral_discharge_reason_code
		,max(case when frs.referralstatustypeid = 16 then rstr.ReferralStatusTypeReasonCode end) as client_referral_accepted_reason_code
		,max(case when frs.referralstatustypeid = 15 then rstr.ReferralStatusTypeReasonCode end) as client_referral_waitlist_reason_code
		,max(case when frs.referralstatustypeid = 20 then rstr.ReferralStatusTypeReasonCode end) as client_referral_declined_reason_code
		,max(case when frs.referralstatustypeid = 13 then rstr.ReferralStatusTypeReasonCode end) as client_referral_pending_reason_code   --New Column
		,min(case when fr.ReferralReferralType like '%Inbound%' 
						   and fr.CurrentReferralStatusTypeID in (13,15,16)
						   and fr.ReferralEndDate is null
					then 'Active'
					else 'Not Active' end) as client_status_is_active
		,rst3.ReferralStatusTypeCode AS client_referral_status
		--New Columns
		,max(case when frs.referralstatustypeid = 19 then frs.ReferralStatusComments end) as client_referral_discharge_comment
		,max(case when frs.referralstatustypeid = 16 then frs.ReferralStatusComments end) as client_referral_accepted_comment
		,max(case when frs.referralstatustypeid = 15 then frs.ReferralStatusComments end) as client_referral_waitlist_comment
		,max(case when frs.referralstatustypeid = 20 then frs.ReferralStatusComments end) as client_referral_declined_comment
		,max(case when frs.referralstatustypeid = 13 then frs.ReferralStatusComments end) as client_referral_pending_comment

	FROM rbeal.dlfactreferral fr
	LEFT JOIN rbeal.dldimreferrer r ON fr.sourcereferrerid = r.referrerid
	LEFT JOIN (
		SELECT frs2.referralid
			,frs2.referralstatustypeid
			,frs2.referralstatustypereasonid
			,frs2.ReferralStatusComments
			,FIRST_VALUE(frs2.referralstatustypeid) OVER (
				PARTITION BY frs2.referralid ORDER BY frs2.ReferralStatusCreatedDate DESC,rst2.ReferralStatusTypeStatusOrder DESC
				) AS referralstatustypeid_latest -- link to latest status
		FROM rbeal.dlfactreferralstatus frs2
			LEFT JOIN rbeal.dldimreferralstatustype rst2 ON frs2.referralstatustypeid = rst2.referralstatustypeid
		) AS frs ON fr.referralid = frs.referralid
	LEFT JOIN rbeal.dldimreferralstatustype rst ON frs.referralstatustypeid = rst.referralstatustypeid
	LEFT JOIN rbeal.dldimreferralstatustypereason rstr ON frs.referralstatustypereasonid = rstr.referralstatustypereasonid
		AND frs.referralstatustypeid = rstr.referralstatustypeid
	LEFT JOIN rbeal.dldimreferralstatustype rst3 ON frs.referralstatustypeid_latest = rst3.referralstatustypeid -- join to lastest status

	GROUP BY fr.personid
		,fr.referralid
		,fr.referralreferraltype
		,r.ReferrerName
		,fr.TeamID
		,fr.SourceReferralID
		,rst3.ReferralStatusTypeCode
		,r.ReferrerCode

	UNION

	SELECT 5 AS company_key
		,fr.referralid AS client_referral_id
		,fr.personid AS client_id
		,fr.TeamID AS client_team_id
		,fr.referralreferraltype AS client_referral_type
		,r.ReferrerCode AS client_referrer_code
		,r.ReferrerName AS client_referrer_name
		,fr.SourceReferralID AS sourcereferralid
		,max(case when frs.referralstatustypeid = 19 then rstr.referralstatustypereasondescription end) as client_referral_discharge_reason
		,max(case when frs.referralstatustypeid = 16 then rstr.referralstatustypereasondescription end) as client_referral_accepted_reason
		,max(case when frs.referralstatustypeid = 15 then rstr.referralstatustypereasondescription end) as client_referral_waitlist_reason
		,max(case when frs.referralstatustypeid = 20 then rstr.referralstatustypereasondescription end) as client_referral_declined_reason
		,max(case when frs.referralstatustypeid = 13 then rstr.referralstatustypereasondescription end) as client_referral_pending_reason   --New Column
		,max(case when frs.referralstatustypeid = 19 then rstr.ReferralStatusTypeReasonCode end) as client_referral_discharge_reason_code
		,max(case when frs.referralstatustypeid = 16 then rstr.ReferralStatusTypeReasonCode end) as client_referral_accepted_reason_code
		,max(case when frs.referralstatustypeid = 15 then rstr.ReferralStatusTypeReasonCode end) as client_referral_waitlist_reason_code
		,max(case when frs.referralstatustypeid = 20 then rstr.ReferralStatusTypeReasonCode end) as client_referral_declined_reason_code
		,max(case when frs.referralstatustypeid = 13 then rstr.ReferralStatusTypeReasonCode end) as client_referral_pending_reason_code   --New Column
		,min(case when fr.ReferralReferralType like '%Inbound%' 
						   and fr.CurrentReferralStatusTypeID in (13,15,16)
						   and fr.ReferralEndDate is null
					then 'Active'
					else 'Not Active' end) as client_status_is_active
		,rst3.ReferralStatusTypeCode AS client_referral_status
		,max(case when frs.referralstatustypeid = 19 then frs.ReferralStatusComments end) as client_referral_discharge_comment
		,max(case when frs.referralstatustypeid = 16 then frs.ReferralStatusComments end) as client_referral_accepted_comment
		,max(case when frs.referralstatustypeid = 15 then frs.ReferralStatusComments end) as client_referral_waitlist_comment
		,max(case when frs.referralstatustypeid = 20 then frs.ReferralStatusComments end) as client_referral_declined_comment
		,max(case when frs.referralstatustypeid = 13 then frs.ReferralStatusComments end) as client_referral_pending_comment

	FROM rbmnb.dlfactreferral fr
	LEFT JOIN rbmnb.dldimreferrer r ON fr.sourcereferrerid = r.referrerid
	LEFT JOIN (
		SELECT frs2.referralid
			,frs2.referralstatustypeid
			,frs2.referralstatustypereasonid
			,frs2.ReferralStatusComments
			,FIRST_VALUE(frs2.referralstatustypeid) OVER (
				PARTITION BY frs2.referralid ORDER BY frs2.ReferralStatusCreatedDate DESC,rst2.ReferralStatusTypeStatusOrder DESC
				) AS referralstatustypeid_latest -- link to latest status
		FROM rbmnb.dlfactreferralstatus frs2
			LEFT JOIN rbmnb.dldimreferralstatustype rst2 ON frs2.referralstatustypeid = rst2.referralstatustypeid
		) AS frs ON fr.referralid = frs.referralid
	LEFT JOIN rbmnb.dldimreferralstatustype rst ON frs.referralstatustypeid = rst.referralstatustypeid
	LEFT JOIN rbmnb.dldimreferralstatustypereason rstr ON frs.referralstatustypereasonid = rstr.referralstatustypereasonid
		AND frs.referralstatustypeid = rstr.referralstatustypeid
	LEFT JOIN rbmnb.dldimreferralstatustype rst3 ON frs.referralstatustypeid_latest = rst3.referralstatustypeid -- join to lastest status
	GROUP BY fr.personid
		,fr.referralid
		,fr.referralreferraltype
		,r.ReferrerName
		,fr.TeamID
		,fr.SourceReferralID
		,rst3.ReferralStatusTypeCode
		,r.ReferrerCode

