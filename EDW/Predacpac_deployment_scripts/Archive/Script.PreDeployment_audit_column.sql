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
EXEC sp_rename 'edw.dim_business_unit_hierarchy.EDWBatchId', 'DWHBatchId', 'COLUMN';
EXEC sp_rename 'edw.dim_business_unit_hierarchy.EDWCreatedAt', 'DWHCreatedAt', 'COLUMN';
EXEC sp_rename 'edw.dim_business_unit_hierarchy.EDWDMLOperation', 'DWHDMLOperation', 'COLUMN';
EXEC sp_rename 'edw.dim_business_unit_hierarchy.EDWModifiedOn', 'DWHModifiedOn', 'COLUMN';
EXEC sp_rename 'edw.dim_business_unit_hierarchy.EDWSourceSystem', 'DWHSourceSystem', 'COLUMN';
EXEC sp_rename 'edw.dim_client_absence.EDWBatchId', 'DWHBatchId', 'COLUMN';
EXEC sp_rename 'edw.dim_client_absence.EDWDMLOperation', 'DWHDMLOperation', 'COLUMN';
EXEC sp_rename 'edw.dim_client_absence.EDWEffectiveFrom', 'DWHEffectiveFrom', 'COLUMN';
EXEC sp_rename 'edw.dim_client_absence.EDWEffectiveTo', 'DWHEffectiveTo', 'COLUMN';
EXEC sp_rename 'edw.dim_client_absence.EDWIsCurrent', 'DWHIsCurrent', 'COLUMN';
EXEC sp_rename 'edw.dim_client_absence.EDWSourceSystem', 'DWHSourceSystem', 'COLUMN';
EXEC sp_rename 'edw.dim_ethnicity.EDWBatchId', 'DWHBatchId', 'COLUMN';
EXEC sp_rename 'edw.dim_ethnicity.EDWCreatedAt', 'DWHCreatedAt', 'COLUMN';
EXEC sp_rename 'edw.dim_ethnicity.EDWDMLOperation', 'DWHDMLOperation', 'COLUMN';
EXEC sp_rename 'edw.dim_ethnicity.EDWModifiedOn', 'DWHModifiedOn', 'COLUMN';
EXEC sp_rename 'edw.dim_ethnicity.EDWSourceSystem', 'DWHSourceSystem', 'COLUMN';
EXEC sp_rename 'edw.dim_gender.EDWBatchId', 'DWHBatchId', 'COLUMN';
EXEC sp_rename 'edw.dim_gender.EDWCreatedAt', 'DWHCreatedAt', 'COLUMN';
EXEC sp_rename 'edw.dim_gender.EDWDMLOperation', 'DWHDMLOperation', 'COLUMN';
EXEC sp_rename 'edw.dim_gender.EDWModifiedOn', 'DWHModifiedOn', 'COLUMN';
EXEC sp_rename 'edw.dim_gender.EDWSourceSystem', 'DWHSourceSystem', 'COLUMN';
EXEC sp_rename 'edw.dim_kpi_target_definitions.EDWBatchId', 'DWHBatchId', 'COLUMN';
EXEC sp_rename 'edw.dim_kpi_target_definitions.EDWDMLOperation', 'DWHDMLOperation', 'COLUMN';
EXEC sp_rename 'edw.dim_kpi_target_definitions.EDWEffectiveFrom', 'DWHEffectiveFrom', 'COLUMN';
EXEC sp_rename 'edw.dim_kpi_target_definitions.EDWEffectiveTo', 'DWHEffectiveTo', 'COLUMN';
EXEC sp_rename 'edw.dim_kpi_target_definitions.EDWIsCurrent', 'DWHIsCurrent', 'COLUMN';
EXEC sp_rename 'edw.dim_kpi_target_definitions.EDWSourceSystem', 'DWHSourceSystem', 'COLUMN';
EXEC sp_rename 'edw.dim_leave_type.EDWBatchId', 'DWHBatchId', 'COLUMN';
EXEC sp_rename 'edw.dim_leave_type.EDWCreatedAt', 'DWHCreatedAt', 'COLUMN';
EXEC sp_rename 'edw.dim_leave_type.EDWDMLOperation', 'DWHDMLOperation', 'COLUMN';
EXEC sp_rename 'edw.dim_leave_type.EDWModifiedOn', 'DWHModifiedOn', 'COLUMN';
EXEC sp_rename 'edw.dim_leave_type.EDWSourceSystem', 'DWHSourceSystem', 'COLUMN';
EXEC sp_rename 'edw.dim_nationality.EDWBatchId', 'DWHBatchId', 'COLUMN';
EXEC sp_rename 'edw.dim_nationality.EDWCreatedAt', 'DWHCreatedAt', 'COLUMN';
EXEC sp_rename 'edw.dim_nationality.EDWDMLOperation', 'DWHDMLOperation', 'COLUMN';
EXEC sp_rename 'edw.dim_nationality.EDWModifiedOn', 'DWHModifiedOn', 'COLUMN';
EXEC sp_rename 'edw.dim_nationality.EDWSourceSystem', 'DWHSourceSystem', 'COLUMN';
EXEC sp_rename 'edw.dim_payroll_category.EDWBatchId', 'DWHBatchId', 'COLUMN';
EXEC sp_rename 'edw.dim_payroll_category.EDWCreatedAt', 'DWHCreatedAt', 'COLUMN';
EXEC sp_rename 'edw.dim_payroll_category.EDWDMLOperation', 'DWHDMLOperation', 'COLUMN';
EXEC sp_rename 'edw.dim_payroll_category.EDWModifiedOn', 'DWHModifiedOn', 'COLUMN';
EXEC sp_rename 'edw.dim_payroll_category.EDWSourceSystem', 'DWHSourceSystem', 'COLUMN';
EXEC sp_rename 'edw.dim_property_lease.EDWBatchId', 'DWHBatchId', 'COLUMN';
EXEC sp_rename 'edw.dim_property_lease.EDWDMLOperation', 'DWHDMLOperation', 'COLUMN';
EXEC sp_rename 'edw.dim_property_lease.EDWEffectiveFrom', 'DWHEffectiveFrom', 'COLUMN';
EXEC sp_rename 'edw.dim_property_lease.EDWEffectiveTo', 'DWHEffectiveTo', 'COLUMN';
EXEC sp_rename 'edw.dim_property_lease.EDWIsCurrent', 'DWHIsCurrent', 'COLUMN';
EXEC sp_rename 'edw.dim_property_lease.EDWSourceSystem', 'DWHSourceSystem', 'COLUMN';
EXEC sp_rename 'edw.dim_property_maintenace_type.EDWBatchId', 'DWHBatchId', 'COLUMN';
EXEC sp_rename 'edw.dim_property_maintenace_type.EDWDMLOperation', 'DWHDMLOperation', 'COLUMN';
EXEC sp_rename 'edw.dim_property_maintenace_type.EDWEffectiveFrom', 'DWHEffectiveFrom', 'COLUMN';
EXEC sp_rename 'edw.dim_property_maintenace_type.EDWEffectiveTo', 'DWHEffectiveTo', 'COLUMN';
EXEC sp_rename 'edw.dim_property_maintenace_type.EDWIsCurrent', 'DWHIsCurrent', 'COLUMN';
EXEC sp_rename 'edw.dim_property_maintenace_type.EDWSourceSystem', 'DWHSourceSystem', 'COLUMN';
EXEC sp_rename 'edw.dim_property_program.EDWBatchId', 'DWHBatchId', 'COLUMN';
EXEC sp_rename 'edw.dim_property_program.EDWDMLOperation', 'DWHDMLOperation', 'COLUMN';
EXEC sp_rename 'edw.dim_property_program.EDWEffectiveFrom', 'DWHEffectiveFrom', 'COLUMN';
EXEC sp_rename 'edw.dim_property_program.EDWEffectiveTo', 'DWHEffectiveTo', 'COLUMN';
EXEC sp_rename 'edw.dim_property_program.EDWIsCurrent', 'DWHIsCurrent', 'COLUMN';
EXEC sp_rename 'edw.dim_property_program.EDWSourceSystem', 'DWHSourceSystem', 'COLUMN';
EXEC sp_rename 'edw.fact_client_account_activity.EDWBatchId', 'DWHBatchId', 'COLUMN';
EXEC sp_rename 'edw.fact_client_account_activity.EDWDMLOperation', 'DWHDMLOperation', 'COLUMN';
EXEC sp_rename 'edw.fact_client_account_activity.EDWEffectiveFrom', 'DWHEffectiveFrom', 'COLUMN';
EXEC sp_rename 'edw.fact_client_account_activity.EDWEffectiveTo', 'DWHEffectiveTo', 'COLUMN';
EXEC sp_rename 'edw.fact_client_account_activity.EDWIsCurrent', 'DWHIsCurrent', 'COLUMN';
EXEC sp_rename 'edw.fact_client_account_activity.EDWSourceSystem', 'DWHSourceSystem', 'COLUMN';
EXEC sp_rename 'edw.fact_client_assessment_outcome.EDWBatchId', 'DWHBatchId', 'COLUMN';
EXEC sp_rename 'edw.fact_client_assessment_outcome.EDWDMLOperation', 'DWHDMLOperation', 'COLUMN';
EXEC sp_rename 'edw.fact_client_assessment_outcome.EDWEffectiveFrom', 'DWHEffectiveFrom', 'COLUMN';
EXEC sp_rename 'edw.fact_client_assessment_outcome.EDWEffectiveTo', 'DWHEffectiveTo', 'COLUMN';
EXEC sp_rename 'edw.fact_client_assessment_outcome.EDWIsCurrent', 'DWHIsCurrent', 'COLUMN';
EXEC sp_rename 'edw.fact_client_assessment_outcome.EDWSourceSystem', 'DWHSourceSystem', 'COLUMN';
EXEC sp_rename 'edw.fact_void_checklist.EDWBatchId', 'DWHBatchId', 'COLUMN';
EXEC sp_rename 'edw.fact_void_checklist.EDWDMLOperation', 'DWHDMLOperation', 'COLUMN';
EXEC sp_rename 'edw.fact_void_checklist.EDWEffectiveFrom', 'DWHEffectiveFrom', 'COLUMN';
EXEC sp_rename 'edw.fact_void_checklist.EDWEffectiveTo', 'DWHEffectiveTo', 'COLUMN';
EXEC sp_rename 'edw.fact_void_checklist.EDWIsCurrent', 'DWHIsCurrent', 'COLUMN';
EXEC sp_rename 'edw.fact_void_checklist.EDWSourceSystem', 'DWHSourceSystem', 'COLUMN';