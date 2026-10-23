
CREATE         view [ETL].[dim_employee_leave_request_type]

as

/**********************************************************************************************************
 View		[ETL].[dim_employee_leave_request_type]
 Author		Pankaj Bhatt
 Created	2026-03-02
 Purpose	Used to build the edw.dim_employee_leave_request_type table
 
 **************************************************************************************************************
--REVISIONS:
--Version	 Date			Author			Description
---------	 ------------	---------------	--------------------------
--1.0		 2026-03-02		Pankaj Bhatt	Initial version

**************************************************************************************************************/

SELECT
lt.leave_type_id as leave_request_type_id
, lt.abbreviation as leave_request_type_code
, lt.[name] as leave_request_type
FROM EmpliveAPI.leave_types as lt
where lt.ODSIsCurrent = 1