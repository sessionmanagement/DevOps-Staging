


		CREATE procedure [edw].[GetHighwaterForedwdim_finance_funder]
			@Last_Modified_Date_Time datetime2(0) = null output
		as begin
			select
				 @Last_Modified_Date_Time = max([finance_funder_last_modified_date_time])
			from [edw].[dim_finance_funder];

			return 0;
		end