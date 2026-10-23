create   VIEW [ETL].[dim_employee_qualification_library] 

/**********************************************************************************************************
 View		[ETL].[dim_employee_qualification]
 Author		Greg Nuthall / Greg Hubbard
 Created	2025-07-25
 Purpose	Used to build the edw.dim_employee_qualification table 

**************************************************************************************************************
--REVISIONS:
--Version	 Date		   Author			Description
---------	 ------------  ---------------	--------------------------
--1.0		2025-07-25		Greg Nuthall			Initial version
**************************************************************************************************************/

as

	select i.qualification_library_items_id as employee_qualification_library_id
	,i.name as employee_qualification_library
	,i.job_requirement_usage_count

	from IntelliHR.qualification_library_items i 
		 
	where i.ODSIsCurrent = 1