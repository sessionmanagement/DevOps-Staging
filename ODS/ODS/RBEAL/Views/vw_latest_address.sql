create view [RBEAL].vw_latest_address as (SELECT  [AddressID]
      ,[AddressName]
      ,[AddressLine1]
      ,[AddressLine2]
      ,[AddressLine3]
      ,[AddressSuburb]
      ,[AddressTownCity]
      ,[CountryID]
      ,[AddressPostCode]
      ,[AddressIsPostalAddress]
      ,[AddressMapReference]
      ,[AddressEntityType]
      ,[EntityID]
      ,[AddressCreatedDate]
      ,[AddressCreatedUserID]
      ,[AddressIsPrimaryAddress],
	  row_number () over (partition by [EntityID] order by [EntityID], [AddressID],[AddressCreatedDate] desc) as row_order
  FROM [RBEAL].[dlFactAddress]
 
  )