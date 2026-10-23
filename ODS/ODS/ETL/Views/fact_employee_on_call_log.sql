

/****** Object:  View [ETL].[fact_employee_on_call_log]    Script Date: 12/08/2026 11:31:23 am ******/
CREATE     view [ETL].[fact_employee_on_call_log]

as

/**********************************************************************************************************
 View		[ETL].[fact_employee_on_call_log]
 Author		Greg Nuthall
 Created	11-08-2026	
 Purpose	Used to build the edw.fact_employee_on_call_log table 

 **************************************************************************************************************
--REVISIONS:
--Version	 Date			Author			Description
---------	 ------------	---------------	--------------------------
--1.0		 11-08-2026		Greg Nuthall	Initial version
--1.1        22-09-2026     Greg Nuthall    Added call_duration
**************************************************************************************************************/


SELECT l.on_call_id
      ,l.call_date_time
      ,l.region_id
      ,r.region as region_name
      ,l.service_id
      ,s.[service_name]
      ,l.category_id
      ,c.category_name
      ,l.call_received_from
      ,l.extra_time
      ,l.incident_report_required
      ,l.escalated_to_another_tier
      ,l.escalated_to_id
      ,k.kaimahi_name as escalated_to
      ,k.kaimahi_email as escalated_to_email
      ,l.shift_covered
      ,l.hours_covered
      ,l.event_status
      ,l.on_call_staff_member_id
      ,ock.kaimahi_name as on_call_staff_member
      ,ock.kaimahi_email as on_call_staff_member_email
      ,l.travel_time
      ,l.over_96_hours
      ,l.shift_covered_kaimahi
      ,l.created_by
      ,l.created_date_time
      ,l.call_duration

  FROM on_call.call_log l
  left outer join on_call.call_log_kaimahi k on l.escalated_to_id = k.kaimahi_id 
  left outer join on_call.call_log_kaimahi ock on l.on_call_staff_member_id = ock.kaimahi_id
  left outer join on_call.[service] s on l.service_id = s.service_id
  left outer join on_call.region r on l.region_id = r.region_id
  left outer join on_call.category c on l.category_id = c.category_id