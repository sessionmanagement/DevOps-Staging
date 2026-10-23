CREATE SCHEMA [staging]
    AUTHORIZATION [dbo];




























GO
GRANT UPDATE
    ON SCHEMA::[staging] TO [eal_etl_role];


GO
GRANT SELECT
    ON SCHEMA::[staging] TO [eal_etl_role];


GO
GRANT INSERT
    ON SCHEMA::[staging] TO [eal_etl_role];


GO
GRANT EXECUTE
    ON SCHEMA::[staging] TO [eal_etl_role];


GO
GRANT DELETE
    ON SCHEMA::[staging] TO [eal_etl_role];


GO
GRANT ALTER
    ON SCHEMA::[staging] TO [eal_etl_role];

