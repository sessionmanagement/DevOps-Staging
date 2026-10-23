If you need to find what tables are being used in the ETL Views in the ODS you can run the below script.



```sql
--This is a view to look at the sources of each object using the ETL views dependancies
--You can reverse the query to look at what depends on certain data sources 

select s.name as schema_name
    ,object_name(sed.referencing_id) AS referencing_entity_name 
    ,lower(sed.referenced_schema_name) as referenced_schema_name
    ,string_agg(sed.referenced_entity_name,', ') as referenced_entity_names
 ,o.create_date
 ,o.modify_date as last_modified_date
 ,string_agg(sed2.referenced_entity_name,', ') as secondary_referenced_entity_names

from sys.sql_expression_dependencies sed  
inner join sys.objects o on sed.referencing_id = o.object_id
inner join sys.schemas s on o.schema_id = s.schema_id
left outer join sys.sql_expression_dependencies sed2 on sed.referenced_id = sed2.referencing_id

where o.type_desc = 'view'
and s.name in ('etl')
--and sed.referencing_id = OBJECT_ID(N'ETL.fact_client_referral')

--where referenced_entity_name like 'dimension%'
and lower(sed.referenced_entity_name) like '%detailVendorLedgEntries%'

group by s.name
    ,object_name(sed.referencing_id)
    ,lower(sed.referenced_schema_name)
 ,o.create_date
 ,o.modify_date

order by object_name(sed.referencing_id),referenced_schema_name


--select *   
--from sys.sql_expression_dependencies sed
--where referencing_id = OBJECT_ID(N'ETL.dim_ethnicity')



--select c.table_name, c.column_name, c.DATA_TYPE

--from information_schema.columns c
----inner join sys.objects o
----inner join sys.schemas s on o.schema_id = s.schema_id
--where c.TABLE_SCHEMA = 'edw'
--and  c.column_name like '%ethn%'

--order by c.table_name
----table_name = 'table_name'
```