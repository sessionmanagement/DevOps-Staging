CREATE SCHEMA [landing]
    AUTHORIZATION [dbo];




























GO
GRANT UPDATE
    ON SCHEMA::[landing] TO [eal_etl_role];


GO
GRANT SELECT
    ON SCHEMA::[landing] TO [eal_etl_role];


GO
GRANT INSERT
    ON SCHEMA::[landing] TO [eal_etl_role];


GO
GRANT EXECUTE
    ON SCHEMA::[landing] TO [eal_etl_role];


GO
GRANT DELETE
    ON SCHEMA::[landing] TO [eal_etl_role];


GO
GRANT ALTER
    ON SCHEMA::[landing] TO [eal_etl_role];

