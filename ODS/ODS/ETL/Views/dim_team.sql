






CREATE VIEW [ETL].[dim_team]
AS
SELECT 1 AS company_key,
	ISNULL(NULLIF(dldimteam.teamudf5,''),0) as service_id,
	dldimteam.teamid as team_id,
	dldimteam.teamname as team_name,
	dldimteam.TeamDescription as team_description,
	dldimteamfunction.teamfunctionname as team_function,
	dldimteamfunction.TeamFunctionIsAccomodationBased as team_is_accommodation_based, 
	dldimteam.teamstartdate as dim_team_start_date_key,
	dldimteam.teamenddate as dim_team_end_date_key,
	dldimteam.teamcapacity as team_bed_number,
	dldimteam.TeamIsAllocatedSupportTimeTeam as team_is_allocated_support,
	dldimteam.TeamIsEmploymentTeam as team_is_employment_team,
	case when dldimteam.TeamEndDate is null then 'Open'
	when dldimteam.teamenddate > getdate() then 'Open'
	else 'Closed' end as team_status
from			rbeal.dldimteam
inner join		rbeal.dlDimTeamFunction on dlDimTeam.TeamFunctionID		= dlDimTeamFunction.TeamFunctionID

UNION

SELECT  5 AS company_key,
	ISNULL(NULLIF(dldimteam.teamudf5,''),0) as service_id,
	dldimteam.teamid,
	dldimteam.teamname as team_name,
	dldimteam.TeamDescription as team_description,
	dldimteamfunction.teamfunctionname as team_function,
	dldimteamfunction.TeamFunctionIsAccomodationBased as team_is_accommodation_based,
	dldimteam.teamstartdate as dim_team_start_date_key,
	dldimteam.teamenddate as dim_team_end_date_key, 
	dldimteam.teamcapacity as team_bed_number,
	dldimteam.TeamIsAllocatedSupportTimeTeam as team_is_allocated_support,
	dldimteam.TeamIsEmploymentTeam as team_is_employment_team,
	case when dldimteam.TeamEndDate is null then 'Open'
	when dldimteam.teamenddate > getdate() then 'Open'
	else 'Closed' end as team_status
from			RBMNB.dldimteam
inner join		RBMNB.dlDimTeamFunction on dlDimTeam.TeamFunctionID		= dlDimTeamFunction.TeamFunctionID

