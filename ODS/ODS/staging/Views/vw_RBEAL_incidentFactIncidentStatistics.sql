
create view [Staging].[vw_RBEAL_incidentFactIncidentStatistics]
as 
select
	 src.[IncidentID] 	,src.[IncidentTypeID] 	,src.[IncidentDate] 	,src.[TeamID] 	,src.[AreaID] 	,src.[IncidentLikelihoodID] 	,src.[IncidentSeverityID] 	,src.[PendingDate] 	,src.[AssignedToInvestigatorDate] 	,src.[AssignedToReporterDate] 	,src.[CompletedDate] 	,src.[InvestigationDate] 	,src.[ReviewDate] 	,src.[CurrentIncidentStatusTypeID] 	,src.[OriginatorUserID] 	,src.[InvestigatorUserID] 	,src.[ReporterUserID] 	,src.[RiskTypeID] 	,src.[CompanyId] 
from [Landing].[RBEAL_incidentFactIncidentStatistics] as src;