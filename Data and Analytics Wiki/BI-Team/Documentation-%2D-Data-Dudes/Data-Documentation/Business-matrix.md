     
| table_name | dim_business_unit_hierarchy_key | dim_certification_key | dim_client_activity_breakdown_type_key | dim_client_key | dim_client_personal_goal_action_status_key | dim_client_personal_goal_status_key | dim_client_referral_key | dim_client_team_key | dim_company_key | dim_course_key | dim_department_key | dim_district_key | dim_employee_key | dim_ethnicity_key | dim_finance_budget_holder_key | dim_finance_contract_key | dim_finance_customer_key | dim_finance_funder_key | dim_finance_funding_agency_key | dim_finance_general_ledger_account_key | dim_finance_vendor_key | dim_gender_key | dim_leave_type_key | dim_location_key | dim_offered_property_key | dim_payroll_categories_key | dim_payroll_category_key | dim_people_hierarchy_key | dim_powerbi_activity_type_key | dim_program_key | dim_property_detail_key | dim_property_healthy_homes_key | dim_property_key | dim_property_maintenace_type_key | dim_property_maintenance_key | dim_property_program_key | dim_property_tenancy_key | dim_region_key | dim_role_hierarchy_key | dim_service_key | dim_void_category_k |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| fact_client_account_activity |  |  |  |  |  |  |  | 1 | 1 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | 1 |  |
| fact_client_activity_breakdown |  |  | 1 | 1 |  |  | 1 | 1 | 1 |  |  |  | 1 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | 1 |  |
| fact_client_address_history |  |  |  | 1 |  |  |  |  | 1 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| fact_client_assessment_outcome |  |  |  | 1 |  |  | 1 | 1 | 1 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| fact_client_person_relationship |  |  |  | 1 |  |  | 1 | 1 | 1 |  |  |  | 1 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | 1 |  |
| fact_client_personal_goal |  |  |  | 1 | 1 | 1 | 1 |  | 1 |  |  |  | 1 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| fact_client_referral |  |  |  | 1 |  |  | 1 | 1 | 1 |  |  |  | 1 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | 1 |  |
| fact_client_referral_goal |  |  |  | 1 |  |  | 1 |  | 1 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| fact_client_referral_V2 |  |  |  | 1 |  |  | 1 | 1 | 1 |  |  |  | 1 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | 1 |  |
| fact_employee_certification_progress | 1 | 1 |  |  |  |  |  |  |  |  |  |  | 1 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | 1 |  |
| fact_employee_course_progress | 1 |  |  |  |  |  |  |  |  | 1 |  |  | 1 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | 1 |  |
| fact_employee_hours_worked |  |  |  |  |  |  |  |  | 1 |  |  |  | 1 | 1 |  |  |  |  |  |  |  |  | 1 |  |  |  | 1 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| fact_employee_leave | 1 |  |  |  |  |  |  |  | 1 |  |  |  | 1 | 1 |  |  |  |  |  |  |  |  | 1 |  |  |  | 1 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| fact_employee_program_progress | 1 |  |  |  |  |  |  |  |  |  |  |  | 1 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | 1 |  |  |  |  |  |  |  |  |  | 1 |  |
| fact_employee_remuneration |  |  |  |  |  |  |  |  | 1 |  |  |  | 1 | 1 |  |  |  |  |  |  |  |  |  | 1 |  | 1 |  | 1 |  |  |  |  |  |  |  |  |  |  | 1 | 1 |  |
| fact_finance_budget |  |  |  |  |  |  |  |  | 1 |  | 1 | 1 |  |  | 1 | 1 | 1 | 1 | 1 | 1 | 1 |  |  | 1 |  |  |  |  |  |  |  |  |  |  |  |  |  | 1 |  | 1 |  |
| fact_finance_customer_ledger |  |  |  |  |  |  |  |  | 1 |  | 1 | 1 |  |  | 1 | 1 | 1 | 1 | 1 | 1 | 1 |  |  | 1 |  |  |  |  |  |  |  |  |  |  |  |  |  | 1 |  | 1 |  |
| fact_finance_general_ledger |  |  |  |  |  |  |  |  | 1 |  | 1 | 1 |  |  | 1 | 1 | 1 | 1 | 1 | 1 | 1 |  |  | 1 |  |  |  |  |  |  |  |  |  |  |  |  |  | 1 |  | 1 |  |
| fact_finance_vendor_ledger |  |  |  |  |  |  |  |  | 1 |  | 1 | 1 |  |  | 1 | 1 |  | 1 | 1 | 1 | 1 |  |  | 1 |  |  |  |  |  |  |  |  |  |  |  |  |  | 1 |  | 1 |  |
| fact_powerbi_activity_log |  |  |  |  |  |  |  |  |  |  |  |  | 1 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | 1 |  |  |  |  |  |  |  |  |  |  |  |  |
| fact_property_hazard |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | 1 |  |  |  |  |  |  |  |  |
| fact_property_inspection |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | 1 | 1 | 1 |  | 1 |  | 1 |  |  |  |  |
| fact_property_maintenance_task |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | 1 | 1 | 1 | 1 | 1 | 1 | 1 |  |  |  |  |
| fact_property_risk |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | 1 |  |  |  | 1 |  |  |  |  |
| fact_property_tenancy_transaction |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | 1 | 1 | 1 |  |  | 1 | 1 |  |  |  |  |
| fact_property_tenant |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | 1 |  |  |  |  |  |  |  |  | 1 | 1 | 1 |  |  | 1 | 1 |  |  |  |  |
| fact_void_checklist |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | 1 |  |  |  |  |  |  |  | 1 |  |  |  | 1 |  |  |  |  |