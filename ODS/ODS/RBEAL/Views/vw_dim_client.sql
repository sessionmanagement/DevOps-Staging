create view [RBEAL].vw_dim_client as 
SELECT distinct dp.personid,(PersonFirstName + isnull(PersonMiddleNames,'')+isnull(PersonLastName,'')) As Client_Display_Name
,PersonPreferredName as Client_Preferred_Name,
PersonReferenceNumber as client_nhi_number ,
PersonDateOfBirth as client_date_of_birth,[PersonDeceasedDate] as client_date_of_death
,CONVERT(int,ROUND(DATEDIFF(hour,PersonDateOfBirth,GETDATE())/8766.0,0)) AS client_age_years
,COALESCE(de1.EthnicityText,de2.EthnicityText,de3.EthnicityText,de4.EthnicityText,'Not specified') AS client_ethnicity 
,COALESCE(dr.ResidencyText,'Not specified') clinet_residency
,COALESCE(dg.GenderText,'Not specified') client_gender ,
--fpc.PersonContactName,fpc.[PersonContactCreatedDate],
CASE WHEN fpc.PersonID is not null  then 1 else 0 end emergency_contact_missing_indicator,
fa.AddressName as client_postal_address_name,
AddressLine1 as client_postal_address_line1,
AddressLine2 as client_postal_address_line2,
AddressLine3 as client_postal_address_line3,
AddressSuburb as client_postal_address_suburb,
AddressTownCity as client_postal_address_town_or_city,
AddressPostCode as client_postal_address_postcode,
'need to decide logic' as Client_Postal_Address_Missing_Indicator ,
fe.EmailEmail as client_email,
fe.EmailIsPrimary as EmailIsPrimary ,
fp.PhonePhoneNumber as contact_number,
pht.PhoneNumberTypeText,
ss.SmokingStatusText as smoking_status


  FROM [RBEAL].[dlDimPerson] dp left outer join
	   [RBEAL].[dlDimEthnicity] de1 on dp.Ethnicity2ID=de1.EthnicityID left outer join
	   [RBEAL].[dlDimEthnicity] de2 on dp.Ethnicity2ID=de2.EthnicityID left outer join
	   [RBEAL].[dlDimEthnicity] de3 on dp.Ethnicity2ID=de3.EthnicityID left outer join
	   [RBEAL].[dlDimEthnicity] de4 on dp.Ethnicity2ID=de4.EthnicityID left outer join
	   [RBEAL].[dlDimEthnicity] de5 on dp.Ethnicity2ID=de5.EthnicityID 
	   Left Outer join RBEAL.dlDimResidency dr on dp.ResidencyID=dr.ResidencyID
	   left outer join RBEAL.dlDimGender dg on dp.GenderID=dg.GenderID
	   left outer join (  SELECT  [personid]
  FROM [RBEAL].[dlFactPersonContact]
  where PersonContactIsEmergencyContact=1 
  group by [personid] having count(*)>0) fpc on dp.PersonID=fpc.PersonID
		  left outer join  
   [RBEAL].vw_latest_address fa on dp.PersonID=fa.EntityID and fa.row_order=1
	left outer join [RBEAL].vw_latest_email  fe on dp.PersonID=fe.EntityID and fa.row_order=1
    left outer join [RBEAL].vw_latest_phone fp on dp.PersonID=fp.EntityID and fp.row_order=1
    left outer join RBEAL.dlDimPhoneNumberType pht on fp.PhoneNumberTypeID=pht.PhoneNumberTypeID
    left outer join [RBEAL].vw_latest_smokingstatus ss on dp.PersonID=ss.PersonID