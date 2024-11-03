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
    ORDER BY
        lead_moderator
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
        ) -- Main Query
    SELECT
        (sol.created_on::date)::text AS date,
        ec.moderator,  
        count(ec.ec_id) as ec_count,
        count(distinct sol.id) as sol_count
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
group by date, ec.moderator
order by date
