




CREATE     VIEW [ETL].[fact_client_address_history]

as

SELECT 1 AS company_key
	,fa.EntityID AS client_id
	,fa.AddressID AS client_address_id
	,fa.addressname AS client_address_name
	,fa.addressline1 AS client_address_line1
	,fa.addressline2 AS client_address_line2
	,fa.addressline3 AS client_address_line3
	,fa.addresssuburb AS client_address_suburb
	,fa.addresstowncity AS client_address_town_or_city
	,fa.addresspostcode AS client_address_post_code
	,FORMAT(ISNULL(cast(fa.addresscreateddate AS DATE), '2999-12-31'), 'yyyyMMdd') AS client_address_created_date
	,FORMAT(ISNULL(cast(fa.AddressStartDate AS DATE), '1901-01-01'), 'yyyyMMdd') AS client_address_start_date
	,FORMAT(ISNULL(cast(fa.AddressEndDate AS DATE), '2999-12-31'), 'yyyyMMdd') AS client_address_end_date
	,fa.AddressIsPostalAddress AS client_address_is_postal_indicator
	,fa.AddressIsPrimaryAddress AS client_address_is_primary_indicator
FROM rbeal.dlfactaddress fa
WHERE fa.AddressID != '-99'

UNION

SELECT 5 AS company_key
	,fa.EntityID AS client_id
	,fa.AddressID AS client_address_id
	,fa.addressname AS client_address_name
	,fa.addressline1 AS client_address_line1
	,fa.addressline2 AS client_address_line2
	,fa.addressline3 AS client_address_line3
	,fa.addresssuburb AS client_address_suburb
	,fa.addresstowncity AS client_address_town_or_city
	,fa.addresspostcode AS client_address_post_code
	,FORMAT(ISNULL(cast(fa.addresscreateddate AS DATE), '2999-12-31'), 'yyyyMMdd') AS client_address_created_date
	,FORMAT(ISNULL(cast(fa.AddressStartDate AS DATE), '1901-01-01'), 'yyyyMMdd') AS client_address_start_date
	,FORMAT(ISNULL(cast(fa.AddressEndDate AS DATE), '2999-12-31'), 'yyyyMMdd') AS client_address_end_date
	,fa.AddressIsPostalAddress AS client_address_is_postal_indicator
	,fa.AddressIsPrimaryAddress AS client_address_is_primary_indicator
FROM rbmnb.dlfactaddress fa
WHERE fa.AddressID != '-99'

