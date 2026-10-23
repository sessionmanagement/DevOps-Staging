





CREATE PROC [staging].[insert_staging_fact_powerbi_activity_log]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_fact_powerbi_activity_log]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2023-08-25    Manish Singh				Initial version
2.0		 2024-05-07    Manish Singh				Adding change in Dimtime to stored proc

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLfact_powerbi_activity_log]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLfact_powerbi_activity_log] (
      [dim_powerbi_activity_type_key]
      ,[dim_employee_key]
      ,[dim_create_date_key]
      ,[dim_create_time_key]
      ,[dim_create_date_time]
      ,[powerbi_activity_log_internal_id]
      ,[activity]
      ,[is_success]
      ,[item_name]
      ,[item_type]
      ,[user_type]
      ,[user_id]
      ,[client_ip]
      ,[user_agent]
      ,[distribution_method]
      ,[consumption_method]
      ,[bk_workspace_id]
      ,[workspace_name]
      ,[bk_report_id]
      ,[report_name]
      ,[folder_display_name]
      ,[import_source]
      ,[import_type]
      ,[import_display_name]
      ,[data_connectivity_mode]
      ,[bk_dataset_id]
      ,[dataset_name]
      ,[refresh_type]
      ,[bk_gateway_cluster_id]
      ,[gateway_cluster_name]
      ,[gateway_cluster_type]
      ,[bk_artifact_id]
      ,[artifact_name]
      ,[capacity_name]
      ,[capacity_users]
      ,[capacity_state]
      ,[exported_artifact_export_type]
      ,[exported_artifact_type]
      ,[audited_artifact_name]
      ,[audited_artifact_item_type]
      ,[other_dataset_names]
      ,[other_data_source_types]
      ,[other_data_source_connection_details]
      ,[sharing_recipient_emails]
      ,[sharing_re_share_permissions]
      ,[subscribee_recipient_emails]
      ,[subscribee_recipient_names]
      ,[create_date]
      ,[create_time]
	)
SELECT
	isnull(pct.[dim_powerbi_activity_type_key],'0')  as [dim_powerbi_activity_type_key] 
	,isnull(emp.[dim_employee_key],'0') as [dim_employee_key]
	,isnull(dt.[dim_date_key],'0') as [dim_create_date_key]
	,isnull(dtt.[dim_time_key],'0') as [dim_create_time_key]
	,isnull(CAST( CAST( dt.[dim_date_key] AS char(8)) AS date ),'1900-01-01') as [dim_create_date_time]
	
	,[powerbi_activity_log_internal_id] 
	,src.[activity] 
	,[is_success] 
	,[item_name] 
	,[item_type] 
	,[usertype] 
	,[userid] 
	,[clientip] 
	,[useragent] 
	,[distributionmethod] 
	,[consumptionmethod] 
	,[bkworkspaceid] 
	,[workspacename] 
	,[bkreportid] 
	,[reportname] 
	,[folderdisplayname] 
	,[importsource] 
	,[importtype] 
	,[importdisplayname] 
	,[dataconnectivitymode] 
	,[bkdatasetid] 
	,[datasetname] 
	,[refreshtype] 
	,[bkgatewayclusterid] 
	,[gatewayclustername] 
	,[gatewayclustertype] 
	,[bkartifactid] 
	,[artifactname] 
	,[capacityname] 
	,[capacityusers] 
	,[capacitystate] 
	,[exportedartifactexporttype] 
	,[exportedartifacttype] 
	,[auditedartifactname] 
	,[auditedartifactitemtype] 
	,[otherdatasetnames] 
	,[otherdatasourcetypes] 
	,[otherdatasourceconnectiondetails] 
	,[sharingrecipientemails] 
	,[sharingresharepermissions] 
	,[subscribeerecipientemails] 
	,[subscribeerecipientnames] 
	 , CAST( CAST( createdatekey AS char(8)) AS date ) as create_date
	,[createtimekey] as create_time
from [Landing].[edw_fact_powerbi_activity_log] as src
  LEFT JOIN   [edw].[dim_powerbi_activity_type] pct
  on src.[activity]=pct.[activity]
  LEFT JOIN  [edw].[dim_employee] emp
  on src.[UserID]=emp.[employee_primary_email_address]
  and emp.dwhiscurrent=1
  LEFT JOIN [edw].[dim_date] dt
  on src.[createdatekey]=dt.dim_date_key
  LEFT JOIN [edw].[dim_time] dtt
  on src.[createtimekey]=dtt.[time]