/****** Object:  View [ETL].[fact_property_rent_charges]    Script Date: 11/11/2025 2:03:42 pm ******/
CREATE VIEW [ETL].[fact_property_rent_charges]
as

/**********************************************************************************************************
 View		[ETL].[fact_property_rent_charges]
 Author		Greg Nuthall
 Created	2025-11-11	
 Purpose	Used to build the edw.fact_property_rent_charges

 **************************************************************************************************************
--REVISIONS:
--Version	 Date		   Author			description
---------	 ------------  ---------------	--------------------------
--1.0		 2025-11-11	   Greg Nuthall	    Initial version
**************************************************************************************************************/


select pc.zav_propertyrentchargesid as rent_charge_id
,zav_name as rent_charge_name
,zav_property as property_id
,zav_propertyname as property_name
,zav_provideragreementname as provider_name
,pc.owningbusinessunitname as company_name
,pc.zav_agreedrent as agreed_rent
,pc.zav_marketrent as market_rent
,pc.zav_operatingsupplementamount as supplement_amount 
,pc.zav_startdate as [start_date]
,pc.zav_enddate as end_date
,pc.modifiedbyname as employee_name
,u.internalemailaddress as employee_email


from [Zavanti].[vw_zav_propertyrentcharges] pc
left outer join [Zavanti].[vw_systemuser] u on pc.modifiedby = u.Id

GO


