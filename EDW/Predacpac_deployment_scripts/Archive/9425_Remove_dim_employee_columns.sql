/*
 Pre-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be executed before the build script.	
 Use SQLCMD syntax to include a file in the pre-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the pre-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/


--edw.dim_employee

--Update edw.dim_employee Set employee_salary_sacrifice = null
--	,employee_bank_details = null
--	,employee_incidents = null
--	,employee_latest_incident_date = null
--	,employee_disciplinary_status = null
--	,employee_specific_needs = null
--	,employee_qualification_level = null
--	,employee_referral_source = null
--	,employee_current_status = null


if exists(select * from sys.columns where name='employee_salary_sacrifice' and object_id = object_id('edw.dim_employee'))
alter table edw.dim_employee drop column employee_salary_sacrifice
go

if exists(select * from sys.columns where name='employee_bank_details' and object_id = object_id('edw.dim_employee'))
alter table edw.dim_employee drop column employee_bank_details
go

if exists(select * from sys.columns where name='employee_incidents' and object_id = object_id('edw.dim_employee'))
alter table edw.dim_employee drop column employee_incidents
go

if exists(select * from sys.columns where name='employee_latest_incident_date' and object_id = object_id('edw.dim_employee'))
alter table edw.dim_employee drop column employee_latest_incident_date
go

if exists(select * from sys.columns where name='employee_disciplinary_status' and object_id = object_id('edw.dim_employee'))
alter table edw.dim_employee drop column employee_disciplinary_status
go

if exists(select * from sys.columns where name='employee_specific_needs' and object_id = object_id('edw.dim_employee'))
alter table edw.dim_employee drop column employee_specific_needs
go

if exists(select * from sys.columns where name='employee_qualification_level' and object_id = object_id('edw.dim_employee'))
alter table edw.dim_employee drop column employee_qualification_level
go

if exists(select * from sys.columns where name='employee_referral_source' and object_id = object_id('edw.dim_employee'))
alter table edw.dim_employee drop column employee_referral_source
go

if exists(select * from sys.columns where name='employee_current_status' and object_id = object_id('edw.dim_employee'))
alter table edw.dim_employee drop column employee_current_status
go



--landing.edw_dim_employee

--Update landing.edw_dim_employee Set employee_salary_sacrifice = null
--	,employee_bank_details = null
--	,employee_incidents = null
--	,employee_latest_incident_date = null
--	,employee_disciplinary_status = null
--	,employee_specific_needs = null
--	,employee_qualification_level = null
--	,employee_referral_source = null
--	,employee_current_status = null


if exists(select * from sys.columns where name='employee_salary_sacrifice' and object_id = object_id('landing.edw_dim_employee'))
alter table landing.edw_dim_employee drop column employee_salary_sacrifice
go

if exists(select * from sys.columns where name='employee_bank_details' and object_id = object_id('landing.edw_dim_employee'))
alter table landing.edw_dim_employee drop column employee_bank_details
go

if exists(select * from sys.columns where name='employee_incidents' and object_id = object_id('landing.edw_dim_employee'))
alter table landing.edw_dim_employee drop column employee_incidents
go

if exists(select * from sys.columns where name='employee_latest_incident_date' and object_id = object_id('landing.edw_dim_employee'))
alter table landing.edw_dim_employee drop column employee_latest_incident_date
go

if exists(select * from sys.columns where name='employee_disciplinary_status' and object_id = object_id('landing.edw_dim_employee'))
alter table landing.edw_dim_employee drop column employee_disciplinary_status
go

if exists(select * from sys.columns where name='employee_specific_needs' and object_id = object_id('landing.edw_dim_employee'))
alter table landing.edw_dim_employee drop column employee_specific_needs
go

if exists(select * from sys.columns where name='employee_qualification_level' and object_id = object_id('landing.edw_dim_employee'))
alter table landing.edw_dim_employee drop column employee_qualification_level
go

if exists(select * from sys.columns where name='employee_referral_source' and object_id = object_id('landing.edw_dim_employee'))
alter table landing.edw_dim_employee drop column employee_referral_source
go

if exists(select * from sys.columns where name='employee_current_status' and object_id = object_id('landing.edw_dim_employee'))
alter table landing.edw_dim_employee drop column employee_current_status
go


--staging.ODSETLdim_employee

--Update staging.ODSETLdim_employee Set employee_salary_sacrifice = null
--	,employee_bank_details = null
--	,employee_incidents = null
--	,employee_latest_incident_date = null
--	,employee_disciplinary_status = null
--	,employee_specific_needs = null
--	,employee_qualification_level = null
--	,employee_referral_source = null
--	,employee_current_status = null


if exists(select * from sys.columns where name='employee_salary_sacrifice' and object_id = object_id('staging.ODSETLdim_employee'))
alter table staging.ODSETLdim_employee drop column employee_salary_sacrifice
go

if exists(select * from sys.columns where name='employee_bank_details' and object_id = object_id('staging.ODSETLdim_employee'))
alter table staging.ODSETLdim_employee drop column employee_bank_details
go

if exists(select * from sys.columns where name='employee_incidents' and object_id = object_id('staging.ODSETLdim_employee'))
alter table staging.ODSETLdim_employee drop column employee_incidents
go

if exists(select * from sys.columns where name='employee_latest_incident_date' and object_id = object_id('staging.ODSETLdim_employee'))
alter table staging.ODSETLdim_employee drop column employee_latest_incident_date
go

if exists(select * from sys.columns where name='employee_disciplinary_status' and object_id = object_id('staging.ODSETLdim_employee'))
alter table staging.ODSETLdim_employee drop column employee_disciplinary_status
go

if exists(select * from sys.columns where name='employee_specific_needs' and object_id = object_id('staging.ODSETLdim_employee'))
alter table staging.ODSETLdim_employee drop column employee_specific_needs
go

if exists(select * from sys.columns where name='employee_qualification_level' and object_id = object_id('staging.ODSETLdim_employee'))
alter table staging.ODSETLdim_employee drop column employee_qualification_level
go

if exists(select * from sys.columns where name='employee_referral_source' and object_id = object_id('staging.ODSETLdim_employee'))
alter table staging.ODSETLdim_employee drop column employee_referral_source
go

if exists(select * from sys.columns where name='employee_current_status' and object_id = object_id('staging.ODSETLdim_employee'))
alter table staging.ODSETLdim_employee drop column employee_current_status
go