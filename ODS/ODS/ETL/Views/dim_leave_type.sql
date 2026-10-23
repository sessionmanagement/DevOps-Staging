
/**********************************************************************************************************
REVISIONS:
Version	 Date			Author			    Description
-------	------------	------------------	--------------------------
1.0		2024-02-11		?????????     		Initial creation of view
1.1		2024-08-09		Greg Nuthall		Inclusion of emplive time categories


**********************************************************************************************************/

--Does no group these, it is done later in the EDW staging store procedure
--Unpaid Sick leave = Sick LWOP
--Well Being Leave = Wellbeing leave
--Ordinary = Annual Leave
--No Pay = LWOP
--Leave without Pay = LWOP
--Jury Leave = Jury Service
--Family Violence leave = Domestic Violence Leave
--Discretionary = Discretionary leave 
--Cultural Contribution Leave = Cultural Contribution
--Christmas Shopping leave = Christmas


CREATE   VIEW [ETL].[dim_leave_type]
AS
	
	With Cte_Emplive_Time_Categories
	as (select tc.id
		,Replace(tc.name,' day','') as leave_type_name  
		,Lower(trim(Replace(tc.name,' day',''))) as leave_type_join    
		,'' as leave_type_group
		,c2.name as leave_type_company_name  

		from [EmpLive].[time_categories] tc
		inner join [DataPay].[companies] c2 on 1=1

		WHERE tc.odsiscurrent = 1) 

	select min(isnull(lt.[leave_type_id],tc.id)) as leave_type_id      
		,isnull(lt.[name],tc.leave_type_name) as leave_type_name      
		,isnull(lt.[type],'') as leave_type_group
		,isnull(c.name,tc.leave_type_company_name) as leave_type_company_name  
	from (Select * from [DataPay].[leave_types]  where odsiscurrent = 1) lt
	inner join (Select * from [DataPay].[companies] where odsiscurrent = 1) c ON lt.[company_id] = c.company_id
	full outer join Cte_Emplive_Time_Categories tc on Lower(trim(lt.[name])) = tc.leave_type_join and c.name = tc.leave_type_company_name
	

	group by isnull(lt.[name],tc.leave_type_name), isnull(lt.[type],''), isnull(c.name,tc.leave_type_company_name) 

	--Order by leave_type_name, leave_type_company_name