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
        ec.is_active
        AND repu.recruited
),
solutionmoderated AS (
    SELECT
        u.moderator,
        ms.created_on::date AS date,
        count(DISTINCT ms.solution_id) AS moderated_solutions
    FROM
        moderator_list u
        LEFT JOIN moderator_solutionmoderated ms ON ms.moderator_id = u.moderator_id
    WHERE
        ms.created_on::date >= CURRENT_DATE -121
        AND ms.created_on::date < CURRENT_DATE
    GROUP BY
    date,u.moderator
),
ec_hoursworked AS (
    SELECT
        ec.moderator,
        pu.date,
        sum(pu.hours) AS hours
    FROM
        payment_userhoursworked AS pu
        LEFT JOIN ec_list ec ON ec.ec_id = pu.user_id
    WHERE
        pu.date >= CURRENT_DATE -121
        AND pu.date < CURRENT_DATE
    GROUP BY
        pu.date,
        ec.moderator
),
hoursworked AS (
    SELECT
        pu.user_id,
        pu.hourly_rate,
        pu.hours,
        pu.date AS work_date,
        UNNEST(STRING_TO_ARRAY(pu.notes, ';')) AS project_entry
    FROM
        payment_userhoursworked AS pu
        LEFT JOIN moderator_list mod ON pu.user_id = mod.moderator_id
    WHERE
        pu.date >= CURRENT_DATE -121
        AND pu.date < CURRENT_DATE
),
moderation_stats AS (
    SELECT
        hw.work_date,
        mod.moderator,
        avg(hw.hourly_rate) AS hourly_rate,
        avg(hw.hours) as hours,
        SUM(CAST(substring(hw.project_entry, 'moderating_[^,]+, hours: ([0-9]+\.?[0-9]*)') AS numeric)) AS moderation_time,
        SUM(CAST(substring(hw.project_entry, 'moderating_[^,]+, hours: ([0-9]+\.?[0-9]*)') AS numeric) * hw.hourly_rate) AS amount_spent
    FROM
        moderator_list mod
        LEFT JOIN hoursworked hw ON hw.user_id = mod.moderator_id
    GROUP BY
        hw.work_date,
        mod.moderator
)
SELECT
    ms.work_date::text AS date,
    sum(ms.hours) as total_hours,
    sum(ms.moderation_time) AS moderation_time,
    sum(ms.amount_spent) AS amount_spent,
    sum(sm.moderated_solutions) AS moderated_solutions,
    sum(hw.hours) AS ec_time,
    ARRAY_AGG(ROW (ms.moderator, ms.hourly_rate, ms.moderation_time, ms.amount_spent, sm.moderated_solutions, hw.hours,ms.hours)::text) AS data_array
FROM
    moderation_stats ms
    LEFT JOIN solutionmoderated sm ON sm.moderator = ms.moderator
        AND sm.date = ms.work_date
    LEFT JOIN ec_hoursworked hw ON ms.moderator = hw.moderator
        AND hw.date = ms.work_date
WHERE
    work_date IS NOT NULL
GROUP BY
    work_date
ORDER BY
    work_date;

