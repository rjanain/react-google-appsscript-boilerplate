
with moderated_solutions_stats as (
SELECT
    mod.username AS moderator,
    au.username AS contributor,
    count(distinct ms.solution_id) as moderated_solutions,
    count(DISTINCT ms.solution_id) FILTER (WHERE ms.moderation_type = 'a') AS approved_solutions,
    count(DISTINCT ms.solution_id) FILTER (WHERE ms.moderation_type IN ('sb', 'r')) AS rejected_solutions,
    ROUND(AVG(CURRENT_DATE - soldata.modified_on::date-1),2) AS average_moderation_time
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
    au.username
)
select 
(CURRENT_DATE -1)::text AS date,
count(distinct moderator) as total_moderator,
count(distinct contributor) as total_contributor, 
sum(moderated_solutions) as total_moderated_solutions, 
sum(approved_solutions) as total_approved_solutions,
sum(rejected_solutions) as total_rejected_solutions, 
ROUND(AVG(average_moderation_time),2) as overall_average_moderation_time,
 ARRAY_AGG(
        ROW(
          moderator, contributor, moderated_solutions, 
          approved_solutions, rejected_solutions, average_moderation_time)::TEXT
    ) AS data_array
from moderated_solutions_stats



/*
PREPARE my_query(date, date) AS
    with moderated_solutions_stats as (
      SELECT
          mod.username AS moderator,
          au.username AS contributor,
          count(distinct ms.solution_id) as moderated_solutions,
          count(DISTINCT ms.solution_id) FILTER (WHERE ms.moderation_type = 'a') AS approved_solutions,
          count(DISTINCT ms.solution_id) FILTER (WHERE ms.moderation_type IN ('sb', 'r')) AS rejected_solutions,
          ROUND(AVG(CURRENT_DATE - soldata.modified_on::date-1),2) AS average_moderation_time
      FROM
          moderator_solutionmoderated ms
          INNER JOIN auth_user mod ON mod.id = ms.moderator_id
          INNER JOIN solutions_solution sol ON sol.id = ms.solution_id
          INNER JOIN auth_user au ON sol.user_id = au.id
          INNER JOIN solutions_solutiondata soldata on soldata.solution_id = sol.id 
      WHERE
          ms.created_on >= $1  
          AND ms.created_on < $2
      GROUP BY
          mod.id,
          au.id
      ORDER BY
          mod.username,
          au.username
      )
      select 
      ($1)::text AS date,
      count(distinct moderator) as total_moderator,
      count(distinct contributor) as total_contributor, 
      sum(moderated_solutions) as total_moderated_solutions, 
      sum(approved_solutions) as total_approved_solutions,
      sum(rejected_solutions) as total_rejected_solutions, 
      ROUND(AVG(average_moderation_time),2) as overall_average_moderation_time,
       ARRAY_AGG(
              ROW(
                moderator, contributor, moderated_solutions, 
                approved_solutions, rejected_solutions, average_moderation_time)::TEXT
          ) AS data_array
      from moderated_solutions_stats;

-- EXECUTE my_query(CURRENT_DATE-1, CURRENT_DATE);
EXECUTE my_query(CURRENT_DATE-8, CURRENT_DATE-7);
*/