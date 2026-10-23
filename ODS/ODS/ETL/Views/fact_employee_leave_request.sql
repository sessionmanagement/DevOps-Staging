

CREATE      view [ETL].[fact_employee_leave_request]

as

/**********************************************************************************************************
 View		[ETL].[fact_employee_leave_request]
 Author		Pankaj Bhatt
 Created	2026-03-02
 Purpose	Used to build the edw.fact_employee_leave_request table
 
 **************************************************************************************************************
--REVISIONS:
--Version	 Date			Author			Description
---------	 ------------	---------------	--------------------------
--1.0		 2026-03-02		Pankaj Bhatt	Initial version
--1.1        2026-06-18     Malhar Badheka  removing 'D' condition because it is filtering out current record  

**************************************************************************************************************/

SELECT
lr.leave_request_id as leave_request_id
, try_cast(e.reference_number as int) as employee_id
, lr.default_leave_type as leave_request_type_id
, lr.start_date_time as leave_request_start_date_time
, lr.end_date_time as leave_request_end_date_time
, lr.[status] as leave_request_status

FROM EmpliveAPI.leave_requests as lr
left outer join EmpLive.employees as e on lr.employee_id = e.id and e.ODSIsCurrent = 1
where lr.ODSIsCurrent = 1 