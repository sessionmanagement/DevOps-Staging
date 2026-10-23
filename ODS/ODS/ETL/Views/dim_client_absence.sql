
CREATE   VIEW [ETL].[dim_client_absence]

/**********************************************************************************************************
 View		[ETL].[dim_client_incident]
 Author		Greg Nuthall
 Created	2024-08-05
 Purpose	Used to build the edw.dim_client_absence table 

 **************************************************************************************************************
--REVISIONS:
--Version	 Date			Author			Description
---------	 ------------	---------------	--------------------------
--1.0		 2024-08-05		Greg Nuthall	Initial version
--1.1        2025-12-22     Greg Nuthall	Remove RB duplicate records PersonStatusID (277,63,86,90,82,199,114,146)

**************************************************************************************************************/


as

SELECT 
	1 as company_id,
	concat(ps.personid,'_',format(ps.personstatusstartdate,'yyyyMMddHHmmss'),'_','1') as dim_client_unique_key,
	ps.personid as client_id,
	ps.PersonStatusAbsenceApprovedByFunder as client_absence_approved_by_funder_flag,
	ps.personstatusstartdate as client_absence_start_date_time,
	ps.personstatusenddate as client_absence_end_date_time, 
	pt.PersonStatusTypeText as client_absence_type,
	ps.AbsenceReasonId as client_absence_reason_id, 
	dl.LookupText as client_absence_reason
	

FROM [RBEAL].[dlFactPersonStatus] ps

   left join rbeal.dlDimPersonStatusType pt on ps.PersonStatusTypeID = pt.PersonStatusTypeID
  --====there's no absence reason table so use the look up table to find codes
left join rbeal.dldimlookup dl on ps.AbsenceReasonId = dl.lookupid 
  
  --===I'm not sure how ethnical this is but I don't think we need to know active clients, only when they're away
  where PersonStatusTypeText not in ('active')
  --====I don't want to count where the absence happened on the same day. Now its no longer a date time field past June
  and datediff(day,PersonStatusStartDate,personstatusenddate) > 0 

  and ps.PersonStatusID Not in (277,63,86,90,82,199,114,146)

union all
-- add in Mind and Body*
SELECT 
	5 as company_id,
	concat(ps.personid,'_',format(ps.personstatusstartdate,'yyyyMMddHHmmss'),'_','5') as dim_client_unique_key,
	ps.personid as client_id,
	ps.PersonStatusAbsenceApprovedByFunder as client_absence_approved_by_funder_flag,
	ps.personstatusstartdate as client_absence_start_date_time,
	ps.personstatusenddate as client_absence_end_date_time, 
	pt.PersonStatusTypeText as client_absence_type,
	ps.AbsenceReasonId as client_absence_reason_id, 
	dl.LookupText as  client_absence_reason

FROM [RBMNB].[dlFactPersonStatus] ps
  
  left join [RBMNB].dlDimPersonStatusType pt on ps.PersonStatusTypeID = pt.PersonStatusTypeID
 
 --====there's no absence reason table so use the look up table to find codes
 left join [RBMNB].dldimlookup dl on ps.AbsenceReasonId = dl.lookupid 
  
  --===I'm not sure how ethnical this is but I don't think we need to know active clients, only when they're away
  where PersonStatusTypeText not in ('active')
    --====I don't want to count where the absence happened on the same day. Now its no longer a date time field past June
  and datediff(day,PersonStatusStartDate,personstatusenddate) > 0