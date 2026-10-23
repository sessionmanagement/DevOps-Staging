
create view [Staging].[vw_Datapay_pay_runs]
as 
select
	 src.[pay_run_id] 	,src.[pay_group_id] 	,src.[run_type] 	,src.[status] 	,src.[locked] 	,src.[finalisation_date] 	,src.[dc_date] 	,src.[exclude_from_banking] 	,src.[pay_period_start_date] 	,src.[pay_period_end_date] 	,src.[process_timestamp] 	,src.[filepath] 
from [Landing].[Datapay_pay_runs] as src;