###Introduction
How we monitor the source view, source system, ods and edw row counts to ensure all the rows of data get through and are not duplicated

###Context
Context1: SQL server management studio (sql-prod-aus-svc-datawarehouse-01.database.windows.net )
<br/>
<details>

<summary><b>
01) Tables in the sqldb-prod-manager database
</b></summary>
<br/>

- load_check.check_detail
- load_check.row_count
- meta_data.source_system

</details>
<br/>


<details>

<summary><b>
02) Special case row counts --> Recordbase EAL/MNB has got data checks the [extract].[ExtractHistory] in the EAL DB 
</b></summary>
<br/>

This process checks the [extract].[ExtractHistory] table in EAL production database to check the recordbase process ran overnight


``` SQL
    select count(*) as row_count   
    from [extract].[ExtractHistory]   
    where ExtractDate >= dateadd(day,-1,getdate())  
    and StageEndTime >= dateadd(day,-1,getdate())  
    and LoadEndTime >= dateadd(day,-1,getdate())  
    and TransformEndTime >= dateadd(day,-1,getdate())

```

</details>
<br/>


<details>

<summary><b>
03) Special case row counts --> Business central total absolute general ledger amount 
</b></summary>
<br/>
 
This process checks the business central fact_finance_general_ledger_amount to add up all transactions and check that the amount always goes up and the daily change is a significant amount. Also checks the total amount is the same at each stage of the data loading.


``` SQL
--source
select sum(abs(amount)) as row_count from [BusinessCentral].[glEntries] g where g.ODSIsCurrent = 1
--ODS
select sum(abs(amount)) as row_count from etl.fact_finance_general_ledger where ODSIsCurrent = 1 and ODSDMLOperation <> 'D'
--edw
select sum(abs(finance_general_ledger_amount)) as row_count from edw.fact_finance_general_ledger v where v.DWHDMLOperation <> 'D'

```

</details>
<br/>


<details>

<summary><b>
04) Query to check the row counts
</b></summary>
<br/>

``` SQL

-- Created by Copilot in SSMS - review carefully before executing

--This script is to monitor our pipelines and data feeds
--•	Analyzes row count data for tables loaded from various source systems: (excluding KPI measures).
    --•Akoranga
    --•Business Central
    --•Emplive
    --•IntelliHR
    --•Recordbase
--•	Compares row counts between:
    --•	Source system
    --•	ODS (Operational Data Store)
    --•	EDW (Enterprise Data Warehouse)
--•	References setup details for each row count analysis in the load_check.check_detail table.
--•	Compares load dates:
--•	    Most recent load date vs. previous load date
--•	    Calculates differences and percent changes in row counts


declare @load_date date = (select max(load_date) from load_check.row_count 
                           where check_detail_id in (Select check_detail_id 
                           from load_check.check_detail where source_system_id <> 9));
declare @previous_load_date date = (select max(load_date) 
                                    from load_check.row_count 
                                    where load_date < @load_date
                                    and check_detail_id in (Select check_detail_id 
                                    from load_check.check_detail where source_system_id <> 9));

select 
    c.check_detail_id, 
    case when c.source_system_id = 1 and table_name like '%kpi%' then 'kpi table' else  s.source_system_name end as source_system, 
    c.table_name, 
    r.load_date,
    r.source_load_count,
    r.ods_load_count,
    r.edw_load_count,
    isnull(r.ods_load_count, 0) - isnull(r.source_load_count, 0) - isnull(c.source_ods_acceptable_difference, 0) as ods_load_difference,
    isnull(r.edw_load_count, 0) - isnull(r.ods_load_count, 0) - isnull(c.ods_edw_acceptable_difference, 0) as edw_load_difference,
    case 
        when isnull(r2.source_load_count, 0) > 0 
        then cast(round((cast(isnull(r.source_load_count, 0) - isnull(r2.source_load_count, r.source_load_count) as numeric(20, 8)) 
                        / isnull(r2.source_load_count, r.source_load_count)), 6) as numeric(20, 6)) 
        else 0.000 
    end as percent_daily_change,
    isnull(r.ods_load_count, 0) - isnull(r2.ods_load_count, r.ods_load_count) as ods_daily_change,
    isnull(r.edw_load_count, 0) - isnull(r2.edw_load_count, r.edw_load_count) as edw_daily_change
from 
    load_check.check_detail c
inner join 
    load_check.row_count r 
    on c.check_detail_id = r.check_detail_id
left outer join 
    (select * from load_check.row_count where load_date = @previous_load_date) r2 
    on c.check_detail_id = r2.check_detail_id
inner join 
    meta_data.source_system s 
    on c.source_system_id = s.source_system_id
where 
    r.load_date = @load_date
    and c.source_system_id <> 9
order by 
    case when c.source_system_id = 1 and table_name like '%kpi%' then 'kpi table' else  s.source_system_name end,
    c.source_load_dataset, 
    c.table_name, 
    r.load_date;


``` 


</details>
<br/>


![image.png](/.attachments/image-e462e5d1-b416-481e-9735-6c3563a9b1f4.png)



<details>

<summary><b>
05) Check how the row count is obtained for each row on the report
</b></summary>
<br/>

You can query the manager database to check how each row count is obtained by using the following query

``` SQL
   
select * from load_check.check_detail where check_detail_id = ?? 

```

</details>
<br/>