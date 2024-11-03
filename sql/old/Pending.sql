/*
 Query to fetch pending solution statistics grouped by moderator, contributor, and content manager
 */
SELECT
    (CURRENT_DATE -1)::text AS date,
    mod.username AS moderator,
    count(DISTINCT sol.id) AS total_pending_solns,
    count(DISTINCT sol.id) FILTER (WHERE soldata.modified_on >= CURRENT_DATE -8
        AND soldata.modified_on < CURRENT_DATE) AS pending_solns_within_7days,
    count(DISTINCT sol.id) FILTER (WHERE soldata.modified_on >= CURRENT_DATE -16
        AND soldata.modified_on < CURRENT_DATE -8) AS pending_solns_7to15days,
    count(DISTINCT sol.id) FILTER (WHERE soldata.modified_on >= CURRENT_DATE -31
        AND soldata.modified_on < CURRENT_DATE -16) AS pending_solns_15to30days,
    count(DISTINCT sol.id) FILTER (WHERE soldata.modified_on < CURRENT_DATE -31) AS pending_solns_monthlong,
    min(sol.modified_on)::date::text AS first_sol_date,
    max(sol.modified_on)::date::text AS last_sol_date
FROM
    solutions_solution sol
    INNER JOIN solutions_solutiondata soldata ON soldata.solution_id = sol.id
    LEFT JOIN solutions_exerciseingroup eig ON eig.exercise_id = sol.exercise_id
    LEFT JOIN discussion_question q ON q.related_exercise_id = sol.exercise_id
    LEFT JOIN auth_user u ON u.id = sol.user_id
    LEFT JOIN reputation_userreputation rep ON rep.user_id = u.id
    LEFT JOIN auth_user mod ON mod.id = rep.moderator_id
    
WHERE sol.active and sol.status = 'rp' and (eig.id is not null or q.id is not null) 
AND rep.recruited
GROUP BY
    moderator
ORDER BY
    moderator,
    total_pending_solns DESC;

