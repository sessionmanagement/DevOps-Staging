CREATE VIEW [ETL].[fact_client_relationship]
as
	
--View			[ETL].[fact_client_relationship]
--Author		Greg Nuthall
--Created		2024/06/06
--Purpose		client record base dlfactpersonlink to generate fact_client_relationship
			
--=========================================================================================================
--REVISIONS:
--Version	 Date		   Author			Description
---------	 ------------  ---------------	--------------------------
--1.0		 2025-11-20	   Greg Nuthall     Initial version 
--1.1        2025-11-25	   Greg Nuthall     Added PersonLinkRelationshipId join to avoid duplicates
--**********************************************************************************************************/


	select 1 AS company_id
	,pl.PersonLinkId + 1000000 as client_relationship_id
	,pl.PrimaryPersonId as primary_client_id
	,p2.PersonFirstName primary_first_name
	,p2.PersonLastName primary_last_name
	,l.LookupText as relationship
	,pl.LinkedPersonId as related_client_id
	,p.PersonFirstName related_first_name
	,p.PersonLastName related_last_name
	,r.PersonLinkRelationshipStartDate as relationship_start_date
	,r.PersonLinkRelationshipEndDate as relationship_end_date

	from rbeal.dlfactPersonlink pl
	left join rbeal.dlFactPersonLinkRelationship r 
		--on pl.personlinkid = r.personlinkid and
		 on pl.PersonLinkId = r.PersonLinkRelationshipId
	left join rbeal.dldimlookup l on r.relationshiptypeid = l.LookupID
	left join rbeal.dlDimPerson p on pl.LinkedPersonId = p.PersonID 
	left join rbeal.dlDimPerson p2 on pl.PrimaryPersonId = p2.PersonID


	union all

	select 5 AS company_id
	,pl.PersonLinkId + 5000000 as client_relationship_id
	,pl.PrimaryPersonId as primary_client_id
	,p2.PersonFirstName primary_first_name
	,p2.PersonLastName primary_last_name
	,l.LookupText as relationship
	,pl.LinkedPersonId as related_client_id
	,p.PersonFirstName related_first_name
	,p.PersonLastName related_last_name
	,r.PersonLinkRelationshipStartDate as relationship_start_date
	,r.PersonLinkRelationshipEndDate as relationship_end_date

	from rbmnb.dlfactPersonlink pl
	left join rbmnb.dlFactPersonLinkRelationship r 
		--on pl.personlinkid = r.personlinkid and
		 on pl.PersonLinkId = r.PersonLinkRelationshipId
	left join rbmnb.dldimlookup l on r.relationshiptypeid = l.LookupID
	left join rbmnb.dlDimPerson p on pl.LinkedPersonId = p.PersonID 
	left join rbmnb.dlDimPerson p2 on pl.PrimaryPersonId = p2.PersonID

	--Order by p2.PersonLastName, p2.PersonFirstName
