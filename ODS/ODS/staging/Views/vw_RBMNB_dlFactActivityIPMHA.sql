
create view [Staging].[vw_RBMNB_dlFactActivityIPMHA]
as 
select
	 src.[ActivityIPMHAid] 	,src.[ActivityId] 	,src.[SessionTypeId] 	,src.[JudgementOfChangeId] 	,src.[ActivityIPMHAClientProblemRating] 	,src.[ActivityIPMHAConfidenceInCarryingOutPlans] 	,src.[ActivityIPMHAHowHelpfulWasThisVisit] 	,src.[ExternalReferralId] 	,src.[ActivityIPMHAClientExperienceOfPlan] 	,src.[ActivityIPMHACreatedUserId] 	,src.[ActivityIPMHACreatedDate] 
from [Landing].[RBMNB_dlFactActivityIPMHA] as src;
GO

