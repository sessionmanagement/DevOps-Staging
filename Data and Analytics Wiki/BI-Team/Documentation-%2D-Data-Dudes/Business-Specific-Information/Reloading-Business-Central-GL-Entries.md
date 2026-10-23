[DevOps Bug Ticket 7130](https://dev.azure.com/EmergeAotearoa/Data%20and%20Analytics/_sprints/taskboard/Business%20Intelligence%20Team/Data%20and%20Analytics/Data%20and%20Reporting%20Stream/ScrumBan%20-%20Sprint%20005?workitem=7130)

[Change Request 189](https://servicedesk.emergeaotearoa.org.nz/itil/changes/189)

### Issue
on the 27th Jan 2024 there was a issue loading the Business Central GL Entries into the ODS.  the error looks like there was an issue at the platform level and self corrected itself on the 28th Jan.  but the data from the 27th hasn't been loaded into the ODS so we were missing 4790 rows.

### Fix
so we loaded the 27th Jan data via the dataflow, updated the DatePathindays Parameter to be -37 days.

After that I had to load a Spark Notebook and load the GL Entries into a dataframe.  Using this dataframe I created another dataframe to hold the data from the 27th Jan using the BatchID

Using the this filtered dataframe I got a list of GL Entries where we had more that one row and checked that the ODSIsCurrent flag was set correct row.  There was two GL Entries where the ODSIsCurrent has been set against the wrong row which I have corrected

#### Python Notebook
_note:  had to rename the notebook as text file to attach_
[Update ODS Audit Columns.txt](/.attachments/Update%20ODS%20Audit%20Columns-0d0b714a-9050-474f-8a5e-816431568b58.txt)
