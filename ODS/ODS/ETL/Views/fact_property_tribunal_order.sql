create   view [ETL].[fact_property_tribunal_order]

as

--=========================================================================================================
--View			[ETL].[fact_property_tribunal_order]
--Author		Greg Nuthall
--Created		2025-07-15
--Purpose		property tribunal order from vw_zav_tribunalorder to generate fact_property_tribunal_order
				
--=========================================================================================================
--REVISIONS:
--Version	 Date		   Author			Description
---------	 ------------  ---------------	--------------------------
--1.0		 2025-07-15    Greg Nuthall		Initial version
----------------------------------------------------------------------

	select t.ID as property_tribunal_order_id
	,t.zav_tenancybreach as property_tenancy_breach_id
	,tb.zav_tenancy as property_tenancy_id
	,t.zav_name as tribunal_order
	,t.zav_notes as notes
	,t.zav_tribunaloutcomename as tribunal_outcome 
	,t.zav_tribunaloutcomereasonname as tribunal_outcome_reason
	,t.zav_startdate as tribunal_order_start_date
	,t.owneridname as tribunal_order_owner
	,t.modifiedbyname as modified_by
	,t.modifiedon as modified_date
	,t.createdon as created_date
	,s.localizedLabel as tribunal_order_state
	,st.LocalizedLabel as tribunal_order_status
	
	from [Zavanti].[vw_zav_tribunalorder] t

	left outer join [Zavanti].[vw_zav_tenancybreach] tb 
		on t.zav_tenancybreach = tb.zav_tenancybreachid
	
	left outer join [Zavanti].[vw_StateMetadata] s 
		on t.statecode = s.state 
		and s.entityname = 'zav_tribunalorder'

	left outer join [Zavanti].[vw_StatusMetadata] st 
		on t.statuscode = st.state 
		and st.entityname = 'zav_tribunalorder'

	--left outer join [Zavanti].[vw_zav_tribunaloutcome] o on t.zav_tribunaloutcome = o.ID
	--left outer join [Zavanti].zav_tribunaloutcomereason r on r.zav_tribunaloutcomereason = r.ID