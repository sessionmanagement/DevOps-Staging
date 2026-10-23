CREATE SCHEMA [kpi]
    AUTHORIZATION [dbo];






GO
GRANT UPDATE
    ON SCHEMA::[kpi] TO [eal_etl_role];


GO
GRANT SELECT
    ON SCHEMA::[kpi] TO [eal_etl_role];


GO
GRANT INSERT
    ON SCHEMA::[kpi] TO [eal_etl_role];


GO
GRANT EXECUTE
    ON SCHEMA::[kpi] TO [eal_etl_role];


GO
GRANT DELETE
    ON SCHEMA::[kpi] TO [eal_etl_role];


GO
GRANT ALTER
    ON SCHEMA::[kpi] TO [eal_etl_role];

