CREATE    procedure [TapuiWaka].[GetHighwaterForTapuiWakaasset_trip]
as 
begin
-- Because all the cars are lumped together i have to get the min date for all of them as the highwater mark
	select
		ISNULL(MIN(max_start_timestamp), '1900-01-01 00:00:00') as HighwaterValue 
	 from TapuiWaka.asset as a
	 inner join 
		(
			SELECT asset_id,  MAX(start_timestamp) as max_start_timestamp from TapuiWaka.asset_trip group by asset_id
		)
	 as at on a.asset_id = at.asset_id
	 where a.ODSIsCurrent = 1
	 and a.ODSDMLOperation  <> 'D'

end