CREATE TABLE [landing].[edw_fact_employee_incident] (
    [incident_id]                       NVARCHAR (4000) NULL,
    [incident_date]                     NVARCHAR (4000) NULL,
    [incident_reported_date]            NVARCHAR (4000) NULL,
    [investigation_start_date]          NVARCHAR (4000) NULL,
    [investigation_end_date]            NVARCHAR (4000) NULL,
    [incident_close_out_date]           NVARCHAR (4000) NULL,
    [actual_severity_gauge_score]       DECIMAL (18, 6) NULL,
    [ongoing_risk_gauge_score]          DECIMAL (18, 6) NULL,
    [number_of_times_incident_occurred] DECIMAL (18, 6) NULL,
    [incident_recordbase_detail]        NVARCHAR (4000) NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [fact_employee_incident]
    ON [landing].[edw_fact_employee_incident]([incident_id] ASC);

