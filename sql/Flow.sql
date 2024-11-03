WITH moderator_list AS (
    SELECT
        u.id moderator_id,
        u.username AS moderator,
        lead_mod.username AS lead_moderator
    FROM
        auth_user u
        LEFT JOIN reputation_userreputation repu ON repu.user_id = u.id
        LEFT JOIN auth_user lead_mod ON lead_mod.id = repu.moderator_id
    WHERE
        u.is_active
        AND repu.recruited
        AND repu.content_manager_id = '2651710' -- CM is Mislav
),
ec_list AS (
    SELECT DISTINCT
        ec.id AS ec_id,
        ec.username AS contributor,
        ml.moderator
    FROM
        auth_user ec
        LEFT JOIN reputation_userreputation repu ON repu.user_id = ec.id
        INNER JOIN moderator_list ml ON repu.moderator_id = ml.moderator_id
    WHERE
        repu.recruited
),
solution_created AS (
    SELECT
        (sol.created_on::date) AS date,
        ec.moderator,
        count(distinct ec.ec_id) AS ec_created,
    count(DISTINCT sol.id) AS sol_count
FROM
    solutions_solution sol
    INNER JOIN ec_list ec ON ec.ec_id = sol.user_id
        LEFT JOIN solutions_exerciseingroup eig ON eig.exercise_id = sol.exercise_id
        LEFT JOIN discussion_question q ON q.related_exercise_id = sol.exercise_id
    WHERE
        sol.active
        AND (eig.id IS NOT NULL
            OR q.id IS NOT NULL)
        AND (sol.created_on >= CURRENT_DATE -1
            AND sol.created_on < CURRENT_DATE)
    GROUP BY
        date,
        ec.moderator
    ORDER BY
        date
),
solution_moderated AS (
    SELECT
        (ms.created_on::date) AS date,
        mod.moderator,
        count(DISTINCT ec.id) AS ec_moderated,
        count(DISTINCT ms.solution_id) AS moderated_solutions,
        count(DISTINCT ms.solution_id) FILTER (WHERE ms.moderation_type = 'a') AS approved_solutions,
        count(DISTINCT ms.solution_id) FILTER (WHERE ms.moderation_type IN ('sb', 'r')) AS rejected_solutions,
        ROUND(AVG(DATE_PART('day', ms.created_on - soldata.modified_on))::numeric, 2) AS lead_time
    FROM
        moderator_solutionmoderated ms
        INNER JOIN moderator_list mod ON mod.moderator_id = ms.moderator_id
        INNER JOIN solutions_solution sol ON sol.id = ms.solution_id
        INNER JOIN auth_user ec ON ec.id = sol.user_id
        INNER JOIN solutions_solutiondata soldata ON soldata.solution_id = sol.id
    WHERE
        ms.created_on >= CURRENT_DATE -1
        AND ms.created_on < CURRENT_DATE
    GROUP BY
        date,
        mod.moderator
    ORDER BY
        date,
        mod.moderator
)
SELECT
    sc.date::text AS date,
    count(DISTINCT ml.moderator) AS total_moderators,
    sum(sc.ec_created) AS total_ec_created,
    sum(sc.sol_count) AS total_sol_count,
    sum(sm.ec_moderated) AS total_ec_moderated,
    sum(sm.moderated_solutions) AS total_moderated_sol,
    sum(sm.approved_solutions) AS total_approved_sol,
    sum(sm.rejected_solutions) AS total_rejected_sol,
    round(avg(sm.lead_time), 2) AS overall_lead_time,
    ARRAY_AGG(ROW (
      ml.moderator, 
      sc.ec_created, 
      sc.sol_count, 
      sm.ec_moderated, 
      sm.moderated_solutions, 
      sm.approved_solutions, 
      sm.rejected_solutions, 
      sm.lead_time)::text) AS data_array
FROM
    moderator_list ml
    LEFT JOIN solution_created sc ON sc.moderator = ml.moderator
    LEFT JOIN solution_moderated sm ON sm.moderator = ml.moderator
        AND sc.date = sm.date
WHERE
    sc.date IS NOT NULL
    AND ml.moderator IS NOT NULL
GROUP BY
    sc.date
ORDER BY
    sc.date
