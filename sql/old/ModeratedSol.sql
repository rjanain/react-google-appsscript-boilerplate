/* This query retrieves information on solution 
    moderated by each moderator for each contributor on the previous day.
    - Date of the previous day
    - Moderator Username
    - EC username
    - Number of Approved Solution on that day
    - Number of Rejected Solution on that day
    - Average day Taken to moderate that solution

    Note: To calculate average day taken to moderate we use 
            solutions_solutiondata modfication date 
            as the solutions_solution modification date also gets updated 
            whenever a solution moderation status changed. 
 */
SELECT
    (CURRENT_DATE -1)::text AS date,
    mod.username AS moderator,
    au.username AS contributor,
    count(distinct ms.solution_id) as no_moderated_solutions,
    count(DISTINCT ms.solution_id) FILTER (WHERE ms.moderation_type = 'a') AS no_approved_solutions,
    count(DISTINCT ms.solution_id) FILTER (WHERE ms.moderation_type IN ('sb', 'r')) AS no_rejected_solutions,
    AVG(CURRENT_DATE - soldata.modified_on::date-1) AS average_moderation_time
FROM
    moderator_solutionmoderated ms
    INNER JOIN auth_user mod ON mod.id = ms.moderator_id
    INNER JOIN solutions_solution sol ON sol.id = ms.solution_id
    INNER JOIN auth_user au ON sol.user_id = au.id
    INNER JOIN solutions_solutiondata soldata on soldata.solution_id = sol.id 
WHERE
    ms.created_on >= CURRENT_DATE -1
    AND ms.created_on < CURRENT_DATE
GROUP BY
    mod.id,
    au.id
ORDER BY
    mod.username,
    au.username;

