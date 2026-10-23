###Introduction
How we monitor dim key links, where there is no record in the dim table for the dim-key in the fact table

###Context
Context1: SQL server management studio (sql-prod-aus-svc-datawarehouse-01.database.windows.net )
<br/>
<details>

<summary><b>
01) Tables in the sqldb-prod-manager database
</b></summary>
<br/>

- meta_data.mismatches
- meta_data.mismatch_reason

</details>
<br/>


<details>

<summary><b>
02) Query to check the mismatches 
</b></summary>
<br/>

``` SQL


declare @load_date date = (Select max(mismatches_date) from meta_data.mismatches);
declare @previous_load_date date = (Select max(mismatches_date) from meta_data.mismatches where mismatches_date < @load_date);

select 
    m.mismatches_id,
    convert(varchar(10), m.mismatches_date, 103) as mismatches_date,
    m.table_name,
    m.column_name,
    m.mismatches_count,
    m2.mismatches_count as yesterdays_mismatches,
    isnull(r.mismatch_reason, '') as mismatch_reason,
    isnull(r.mismatch_business_data, '') as examples
from 
    meta_data.mismatches m
left join 
    meta_data.mismatch_reason r 
    on m.column_name = r.column_name 
    and m.table_name = r.table_name
left join 
    meta_data.mismatches m2 
    on m.table_name = m2.table_name
    and m.column_name = m2.column_name
    and convert(date, m2.mismatches_date, 102) = @previous_load_date
where 
    m.table_name not like '%BKP%' 
    and (
        (left(m.table_name, 3) = 'dim' and m.mismatches_count >= 2) 
        or 
        (left(m.table_name, 4) = 'fact' and m.mismatches_count >= 1)
    )
    and m.table_name not like '%row_level%'
    and convert(date, m.mismatches_date, 102) = @load_date
order by 
    m.mismatches_count desc;

``` 


</details>
<br/>


![image.png](/.attachments/image-a1ef70d0-c23f-4fb6-9a27-c512e3e9816b.png)

