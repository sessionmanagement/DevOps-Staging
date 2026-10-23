CREATE SCHEMA [logging]
    AUTHORIZATION [dbo];


GO
GRANT UPDATE
    ON SCHEMA::[logging] TO [eal_etl_role];


GO
GRANT SELECT
    ON SCHEMA::[logging] TO [eal_etl_role];


GO
GRANT INSERT
    ON SCHEMA::[logging] TO [eal_etl_role];


GO
GRANT EXECUTE
    ON SCHEMA::[logging] TO [eal_etl_role];


GO
GRANT DELETE
    ON SCHEMA::[logging] TO [eal_etl_role];


GO
GRANT ALTER
    ON SCHEMA::[logging] TO [eal_etl_role];

