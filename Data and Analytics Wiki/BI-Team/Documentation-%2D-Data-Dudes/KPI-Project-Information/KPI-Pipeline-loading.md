

1) KPI data from sharepoint is run under the 'Extract MS Graph Master' data factory load

2) KPI Trigger to load dim_KPI from landing to ODS

3) KPI EDW load runs as a normal 101 Dimensions dataload

4) KPI views populate snapshot table, automatically run at the end of the 10_Load_Master EDW framework load

There are currently 4 views to run 
- Client, Referral, Kahmahi, Property
 