

		CREATE procedure [edw].[GetHighwaterForedwdim_property_maintenace_type]
			@synapse_link_sink_modified_on datetime = null output
		as begin
			select
				 @synapse_link_sink_modified_on = max([synapse_link_sink_modified_on])
			from [edw].[dim_property_maintenace_type];

			return 0;
		end