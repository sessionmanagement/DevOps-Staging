When running a Database compare and if failures due to a casting of datatype but doesn't give you the name of the table/view or stored procedure

#### what we did to resolve the issue

Get a list of Tables, Views & Stored Procedure and order them by Data Modified with the most recent at the top.  Start by removing the SQL object a couple at a time,  check to see if you can do a schema compare.  at some stage hopefully you can complete a schema compare without the error.
Restore the last couple of SQL object you removed to see if one of them was causing the issue.  Otherwise you will need to restore all the objects you have deleted and keep test to see if the schema compare process fails or not