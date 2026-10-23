


		CREATE procedure [edw].[GetHighwaterForedwdim_property_tenancy]
			@property_tenancy_modified_datetime datetime2(0) = null output
		as begin
			select
				 @property_tenancy_modified_datetime = max([property_tenancy_modified_datetime])
			from [edw].[dim_property_tenancy];
			--select @property_tenancy_modified_datetime = '2025-12-01 12:42:03.0000000'
			return 0;
		end


		--exec [edw].[GetHighwaterForedwdim_property_tenancy]