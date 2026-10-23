

create   view etl.dim_employee_on_call_log
  
as

/**********************************************************************************************************
 View		[ETL].[dim_employee_on_call_log]
 Author		Greg Nuthall
 Created	11-08-2026	
 Purpose	Used to build the edw.dim_employee_on_call_log table 

 **************************************************************************************************************
--REVISIONS:
--Version	 Date			Author			Description
---------	 ------------	---------------	--------------------------
--1.0		 11-08-2026		Greg Nuthall	Initial version
**************************************************************************************************************/


SELECT l.on_call_id
      ,l.on_call_title
      ,l.event_name
      ,l.call_received_from
      ,l.issue_description
      ,l.outcome
      ,l.escalation_comments
      
  FROM on_call.call_log l