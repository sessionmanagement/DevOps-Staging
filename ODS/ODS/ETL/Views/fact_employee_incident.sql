
CREATE      view [ETL].[fact_employee_incident]

as

/**********************************************************************************************************
 View		[ETL].[fact_employee_incident]
 Author		Pankaj Bhatt
 Created	2026-01-09
 Purpose	Used to build the edw.fact_employee_incident table 

 **************************************************************************************************************
--REVISIONS:
--Version	 Date			Author			Description
---------	 ------------	---------------	--------------------------
--1.0		 2026-01-09		Pankaj Bhatt	Initial version

**************************************************************************************************************/

select
    base.page_uid as incident_id,

    base.rpt_incident_details_incident_datetime as incident_date,
    base.rpt_incident_details_reported_datetime as incident_reported_date,
    base.ai_investigation_details_initial_date as investigation_start_date,
    base.ai_investigation_final_date as investigation_end_date,
    base.co_close_out_date as incident_close_out_date,


    base.ai_actual_severity_gauge_number as actual_severity_gauge_score,
    base.ai_ongoing_risk_gauge_number as ongoing_risk_gauge_score,

    base.rpt_incident_class_number_incidents_number as number_of_times_incident_occurred,

    base.rpt_incident_details_recordbase_entry_plaintext as incident_recordbase_detail

from [EcoPortal].[incident_investigations] base
/*
-- select * from [ETL].[fact_employee_incident] 
--where incident_id in ('EVN-01859','EVN-04346','EVN-03757','EVN-04560','EVN-04567','EVN-03074')
--incident_id = 'EVN-03512' --'EVN-03677'
--where incident_id in ('EVN-04677','EVN-04680','EVN-04681','EVN-04682')
--where incident_id in ('EVN-04314')
--where incident_immediate_actions_taken like '%Checked any cable lying down but found nothing%'
--order by incident_id
*/
where base.ODSIsCurrent = 1