In the stored procedure the merges the incoming data with existing data there is a bug where rows that have previously been marked as delete are removed from the table in the ODS.  To fix this you need to updated the stored procedure that updates the table find the below code in the stored procedure,  usually around the 160 lines

```
-- Previously soft deleted records that (still) dont exist in source
			select  src.[company_id] ,  'Non' as MergeType
			from [Staging].[Datapay_companies] as src
				right outer join [Working].[Datapay_companies] trg
					on src.[company_id] = trg.[company_id] collate database_default
			where  src.[company_id] is null    
				and isnull(trg.[ODSIsCurrent], 1) = 1
				and isnull(trg.[ODSDMLOperation], 'X') = 'D'

```

and update the select statement so it getting the id from the target table not the source


```
	-- Previously soft deleted records that (still) dont exist in source
			select  trg.[id] ,  'Non' as MergeType
			from [Staging].[Datapay_employees] as src
				right outer join [Working].[Datapay_employees] trg
					on src.[id] = trg.[id] collate database_default
			where  src.[id] is null    
				and isnull(trg.[ODSIsCurrent], 1) = 1
				and isnull(trg.[ODSDMLOperation], 'X') = 'D'
```
