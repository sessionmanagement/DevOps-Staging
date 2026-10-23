
create view [RBEAL].[vw_latest_smokingstatus] as ( select fpsh.PersonID,dss.[SmokingStatusText],row_number () over (partition by fpsh.PersonID order by fpsh.PersonID, 
fpsh.personsmokinghistorycreateddate desc) as row_order FROM            RBEAL.dlFactPersonSmokingHistory fpsh
inner join [RBEAL].[dlDimSmokingStatus] dss
on fpsh.SmokingStatusId=dss.SmokingStatusID)
