


		CREATE procedure [edw].[GetHighwaterForedwfact_finance_vendor_ledger]
			@ODSEffectiveFrom datetime = null output
		as begin
			select
				 @ODSEffectiveFrom = max([finance_vendor_ledger_ODSEffectiveFrom])
			from [edw].[fact_finance_vendor_ledger];

			return 0;
		end