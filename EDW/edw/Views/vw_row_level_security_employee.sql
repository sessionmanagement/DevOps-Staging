
CREATE   VIEW [edw].[vw_row_level_security_employee]

AS

select
manager_email as user_principal_name
, dim_service_key
from edw.row_level_security
where dim_service_key is not null