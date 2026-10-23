


 --1.9        2025/05/12    Manish Singh		Changing UTC date column to NZT










CREATE VIEW [ETL].[Testdim_property_maintenance]
AS


SELECT 
zmt.ID AS property_maintenance_id
,CAST(state_mt.LocalizedLabel AS VARCHAR(10)) AS property_maintenance_task_state
,CAST(status_mt.LocalizedLabel AS VARCHAR(10)) AS property_maintenance_task_state_status -- property_maintenance_task_status name already used
,CAST(newtype_om.LocalizedLabel AS VARCHAR(20)) AS property_maintenance_type
,CAST(acknowledgment_type_om.LocalizedLabel AS VARCHAR(40)) AS property_maintenance_acknowledgment_type
,CAST(contractorstatus_gm.LocalizedLabel AS VARCHAR(20)) AS property_maintenance_contractor_status
--,zmt.zav_contractorstatusdateandtime AS property_maintenance_contractor_status_datetime

,CAST((zmt.zav_contractorstatusdateandtime AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS property_maintenance_contractor_status_datetime

,CAST(damagetype_gm.LocalizedLabel AS VARCHAR(40)) AS property_maintenance_damage_type
,keyaccessinformation_gm.LocalizedLabel AS property_maintenance_key_access_information
,CAST(propertystatus_gm.LocalizedLabel  AS VARCHAR(40)) AS property_maintenance_property_status
,CAST(sendworkorderto_om.LocalizedLabel  AS VARCHAR(20)) AS property_maintenance_send_workorder_to
,CAST(taskstatus_gm.LocalizedLabel  AS VARCHAR(20)) AS property_maintenance_task_status
,CAST(urgent_gm.LocalizedLabel  AS VARCHAR(20)) AS property_maintenance_task_urgency
--,zmt.new_type -- 
--,zmt.zav_doarequired -- all null
--,zmt.zav_inventoryitem -- all null
--,zmt.zav_location -- all null
--,zmt.zav_rectificationstatus -- all null
----flags
, CAST(CAST(zmt.new_completedbycontractor as BIT) as INT) as property_maintenance_completed_by_contractor_flag
, CAST(CAST(zmt.new_postinspectiondone as BIT) as INT) as property_maintenance_post_inspection_done_flag
, CAST(CAST(zmt.new_tenantconsent as BIT) as INT) as property_maintenance_tenant_consent_flag
, CAST(CAST(zmt.zav_acknowledgmentsenttothetenant as BIT) as INT) as property_maintenance_acknowledgment_sent_to_tenant_flag
, CAST(CAST(zmt.zav_cancelworktask as BIT) as INT) as property_maintenance_cancel_work_task_flag
, CAST(CAST(zmt.zav_completedsatisfactorily as BIT) as INT) as property_maintenance_completed_satisfactorily_flag
, CAST(CAST(zmt.zav_confirmedforpayment as BIT) as INT) as property_maintenance_confirmed_for_payment_flag
, CAST(CAST(zmt.zav_dummycompletedbutkeeptaskstatus as BIT) as INT) as property_maintenance_dummy_completed_but_keep_task_status_flag
, CAST(CAST(zmt.zav_ecdprocessedqueue as BIT) as INT) as property_maintenance_ecd_processed_queue_flag
, CAST(CAST(zmt.zav_email as BIT) as INT) as property_maintenance_email_flag
, CAST(CAST(zmt.zav_exported as BIT) as INT) as property_maintenance_exported_flag
, CAST(CAST(zmt.zav_finalisedworktask as BIT) as INT) as property_maintenance_finalised_work_task_flag
, CAST(CAST(zmt.zav_flexifund as BIT) as INT) as property_maintenance_flexi_fund_flag
, CAST(CAST(zmt.zav_invoicedetailsprocessedqueue as BIT) as INT) as property_maintenance_invoice_details_processed_queue_flag
, CAST(CAST(zmt.zav_letter as BIT) as INT) as property_maintenance_letter_flag
, CAST(CAST(zmt.zav_onhold as BIT) as INT) as property_maintenance_onhold_flag
, CAST(CAST(zmt.zav_ownerrecovery as BIT) as INT) as property_maintenance_owner_recovery_flag
, CAST(CAST(zmt.zav_phonecall as BIT) as INT) as property_maintenance_phonecall_flag
, CAST(CAST(zmt.zav_requestreceivedsentprocessedqueue as BIT) as INT) as property_maintenance_request_received_sent_processed_queue_flag
, CAST(CAST(zmt.zav_sendemailnotificationwhenpfmcancelled as BIT) as INT) as property_maintenance_send_email_notification_when_pfm_cancelled_flag
, CAST(CAST(zmt.zav_supportemail as BIT) as INT) as property_maintenance_support_email_flag
, CAST(CAST(zmt.zav_suppresstenantemail as BIT) as INT) as property_maintenance_suppress_tenant_email_flag
, CAST(CAST(zmt.zav_tenantdamage as BIT) as INT) as property_maintenance_tenant_damage_flag
, CAST(CAST(zmt.zav_tenantliable as BIT) as INT) as property_maintenance_tenant_liable_flag
, CAST(CAST(zmt.zav_tenantscharged as BIT) as INT) as property_maintenance_tenants_charged_flag
, CAST(CAST(zmt.zav_tenantspermission as BIT) as INT) as property_maintenance_tenants_permission_flag
, CAST(CAST(zmt.zav_textmessage as BIT) as INT) as property_maintenance_text_message_flag
, CAST(CAST(zmt.zav_variationprocessedqueue as BIT) as INT) as property_maintenance_variation_processed_queue_flag
, CAST(CAST(zmt.zav_workquoteprocessedqueue as BIT) as INT) as property_maintenance_work_quote_processed_queue_flag
, CAST(CAST(zmt.zav_worktaskcompletionprocessedqueue as BIT) as INT) as property_maintenance_work_task_completion_processed_queue_flag
--,zmt.new_inspectionid AS property_maintenance_inspectionid
,CAST(insp.zav_inspectionid1 AS VARCHAR(10)) AS property_maintenance_inspection_identifier
--,zmt.new_officelocationid AS property_maintenance_officelocationid << all Null
--,zmt.new_property AS property_maintenance_property
--,zmt.owningbusinessunit AS property_maintenance_owningbusinessunit
--,zmt.owningteam AS property_maintenance_owningteam
--,zmt.owninguser AS property_maintenance_owninguser
--,zmt.slaid -- all null AS property_maintenance_slaid -- all null
--,zmt.slainvokedid -- all null AS property_maintenance_slainvokedid -- all null
--,zmt.transactioncurrencyid AS property_maintenance_transactioncurrencyid
--,zmt.zav_acknowledgedby AS property_maintenance_acknowledgedby << all Null
 ,(SELECT CAST(fullname AS VARCHAR(100)) FROM [Zavanti].[vw_systemuser] where [Id] = zmt.zav_cancellationrequestedby ) as property_maintenance_cancellation_requested_by 
--,zmt.zav_cause AS property_maintenance_cause << all Null
--,zmt.zav_client AS property_maintenance_client
 ,(SELECT CAST(fullname AS VARCHAR(100)) FROM [Zavanti].[vw_contact] where [Id] = zmt.zav_client ) as property_maintenance_client 
--,zmt.zav_doasettings AS property_maintenance_doasettings << all Null
--,zmt.zav_emergencyresponsewithin4hoursid AS property_maintenance_emergencyresponsewithin4hoursid << all Null
--,zmt.zav_housingofficer AS property_maintenance_housingofficer
--,zmt.zav_housingofficerid AS property_maintenance_housingofficerid
 ,(SELECT CAST(fullname AS VARCHAR(100)) FROM [Zavanti].[vw_systemuser] where [Id] = zmt.zav_housingofficerid ) as property_maintenance_housing_officer 
--,zmt.zav_invoiceapprovedby AS zav_invoiceapprovedby
 ,(SELECT CAST(fullname AS VARCHAR(100)) FROM [Zavanti].[vw_systemuser] where [Id] = zmt.zav_invoiceapprovedby ) as property_maintenance_zav_invoice_approved_by
--,zmt.zav_itemgroup AS property_maintenance_itemgroup << all NULL
--,zmt.zav_itemtype AS property_maintenance_itemtype << all NULL
--,zmt.zav_keysupportcontact AS property_maintenance_keysupportcontact
 ,(SELECT CAST(fullname AS VARCHAR(100)) FROM [Zavanti].[vw_contact] where [Id] = zmt.zav_keysupportcontact ) as property_maintenance_key_support_contact
--,zmt.zav_legalownerprimarycontact AS property_maintenance_legalownerprimarycontact
 ,(SELECT CAST(fullname AS VARCHAR(100)) FROM [Zavanti].[vw_contact] where [Id] = zmt.zav_legalownerprimarycontact ) as property_maintenance_legal_owner_primary_contact 
,bu.name AS property_maintenance_owning_business_unit_name
,CAST(t.fullname AS VARCHAR(100)) AS property_maintenance_owning_user
--,zmt.[createdon] AS property_maintenance_created_datetime
--,zmt.[modifiedon] AS property_maintenance_modified_datetime
--,zmt.[createdon] AS property_maintenance_created_datetime

,CAST((zmt.createdon AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS property_maintenance_created_datetime

--,zmt.[modifiedon] AS property_maintenance_modified_datetime

,CAST((zmt.modifiedon AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS property_maintenance_modified_datetime


,CAST(CAST(zmt.[IsDelete]  as BIT) as INT) AS property_maintenance_is_delete_flag
  FROM [Zavanti].[vw_zav_maintenancetask] zmt
  LEFT JOIN [Zavanti].[vw_zav_inspection] insp ON zmt.new_inspectionid = insp.id
  LEFT JOIN [Zavanti].[vw_StateMetadata] AS state_mt ON state_mt.EntityName = 'zav_maintenancetask' AND state_mt.state = zmt.statecode
  LEFT JOIN [Zavanti].[vw_StatusMetadata] AS status_mt ON status_mt.EntityName = 'zav_maintenancetask' AND status_mt.state = zmt.statecode AND status_mt.status = zmt.statuscode
  LEFT JOIN [Zavanti].[vw_OptionsetMetadata] AS newtype_om ON   newtype_om.EntityName = 'zav_maintenancetask' AND newtype_om.OptionSetName = 'new_type' AND newtype_om.[Option] = zmt.new_type
  LEFT JOIN [Zavanti].[vw_OptionsetMetadata] AS acknowledgment_type_om ON   acknowledgment_type_om.EntityName = 'zav_maintenancetask' AND acknowledgment_type_om.OptionSetName = 'zav_acknowledgmenttype' AND acknowledgment_type_om.[Option] = zmt.zav_acknowledgmenttype
  LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS contractorstatus_gm ON  contractorstatus_gm.EntityName = 'zav_maintenancetask' AND  contractorstatus_gm.GlobalOptionSetName = 'zav_contractorstatus' AND contractorstatus_gm.[Option] = zmt.zav_contractorstatus
  LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS damagetype_gm ON damagetype_gm.EntityName = 'zav_maintenancetask' AND damagetype_gm.GlobalOptionSetName = 'zav_damagetype' AND damagetype_gm.[Option] = zmt.zav_damagetype
  LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS keyaccessinformation_gm ON keyaccessinformation_gm.EntityName = 'zav_maintenancetask' AND keyaccessinformation_gm.GlobalOptionSetName = 'zav_keyaccessinformation' AND keyaccessinformation_gm.[Option] = zmt.zav_keyaccessinformation
  LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS propertystatus_gm ON propertystatus_gm.EntityName = 'zav_maintenancetask' AND propertystatus_gm.GlobalOptionSetName = 'new_propertystatus' AND propertystatus_gm.[Option] = zmt.zav_propertystatus
  LEFT JOIN [Zavanti].[vw_OptionsetMetadata] AS sendworkorderto_om ON   sendworkorderto_om.EntityName = 'zav_maintenancetask' AND sendworkorderto_om.OptionSetName = 'zav_sendworkorderto' AND sendworkorderto_om.[Option] = zmt.zav_sendworkorderto
  LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS taskstatus_gm ON taskstatus_gm.EntityName = 'zav_maintenancetask' AND taskstatus_gm.GlobalOptionSetName = 'zav_taskstatus' AND taskstatus_gm.[Option] = zmt.zav_taskstatus
  LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS urgent_gm ON urgent_gm.EntityName = 'zav_maintenancetask' AND urgent_gm.GlobalOptionSetName = 'zav_urgent' AND urgent_gm.[Option] = zmt.zav_urgent
  LEFT JOIN [Zavanti].[vw_businessunit] bu ON bu.[Id] = zmt.owningbusinessunit
  LEFT JOIN [Zavanti].[vw_systemuser] t ON t.[Id] = zmt.owninguser
 -- WHERE zmt.IsDelete IS NULL