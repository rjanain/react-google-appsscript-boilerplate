/**
 * This SQL query provides a expense report on the moderation activities  
 *
 * Detailed Breakdown:
 * - `moderator_list`: Identifies all active moderators  
 * - `hoursworked`: Extracts the working hours details for the last 120 days,
 *    including the split project entries from the `notes` field.
 * - `moderation_stats`: Aggregates the moderation activities  
 *
 * Output:
 * - `date`: The date for which the moderation data is aggregated.
 * - `total_moderation_time`: Total number of hours spent on moderation tasks for each day.
 * - `total_amount_spent`: Total amount spent on moderation tasks for each day,  
 * - `data_array`: An array of rows, each containing the moderator's username, their average hourly rate,
 *   moderation time, and amount spent for that day.
 */ 
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
 solutionmoderated as(
   select u.id,
   u.username,
   ms.created_on::date as date,
   count(distinct ms.solution_id) as moderated_solutions
   from moderator_list u 
   left join moderator_solutionmoderated ms on ms.moderator_id = u.id
  where   ms.created_on::date >= CURRENT_DATE-121
         and ms.created_on::date < CURRENT_DATE
   group by u.id, u.username, date
 ),
         hoursworked as
    (select pu.user_id,
            pu.hourly_rate,
            pu.date as work_date,
            UNNEST(STRING_TO_ARRAY(pu.notes, ';')) as project_entry
     from payment_userhoursworked as pu
     left join moderator_list mod on pu.user_id = mod.id
     where pu.date >= CURRENT_DATE-121
         and pu.date < CURRENT_DATE),
         moderation_stats as
    (SELECT hw.work_date,
            mod.username as moderator,
            avg(hw.hourly_rate) as hourly_rate,
            SUM(CAST(substring(hw.project_entry, 'moderating_[^,]+, hours: ([0-9]+\.?[0-9]*)') AS NUMERIC)) AS moderation_time,
            SUM(CAST(substring(hw.project_entry, 'moderating_[^,]+, hours: ([0-9]+\.?[0-9]*)') AS NUMERIC) * hw.hourly_rate) AS amount_spent
     FROM moderator_list mod
     LEFT JOIN hoursworked hw ON hw.user_id = mod.id
     group by hw.work_date,
              mod.username) -- Main Query

select ms.work_date::text as date,
       sum(ms.moderation_time) as moderation_time,
       sum(ms.amount_spent) as amount_spent,
       sum(sm.moderated_solutions) as moderated_solutions,
       ARRAY_AGG(
        ROW(
          ms.moderator,  ms.hourly_rate, ms.moderation_time,  ms.amount_spent, sm.moderated_solutions)::TEXT
    ) AS data_array
       /*
       json_agg(json_build_object(
        'moderator', moderator,
        'hourly_rate', hourly_rate,
        'moderation_time', moderation_time,
        'amount_spent', amount_spent
    )) AS data_array*/
from moderation_stats ms 
left join solutionmoderated sm on sm.username =ms.moderator and sm.date = ms.work_date 
where work_date is not null
group by work_date
order by work_date;

