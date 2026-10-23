

		CREATE procedure [edw].[GetHighwaterForedwfact_property_tenancy_transaction]
			@property_tenancy_transaction_modified_datetime datetime2(0) = null output
		as begin
			select
				 @property_tenancy_transaction_modified_datetime = max([property_tenancy_transaction_modified_datetime])
			from [edw].[fact_property_tenancy_transaction];

			return 0;
		end