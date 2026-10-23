CREATE     view [ETL].[dim_client_team]
as

/**********************************************************************************************************
 View		[ETL].[dim_client_team]
 Author		???
 Created	2023/02/10	
 Purpose	Used to build the edw.dim_client_team table 

 **************************************************************************************************************
--REVISIONS:
--Version	 Date		   Author			description
---------	 ------------  ---------------	--------------------------
--1.0		 2023/02/10						Initial version
--1.1		 2024/09/06	   Greg Nuthall     9148 Added team area 
--1.2		 2025/10/22	   Pankaj Bhatt     Added parent area 

**************************************************************************************************************/

select 1 AS company_key
	,isnull(nullif(t.teamudf5, ''), 0) AS service_id
	,t.teamid as team_id
	,t.teamname AS team_name
	,t.TeamDescription AS team_description
	,f.teamfunctionname AS team_function
	,f.TeamFunctionIsAccomodationBased AS team_is_accommodation_based
	,t.teamstartdate AS dim_team_start_date_key
	,t.teamenddate AS dim_team_end_date_key
	,t.teamcapacity AS team_bed_number
	,t.TeamIsAllocatedSupportTimeTeam AS team_is_allocated_support
	,t.TeamIsEmploymentTeam AS team_is_employment_team
	,case 
		when t.teamenddate is null
			then 'Open'
		when t.teamenddate > getdate()
			then 'Open'
		else 'Closed'
		end as team_status
	,CASE WHEN TRIM(t.TeamUDF4) = '1' THEN 1 ELSE 0 END AS client_team_primhd_exclusion_flag
	,a.AreaName as client_team_area
	,ap.AreaName as client_team_parent_area
	,agp.AreaName as client_team_grand_parent_area
	
	from rbeal.dldimteam t
	inner join rbeal.dlDimTeamFunction f ON t.TeamFunctionID = f.TeamFunctionID
	inner join rbeal.dlDimArea a on t.AreaID = a.AreaID
	left outer join rbeal.dlDimArea ap on a.AreaParentID = ap.AreaID
	left outer join rbeal.dlDimArea agp on ap.AreaParentID = agp.AreaID

union

select 5 AS company_key
	,isnull(nullif(t.teamudf5, ''), 0) AS service_id
	,t.teamid as team_id
	,t.teamname AS team_name
	,t.TeamDescription AS team_description
	,f.teamfunctionname AS team_function
	,f.TeamFunctionIsAccomodationBased AS team_is_accommodation_based
	,t.teamstartdate AS dim_team_start_date_key
	,t.teamenddate AS dim_team_end_date_key
	,t.teamcapacity AS team_bed_number
	,t.TeamIsAllocatedSupportTimeTeam AS team_is_allocated_support
	,t.TeamIsEmploymentTeam AS team_is_employment_team
	,case 
		when t.teamenddate is null
			then 'Open'
		when t.teamenddate > getdate()
			then 'Open'
		else 'Closed'
		end as team_status
	,case when trim(t.TeamUDF4) = '1' then 1 else 0 end as client_team_primhd_exclusion_flag
	,a.AreaName as client_team_area
	,ap.AreaName as client_team_parent_area
	,agp.AreaName as client_team_grand_parent_area

	from rbmnb.dldimteam t
	inner join rbmnb.dlDimTeamFunction f ON t.TeamFunctionID = f.TeamFunctionID
	inner join rbmnb.dlDimArea a on t.AreaID = a.AreaID
	left outer join rbmnb.dlDimArea ap on a.AreaParentID = ap.AreaID
	left outer join rbmnb.dlDimArea agp on ap.AreaParentID = agp.AreaID