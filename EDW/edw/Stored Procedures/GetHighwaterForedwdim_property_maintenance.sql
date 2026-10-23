

		CREATE procedure [edw].[GetHighwaterForedwdim_property_maintenance]
			@property_maintenance_modified_datetime datetime2(0) = null output
		as begin
			select
				 @property_maintenance_modified_datetime = max([property_maintenance_modified_datetime])
			from [edw].[dim_property_maintenance];

			return 0;
		end