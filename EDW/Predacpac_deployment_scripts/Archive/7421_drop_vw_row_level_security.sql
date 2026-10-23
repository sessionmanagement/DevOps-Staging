
IF EXISTS ( SELECT name from sys.views where name = 'vw_row_level_security')
	BEGIN
		DROP VIEW [edw].[vw_row_level_security]
	END;
GO