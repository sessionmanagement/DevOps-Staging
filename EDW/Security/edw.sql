CREATE SCHEMA [edw]
    AUTHORIZATION [dbo];




























GO
GRANT SELECT
    ON SCHEMA::[edw] TO [eal_report_reader_role];


GO
GRANT UPDATE
    ON SCHEMA::[edw] TO [eal_etl_role];


GO
GRANT SELECT
    ON SCHEMA::[edw] TO [eal_etl_role];


GO
GRANT INSERT
    ON SCHEMA::[edw] TO [eal_etl_role];


GO
GRANT EXECUTE
    ON SCHEMA::[edw] TO [eal_etl_role];


GO
GRANT DELETE
    ON SCHEMA::[edw] TO [eal_etl_role];


GO
GRANT ALTER
    ON SCHEMA::[edw] TO [eal_etl_role];

