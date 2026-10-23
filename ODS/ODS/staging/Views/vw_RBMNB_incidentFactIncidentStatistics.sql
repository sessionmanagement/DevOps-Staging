
create view [Staging].[vw_RBMNB_incidentFactIncidentStatistics]
as 
select
	 src.[IncidentID] 	,src.[IncidentTypeID] 	,src.[IncidentDate] 	,src.[TeamID] 	,src.[AreaID] 	,src.[IncidentLikelihoodID] 	,src.[IncidentSeverityID] 	,src.[PendingDate] 	,src.[AssignedToInvestigatorDate] 	,src.[AssignedToReporterDate] 	,src.[CompletedDate] 	,src.[InvestigationDate] 	,src.[ReviewDate] 	,src.[CurrentIncidentStatusTypeID] 	,src.[OriginatorUserID] 	,src.[InvestigatorUserID] 	,src.[ReporterUserID] 	,src.[RiskTypeID] 	,src.[CompanyId] 
from [Landing].[RBMNB_incidentFactIncidentStatistics] as src;