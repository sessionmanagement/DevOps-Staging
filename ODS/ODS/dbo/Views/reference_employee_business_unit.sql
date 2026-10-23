

/****** Object:  View [dbo].[reference_employee_bussiness_unit]    Script Date: 18/11/2024 7:43:03 am 
          This view created to get unique employee number linked to business unit and business entity ******/
CREATE VIEW [dbo].[reference_employee_business_unit] as 
SELECT 
     DISTINCT  [person_employeeNumber]
      ,[businessUnit_name]
      ,[businessEntity_name]
       ,[position_title_name]
      FROM [IntelliHR].[jobs]
	  where ODSIsCurrent=1 and isPrimaryJob=1