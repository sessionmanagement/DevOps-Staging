

		CREATE procedure [edw].[GetHighwaterForedwdim_location]
			@Last_Modified_Date_Time datetime2(0) = null output
		as begin
			select
				 @Last_Modified_Date_Time = max([location_last_modified_date_time])
			from [edw].[dim_location];

			return 0;
		end