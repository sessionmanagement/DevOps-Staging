
create view [Staging].[vw_SnapHire_jobs]
as 
select
	 src.[Job_Id] 	,src.[Positions_open] 	,src.[Remaining_Positions_Vacant] 	,src.[Number_Applications] 	,src.[Number_Hires] 	,src.[Title] 	,src.[Business_Group_Level_1] 	,src.[Job_Location] 	,src.[Hiring_Manager] 	,src.[Job_Type] 	,src.[Job_Status_Name] 	,src.[Actual_Open_Date] 	,src.[Post_Date] 	,src.[Advertised_Currently] 	,src.[Planned_Close_Date_For_Application] 	,src.[Actual_Days_Open] 	,src.[Externally_Visible_Now] 	,src.[Internally_Visible_Now] 
from [Landing].[SnapHire_jobs] as src;