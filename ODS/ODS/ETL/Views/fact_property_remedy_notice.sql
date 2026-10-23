create   view [ETL].[fact_property_remedy_notice]

as

--=========================================================================================================
--View			[ETL].[fact_property_remedy_notice]
--Author		Greg Nuthall
--Created		2025-07-15
--Purpose		property remedy notice from vw_zav_noticetoremedy to generate fact_property_remedy_notice
				
--=========================================================================================================
--REVISIONS:
--Version	 Date		   Author			Description
---------	 ------------  ---------------	--------------------------
--1.0		 2025-07-15    Greg Nuthall		Initial version
----------------------------------------------------------------------

	select 
	nr.ID as property_remedy_notice_id
	,nr.zav_tenancy as property_tenancy_id
	,nr.zav_tenancybreach as property_tenancy_breach_id

	,nr.zav_name as remedy_notice
	,nr.zav_theantisocialbehaviourthatwasreportedtous as anti_social_behaviour_report
	,nr.zav_thebehaviouroccurredatbetween as behaviour_occurred_between
	,nr.zav_thebehaviourwaslocated as behaviour_locatation
	,nr.zav_thepeopleengagedinthebehaviourwere as behaviour_people
	,nr.zav_notkepttoyourtenancyresponsibilities as unkept_responsibility
	,nr.zav_remedythesituationbydoingthefollowing as remedy_path
	,nr.zav_notes as notes
	,nr.zav_anyotherrelevantinformation as other_information


	,zav_startdate as remedy_notice_start_date
	,nr.owneridname as remedy_notice_owner
	,nr.modifiedbyname as modified_by
	,nr.modifiedon as modified_date
	,nr.createdon as created_date
	,s.localizedLabel as remedy_notice_state
	,st.LocalizedLabel as remedy_notice_status


	from [Zavanti].[vw_zav_noticetoremedy] nr

	left outer join [Zavanti].[vw_StateMetadata] s on nr.statecode = s.state 
	and s.entityname = 'zav_noticetoremedy'

	left outer join [Zavanti].[vw_StatusMetadata] st on nr.statuscode = st.state 
	and st.entityname = 'zav_noticetoremedy'