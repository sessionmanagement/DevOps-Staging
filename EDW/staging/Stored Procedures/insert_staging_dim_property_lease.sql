
CREATE PROC [staging].[insert_staging_dim_property_lease]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_property_lease]
PURPOSE:    
NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2023-12-13    Glenn McLeod		Initial version
1.2	     2025-12-09    Greg Nuthall	    Added property_id, lease status and lease state
1.3      2026-02-20    GitHub Copilot    Removed redundant columns per work item 12210
****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_property_lease]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_property_lease] (
	 [dim_property_key]
	,[property_lease_details_id] 
	,[property_id]
	,[property_lease_status]
	,[property_lease_state] 
	,[property_lease_details_name] 
	,[property_lease_details_lease_type_code] 
	,[property_lease_details_contract_name] 
	,[property_lease_details_lease_contract_code] 
	,[property_lease_details_date_lodged] 
	,[property_lease_details_term] 
	,[property_lease_details_term_days] 
	,[property_lease_details_from_date] 
	,[property_lease_details_to_date] 
	,[property_lease_details_bond_comments] 
	,[property_lease_details_bond_total_date] 
	,[property_lease_details_right_of_renewal_years] 
	,[property_lease_details_next_right_of_renewal_date] 
	,[property_lease_details_next_rent_lease_review_date] 
	,[property_lease_details_expected_hand_back_date] 
	,[property_lease_details_legal_owner_name] 
	,[property_lease_details_CORT_signatory_name] 
	,[property_lease_details_property_reference] 
	,[property_lease_details_property_name] 
	,[property_lease_details_property_owner_contact] 
	,[property_lease_details_rent_lease_payment_reference] 
	,[property_lease_details_tenancy_services_reference] 
	,[property_lease_details_agreement_type] 
	,[property_lease_details_frequency] 
	,[property_lease_details_landlord_charge_amount_gst_exclusive] 
	,[property_lease_details_rent_lease_payment_day] 
	,[property_lease_details_crba8_bank_deposit_confirmation_in_sharepoint_flag] 
	,[property_lease_details_landlord_agreement_in_sharepoint_flag] 
	,[property_lease_details_owning_user] 
	,[property_lease_details_property_owner_contact_name] 
	,[property_lease_details_crba8_landlord_annual_charge_amount] 
	,[property_lease_details_new_landlord_lease_charge_amount] 
	,[property_lease_details_bond_amount] 
	,[property_lease_details_bond_total] 
	,[property_lease_details_landlord_monthly_charge_amount] 
	,[property_lease_details_crba8_bank_automatic_payment_number] 
	,[property_lease_details_crba8_last_rent_review_date] 
	,[property_lease_details_deleted_flag] 
	,[synapse_link_sink_modified_on] 
	)
SELECT
	 case when isnull(l.[property_id],'') = '' then 0
		  when isnull([dim_property_key],0) = 0 then -1
		  else [dim_property_key] end as [dim_property_key]
	,l.[property_lease_details_id] 
	,l.[property_id]
	,l.[property_lease_status]
	,l.[property_lease_state] 
	,l.[property_lease_details_name] 
	,l.[property_lease_details_lease_type_code] 
	,l.[property_lease_details_contract_name] 
	,l.[property_lease_details_lease_contract_code] 
	,l.[property_lease_details_date_lodged] 
	,l.[property_lease_details_term] 
	,l.[property_lease_details_term_days] 
	,l.[property_lease_details_from_date] 
	,l.[property_lease_details_to_date] 
	,l.[property_lease_details_bond_comments] 
	,l.[property_lease_details_bond_total_date] 
	,l.[property_lease_details_right_of_renewal_years] 
	,l.[property_lease_details_next_right_of_renewal_date] 
	,l.[property_lease_details_next_rent_lease_review_date] 
	,l.[property_lease_details_expected_hand_back_date] 
	,l.[property_lease_details_legal_owner_name] 
	,l.[property_lease_details_CORT_signatory_name] 
	,l.[property_lease_details_property_reference] 
	,l.[property_lease_details_property_name] 
	,l.[property_lease_details_property_owner_contact] 
	,l.[property_lease_details_rent_lease_payment_reference] 
	,l.[property_lease_details_tenancy_services_reference] 
	,l.[property_lease_details_agreement_type] 
	,l.[property_lease_details_frequency] 
	,l.[property_lease_details_landlord_charge_amount_gst_exclusive] 
	,l.[property_lease_details_rent_lease_payment_day] 
	,l.[property_lease_details_crba8_bank_deposit_confirmation_in_sharepoint_flag] 
	,l.[property_lease_details_landlord_agreement_in_sharepoint_flag] 
	,l.[property_lease_details_owning_user] 
	,l.[property_lease_details_property_owner_contact_name] 
	,l.[property_lease_details_crba8_landlord_annual_charge_amount] 
	,l.[property_lease_details_new_landlord_lease_charge_amount] 
	,l.[property_lease_details_bond_amount] 
	,l.[property_lease_details_bond_total] 
	,l.[property_lease_details_landlord_monthly_charge_amount] 
	,l.[property_lease_details_crba8_bank_automatic_payment_number] 
	,l.[property_lease_details_crba8_last_rent_review_date] 
	,l.[property_lease_details_deleted_flag] 
	,l.[synapse_link_sink_modified_on] 
from [Landing].[edw_dim_property_lease] l
left outer join edw.dim_property p on l.property_id = p.property_id and p.DWHISCurrent = 1