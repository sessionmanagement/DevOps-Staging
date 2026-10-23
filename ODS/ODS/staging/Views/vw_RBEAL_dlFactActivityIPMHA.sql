
create view [Staging].[vw_RBEAL_dlFactActivityIPMHA]
as 
select
	 src.[ActivityIPMHAid] 	,src.[ActivityId] 	,src.[SessionTypeId] 	,src.[JudgementOfChangeId] 	,src.[ActivityIPMHAClientProblemRating] 	,src.[ActivityIPMHAConfidenceInCarryingOutPlans] 	,src.[ActivityIPMHAHowHelpfulWasThisVisit] 	,src.[ExternalReferralId] 	,src.[ActivityIPMHAClientExperienceOfPlan] 	,src.[ActivityIPMHACreatedUserId] 	,src.[ActivityIPMHACreatedDate] 	,src.[NextEncounterBookedId] 
from [Landing].[RBEAL_dlFactActivityIPMHA] as src;
GO

