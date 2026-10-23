CREATE   view [ETL].[dim_client]

as

/**********************************************************************************************************
 View		[ETL].[dim_client]
 Author		Shashi Sharma
 Created	2023/03/04	
 Purpose	Used to build the edw.dim_client table 

 **************************************************************************************************************
--REVISIONS:
--Version	 Date			Author			Description
---------	 ------------	---------------	--------------------------
--1.0		 2023/06/23		Shashi Sharma	Initial version
--1.1		 2024/07/09		Greg Nuthall    Found rbeal in smoking link which should be rbmnb
--1.2		 2024/07/22		Greg Nuthall    8286 PrimhdServiceReviewReviewDate max moved inside case statement to correct overdue flags
--2.0		 2024-11-11		Greg Nuthall    Rewrite the ethnicity part for new structure
--2.1		 2025-03-17		Greg Nuthall	Fixed the bug in the CTE for missing GP registrations
--2.2		 2025-03-21	    Greg Nuthall	Fixed the address primary flag and which address is shown
--2.3        2026-01-15     Greg Nuthall	Changed to NZ date for age calculation

**************************************************************************************************************/


	with cte_dimclient_RBEAL(client_id, client_display_name, client_first_name,client_middle_name,client_last_name,client_preferred_name,client_nhi_number,client_created_date,client_date_of_birth,client_date_of_death,client_age_years,client_gender,client_residency,client_ethnicity1,client_ethnicity2,client_ethnicity3)
	as (select 
		dp.personid 
		,replace(rtrim(coalesce(dp.personfirstname + ' ','') + coalesce(dp.personmiddlenames + ' ','')+ coalesce(dp.personlastname + ' ','')), space(2),space(1))
		,dp.personfirstname
		,dp.personmiddlenames
		,dp.personlastname
		,dp.personpreferredname
		,dp.personreferencenumber
		,dp.PersonCreatedDate
		,dp.persondateofbirth
		,isnull(dp.PersonDeceasedDate,'1900-01-01')
		,CASE WHEN dp.PersonDeceasedDate is null
		then floor(datediff(Day,dp.persondateofbirth,CONVERT(datetime, SWITCHOFFSET(getdate(), DATEPART(TZOFFSET,
				Getdate() AT TIME ZONE 'New Zealand Standard Time'))))/365.25)
		else floor(datediff(Day,dp.persondateofbirth,dp.PersonDeceasedDate)/365.25)
		END
		
		,dp.genderid
		,dp.residencyid
		,coalesce (dp.Ethnicity1ID,dp.Ethnicity2ID,dp.Ethnicity3ID,dp.Ethnicity4ID,dp.Ethnicity5ID)
		,coalesce (dp.Ethnicity2ID,dp.Ethnicity3ID,dp.Ethnicity4ID,dp.Ethnicity5ID)
		,coalesce (dp.Ethnicity3ID,dp.Ethnicity4ID,dp.Ethnicity5ID)
	from rbeal.dldimperson dp),


	--CTE_CFDI_RBEAL(PersonID,GPOnly,GPRegistration,LookupID)
	--as
	--(Select CFDI.EntityId
	--,MAX(LookupId)
	--,MAX(CASE when CFDI.CustomFieldId = 3 then LookupId end) 
	--,MAX(CASE when CFDI.CustomFieldId = 4 then LookupId end) 
	--from rbeal.dlFactCustomFieldDataItem CFDI
	--group by 
	--	CFDI.EntityId
	--),

	--Changed becasue the above code had the wrong fields sequence (Lookup is at the end not the second field) 
	--added link to the custom name to clarify data source
	CTE_GPRegistration_RBEAL(PersonID,GPOnly,GPOnlyValue,GPRegistration,GPRegistrationValue)
	as
	(SELECT
         CFDI.EntityId AS PersonID
       , MAX(CASE WHEN DCF.CustomFieldName = 'GPOnly' THEN CFDI.LookupId END) AS GPOnly
       , MAX(CASE WHEN DCF.CustomFieldName = 'GPOnly' THEN LK.LookupValue END) AS GPOnlyValue
       , MAX(CASE WHEN DCF.CustomFieldName = 'GPRegistration' THEN CFDI.LookupId END) AS GPRegistration
       , MAX(CASE WHEN DCF.CustomFieldName = 'GPRegistration' THEN LK.LookupValue END) AS GPRegistrationValue
    FROM rbeal.dlFactCustomFieldDataItem CFDI
    INNER JOIN rbeal.dlDimCustomField DCF
            ON CFDI.CustomFieldId = DCF.CustomFieldId
    LEFT JOIN rbeal.dlDimLookup LK
           ON CFDI.LookupId = LK.LookupId
    WHERE DCF.CustomFieldName IN ('GPOnly','GPRegistration')
    GROUP BY CFDI.EntityId
	),

	


	CTE_PHC_RBEAL(PersonID,MentalHealthConditionCount,PhysicalHealthConditionCount,SubstanceCount)
	as
	(SELECT PersonId
	,Count(case when PersonHealthConditionHealthConditionType = 'MentalHealthCondition' then HealthConditionTypeId end) as MentalHealthConditionCount
	,Count(case when PersonHealthConditionHealthConditionType = 'PhysicalHealthCondition' then HealthConditionTypeId end) as PhysicalHealthConditionCount
	,Count(case when PersonHealthConditionHealthConditionType = 'Substance' then HealthConditionTypeId end) as SubstanceCount
	FROM RBEAL.dlFactPersonHealthCondition
	Group by PersonId)

	,person_iwi_eal as (

	select dp.personid ,
		case when e1.EthnicityParentId = 11183 then e1.EthnicityText when e1.EthnicityText = 'Maori' then 'Not Stated' else null end as EthnicityIwi1
		,case when e2.EthnicityParentId = 11183 then e2.EthnicityText when e2.EthnicityText = 'Maori' then 'Not Stated' else null end as EthnicityIwi2
		,case when e3.EthnicityParentId = 11183 then e3.EthnicityText when e3.EthnicityText = 'Maori' then 'Not Stated' else null end as EthnicityIwi3
		,case when e4.EthnicityParentId = 11183 then e4.EthnicityText when e4.EthnicityText = 'Maori' then 'Not Stated' else null end as EthnicityIwi4
		,case when e5.EthnicityParentId = 11183 then e5.EthnicityText when e5.EthnicityText = 'Maori' then 'Not Stated' else null end as EthnicityIwi5
	
		 ,format(case when e1.EthnicityParentId = 11183 or e1.EthnicityText = 'Maori' then 10000 else 0 end
		 +	case when e2.EthnicityParentId = 11183 or e2.EthnicityText = 'Maori'  then 1000 else 0 end
		 +	case when e3.EthnicityParentId = 11183 or e3.EthnicityText = 'Maori'  then 100 else 0 end
		 +	case when e4.EthnicityParentId = 11183 or e4.EthnicityText = 'Maori'  then 10 else 0 end
		 +	case when e5.EthnicityParentId = 11183 or e5.EthnicityText = 'Maori'  then 1 else 0 end, '00000') as IwiCounter

	from rbeal.dldimperson dp
		left outer join rbeal.dlDimEthnicity e1 on dp.Ethnicity1ID = e1.EthnicityID 
		left outer join rbeal.dlDimEthnicity e2 on dp.Ethnicity2ID = e2.EthnicityID 
		left outer join rbeal.dlDimEthnicity e3 on dp.Ethnicity3ID = e3.EthnicityID 
		left outer join rbeal.dlDimEthnicity e4 on dp.Ethnicity4ID = e4.EthnicityID 
		left outer join rbeal.dlDimEthnicity e5 on dp.Ethnicity5ID = e5.EthnicityID)

	,person_ethnicity_eal as (

	select dp.personid ,
		case when e1.EthnicityParentId = 11183 then 'Maori' else e1.EthnicityText end as Ethnicity1
		,case when e2.EthnicityParentId = 11183 then 'Maori' else e2.EthnicityText end as Ethnicity2
		,case when e3.EthnicityParentId = 11183 then 'Maori' else e3.EthnicityText end as Ethnicity3
		,case when e4.EthnicityParentId = 11183 then 'Maori' else e4.EthnicityText end as Ethnicity4
		,case when e5.EthnicityParentId = 11183 then 'Maori' else e5.EthnicityText end as Ethnicity5

		,format(case when isnull(case when e1.EthnicityParentId = 11183 then 'Maori' else e1.EthnicityText end,'') <> '' then 10000 else 0 end
		 +	case when isnull(case when e2.EthnicityParentId = 11183 then 'Maori' else e2.EthnicityText end,'') <> '' then 1000 else 0 end
		 +	case when isnull(case when e3.EthnicityParentId = 11183 then 'Maori' else e3.EthnicityText end,'') <> '' then 100 else 0 end
		 +	case when isnull(case when e4.EthnicityParentId = 11183 then 'Maori' else e4.EthnicityText end,'') <> '' then 10 else 0 end
		 +	case when isnull(case when e5.EthnicityParentId = 11183 then 'Maori' else e5.EthnicityText end,'') <> '' then 1 else 0 end, '00000') as EthnicityCounter

	from rbeal.dldimperson dp
		left outer join rbeal.dlDimEthnicity e1 on dp.Ethnicity1ID = e1.EthnicityID 
		left outer join rbeal.dlDimEthnicity e2 on dp.Ethnicity2ID = e2.EthnicityID 
		left outer join rbeal.dlDimEthnicity e3 on dp.Ethnicity3ID = e3.EthnicityID 
		left outer join rbeal.dlDimEthnicity e4 on dp.Ethnicity4ID = e4.EthnicityID 
		left outer join rbeal.dlDimEthnicity e5 on dp.Ethnicity5ID = e5.EthnicityID)


	,cte_dimclient_RBMNB(client_id, client_display_name, client_first_name,client_middle_name,client_last_name,client_preferred_name,client_nhi_number,client_created_date,client_date_of_birth,client_date_of_death,client_age_years,client_gender,client_residency,client_ethnicity1,client_ethnicity2,client_ethnicity3)
	as (select 
		dp.personid 
		,replace(rtrim(coalesce(dp.personfirstname + ' ','') + coalesce(dp.personmiddlenames + ' ','')+ coalesce(dp.personlastname + ' ','')), space(2),space(1))
		,dp.personfirstname
		,dp.personmiddlenames
		,dp.personlastname
		,dp.personpreferredname
		,dp.personreferencenumber
		,dp.PersonCreatedDate
		,dp.persondateofbirth
		,isnull(dp.PersonDeceasedDate,'2999-12-31')
		,CASE WHEN dp.PersonDeceasedDate is null
		then floor(datediff(Day,dp.persondateofbirth,CONVERT(datetime, SWITCHOFFSET(getdate(), DATEPART(TZOFFSET,
				Getdate() AT TIME ZONE 'New Zealand Standard Time'))))/365.25)
		else floor(datediff(Day,dp.persondateofbirth,dp.PersonDeceasedDate)/365.25)
		END
		,dp.genderid
		,dp.residencyid
		,coalesce (dp.Ethnicity1ID,dp.Ethnicity2ID,dp.Ethnicity3ID,dp.Ethnicity4ID,dp.Ethnicity5ID)
		,coalesce (dp.Ethnicity2ID,dp.Ethnicity3ID,dp.Ethnicity4ID,dp.Ethnicity5ID)
		,coalesce (dp.Ethnicity3ID,dp.Ethnicity4ID,dp.Ethnicity5ID)
	from rbmnb.dldimperson dp),


	--CTE_CFDI_RBMNB(PersonID,GPOnly,GPRegistration,LookupID)
	--as
	--(Select CFDI.EntityId
	--,MAX(LookupId)
	--,MAX(CASE when CFDI.CustomFieldId = 3 then LookupId end) 
	--,MAX(CASE when CFDI.CustomFieldId = 4 then LookupId end) 
	--from rbmnb.dlFactCustomFieldDataItem CFDI
	--group by 
	--	CFDI.EntityId
	--),

	--Changed becasue the above code had the wrong fields sequence (Lookup is at the end not the second field) 
	--added link to the custom name to clarify data source
	CTE_GPRegistration_rbmnb2(PersonID,GPOnly,GPOnlyValue,GPRegistration,GPRegistrationValue)
	as
	(SELECT
         CFDI.EntityId AS PersonID
       , MAX(CASE WHEN DCF.CustomFieldName = 'GPOnly' THEN CFDI.LookupId END) AS GPOnly
       , MAX(CASE WHEN DCF.CustomFieldName = 'GPOnly' THEN LK.LookupValue END) AS GPOnlyValue
       , MAX(CASE WHEN DCF.CustomFieldName = 'GPRegistration' THEN CFDI.LookupId END) AS GPRegistration
       , MAX(CASE WHEN DCF.CustomFieldName = 'GPRegistration' THEN LK.LookupValue END) AS GPRegistrationValue
    FROM rbmnb.dlFactCustomFieldDataItem CFDI
    INNER JOIN rbmnb.dlDimCustomField DCF
            ON CFDI.CustomFieldId = DCF.CustomFieldId
    LEFT JOIN rbmnb.dlDimLookup LK
           ON CFDI.LookupId = LK.LookupId
    WHERE DCF.CustomFieldName IN ('GPOnly','GPRegistration')
    GROUP BY CFDI.EntityId
	),

	CTE_PHC_RBMNB(PersonID,MentalHealthConditionCount,PhysicalHealthConditionCount,SubstanceCount)
	as
	(SELECT PersonId
	,Count(case when PersonHealthConditionHealthConditionType = 'MentalHealthCondition' then HealthConditionTypeId end) as MentalHealthConditionCount
	,Count(case when PersonHealthConditionHealthConditionType = 'PhysicalHealthCondition' then HealthConditionTypeId end) as PhysicalHealthConditionCount
	,Count(case when PersonHealthConditionHealthConditionType = 'Substance' then HealthConditionTypeId end) as SubstanceCount
	FROM rbmnb.dlFactPersonHealthCondition
	Group by PersonId)

	,person_iwi_mnb as (

	select dp.personid ,
		case when e1.EthnicityParentId = 11183 then e1.EthnicityText when e1.EthnicityText = 'Maori' then 'Not Stated' else null end as EthnicityIwi1
		,case when e2.EthnicityParentId = 11183 then e2.EthnicityText when e2.EthnicityText = 'Maori' then 'Not Stated' else null end as EthnicityIwi2
		,case when e3.EthnicityParentId = 11183 then e3.EthnicityText when e3.EthnicityText = 'Maori' then 'Not Stated' else null end as EthnicityIwi3
		,case when e4.EthnicityParentId = 11183 then e4.EthnicityText when e4.EthnicityText = 'Maori' then 'Not Stated' else null end as EthnicityIwi4
		,case when e5.EthnicityParentId = 11183 then e5.EthnicityText when e5.EthnicityText = 'Maori' then 'Not Stated' else null end as EthnicityIwi5
	
		 ,format(case when e1.EthnicityParentId = 11183 or e1.EthnicityText = 'Maori' then 10000 else 0 end
		 +	case when e2.EthnicityParentId = 11183 or e2.EthnicityText = 'Maori'  then 1000 else 0 end
		 +	case when e3.EthnicityParentId = 11183 or e3.EthnicityText = 'Maori'  then 100 else 0 end
		 +	case when e4.EthnicityParentId = 11183 or e4.EthnicityText = 'Maori'  then 10 else 0 end
		 +	case when e5.EthnicityParentId = 11183 or e5.EthnicityText = 'Maori'  then 1 else 0 end, '00000') as IwiCounter

	from rbmnb.dldimperson dp
		left outer join rbmnb.dlDimEthnicity e1 on dp.Ethnicity1ID = e1.EthnicityID 
		left outer join rbmnb.dlDimEthnicity e2 on dp.Ethnicity2ID = e2.EthnicityID 
		left outer join rbmnb.dlDimEthnicity e3 on dp.Ethnicity3ID = e3.EthnicityID 
		left outer join rbmnb.dlDimEthnicity e4 on dp.Ethnicity4ID = e4.EthnicityID 
		left outer join rbmnb.dlDimEthnicity e5 on dp.Ethnicity5ID = e5.EthnicityID)

	,person_ethnicity_mnb as (

	select dp.personid ,
		case when e1.EthnicityParentId = 11183 then 'Maori' else e1.EthnicityText end as Ethnicity1
		,case when e2.EthnicityParentId = 11183 then 'Maori' else e2.EthnicityText end as Ethnicity2
		,case when e3.EthnicityParentId = 11183 then 'Maori' else e3.EthnicityText end as Ethnicity3
		,case when e4.EthnicityParentId = 11183 then 'Maori' else e4.EthnicityText end as Ethnicity4
		,case when e5.EthnicityParentId = 11183 then 'Maori' else e5.EthnicityText end as Ethnicity5

		,format(case when isnull(case when e1.EthnicityParentId = 11183 then 'Maori' else e1.EthnicityText end,'') <> '' then 10000 else 0 end
		 +	case when isnull(case when e2.EthnicityParentId = 11183 then 'Maori' else e2.EthnicityText end,'') <> '' then 1000 else 0 end
		 +	case when isnull(case when e3.EthnicityParentId = 11183 then 'Maori' else e3.EthnicityText end,'') <> '' then 100 else 0 end
		 +	case when isnull(case when e4.EthnicityParentId = 11183 then 'Maori' else e4.EthnicityText end,'') <> '' then 10 else 0 end
		 +	case when isnull(case when e5.EthnicityParentId = 11183 then 'Maori' else e5.EthnicityText end,'') <> '' then 1 else 0 end, '00000') as EthnicityCounter

	from rbmnb.dldimperson dp
		left outer join rbmnb.dlDimEthnicity e1 on dp.Ethnicity1ID = e1.EthnicityID 
		left outer join rbmnb.dlDimEthnicity e2 on dp.Ethnicity2ID = e2.EthnicityID 
		left outer join rbmnb.dlDimEthnicity e3 on dp.Ethnicity3ID = e3.EthnicityID 
		left outer join rbmnb.dlDimEthnicity e4 on dp.Ethnicity4ID = e4.EthnicityID 
		left outer join rbmnb.dlDimEthnicity e5 on dp.Ethnicity5ID = e5.EthnicityID)

		
