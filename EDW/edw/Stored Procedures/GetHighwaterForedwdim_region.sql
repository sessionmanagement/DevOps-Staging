

		CREATE procedure [edw].[GetHighwaterForedwdim_region]
			@Last_Modified_Date_Time datetime2(0) = null output
		as begin
			select
				 @Last_Modified_Date_Time = max([region_last_modified_date_time])
			from [edw].[dim_region];

			return 0;
		end