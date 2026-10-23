
create view [Staging].[vw_Akoranga_mdl_dp_record_of_learning]
as 
select
	 src.[id] 	,src.[user_id] 	,src.[instance_id] 	,src.[type] 
from [Landing].[Akoranga_mdl_dp_record_of_learning] as src;