,CTE_Dimethnicity_RBEAL (ethnicity_id,ethnicity_value,ethnicity_text,Region,Iwi,Waka_IwiUnknown,ethnicity_group,ethnicity_group_priority,ethnicity_is_active,ethnicityparent)
as ( 
select  e.[EthnicityID]
,e.[EthnicityValue]
,e.[EthnicityText]
,Case when left(e.[EthnicityValue],2) = 01 and e.[EthnicityParentId] = 11183 then 'Te Tai Tokerau/Tāmaki-makaurau (Northland/Auckland)'
	  when left(e.[EthnicityValue],2) = 02 and e.[EthnicityParentId] = 11183 then 'Hauraki (Coromandel)'
	  when left(e.[EthnicityValue],2) = 03 and e.[EthnicityParentId] = 11183 then 'Waikato/Te Rohe Pōtae (Waikato/King Country)'
	  when left(e.[EthnicityValue],2) = 04 and e.[EthnicityParentId] = 11183 then 'Te Arawa/Taupō (Rotorua/Taupō) '
	  when left(e.[EthnicityValue],2) = 05 and e.[EthnicityParentId] = 11183 then 'Tauranga Moana/Mātaatua (Bay of Plenty)'
	  when left(e.[EthnicityValue],2) = 06 and e.[EthnicityParentId] = 11183 then 'Te Tai Rāwhiti (East Coast)'
	  when left(e.[EthnicityValue],2) = 07 and e.[EthnicityParentId] = 11183 then 'Te Matau-a-Māui/Wairarapa (Hawke''s Bay/Wairarapa) '
	  when left(e.[EthnicityValue],2) = 08 and e.[EthnicityParentId] = 11183 then 'Taranaki'
	  when left(e.[EthnicityValue],2) = 09 and e.[EthnicityParentId] = 11183 then 'Whanganui/Rangitīkei (Wanganui/Rangitīkei)'
	  when left(e.[EthnicityValue],2) = 10 and e.[EthnicityParentId] = 11183 then 'Manawatū/Horowhenua/Te Whanganui-a-Tara (Manawatū/Horowhenua/Wellington)'						  
	  when left(e.[EthnicityValue],2) = 11 and e.[EthnicityParentId] = 11183 then 'Te Waipounamu (South Island)'
	  when left(e.[EthnicityValue],2) = 21 and e.[EthnicityParentId] = 11183 then 'Iwi named, region not known'
	  when left(e.[EthnicityValue],2) = 22 and e.[EthnicityParentId] = 11183 then 'Hapū affiliated to more than one iwi'
	  when left(e.[EthnicityValue],2) = 23 and e.[EthnicityParentId] = 11183 then 'Region known, Iwi not named'
	  else null END as Region
	  ,Case when right(e.[EthnicityValue],2) != 00 and e.[EthnicityParentId] = 11183 and left(e.[EthnicityValue],2) != 20  then e.EthnicityText
	 else null end as Iwi
	 ,Case when left(e.[EthnicityValue],2) = 20 and e.[EthnicityParentId] = 11183 then e.EthnicityText
	 else null end as Waka_IwiUnknown
,CASE when LEFT(e.EthnicityValue,1)=2 or e.EthnicityParentId = 11183 then 'Maori'
	 when LEFT(e.EthnicityValue,1)=1 or e.EthnicityID in (12314,12315,12316,12318,12319,12320,12326,12327,12324) then 'European'
	 when LEFT(e.EthnicityValue,1)=3 then 'Pasifika'
	 when LEFT(e.EthnicityValue,1)=4 or e.EthnicityID in (12317,12322,12325,12328,12330,12321,12323,12329) then 'Asian'
	 when EthnicityID= 11195 then 'Other Ethnicity'
	 when LEFT(e.EthnicityValue,1)=5 and e.EthnicityValue != '54' then 'Middle Eastern/Latin American/African'
	 
	 when LEFT(e.EthnicityValue,1)=9 then 'Residual Categories'
	 Else 'Unidentified'
END as EthinicityGroup
,CASE when e.EthnicityParentId = 11183 or LEFT(e.EthnicityValue,2)=21 then 1
	 when LEFT(e.EthnicityValue,2)=10 then 21
	 when LEFT(e.EthnicityValue,2)=11 then 22
	 when LEFT(e.EthnicityValue,2)=12 or e.EthnicityID in (12314,12315,12316,12318,12319,12320,12326,12327,12324) then 20
	 when LEFT(e.EthnicityValue,2)=30 then 9
	 when LEFT(e.EthnicityValue,2)=31 then 7
	 when LEFT(e.EthnicityValue,2)=32 then 6
	 when LEFT(e.EthnicityValue,2)=33 then 5
	 when LEFT(e.EthnicityValue,2)=34 then 4
	 when LEFT(e.EthnicityValue,2)=35 then 2
	 when LEFT(e.EthnicityValue,2)=36 then 3
	 when LEFT(e.EthnicityValue,2)=37 then 8
	 when LEFT(e.EthnicityValue,2)=40 then 14
	 when LEFT(e.EthnicityValue,2)=41 or e.EthnicityID in (12317,12322,12325,12328,12330) then 10
	 when LEFT(e.EthnicityValue,2)=42 then 12
	 when LEFT(e.EthnicityValue,2)=43 then 11
	 when LEFT(e.EthnicityValue,2)=44 or e.EthnicityID in (12321,12323,12329) then 13
	 when LEFT(e.EthnicityValue,2)=51 then 17
	 when LEFT(e.EthnicityValue,2)=52 then 15
	 when LEFT(e.EthnicityValue,2)=53 then 16
	 when LEFT(e.EthnicityValue,2)=54 then 18
	 when LEFT(e.EthnicityValue,2)=95 then 95
	 when LEFT(e.EthnicityValue,2)=97 then 97
	 when LEFT(e.EthnicityValue,2)=99 then 99
	 Else 'Unidentified'
END as EthinicityGroupPriority
,e.[EthnicityIsActive]
,e.EthnicityParentId
FROM RBEAL.dlDimEthnicity e
where isnumeric(e.EthnicityValue)=1
)



	
,CTE_Dimethnicity_rbmnb (ethnicity_id,ethnicity_value,ethnicity_text,Region,Iwi,Waka_IwiUnknown,ethnicity_group,ethnicity_group_priority,ethnicity_is_active,ethnicityparent)
as ( 
select  e.[EthnicityID]
,e.[EthnicityValue]
,e.[EthnicityText]
,Case when left(e.[EthnicityValue],2) = 01 and e.[EthnicityParentId] = 11183 then 'Te Tai Tokerau/Tāmaki-makaurau (Northland/Auckland)'
	  when left(e.[EthnicityValue],2) = 02 and e.[EthnicityParentId] = 11183 then 'Hauraki (Coromandel)'
	  when left(e.[EthnicityValue],2) = 03 and e.[EthnicityParentId] = 11183 then 'Waikato/Te Rohe Pōtae (Waikato/King Country)'
	  when left(e.[EthnicityValue],2) = 04 and e.[EthnicityParentId] = 11183 then 'Te Arawa/Taupō (Rotorua/Taupō) '
	  when left(e.[EthnicityValue],2) = 05 and e.[EthnicityParentId] = 11183 then 'Tauranga Moana/Mātaatua (Bay of Plenty)'
	  when left(e.[EthnicityValue],2) = 06 and e.[EthnicityParentId] = 11183 then 'Te Tai Rāwhiti (East Coast)'
	  when left(e.[EthnicityValue],2) = 07 and e.[EthnicityParentId] = 11183 then 'Te Matau-a-Māui/Wairarapa (Hawke''s Bay/Wairarapa) '
	  when left(e.[EthnicityValue],2) = 08 and e.[EthnicityParentId] = 11183 then 'Taranaki'
	  when left(e.[EthnicityValue],2) = 09 and e.[EthnicityParentId] = 11183 then 'Whanganui/Rangitīkei (Wanganui/Rangitīkei)'
	  when left(e.[EthnicityValue],2) = 10 and e.[EthnicityParentId] = 11183 then 'Manawatū/Horowhenua/Te Whanganui-a-Tara (Manawatū/Horowhenua/Wellington)'						  
	  when left(e.[EthnicityValue],2) = 11 and e.[EthnicityParentId] = 11183 then 'Te Waipounamu (South Island)'
	  when left(e.[EthnicityValue],2) = 21 and e.[EthnicityParentId] = 11183 then 'Iwi named, region not known'
	  when left(e.[EthnicityValue],2) = 22 and e.[EthnicityParentId] = 11183 then 'Hapū affiliated to more than one iwi'
	  when left(e.[EthnicityValue],2) = 23 and e.[EthnicityParentId] = 11183 then 'Region known, Iwi not named'
	  else null END as Region
	  ,Case when right(e.[EthnicityValue],2) != 00 and e.[EthnicityParentId] = 11183 and left(e.[EthnicityValue],2) != 20  then e.EthnicityText
	 else null end as Iwi
	 ,Case when left(e.[EthnicityValue],2) = 20 and e.[EthnicityParentId] = 11183 then e.EthnicityText
	 else null end as Waka_IwiUnknown
,CASE when LEFT(e.EthnicityValue,1)=2 or e.EthnicityParentId = 11183 then 'Maori'
	 when LEFT(e.EthnicityValue,1)=1 or e.EthnicityID in (12314,12315,12316,12318,12319,12320,12326,12327,12324) then 'European'
	 when LEFT(e.EthnicityValue,1)=3 then 'Pasifika'
	 when LEFT(e.EthnicityValue,1)=4 or e.EthnicityID in (12317,12322,12325,12328,12330,12321,12323,12329) then 'Asian'
	 when EthnicityID= 11195 then 'Other Ethnicity'
	 when LEFT(e.EthnicityValue,1)=5 and e.EthnicityValue != '54' then 'Middle Eastern/Latin American/African'
	 
	 when LEFT(e.EthnicityValue,1)=9 then 'Residual Categories'
	 Else 'Unidentified'
END as EthinicityGroup
,CASE when e.EthnicityParentId = 11183 or LEFT(e.EthnicityValue,2)=21 then 1
	 when LEFT(e.EthnicityValue,2)=10 then 21
	 when LEFT(e.EthnicityValue,2)=11 then 22
	 when LEFT(e.EthnicityValue,2)=12 or e.EthnicityID in (12314,12315,12316,12318,12319,12320,12326,12327,12324) then 20
	 when LEFT(e.EthnicityValue,2)=30 then 9
	 when LEFT(e.EthnicityValue,2)=31 then 7
	 when LEFT(e.EthnicityValue,2)=32 then 6
	 when LEFT(e.EthnicityValue,2)=33 then 5
	 when LEFT(e.EthnicityValue,2)=34 then 4
	 when LEFT(e.EthnicityValue,2)=35 then 2
	 when LEFT(e.EthnicityValue,2)=36 then 3
	 when LEFT(e.EthnicityValue,2)=37 then 8
	 when LEFT(e.EthnicityValue,2)=40 then 14
	 when LEFT(e.EthnicityValue,2)=41 or e.EthnicityID in (12317,12322,12325,12328,12330) then 10
	 when LEFT(e.EthnicityValue,2)=42 then 12
	 when LEFT(e.EthnicityValue,2)=43 then 11
	 when LEFT(e.EthnicityValue,2)=44 or e.EthnicityID in (12321,12323,12329) then 13
	 when LEFT(e.EthnicityValue,2)=51 then 17
	 when LEFT(e.EthnicityValue,2)=52 then 15
	 when LEFT(e.EthnicityValue,2)=53 then 16
	 when LEFT(e.EthnicityValue,2)=54 then 18
	 when LEFT(e.EthnicityValue,2)=95 then 95
	 when LEFT(e.EthnicityValue,2)=97 then 97
	 when LEFT(e.EthnicityValue,2)=99 then 99
	 Else 'Unidentified'
END as EthinicityGroupPriority
,e.[EthnicityIsActive]
,e.EthnicityParentId
FROM rbmnb.dlDimEthnicity e
where isnumeric(e.EthnicityValue)=1
)



