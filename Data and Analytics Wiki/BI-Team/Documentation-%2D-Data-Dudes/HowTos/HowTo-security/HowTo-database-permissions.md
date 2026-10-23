

SELECT 
    role_members.role_principal_id,
    member.name AS user_name,
    member.type_desc AS user_type,
    role.name AS role_name,
    role.type_desc AS role_type,
    perm.permission_name,
    perm.state_desc AS permission_state,
    perm.class_desc,
    CASE 
        WHEN perm.class_desc = 'OBJECT_OR_COLUMN' THEN SCHEMA_NAME(obj.schema_id)
        WHEN perm.class_desc = 'SCHEMA' THEN s.name
        ELSE NULL
    END AS schema_name,
    CASE 
        WHEN perm.class_desc = 'OBJECT_OR_COLUMN' THEN OBJECT_NAME(perm.major_id)
        ELSE NULL
    END AS object_name
FROM 
    sys.database_role_members AS role_members
left JOIN 
    sys.database_principals AS role
    ON role_members.role_principal_id = role.principal_id
left JOIN 
    sys.database_principals AS member
    ON role_members.member_principal_id = member.principal_id
LEFT JOIN 
    sys.database_permissions AS perm
    ON perm.grantee_principal_id = role.principal_id
LEFT JOIN 
    sys.objects AS obj
    ON perm.major_id = obj.object_id
LEFT JOIN 
    sys.schemas AS s
    ON perm.major_id = s.schema_id

--where role_members.role_principal_id = 6
where member.name = 'ACG-SQL DB-sqldb-prod-datawarehouse-01_report_readers'
ORDER BY 
    role_name, permission_name;