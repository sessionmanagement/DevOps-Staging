CREATE procedure [edw].[GetHighwaterForedwfact_finance_general_ledger]
	@Last_Modified_DateTime datetime2(0) = null output
as begin
	select
		 --@Last_Modified_DateTime = '2024-07-01 01:01:01.0000000'
		 @Last_Modified_DateTime = DateAdd(YEAR,-1, max([finance_general_ledger_last_modified_date_time]))
	from [edw].[fact_finance_general_ledger];

	return 0;
end