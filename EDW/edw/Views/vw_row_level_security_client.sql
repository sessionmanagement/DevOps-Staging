

CREATE   VIEW [edw].[vw_row_level_security_client]

as

select
manager_email as user_principal_name
, dim_client_team_key 
, recordbase_team_id as client_team_id
from edw.row_level_security
where dim_client_team_key is not null