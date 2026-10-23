
--drop view [Akoranga].[vw_certification_path]
CREATE VIEW [Akoranga].[vw_certification_path] AS
WITH SplitPath AS (
    SELECT 
        ctx.id,ctx.context_level,
        base.id AS course_id,
        base.full_name,
        ctx.parent_id,
        ctx.depth,
        ctx.path,
        value,
        ROW_NUMBER() OVER (PARTITION BY ctx.id ORDER BY (SELECT NULL)) AS part
    FROM 
        [Akoranga].mdl_prog base
        INNER JOIN [Akoranga].mdl_context ctx
            ON ctx.instance_id = base.id --AND ctx.context_level in (45,50)
        CROSS APPLY STRING_SPLIT(ctx.path, '/')
    WHERE 
        base.ODSIsCurrent = 1 
        AND ctx.ODSIsCurrent = 1
        AND value <> ''
)
SELECT 
    course_id,context_level,
    id,
    full_name,
    parent_id,
    depth,
    path,
    MAX(CASE WHEN part = 1 THEN value END) AS part1,
    MAX(CASE WHEN part = 2 THEN value END) AS part2,
    MAX(CASE WHEN part = 3 THEN value END) AS part3,
	MAX(CASE WHEN part = 4 THEN value END) AS part4,
	MAX(CASE WHEN part = 5 THEN value END) AS part5
FROM 
    SplitPath
GROUP BY 
    course_id,context_level, id, full_name, parent_id, depth, path
	 ;