WITH moderator_list AS (
    SELECT
        u.id,
        u.username,
        lead_mod.username AS lead_moderator
    FROM
        auth_user u
        LEFT JOIN reputation_userreputation repu ON repu.user_id = u.id
        LEFT JOIN auth_user lead_mod ON lead_mod.id = repu.moderator_id
    WHERE
        u.is_active
        AND repu.recruited
        AND repu.content_manager_id = '2651710' -- cm is Mislav
),
moderated_solutions_stats AS (
    SELECT
        ms.created_on::date AS work_date,
        mod.username AS moderator,
        -- au.username AS contributor,
        count(DISTINCT ms.solution_id) AS moderated_solutions,
    count(DISTINCT ms.solution_id) FILTER (WHERE ms.moderation_type = 'a') AS approved_solutions,
    count(DISTINCT ms.solution_id) FILTER (WHERE ms.moderation_type IN ('sb', 'r')) AS rejected_solutions,
    ROUND(AVG(ms.created_on::date - soldata.modified_on::date ), 2) AS lead_time,
    count(DISTINCT sol.id) FILTER (WHERE DATE_PART('day', ms.created_on - soldata.modified_on) BETWEEN -2 AND 7) AS lead_within_7days,
    count(DISTINCT sol.id) FILTER (WHERE DATE_PART('day', ms.created_on - soldata.modified_on) BETWEEN 8 AND 15) AS lead_7to15days,
    count(DISTINCT sol.id) FILTER (WHERE DATE_PART('day', ms.created_on - soldata.modified_on) BETWEEN 16 AND 30) AS lead_15to30days,
    count(DISTINCT sol.id) FILTER (WHERE DATE_PART('day', ms.created_on - soldata.modified_on) > 30) AS lead_monthlong
FROM
    moderator_solutionmoderated ms
    INNER JOIN moderator_list ml ON ml.id = ms.moderator_id
    INNER JOIN auth_user mod ON mod.id = ms.moderator_id
    INNER JOIN solutions_solution sol ON sol.id = ms.solution_id
    --  INNER JOIN auth_user au ON sol.user_id = au.id
    INNER JOIN solutions_solutiondata soldata ON soldata.solution_id = sol.id
    WHERE
        ms.created_on >= CURRENT_DATE -1
        AND ms.created_on < CURRENT_DATE
    GROUP BY
        ms.created_on::date,
        mod.username
    ORDER BY
        mod.username
)
SELECT
    work_date::text AS date,
    count(DISTINCT moderator) AS total_moderator,
    sum(moderated_solutions) AS total_moderated_solutions,
    sum(approved_solutions) AS total_approved_solutions,
    sum(rejected_solutions) AS total_rejected_solutions,
    ROUND(AVG(lead_time), 2) AS overall_lead_time,
    sum(lead_within_7days) AS leadcounti,
    sum(lead_7to15days) AS leadcountii,
    sum(lead_15to30days) AS leadcountiii,
    sum(lead_monthlong) AS leadcountiv,
    ARRAY_AGG(ROW (moderator, moderated_solutions, approved_solutions, rejected_solutions, lead_time, lead_within_7days, lead_7to15days, lead_15to30days, lead_monthlong)::text) AS data_array
FROM
    moderated_solutions_stats
GROUP BY
    work_date
ORDER BY
    work_date ASC
