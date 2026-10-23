



-- 1.4        2025-05-12      Manish Singh    Changed UTC date columns to NZT




/****** Object:  View [ETL].[dim_property_lease]    Script Date: 27/11/2023 12:09:02 pm ******/
/*
--Lease contract definition
select zav_leasecontractid, zav_leasecontractcode, zav_name, isdelete from detl.[Zavanti].detl.[vw_zav_leasecontract]

--lease contract details
zav_contractname 'COM (Commercial Lease)' is not in zav_leasecontract???
*/

CREATE   VIEW [ETL].[Testdim_property_lease]

AS

SELECT 
	--detl.[zav_leasedetailsid] AS property_lease_details_id -- this field may become NULL if the record is deleted, so cannot be used as the Business Key
	detl.id  AS property_lease_details_id
	,detl.[zav_name] AS property_lease_details_name
	,CAST(lt.LocalizedLabel AS VARCHAR(100)) AS property_lease_details_lease_type -- source ID not populated to can not tell if link is working
	,detl.[zav_leasetypecodename] AS property_lease_details_lease_type_code
	--,detl.[zav_leasetypecode] AS property_lease_details_lease_type_code
	,detl.[zav_contractname] AS property_lease_details_contract_name
	,cont.[zav_leasecontractcode] AS property_lease_details_lease_contract_code
	,CAST(detl.[zav_datelodged] AS DATE) AS property_lease_details_date_lodged
	,detl.[zav_term] AS property_lease_details_term --decimal years
	,CAST(ROUND((detl.[zav_term] * 365),0) AS INT) AS property_lease_details_term_days
	,CAST(detl.[zav_fromdate] AS DATE) AS property_lease_details_from_date
	,CAST(detl.[zav_todate] AS DATE) AS property_lease_details_to_date --sparse
	,detl.[zav_bondcomments] AS property_lease_details_bond_comments
	--,detl.[zav_bondtotal_date] AS property_lease_details_bond_total_date
	,CAST((detl.[zav_bondtotal_date] AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS property_lease_details_bond_total_date
	--,detl.[zav_bondtotal_state] AS property_lease_details_bond_total_state -- <<  looks like a yes/no toggle box, commented out as we dont know what this represents
	--detl.[zav_rightofrenewal]  AS property_lease_details_right_of_renewal 
	,CAST(ror.LocalizedLabel AS varchar(20)) AS property_lease_details_right_of_renewal_years -- << returns options 1/2/3/NA , in years?
	,CAST(detl.[zav_dateofnextrightofrenewal] AS DATE) AS property_lease_details_next_right_of_renewal_date
	,CAST(detl.[zav_nextrentleasereviewdate] AS DATE) AS property_lease_details_next_rent_lease_review_date
	,CAST(detl.[zav_expectedhandbackdate] AS DATE) AS property_lease_details_expected_hand_back_date
	--,detl.[zav_legalownerid] AS property_lease_details_legal_owner_id
	,CAST(detl.[zav_legalowneridname] as varchar(200)) AS property_lease_details_legal_owner_name
	,CAST(detl.[zav_cortsignatoryname] as varchar(100)) AS property_lease_details_cort_signatory_name
	--,CAST(ls.fullname  AS VARCHAR(100)) AS property_lease_details_cort_signatory_name
	,CAST(detl.[zav_propertyreferenceno]  as varchar(100)) AS property_lease_details_property_reference
	--,detl.[zav_property] AS property_lease_details_property_id
	,detl.[zav_propertyname] AS property_lease_details_property_name
	,CAST(detl.[zav_propertyownercontactname] as varchar(100)) AS property_lease_details_property_owner_contact
	,CAST(detl.[zav_rentleasepaymentreference] as varchar(100)) AS property_lease_details_rent_lease_payment_reference
	,detl.[zav_tenancyidname] AS property_lease_details_tenancy_name --null
	,CAST(detl.[zav_tenancyservicesreferencenumber] AS VARCHAR(20)) AS property_lease_details_tenancy_services_reference
	--detl.[zav_agreementtype] AS property_lease_details_agreement_type 
	,CAST([at].LocalizedLabel AS VARCHAR(20)) AS property_lease_details_agreement_type
	--detl.[zav_frequency] AS property_lease_details_frequency
	,CAST(lf.LocalizedLabel AS VARCHAR(20)) AS property_lease_details_frequency
	--,detl.[zav_isthelandlordchargeamountgstexclusive] AS property_lease_details_landlord_charge_amount_gst_exclusive_flag
	,CAST(gst.LocalizedLabel AS VARCHAR(20)) AS property_lease_details_landlord_charge_amount_gst_exclusive
	--,detl.[zav_rentleasepaymentday] AS property_lease_details_rent_lease_payment_day
	,CAST(pd.LocalizedLabel AS VARCHAR(20)) AS property_lease_details_rent_lease_payment_day
	,CAST(CAST(detl.[crba8_bankdepositconfirmationuploadedtosharepoint] AS BIT) AS INT) AS property_lease_details_crba8_bank_deposit_confirmation_in_sharepoint_flag
	,CAST(CAST(detl.[zav_landlordagreementloadedtosharepoint] AS BIT) AS INT) AS property_lease_details_landlord_agreement_in_sharepoint_flag
	,CAST(CAST(detl.[zav_periodic] AS BIT) AS INT) AS property_lease_details_periodic_flag
	--,detl.[owningteam] AS property_lease_details_owning_team
	,CAST(ot.name  AS VARCHAR(100)) AS property_lease_details_owning_team
	--,detl.[owninguser] AS property_lease_details_owning_user
	,CAST(ou.fullname AS VARCHAR(100)) AS property_lease_details_owning_user
	--,detl.[ownerid] AS property_lease_details_owner_id
	--,CAST(ldou.fullname AS VARCHAR(100)) AS property_lease_details_owner
	--,detl.[transactioncurrencyid] AS property_lease_details_transaction_currency_id
	,CAST(detl.transactioncurrencyidname AS VARCHAR(20)) AS property_lease_details_transaction_currency
	--,detl.[zav_cortsignatory] AS property_lease_details_cort_signatory_id
	--,detl.[zav_propertyownercontact] AS property_lease_details_property_owner_contact_id
	,CAST(detl.zav_propertyownercontactname  AS VARCHAR(100)) AS property_lease_details_property_owner_contact_name
	,detl.[crba8_landlordannualchargeamount] AS property_lease_details_crba8_landlord_annual_charge_amount
	,detl.[crba8_landlordannualchargeamount_base] AS property_lease_details_crba8_landlord_annual_charge_amount_base
	,detl.[new_landlordleasechargeamount] AS property_lease_details_new_landlord_lease_charge_amount
	,detl.[new_landlordleasechargeamount_base] AS property_lease_details_new_landlord_lease_charge_amount_base
	,detl.[zav_bondamount] AS property_lease_details_bond_amount
	,detl.[zav_bondamount_base] AS property_lease_details_bond_amount_base
	,detl.[zav_bondtotal] AS property_lease_details_bond_total
	,detl.[zav_bondtotal_base] AS property_lease_details_bond_total_base
	,detl.[zav_landlordmonthlychargeamount] AS property_lease_details_landlord_monthly_charge_amount
	,detl.[zav_landlordmonthlychargeamount_base] AS property_lease_details_landlord_monthly_charge_amount_base
	,CAST(detl.[crba8_bankautomaticpaymentnumber]  AS VARCHAR(20)) AS property_lease_details_crba8_bank_automatic_payment_number
	,CAST(detl.[crba8_rentreviewdatelast] AS DATE) AS property_lease_details_crba8_last_rent_review_date
	,detl.[zav_comments] AS property_lease_details_comments
	,CAST(CAST(detl.[IsDelete] AS BIT) AS INT) AS property_lease_details_deleted_flag
	--,GREATEST(detl.SinkModifiedOn,cont.SinkModifiedOn) AS synapse_link_sink_modified_on

	,CAST((GREATEST(detl.SinkModifiedOn,cont.SinkModifiedOn) AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS synapse_link_sink_modified_on
FROM [Zavanti].[vw_zav_leasedetails] AS detl
LEFT JOIN [Zavanti].[vw_zav_leasecontract] AS cont ON detl.[zav_contract] = cont.[zav_leasecontractid]
LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] lt ON detl.zav_leasetype = lt.[Option]
	AND lt.OptionSetName = 'zav_leasetype'
	AND lt.EntityName = 'zav_leasedetails'
LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] lf ON detl.[zav_frequency] = lf.[Option]
	AND lf.OptionSetName = 'zav_frequency'
	AND lf.EntityName = 'zav_leasedetails'
LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] gst ON detl.[zav_isthelandlordchargeamountgstexclusive] = gst.[Option]
	AND gst.OptionSetName = 'zav_isthelandlordchargeamountgstexclusive'
	AND gst.EntityName = 'zav_leasedetails'
LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] pd ON detl.[zav_rentleasepaymentday] = pd.[Option]
	AND pd.OptionSetName = 'zav_rentleasepaymentday'
	AND pd.EntityName = 'zav_leasedetails'
LEFT JOIN [Zavanti].[vw_OptionsetMetadata] AS [at] ON detl.[zav_agreementtype] = [at].[Option]
	AND [at].OptionSetName = 'zav_agreementtype'
	AND [at].EntityName = 'zav_leasedetails'
LEFT JOIN [Zavanti].[vw_OptionsetMetadata] AS ror ON detl.[zav_rightofrenewal] = [ror].[Option]
	AND ror.OptionSetName = 'zav_rightofrenewal'
	AND ror.EntityName = 'zav_leasedetails'
LEFT JOIN [Zavanti].[vw_team] ot ON detl.[owningteam] = ot.id
LEFT JOIN [Zavanti].[vw_systemuser] ou ON detl.[owninguser] = ou.id