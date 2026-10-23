


		CREATE procedure [edw].[GetHighwaterForedwdim_finance_budget_holder]
			@last_modified_date_time datetime2(0) = null output
		as begin
			select
				 @last_modified_date_time = max([finance_budget_holder_last_modified_date_time])
			from [edw].[dim_finance_budget_holder];

			return 0;
		end