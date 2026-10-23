


		CREATE procedure [edw].[GetHighwaterForedwdim_finance_contract]
			@last_modified_date_time datetime2(0) = null output
		as begin
			select
				 @last_modified_date_time = max([finance_contract_last_modified_date_time])
			from [edw].[dim_finance_contract];

			return 0;
		end