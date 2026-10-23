
		create   procedure [edw].[GetHighwaterForedwdim_property_arrears_arrangement]
			@synapse_link_sink_modified_on datetime = null output
		as begin
			select
				 @synapse_link_sink_modified_on = max(paa.synapse_link_sink_modified_on)  
				 
			from [edw].[dim_property_arrears_arrangement] paa

			return 0;
		end