select 
	1 AS company_key
	,client_id
	,client_display_name
	,client_first_name
	,client_middle_name
	,client_last_name
	,client_preferred_name
	,client_nhi_number
	,FORMAT(cast(client_created_date as date),'yyyyMMdd') as client_created_date
	,max(case when PrimaryAddress.AddressLine1 is null then '1' else '0' end) as client_address_missing_indicator
	,isnull(PrimaryAddress.addressname, OtherAddress.addressname) as client_address_name
    ,isnull(PrimaryAddress.addressline1, OtherAddress.addressline1) as client_address_line1
	,isnull(PrimaryAddress.addressline2, OtherAddress.addressline2) as client_address_line2
    ,isnull(PrimaryAddress.addressline3, OtherAddress.addressline3) as client_address_line3
    ,isnull(PrimaryAddress.addresssuburb, OtherAddress.addresssuburb) as client_address_suburb
    ,isnull(PrimaryAddress.addresstowncity, OtherAddress.addresstowncity) as client_address_town_or_city
    ,isnull(PrimaryAddress.addresspostcode, OtherAddress.addresspostcode) as client_address_post_code
	,max(case when fp.PhonePhoneNumber is null then '1' else '0' end) as client_contact_phone_missing_indicator
	,max(case when pnt.phonenumbertypevalue = 'home' then fp.phonephonenumber end) as client_contact_home_phone
    ,max(case when pnt.phonenumbertypevalue = 'work' then fp.phonephonenumber end) as client_contact_work_phone
    ,max(case when pnt.phonenumbertypevalue = 'mobile' then fp.phonephonenumber end) as client_contact_mobile_phone
    ,max(case when pnt.phonenumbertypevalue = 'fax' then fp.phonephonenumber end) as client_contact_fax
    ,max(case when pnt.phonenumbertypevalue = 'pager' then fp.phonephonenumber end) as client_contact_pager
    ,max(case when pnt.phonenumbertypevalue = 'other' then fp.phonephonenumber end) as client_contact_other
	,MAX(case when pc.PersonContactIsEmergencyContact is null then 0 else pc.PersonContactIsEmergencyContact end) as client_emergency_contact_indicator
	,max(case when pc.PersonContactIsEmergencyContact = 1 then pc.PersonContactPhone else null end)  as client_emergency_contact_phone
	,fe.emailemail as client_email
	--,'' as primary_iwi
	--,'' as primary_region
	--,'' as primary_waka_IwiUnknown
	--,'Maori' as primary_ethnicity
	--,'' as secondary_iwi
	--,'' as secondary_region
	--,'' as secondary_waka_IwiUnknown
	--,'' as secondary_ethnicity
	--,'' as tertiary_iwi
	--,'' as tertiary_region
	--,'' as tertiary_waka_IwiUnknown
	--,'' as tertiary_ethnicity
	--,0 as maori_indicator
	--,0 as pasifika_indicator
	--,'' as ethnicity_group
	,e.Iwi as primary_iwi
	,e.Region as primary_region
	,e.Waka_IwiUnknown as primary_waka_IwiUnknown
	,MAX(case when e.ethnicityparent=11183 then 'Maori' else e.ethnicity_text end ) as primary_ethnicity
	,e1.Iwi as secondary_iwi
	,e1.Region as secondary_region
	,e1.Waka_IwiUnknown as secondary_waka_IwiUnknown
	,MAX(case when e1.ethnicityparent=11183 then 'Maori' else e1.ethnicity_text end ) as secondary_ethnicity
	,e2.Iwi as tertiary_iwi
	,e2.Region as tertiary_region
	,e2.Waka_IwiUnknown as tertiary_waka_IwiUnknown
	,max(case when e2.ethnicityparent=11183 then 'Maori' else e2.ethnicity_text end) as tertiary_ethnicity
	,max(case 
		when e.ethnicity_group = 'Maori' or e1.ethnicity_group = 'Maori' or e2.ethnicity_group = 'Maori' then 1
		when e1.ethnicity_group is null and e.ethnicity_text is null then null
		else 0 END) as maori_indicator
	,max(case 
		when e.ethnicity_group = 'Pasifika' or e1.ethnicity_group = 'Pasifika' or e2.ethnicity_group = 'Pasifika' then 1
		when e1.ethnicity_group is null and e.ethnicity_text is null then null
		else 0 END) as pasifika_indicator
	,max(case 
		when e.ethnicity_group = 'Maori' or e1.ethnicity_group = 'Maori' or e2.ethnicity_group = 'Maori' then 'Maori'
		when e.ethnicity_group = 'Pasifika' or e1.ethnicity_group = 'Pasifika' or e2.ethnicity_group = 'Pasifika' then 'Pasifika'
		when e.ethnicity_group = 'Asian' or e1.ethnicity_group = 'Asian' or e2.ethnicity_group = 'Asian' then 'Asian'
		when e.ethnicity_group = 'Middle Eastern/Latin American/African' or e1.ethnicity_group = 'Middle Eastern/Latin American/African' or e2.ethnicity_group = 'Middle Eastern/Latin American/African' then 'Middle Eastern/Latin American/African'
		when e.ethnicity_group = 'Other Ethnicity' or e1.ethnicity_group = 'Other Ethnicity' or e2.ethnicity_group = 'Other Ethnicity' then 'Other Ethnicity'
		when e.ethnicity_group = 'European' or e1.ethnicity_group = 'European' or e2.ethnicity_group = 'European' then 'European'
		when e.ethnicity_group = 'Residual Categories' or e1.ethnicity_group = 'Residual Categories' or e2.ethnicity_group = 'Residual Categories' then 'Residual Categories'
		else null END) as ethnicity_group

	,dg.gendertext as client_gender
	,cast(client_date_of_birth as date) as client_date_of_birth
	,cast(client_date_of_death as date) as client_date_of_death
	,client_age_years
	,max(case
	when dss.SmokingStatusValue='CS' then 'Current Smoker' else dss.smokingstatustext end) as smoking_status
	,max(case
	when dss.SmokingStatusValue='CS' then dss.smokingstatustext 
	when dss.SmokingStatusValue is null then null 
	else '0' end) as smoking_cigarettes_per_day
	,FORMAT(cast(fpsh.PersonSmokingHistoryAssessmentDate as date),'yyyyMMdd') as smoking_assessment_date
	,MAX(CASE when PLS.PersonID is null then 1 else 0 end) as client_legal_status_missing_indicator
	,dls.LegalStatusText as client_legal_status
	
	,MAX(CASE when phc.PersonHealthConditionHealthConditionType = 'MentalHealthCondition' then 1 else 0 end) as client_mental_health_condition_indicator
	,MAX(case when cph.MentalHealthConditionCount>1 then 'Multiple Condtions' else dmc.MentalConditionText end) as client_mental_health_condition
	,MAX(CASE when phc.PersonHealthConditionHealthConditionType = 'PhysicalHealthCondition' then 1 else 0 end) as client_physical_health_condition_indicator
	,MAX(case when cph.PhysicalHealthConditionCount>1 then 'Multiple Condtions' else dpc.PhysicalConditionText end) as client_physical_condition
	,MAX(CASE when phc.PersonHealthConditionHealthConditionType = 'Substance' then 1 else 0 end) as client_substance_use_indicator
	,MAX(case when cph.SubstanceCount>1 then 'Multiple Substances' else DST.SubstanceTypeText end) as client_substance_condition
	,MAX(CASE when fpsh.personid is null then 1 else 0 end) as client_smoking_status_missing_indicator
	,MAX(CASE when fpsh.personid is null then 0
			  when fpsh.PersonSmokingHistoryBriefAdviceGiven = 0 then 0
			  else 1 end) as client_smoking_advice_indicator
	,MAX(CASE when fpsh.personid is null 
	or fpsh.PersonSmokingHistorySupportServicesOffered is null 
	or fpsh.PersonSmokingHistorySupportServicesOffered = '' then 0 else 1 end) as client_smoking_cessation_referral_indicator
	,MAX(CASE when phsr.PersonId is null then 1 else 0 end) as client_primhd_review_missing_indicator
	,case when DATEDIFF(Day,max(phsr.PrimhdServiceReviewReviewDate),GETDATE())>=90 then 1 else 0 end as client_primhd_review_overdue_indicator
	,case when DATEDIFF(Day,max(phsr.PrimhdServiceReviewReviewDate),GETDATE())>=82 
			and DATEDIFF(Day,max(phsr.PrimhdServiceReviewReviewDate),GETDATE())<90 
		then 1 else 0 end as client_primhd_review_due_soon_indicator
	,case when DATEDIFF(Day,max(phsr.PrimhdServiceReviewReviewDate),GETDATE())<82 then 1 else 0 end as client_primhd_review_current_indicator

	,MAX(CASE WHEN GPRegistration_RBEAL.GPOnly IS NULL THEN 1 ELSE 0 END) AS client_gp_only_missing_indicator
    ,MAX(CASE WHEN GPRegistration_RBEAL.GPRegistration IS NULL OR GPRegistration_RBEAL.GPRegistrationValue = 'No' THEN 1 ELSE 0 END) AS client_gp_registration_missing_indicator

	
	,dr.residencytext as client_residency_status
	,min(case when fr.ReferralReferralType like '%Inbound%' 
				   and fr.CurrentReferralStatusTypeID in (13,15,16)
				   and fr.ReferralEndDate is null
			then 'Active'
			else 'Not Active' end) as client_status_is_active
	,case when fpsh.PersonSmokingHistoryAssessmentDate = MAX(fpsh.PersonSmokingHistoryAssessmentDate) OVER (partition by client_id) then 1 
		  when fpsh.PersonSmokingHistoryAssessmentDate is null then 1 else 0 end as LastAssessmentIndicator
	
	--,isnull(iw.EthnicityIwi5,'') as EthnicityIwi5

	--push them all to the left depending on which columns are filled in 
	,case when left(pe.EthnicityCounter,1) = '1' then pe.Ethnicity1
		  when left(pe.EthnicityCounter,2) = '01' then pe.Ethnicity2 
		  when left(pe.EthnicityCounter,3) = '001' then pe.Ethnicity3 
		  when left(pe.EthnicityCounter,4) = '0001' then pe.Ethnicity4 
		  when pe.EthnicityCounter in ('00001') then pe.Ethnicity5 end as primary_ethnicity2 

	,case when left(pe.EthnicityCounter,2) = '11' then pe.Ethnicity2  
		  when left(pe.EthnicityCounter,3) in ('101','011') then pe.Ethnicity3 
		  when left(pe.EthnicityCounter,4) in ('0011') then pe.Ethnicity4 
		  when pe.EthnicityCounter in ('00011') then pe.Ethnicity5 end as secondary_ethnicity2
	
	,case when left(pe.EthnicityCounter,3) = '111' then pe.Ethnicity3  
		  when left(pe.EthnicityCounter,4) in ('0111','1011','1101') then pe.Ethnicity4 
		  when pe.EthnicityCounter in ('00111') then pe.Ethnicity5 end as tertiary_ethnicity2

	,case when left(pe.EthnicityCounter,4) = '1111' then pe.Ethnicity4  
		  when pe.EthnicityCounter in ('01111','10111','11011','11101') then pe.Ethnicity5 end as fourth_ethnicity2


	--push them all to the left depending on which columns are filled in 	
	,case when left(iw.IwiCounter,1) = '1' then iw.EthnicityIwi1
		  when left(iw.IwiCounter,2) = '01' then iw.EthnicityIwi2 
		  when left(iw.IwiCounter,3) = '001' then iw.EthnicityIwi3 
		  when left(iw.IwiCounter,4) = '0001' then iw.EthnicityIwi4 
		  when iw.IwiCounter in ('00001') then iw.EthnicityIwi5 end as primary_iwi2 

	,case when left(iw.IwiCounter,2) = '11' then iw.EthnicityIwi2  
		  when left(iw.IwiCounter,3) in ('101','011') then iw.EthnicityIwi3 
		  when left(iw.IwiCounter,4) in ('0011') then iw.EthnicityIwi4 
		  when iw.IwiCounter in ('00011') then iw.EthnicityIwi5 end as secondary_iwi2
	
	,case when left(iw.IwiCounter,3) = '111' then iw.EthnicityIwi3  
		  when left(iw.IwiCounter,4) in ('0111','1011','1101') then iw.EthnicityIwi4 
		  when iw.IwiCounter in ('00111') then iw.EthnicityIwi5 end as tertiary_iwi2

	,case when left(iw.IwiCounter,4) = '1111' then iw.EthnicityIwi4  
		  when iw.IwiCounter in ('01111','10111','11011','11101') then iw.EthnicityIwi5 end as fourth_iwi2



	from cte_dimclient_RBEAL dc
	--left join rbeal.dlfactaddress fa on dc.client_id = fa.entityid
	--and fa.addressisprimaryaddress = 1
	--and fa.addressid = (select max(addressid) from rbeal.dlfactaddress fa1 where fa1.entityid = fa.entityid)
	
	--Join with primary addresses only (There should only be one but if not take the latest)
	left join rbeal.dlfactaddress PrimaryAddress ON dc.client_id = PrimaryAddress.entityid
    and PrimaryAddress.addressid = (select max(addressid) 
									from rbeal.dlfactaddress fa1 
									where fa1.entityid = PrimaryAddress.entityid 
									and fa1.addressisprimaryaddress = 1)
	
	--Join on all non primary addresses
	left join rbeal.dlfactaddress OtherAddress ON dc.client_id = OtherAddress.entityid
    and OtherAddress.addressid = (select max(addressid) 
								  from rbeal.dlfactaddress fa1 
								  where fa1.entityid = OtherAddress.entityid
								  and fa1.addressisprimaryaddress <> 1)




	left join rbeal.dlfactphone fp	on dc.client_id = fp.entityid 
	left join rbeal.dldimphonenumbertype pnt	on fp.phonenumbertypeid = pnt.phonenumbertypeid
	
	left join rbeal.dlfactemail fe on dc.client_id=fe.entityid
	and fe.emailid = (select max(emailid) from rbeal.dlfactemail fe1 where fe1.entityid=fe.entityid)
	and fe.EmailEmail not like ('%Password%')
	
	left join rbeal.dldimgender dg	on dc.client_gender = dg.genderid
	left join rbeal.dldimresidency dr	on dc.client_residency = dr.residencyid
	
	left join rbeal.dlfactpersonsmokinghistory fpsh	on dc.client_id = fpsh.personid
	AND fpsh.PersonSmokingHistoryAssessmentDate=(select max(PersonSmokingHistoryAssessmentDate) from rbeal.dlfactpersonsmokinghistory fpsh1 where fpsh1.personid=fpsh.personid)
	
	left join rbeal.dldimsmokingstatus dss	on dss.smokingstatusid = fpsh.smokingstatusid
	
	left join rbeal.dlFactReferral fr on dc.client_id = fr.PersonID
	
	left join person_iwi_eal iw on dc.client_id = iw.PersonID 
	left join person_ethnicity_eal pe on dc.client_id = pe.PersonID 

	left join CTE_Dimethnicity_RBEAL e	on dc.client_ethnicity1 = e.ethnicity_id
	left join CTE_Dimethnicity_RBEAL e1	on dc.client_ethnicity2 = e1.ethnicity_id
	left join CTE_Dimethnicity_RBEAL e2	on dc.client_ethnicity3 = e2.ethnicity_id

	left join rbeal.dlFactPersonLegalStatus PLS	on dc.client_id = PLS.PersonID
	and pls.PersonLegalStatusID= (select MAX(PLS1.PersonLegalStatusID) from rbeal.dlFactPersonLegalStatus PLS1 where PLS1.PersonID =PLS.PersonID)
	
	left join RBEAL.dlDimLegalStatus DLS on PLS.LegalStatusID=DLS.LegalStatusID
	left join rbeal.dlFactPersonContact pc on dc.client_id =pc.PersonID
	and pc.PersonContactIsEmergencyContact=1 and pc.PersonContactID = (select MAX(fpc.PersonContactID) from RBEAL.dlFactPersonContact FPC where fpc.PersonID=pc.PersonID and fpc.PersonContactIsEmergencyContact=1)
	
	left join RBEAL.dlFactPersonHealthCondition PHC	on dc.client_id = phc.PersonId
	left join RBEAL.dlDimMentalCondition DMC on phc.HealthConditionTypeId = dmc.MentalConditionID
	and phc.PersonHealthConditionHealthConditionType = 'MentalHealthCondition'
	
	left join rbeal.dlDimPhysicalCondition DPC	on phc.HealthConditionTypeId = dpc.PhysicalConditionID
	and phc.PersonHealthConditionHealthConditionType = 'PhysicalHealthCondition'
	
	left join RBEAL.dlDimSubstanceType DST	on phc.HealthConditionTypeId = dst.SubstanceTypeID
	and phc.PersonHealthConditionHealthConditionType = 'Substance'
	
	left join CTE_PHC_RBEAL CPH	on dc.client_id = cph.PersonID
	
	left join RBEAL.dlFactPrimhdServiceReview PHSR on dc.client_id = phsr.PersonId
	and PHSR.PrimhdServiceReviewCreatedDate >=GETDATE()-365
	and phsr.PrimhdServiceReviewReviewDate = (select MAX(phsr1.PrimhdServiceReviewReviewDate) from rbeal.dlFactPrimhdServiceReview phsr1 where	phsr1.PrimhdServiceReviewReviewDate=phsr.PrimhdServiceReviewReviewDate)
	
	left join CTE_GPRegistration_RBEAL GPRegistration_RBEAL on dc.client_id = GPRegistration_RBEAL.PersonID
	
	group by 
	client_id
	,client_display_name
	,client_first_name
	,client_middle_name
	,client_last_name
	,client_preferred_name
	,client_nhi_number
	,client_created_date
	,client_date_of_birth
	,client_date_of_death
	,client_age_years
	,isnull(PrimaryAddress.addressname, OtherAddress.addressname) 
    ,isnull(PrimaryAddress.addressline1, OtherAddress.addressline1)
	,isnull(PrimaryAddress.addressline2, OtherAddress.addressline2)
    ,isnull(PrimaryAddress.addressline3, OtherAddress.addressline3) 
    ,isnull(PrimaryAddress.addresssuburb, OtherAddress.addresssuburb) 
    ,isnull(PrimaryAddress.addresstowncity, OtherAddress.addresstowncity) 
    ,isnull(PrimaryAddress.addresspostcode, OtherAddress.addresspostcode)
	
	,fe.emailemail
	,dg.gendertext
	,dr.residencytext
	,fpsh.PersonSmokingHistoryAssessmentDate
	,e.Iwi
	,e.Region
	,e.Waka_IwiUnknown
	,e1.Iwi
	,e1.Region
	,e1.Waka_IwiUnknown
	,e2.Iwi
	,e2.Region
	,e2.Waka_IwiUnknown
	,e.Iwi
	,e.Region
	,dls.LegalStatusText

	,case when left(iw.IwiCounter,1) = '1' then iw.EthnicityIwi1
		  when left(iw.IwiCounter,2) = '01' then iw.EthnicityIwi2 
		  when left(iw.IwiCounter,3) = '001' then iw.EthnicityIwi3 
		  when left(iw.IwiCounter,4) = '0001' then iw.EthnicityIwi4 
		  when iw.IwiCounter in ('00001') then iw.EthnicityIwi5 end 

	,case when left(iw.IwiCounter,2) = '11' then iw.EthnicityIwi2  
		  when left(iw.IwiCounter,3) in ('101','011') then iw.EthnicityIwi3 
		  when left(iw.IwiCounter,4) in ('0011') then iw.EthnicityIwi4 
		  when iw.IwiCounter in ('00011') then iw.EthnicityIwi5 end 
	
	,case when left(iw.IwiCounter,3) = '111' then iw.EthnicityIwi3  
		  when left(iw.IwiCounter,4) in ('0111','1011','1101') then iw.EthnicityIwi4 
		  when iw.IwiCounter in ('00111') then iw.EthnicityIwi5 end 

	,case when left(iw.IwiCounter,4) = '1111' then iw.EthnicityIwi4  
		  when iw.IwiCounter in ('01111','10111','11011','11101') then iw.EthnicityIwi5 end

	,isnull(iw.EthnicityIwi5,'')

	,pe.EthnicityCounter
	,case when left(pe.EthnicityCounter,1) = '1' then pe.Ethnicity1
		  when left(pe.EthnicityCounter,2) = '01' then pe.Ethnicity2 
		  when left(pe.EthnicityCounter,3) = '001' then pe.Ethnicity3 
		  when left(pe.EthnicityCounter,4) = '0001' then pe.Ethnicity4 
		  when pe.EthnicityCounter in ('00001') then pe.Ethnicity5 end 

	,case when left(pe.EthnicityCounter,2) = '11' then pe.Ethnicity2  
		  when left(pe.EthnicityCounter,3) in ('101','011') then pe.Ethnicity3 
		  when left(pe.EthnicityCounter,4) in ('0011') then pe.Ethnicity4 
		  when pe.EthnicityCounter in ('00011') then pe.Ethnicity5 end
	
	,case when left(pe.EthnicityCounter,3) = '111' then pe.Ethnicity3  
		  when left(pe.EthnicityCounter,4) in ('0111','1011','1101') then pe.Ethnicity4 
		  when pe.EthnicityCounter in ('00111') then pe.Ethnicity5 end

	,case when left(pe.EthnicityCounter,4) = '1111' then pe.Ethnicity4  
		  when pe.EthnicityCounter in ('01111','10111','11011','11101') then pe.Ethnicity5  end

	,isnull(pe.Ethnicity5,'') 
	,case when pc.PersonContactIsEmergencyContact = 1 then pc.PersonContactPhone else null end


	union all

	
	select 
	5 AS company_key
	,client_id
	,client_display_name
	,client_first_name
	,client_middle_name
	,client_last_name
	,client_preferred_name
	,client_nhi_number
	,FORMAT(cast(client_created_date as date),'yyyyMMdd') as client_created_date
	--,max(case when fa.AddressLine1 is null then '1' else '0' end) as client_address_missing_indicator
	--,fa.addressname as client_address_name
 --   ,fa.addressline1 as client_address_line1
	--,fa.addressline2 as client_address_line2
 --   ,fa.addressline3 as client_address_line3
 --   ,fa.addresssuburb as client_address_suburb
 --   ,fa.addresstowncity as client_address_town_or_city
 --   ,fa.addresspostcode as client_address_post_code
	,max(case when PrimaryAddress.AddressLine1 is null then '1' else '0' end) as client_address_missing_indicator
	,isnull(PrimaryAddress.addressname, OtherAddress.addressname) as client_address_name
    ,isnull(PrimaryAddress.addressline1, OtherAddress.addressline1) as client_address_line1
	,isnull(PrimaryAddress.addressline2, OtherAddress.addressline2) as client_address_line2
    ,isnull(PrimaryAddress.addressline3, OtherAddress.addressline3) as client_address_line3
    ,isnull(PrimaryAddress.addresssuburb, OtherAddress.addresssuburb) as client_address_suburb
    ,isnull(PrimaryAddress.addresstowncity, OtherAddress.addresstowncity) as client_address_town_or_city
    ,isnull(PrimaryAddress.addresspostcode, OtherAddress.addresspostcode) as client_address_post_code

	,max(case when fp.PhonePhoneNumber is null then '1' else '0' end) as client_contact_phone_missing_indicator
	,max(case when pnt.phonenumbertypevalue = 'home' then fp.phonephonenumber end) as client_contact_home_phone
    ,max(case when pnt.phonenumbertypevalue = 'work' then fp.phonephonenumber end) as client_contact_work_phone
    ,max(case when pnt.phonenumbertypevalue = 'mobile' then fp.phonephonenumber end) as client_contact_mobile_phone
    ,max(case when pnt.phonenumbertypevalue = 'fax' then fp.phonephonenumber end) as client_contact_fax
    ,max(case when pnt.phonenumbertypevalue = 'pager' then fp.phonephonenumber end) as client_contact_pager
    ,max(case when pnt.phonenumbertypevalue = 'other' then fp.phonephonenumber end) as client_contact_other
	,MAX(case when pc.PersonContactIsEmergencyContact is null then 0 else pc.PersonContactIsEmergencyContact end) as client_emergency_contact_indicator
	,max(case when pc.PersonContactIsEmergencyContact = 1 then pc.PersonContactPhone else null end)  as client_emergency_contact_phone
	,fe.emailemail as client_email
	--,'' as primary_iwi
	--,'' as primary_region
	--,'' as primary_waka_IwiUnknown
	--,'Maori' as primary_ethnicity
	--,'' as secondary_iwi
	--,'' as secondary_region
	--,'' as secondary_waka_IwiUnknown
	--,'' as secondary_ethnicity
	--,'' as tertiary_iwi
	--,'' as tertiary_region
	--,'' as tertiary_waka_IwiUnknown
	--,'' as tertiary_ethnicity
	--,0 as maori_indicator
	--,0 as pasifika_indicator
	--,'' as ethnicity_group
	,e.Iwi as primary_iwi
	,e.Region as primary_region
	,e.Waka_IwiUnknown as primary_waka_IwiUnknown
	,MAX(case when e.ethnicityparent=11183 then 'Maori' else e.ethnicity_text end ) as primary_ethnicity
	,e1.Iwi as secondary_iwi
	,e1.Region as secondary_region
	,e1.Waka_IwiUnknown as secondary_waka_IwiUnknown
	,MAX(case when e1.ethnicityparent=11183 then 'Maori' else e1.ethnicity_text end ) as secondary_ethnicity
	,e2.Iwi as tertiary_iwi
	,e2.Region as tertiary_region
	,e2.Waka_IwiUnknown as tertiary_waka_IwiUnknown
	,MAX(case when e2.ethnicityparent=11183 then 'Maori' else e2.ethnicity_text end) as tertiary_ethnicity
	,max(case 
		when e.ethnicity_group = 'Maori' or e1.ethnicity_group = 'Maori' or e2.ethnicity_group = 'Maori' then 1
		when e1.ethnicity_group is null and e.ethnicity_text is null then null
		else 0 END) as maori_indicator
	,max(case 
		when e.ethnicity_group = 'Pasifika' or e1.ethnicity_group = 'Pasifika' or e2.ethnicity_group = 'Pasifika' then 1
		when e1.ethnicity_group is null and e.ethnicity_text is null then null
		else 0 END) as pasifika_indicator
	,max(case 
		when e.ethnicity_group = 'Maori' or e1.ethnicity_group = 'Maori' or e2.ethnicity_group = 'Maori' then 'Maori'
		when e.ethnicity_group = 'Pasifika' or e1.ethnicity_group = 'Pasifika' or e2.ethnicity_group = 'Pasifika' then 'Pasifika'
		when e.ethnicity_group = 'Asian' or e1.ethnicity_group = 'Asian' or e2.ethnicity_group = 'Asian' then 'Asian'
		when e.ethnicity_group = 'Middle Eastern/Latin American/African' or e1.ethnicity_group = 'Middle Eastern/Latin American/African' or e2.ethnicity_group = 'Middle Eastern/Latin American/African' then 'Middle Eastern/Latin American/African'
		when e.ethnicity_group = 'Other Ethnicity' or e1.ethnicity_group = 'Other Ethnicity' or e2.ethnicity_group = 'Other Ethnicity' then 'Other Ethnicity'
		when e.ethnicity_group = 'European' or e1.ethnicity_group = 'European' or e2.ethnicity_group = 'European' then 'European'
		when e.ethnicity_group = 'Residual Categories' or e1.ethnicity_group = 'Residual Categories' or e2.ethnicity_group = 'Residual Categories' then 'Residual Categories'
		else null END) as ethnicity_group

	,dg.gendertext as client_gender
	,cast(client_date_of_birth as date) as client_date_of_birth
	,cast(client_date_of_death as date) as client_date_of_death
	,client_age_years
	,max(case
	when dss.SmokingStatusValue='CS' then 'Current Smoker' else dss.smokingstatustext end) as smoking_status
	,max(case
	when dss.SmokingStatusValue='CS' then dss.smokingstatustext 
	when dss.SmokingStatusValue is null then null 
	else '0' end) as smoking_cigarettes_per_day
	,FORMAT(cast(fpsh.PersonSmokingHistoryAssessmentDate as date),'yyyyMMdd') as smoking_assessment_date
	,MAX(CASE when PLS.PersonID is null then 1 else 0 end) as client_legal_status_missing_indicator
	,dls.LegalStatusText as client_legal_status
	
	,MAX(CASE when phc.PersonHealthConditionHealthConditionType = 'MentalHealthCondition' then 1 else 0 end) as client_mental_health_condition_indicator
	,MAX(case when cph.MentalHealthConditionCount>1 then 'Multiple Condtions' else dmc.MentalConditionText end) as client_mental_health_condition
	,MAX(CASE when phc.PersonHealthConditionHealthConditionType = 'PhysicalHealthCondition' then 1 else 0 end) as client_physical_health_condition_indicator
	,MAX(case when cph.PhysicalHealthConditionCount>1 then 'Multiple Condtions' else dpc.PhysicalConditionText end) as client_physical_condition
	,MAX(CASE when phc.PersonHealthConditionHealthConditionType = 'Substance' then 1 else 0 end) as client_substance_use_indicator
	,MAX(case when cph.SubstanceCount>1 then 'Multiple Substances' else DST.SubstanceTypeText end) as client_substance_condition
	,MAX(CASE when fpsh.personid is null then 1 else 0 end) as client_smoking_status_missing_indicator
	,MAX(CASE when fpsh.personid is null then 0
			  when fpsh.PersonSmokingHistoryBriefAdviceGiven = 0 then 0
			  else 1 end) as client_smoking_advice_indicator
	,MAX(CASE when fpsh.personid is null 
	or fpsh.PersonSmokingHistorySupportServicesOffered is null 
	or fpsh.PersonSmokingHistorySupportServicesOffered = '' then 0 else 1 end) as client_smoking_cessation_referral_indicator
	,MAX(CASE when phsr.PersonId is null then 1 else 0 end) as client_primhd_review_missing_indicator
	,case when DATEDIFF(Day,max(phsr.PrimhdServiceReviewReviewDate),GETDATE())>=90 then 1 else 0 end as client_primhd_review_overdue_indicator
	,case when DATEDIFF(Day,max(phsr.PrimhdServiceReviewReviewDate),GETDATE())>=82 
			and DATEDIFF(Day,max(phsr.PrimhdServiceReviewReviewDate),GETDATE())<90 
		then 1 else 0 end as client_primhd_review_due_soon_indicator
	,case when DATEDIFF(Day,max(phsr.PrimhdServiceReviewReviewDate),GETDATE())<82 then 1 else 0 end as client_primhd_review_current_indicator

	--,MAX(CASE when isnull(GPRegistration.GPOnly,0) = 0 then 1 else 0 end) as client_gp_only_missing_indicator
	--,MAX(CASE when isnull(GPRegistration.GPRegistration,0) = 0 then 1 else 0 end) as client_gp_registration_missing_indicator
	
	
	,max(case when GPRegistration_rbmnb.GPOnly is null then 1 else 0 end) AS client_gp_only_missing_indicator
    ,max(case when GPRegistration_rbmnb.GPRegistration is null or GPRegistration_rbmnb.GPRegistrationValue = 'No' then 1 else 0 end) AS client_gp_registration_missing_indicator
	
	
	,dr.residencytext as client_residency_status
	,min(case when fr.ReferralReferralType like '%Inbound%' 
				   and fr.CurrentReferralStatusTypeID in (13,15,16)
				   and fr.ReferralEndDate is null
			then 'Active'
			else 'Not Active' end) as client_status_is_active
	,case when fpsh.PersonSmokingHistoryAssessmentDate = MAX(fpsh.PersonSmokingHistoryAssessmentDate) OVER (partition by client_id) then 1 
		  when fpsh.PersonSmokingHistoryAssessmentDate is null then 1 else 0 end as LastAssessmentIndicator
	
	--,isnull(iw.EthnicityIwi5,'') as EthnicityIwi5

	--push them all to the left depending on which columns are filled in 
	,case when left(pe.EthnicityCounter,1) = '1' then pe.Ethnicity1
		  when left(pe.EthnicityCounter,2) = '01' then pe.Ethnicity2 
		  when left(pe.EthnicityCounter,3) = '001' then pe.Ethnicity3 
		  when left(pe.EthnicityCounter,4) = '0001' then pe.Ethnicity4 
		  when pe.EthnicityCounter in ('00001') then pe.Ethnicity5 end as primary_ethnicity2 

	,case when left(pe.EthnicityCounter,2) = '11' then pe.Ethnicity2  
		  when left(pe.EthnicityCounter,3) in ('101','011') then pe.Ethnicity3 
		  when left(pe.EthnicityCounter,4) in ('0011') then pe.Ethnicity4 
		  when pe.EthnicityCounter in ('00011') then pe.Ethnicity5 end as secondary_ethnicity2
	
	,case when left(pe.EthnicityCounter,3) = '111' then pe.Ethnicity3  
		  when left(pe.EthnicityCounter,4) in ('0111','1011','1101') then pe.Ethnicity4 
		  when pe.EthnicityCounter in ('00111') then pe.Ethnicity5 end as tertiary_ethnicity2

	,case when left(pe.EthnicityCounter,4) = '1111' then pe.Ethnicity4  
		  when pe.EthnicityCounter in ('01111','10111','11011','11101') then pe.Ethnicity5 end as fourth_ethnicity2


	--push them all to the left depending on which columns are filled in 	
	,case when left(iw.IwiCounter,1) = '1' then iw.EthnicityIwi1
		  when left(iw.IwiCounter,2) = '01' then iw.EthnicityIwi2 
		  when left(iw.IwiCounter,3) = '001' then iw.EthnicityIwi3 
		  when left(iw.IwiCounter,4) = '0001' then iw.EthnicityIwi4 
		  when iw.IwiCounter in ('00001') then iw.EthnicityIwi5 end as primary_iwi2 

	,case when left(iw.IwiCounter,2) = '11' then iw.EthnicityIwi2  
		  when left(iw.IwiCounter,3) in ('101','011') then iw.EthnicityIwi3 
		  when left(iw.IwiCounter,4) in ('0011') then iw.EthnicityIwi4 
		  when iw.IwiCounter in ('00011') then iw.EthnicityIwi5 end as secondary_iwi2
	
	,case when left(iw.IwiCounter,3) = '111' then iw.EthnicityIwi3  
		  when left(iw.IwiCounter,4) in ('0111','1011','1101') then iw.EthnicityIwi4 
		  when iw.IwiCounter in ('00111') then iw.EthnicityIwi5 end as tertiary_iwi2

	,case when left(iw.IwiCounter,4) = '1111' then iw.EthnicityIwi4  
		  when iw.IwiCounter in ('01111','10111','11011','11101') then iw.EthnicityIwi5 end as fourth_iwi2



	from cte_dimclient_rbmnb dc
	--left join rbmnb.dlfactaddress fa on dc.client_id = fa.entityid
	--and fa.addressisprimaryaddress = 1
	--and fa.addressid = (select max(addressid) from rbmnb.dlfactaddress fa1 where fa1.entityid = fa.entityid)
	
	--Join with primary addresses only (There should only be one but if not take the latest)
	left join rbmnb.dlfactaddress PrimaryAddress ON dc.client_id = PrimaryAddress.entityid
    and PrimaryAddress.addressid = (select max(addressid) 
									from rbmnb.dlfactaddress fa1 
									where fa1.entityid = PrimaryAddress.entityid 
									and fa1.addressisprimaryaddress = 1)
	
	--Join on all non primary addresses
	left join rbmnb.dlfactaddress OtherAddress ON dc.client_id = OtherAddress.entityid
    and OtherAddress.addressid = (select max(addressid) 
								  from rbmnb.dlfactaddress fa1 
								  where fa1.entityid = OtherAddress.entityid
								  and fa1.addressisprimaryaddress <> 1)

	left join rbmnb.dlfactphone fp	on dc.client_id = fp.entityid 
	left join rbmnb.dldimphonenumbertype pnt	on fp.phonenumbertypeid = pnt.phonenumbertypeid
	
	left join rbmnb.dlfactemail fe on dc.client_id=fe.entityid
	and fe.emailid = (select max(emailid) from rbmnb.dlfactemail fe1 where fe1.entityid=fe.entityid)
	and fe.EmailEmail not like ('%Password%')
	
	left join rbmnb.dldimgender dg	on dc.client_gender = dg.genderid
	left join rbmnb.dldimresidency dr	on dc.client_residency = dr.residencyid
	
	left join rbmnb.dlfactpersonsmokinghistory fpsh	on dc.client_id = fpsh.personid
	AND fpsh.PersonSmokingHistoryAssessmentDate=(select max(PersonSmokingHistoryAssessmentDate) from rbmnb.dlfactpersonsmokinghistory fpsh1 where fpsh1.personid=fpsh.personid)
	
	left join rbmnb.dldimsmokingstatus dss	on dss.smokingstatusid = fpsh.smokingstatusid
	
	left join rbmnb.dlFactReferral fr on dc.client_id = fr.PersonID
	
	left join person_iwi_mnb iw on dc.client_id = iw.PersonID 
	left join person_ethnicity_mnb pe on dc.client_id = pe.PersonID 

	left join CTE_Dimethnicity_rbmnb e	on dc.client_ethnicity1 = e.ethnicity_id
	left join CTE_Dimethnicity_rbmnb e1	on dc.client_ethnicity2 = e1.ethnicity_id
	left join CTE_Dimethnicity_rbmnb e2	on dc.client_ethnicity3 = e2.ethnicity_id

	left join rbmnb.dlFactPersonLegalStatus PLS	on dc.client_id = PLS.PersonID
	and pls.PersonLegalStatusID= (select MAX(PLS1.PersonLegalStatusID) from rbmnb.dlFactPersonLegalStatus PLS1 where PLS1.PersonID =PLS.PersonID)
	
	left join rbmnb.dlDimLegalStatus DLS on PLS.LegalStatusID=DLS.LegalStatusID
	left join rbmnb.dlFactPersonContact pc on dc.client_id =pc.PersonID
	and pc.PersonContactIsEmergencyContact=1 and pc.PersonContactID = (select MAX(fpc.PersonContactID) from rbmnb.dlFactPersonContact FPC where fpc.PersonID=pc.PersonID and fpc.PersonContactIsEmergencyContact=1)
	
	left join rbmnb.dlFactPersonHealthCondition PHC	on dc.client_id = phc.PersonId
	left join rbmnb.dlDimMentalCondition DMC on phc.HealthConditionTypeId = dmc.MentalConditionID
	and phc.PersonHealthConditionHealthConditionType = 'MentalHealthCondition'
	
	left join rbmnb.dlDimPhysicalCondition DPC	on phc.HealthConditionTypeId = dpc.PhysicalConditionID
	and phc.PersonHealthConditionHealthConditionType = 'PhysicalHealthCondition'
	
	left join rbmnb.dlDimSubstanceType DST	on phc.HealthConditionTypeId = dst.SubstanceTypeID
	and phc.PersonHealthConditionHealthConditionType = 'Substance'
	
	left join CTE_PHC_rbmnb CPH	on dc.client_id = cph.PersonID
	
	left join rbmnb.dlFactPrimhdServiceReview PHSR on dc.client_id = phsr.PersonId
	and PHSR.PrimhdServiceReviewCreatedDate >=GETDATE()-365
	and phsr.PrimhdServiceReviewReviewDate = (select MAX(phsr1.PrimhdServiceReviewReviewDate) from rbmnb.dlFactPrimhdServiceReview phsr1 where	phsr1.PrimhdServiceReviewReviewDate=phsr.PrimhdServiceReviewReviewDate)
	
	left join CTE_GPRegistration_RBMNB2 GPRegistration_rbmnb on dc.client_id = GPRegistration_rbmnb.PersonID
	
	group by 
	client_id
	,client_display_name
	,client_first_name
	,client_middle_name
	,client_last_name
	,client_preferred_name
	,client_nhi_number
	,client_created_date
	,client_date_of_birth
	,client_date_of_death
	,client_age_years
	,isnull(PrimaryAddress.addressname, OtherAddress.addressname) 
    ,isnull(PrimaryAddress.addressline1, OtherAddress.addressline1)
	,isnull(PrimaryAddress.addressline2, OtherAddress.addressline2)
    ,isnull(PrimaryAddress.addressline3, OtherAddress.addressline3) 
    ,isnull(PrimaryAddress.addresssuburb, OtherAddress.addresssuburb) 
    ,isnull(PrimaryAddress.addresstowncity, OtherAddress.addresstowncity) 
    ,isnull(PrimaryAddress.addresspostcode, OtherAddress.addresspostcode)
	--,fa.addressname
 --   ,fa.addressline1
	--,fa.addressline2
 --   ,fa.addressline3
 --   ,fa.addresssuburb
 --   ,fa.addresstowncity
 --   ,fa.addresspostcode
	,fe.emailemail
	,dg.gendertext
	,dr.residencytext
	,fpsh.PersonSmokingHistoryAssessmentDate
	,e.Iwi
	,e.Region
	,e.Waka_IwiUnknown
	,e1.Iwi
	,e1.Region
	,e1.Waka_IwiUnknown
	,e2.Iwi
	,e2.Region
	,e2.Waka_IwiUnknown
	,e.Iwi
	,e.Region
	,dls.LegalStatusText

	,case when left(iw.IwiCounter,1) = '1' then iw.EthnicityIwi1
		  when left(iw.IwiCounter,2) = '01' then iw.EthnicityIwi2 
		  when left(iw.IwiCounter,3) = '001' then iw.EthnicityIwi3 
		  when left(iw.IwiCounter,4) = '0001' then iw.EthnicityIwi4 
		  when iw.IwiCounter in ('00001') then iw.EthnicityIwi5 end 

	,case when left(iw.IwiCounter,2) = '11' then iw.EthnicityIwi2  
		  when left(iw.IwiCounter,3) in ('101','011') then iw.EthnicityIwi3 
		  when left(iw.IwiCounter,4) in ('0011') then iw.EthnicityIwi4 
		  when iw.IwiCounter in ('00011') then iw.EthnicityIwi5 end 
	
	,case when left(iw.IwiCounter,3) = '111' then iw.EthnicityIwi3  
		  when left(iw.IwiCounter,4) in ('0111','1011','1101') then iw.EthnicityIwi4 
		  when iw.IwiCounter in ('00111') then iw.EthnicityIwi5 end 

	,case when left(iw.IwiCounter,4) = '1111' then iw.EthnicityIwi4  
		  when iw.IwiCounter in ('01111','10111','11011','11101') then iw.EthnicityIwi5 end

	,isnull(iw.EthnicityIwi5,'')

	,pe.EthnicityCounter
	,case when left(pe.EthnicityCounter,1) = '1' then pe.Ethnicity1
		  when left(pe.EthnicityCounter,2) = '01' then pe.Ethnicity2 
		  when left(pe.EthnicityCounter,3) = '001' then pe.Ethnicity3 
		  when left(pe.EthnicityCounter,4) = '0001' then pe.Ethnicity4 
		  when pe.EthnicityCounter in ('00001') then pe.Ethnicity5 end 

	,case when left(pe.EthnicityCounter,2) = '11' then pe.Ethnicity2  
		  when left(pe.EthnicityCounter,3) in ('101','011') then pe.Ethnicity3 
		  when left(pe.EthnicityCounter,4) in ('0011') then pe.Ethnicity4 
		  when pe.EthnicityCounter in ('00011') then pe.Ethnicity5 end
	
	,case when left(pe.EthnicityCounter,3) = '111' then pe.Ethnicity3  
		  when left(pe.EthnicityCounter,4) in ('0111','1011','1101') then pe.Ethnicity4 
		  when pe.EthnicityCounter in ('00111') then pe.Ethnicity5 end

	,case when left(pe.EthnicityCounter,4) = '1111' then pe.Ethnicity4  
		  when pe.EthnicityCounter in ('01111','10111','11011','11101') then pe.Ethnicity5  end

	,isnull(pe.Ethnicity5,'') 

	,case when pc.PersonContactIsEmergencyContact = 1 then pc.PersonContactPhone else null end
GO


