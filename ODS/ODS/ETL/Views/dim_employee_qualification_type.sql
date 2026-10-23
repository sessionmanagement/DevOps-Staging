create   VIEW [ETL].[dim_employee_qualification_type] 

/**********************************************************************************************************
 View		[ETL].[dim_employee_qualification_type]
 Author		Greg Nuthall / Greg Hubbard
 Created	2025-07-25
 Purpose	Used to build the edw.dim_employee_qualification_type table 

**************************************************************************************************************
--REVISIONS:
--Version	 Date		   Author			Description
---------	 ------------  ---------------	--------------------------
--1.0		2025-07-25		Greg Nuthall			Initial version
**************************************************************************************************************/

as

	select t.qualification_type_id as employee_qualification_type_id
	,t.name as employee_qualification_type
	
	from IntelliHR.qualification_types t 
		 
	where t.ODSIsCurrent = 1