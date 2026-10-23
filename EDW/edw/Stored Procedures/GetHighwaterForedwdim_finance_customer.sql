

		CREATE procedure [edw].[GetHighwaterForedwdim_finance_customer]
			@last_modified_date_time datetime2(0) = null output
		as begin
			select
				 @last_modified_date_time = max([finance_customer_last_modified_date_time])
			from [edw].[dim_finance_customer];

			return 0;
		end