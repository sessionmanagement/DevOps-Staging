--Rename the edw.dim_client_absence primary key column from ODSdim_client_absenceID to dim_client_absence_key
--have to drop the primary constraint before renaming rename the column and add the constrint back again


ALTER TABLE edw.dim_client_absence DROP CONSTRAINT PK__edw_dim_client_absence
go


EXEC sp_rename 'edw.dim_client_absence.ODSdim_client_absenceID', 'dim_client_absence_key', 'COLUMN';
go


ALTER TABLE edw.dim_client_absence ADD CONSTRAINT PK__edw_dim_client_absence PRIMARY KEY CLUSTERED (dim_client_absence_key);
go
