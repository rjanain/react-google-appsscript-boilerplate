WITH master_subject AS (
      SELECT DISTINCT
            sub.id,
            x.subject,
            x.subject_group,
            x.order_num
      FROM
            subjects_subject sub
            LEFT JOIN ((
                        VALUES ('play', 'Humanities', 1),
('poem', 'Humanities', 2),
('film', 'Art', 3),
('movies', 'Art', 4),
('autobiography', 'Literature', 5),
('short story', 'Art', 6),
('novel', 'Literature', 7),
('art', 'Art', 8),
('elementary education', 'Education', 9),
('education', 'Education', 10),
('criminal law', 'Law', 11),
('administrative law', 'Law', 12),
('civil law', 'Law', 13),
('comparative law', 'Law', 14),
('civics', 'Social Science', 15),
('Political Science', 'Social Science', 16),
('ethics', 'Philosophy', 17),
('neuroscience', 'Science', 18),
('immunology', 'Science', 19),
('cardiology', 'Medicine', 20),
('pathology', 'Medicine', 21),
('psychiatry', 'Medicine', 22),
('anatomy and physiology', 'Medicine', 23),
('genetics', 'Biology', 24),
('optometry', 'Medicine', 25),
('nutrition', 'Health', 26),
('public health', 'Health', 27),
('health', 'Health', 28),
('accounting', 'Business', 29),
('econometrics', 'Economics', 30),
('managerial economics', 'Economics', 31),
('macroeconomics', 'Economics', 32),
('microeconomics', 'Economics', 33),
('finance', 'Business', 34),
('international economics', 'Economics', 35),
('marketing', 'Business', 36),
('advertising', 'Business', 37),
('management', 'Business', 38),
('business', 'Business', 39),
('US government', 'Political Science', 40),
('biological anthropology', 'Anthropology', 41),
('anthropology', 'Anthropology', 42),
('sociology', 'Social Science', 43),
('abnormal psychology', 'Psychology', 44),
('cognitive psychology', 'Psychology', 45),
('biological psychology', 'Psychology', 46),
('psychology', 'Psychology', 47),
('linguistics', 'Humanities', 48),
('literature', 'Humanities', 49),
('literature and english', 'Humanities', 50),
('english', 'Language', 51),
('music theory', 'Music', 52),
('music', 'Music', 53),
('scientific history', 'History', 54),
('US history', 'History', 55),
('european history', 'History', 56),
('modern history', 'History', 57),
('ancient history', 'History', 58),
('world history', 'History', 59),
('spanish', 'Language', 60),
('french', 'Language', 61),
('german', 'Language', 62),
('latin', 'Language', 63),
('foreign languages', 'Language', 64),
('geology', 'Geology', 65),
('geography of north america', 'Geography', 66),
('geography', 'Geography', 67),
('social sciences', 'Social Science', 68),
('life science', 'Biology', 69),
('biotechnology', 'Science', 70),
('civil engineering', 'Engineering', 71),
('materials science', 'Engineering', 72),
('electrical engineering', 'Engineering', 73),
('mechanical engineering', 'Engineering', 74),
('software engineering', 'Computer Science', 75),
('computer architecture', 'Computer Science', 76),
('engineering', 'Engineering', 77),
('ecology', 'Environmental Science', 78),
('animal science', 'Biology', 79),
('environmental science', 'Environmental Science', 80),
('astronomy', 'Science', 81),
('inorganic chemistry', 'Chemistry', 82),
('organic chemistry', 'Chemistry', 83),
('chemistry', 'Chemistry', 84),
('marine biology', 'Biology', 85),
('microbiology', 'Biology', 86),
('molecular biology', 'Biology', 87),
('cell biology', 'Biology', 88),
('human biology', 'Biology', 89),
('biology', 'Biology', 90),
('physics', 'Physics', 91),
('oceanography', 'Science', 92),
('physical science', 'Science', 93),
('sports', 'Sports', 94),
('earth science', 'Geology', 95),
('computer science', 'Computer Science', 96),
('economics', 'Economics', 97),
('abstract algebra', 'Mathematics', 98),
('complex variables', 'Mathematics', 99),
('differential equations', 'Mathematics', 100),
('linear algebra', 'Mathematics', 101),
('statistics', 'Mathematics', 102),
('probability', 'Mathematics', 103),
('calculus', 'Mathematics', 104),
('discrete math', 'Mathematics', 105),
('finite math', 'Mathematics', 106),
('analysis', 'Mathematics', 107),
('college algebra', 'Mathematics', 108),
('precalculus', 'Mathematics', 109),
('algebra 2', 'Mathematics', 110),
('geometry', 'Mathematics', 111),
('algebra', 'Mathematics', 112),
('integrated math', 'Mathematics', 113),
('trigonometry', 'Mathematics', 114),
('business math', 'Business', 115),
('pre-algebra', 'Mathematics', 116),
('advanced mathematics', 'Mathematics', 117),
('math foundations', 'Mathematics', 118),
('high school math', 'Education', 119),
('upper level math', 'Mathematics', 120),
('vocabulary', 'Language', 121),
('critical reading', 'Humanities', 122),
('humanities', 'Humanities', 123),
('business studies', 'Business', 124),
('AP', 'Education', 125),
('IB', 'Education', 126),
('SAT', 'Education', 127),
('A Level', 'Education', 128),
('vocational', 'Vocational', 129),
('history', 'History', 130),
('science', 'Science', 131),
('math', 'Mathematics', 132),
('animals', 'Biology', 133),
('more languages', 'Language', 134),
('fun', 'Entertainment', 135),
('College Prep', 'Education', 136),
('Solving Equations', 'Mathematics', 137),
('other', 'Miscellaneous', 138),
('more', 'Miscellaneous', 139))) AS x(subject, subject_group, order_num) ON sub.name = x.subject
            ORDER BY
                  order_num
),
moderator_list AS (
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
            COALESCE(tbsub.subject, qsub.subject, tsubs.subject_id::text, q.subject_id::text) AS subject_name,
      count(DISTINCT ec.ec_id) AS ec_created,
      count(DISTINCT sol.id) AS sol_count
FROM
      solutions_solution sol
      INNER JOIN ec_list ec ON ec.ec_id = sol.user_id
            AND sol.created_on >= CURRENT_DATE -1
            AND sol.created_on < CURRENT_DATE
      LEFT JOIN solutions_exerciseingroup eig ON eig.id = sol.source_eig_id
            LEFT JOIN discussion_question q ON q.related_exercise_id = sol.exercise_id
            LEFT JOIN master_subject qsub ON qsub.id = q.subject_id
            LEFT JOIN solutions_textbookexercisegroup teig ON teig.id = eig.group_id
            LEFT JOIN solutions_textbook_subjects tsubs ON tsubs.textbook_id = teig.textbook_id
            LEFT JOIN master_subject tbsub ON tbsub.id = tsubs.subject_id
      WHERE
            sol.active
            AND (eig.id IS NOT NULL
                  OR q.id IS NOT NULL)
      GROUP BY
            date,
            ec.moderator,
            subject_name
),
solution_moderated AS (
      SELECT
            (ms.created_on::date) AS date,
            mod.moderator,
            COALESCE(tbsub.subject, qsub.subject, tsubs.subject_id::text, q.subject_id::text) AS subject_name,
            count(DISTINCT ec.id) AS ec_moderated,
            count(DISTINCT ms.solution_id) AS moderated_solutions,
            count(DISTINCT ms.solution_id) FILTER (WHERE ms.moderation_type = 'a') AS approved_solutions,
            count(DISTINCT ms.solution_id) FILTER (WHERE ms.moderation_type IN ('sb', 'r')) AS rejected_solutions,
            ROUND(AVG(DATE_PART('day', ms.created_on - soldata.modified_on))::numeric, 2) AS lead_time
      FROM
            moderator_solutionmoderated ms
            INNER JOIN moderator_list mod ON mod.moderator_id = ms.moderator_id
            INNER JOIN solutions_solution sol ON sol.id = ms.solution_id
                  AND sol.active
            INNER JOIN auth_user ec ON ec.id = sol.user_id
            INNER JOIN solutions_solutiondata soldata ON soldata.solution_id = sol.id
            LEFT JOIN solutions_exerciseingroup eig ON eig.id = sol.source_eig_id
            LEFT JOIN discussion_question q ON q.related_exercise_id = sol.exercise_id
            LEFT JOIN master_subject qsub ON qsub.id = q.subject_id
            LEFT JOIN solutions_textbookexercisegroup teig ON teig.id = eig.group_id
            LEFT JOIN solutions_textbook_subjects tsubs ON tsubs.textbook_id = teig.textbook_id
            LEFT JOIN master_subject tbsub ON tbsub.id = tsubs.subject_id
      WHERE
            ms.created_on >= CURRENT_DATE -1
            AND ms.created_on < CURRENT_DATE
      GROUP BY
            date,
            mod.moderator,
            subject_name)
      -- Main Query
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
      ARRAY_AGG(ROW (ml.moderator, sc.ec_created, sc.sol_count, sm.ec_moderated, sm.moderated_solutions, sm.approved_solutions, sm.rejected_solutions, sm.lead_time, sc.subject_name)::text) AS data_array
FROM
      moderator_list ml
      LEFT JOIN solution_created sc ON sc.moderator = ml.moderator
      LEFT JOIN solution_moderated sm ON sm.moderator = ml.moderator
            AND sc.date = sm.date
            AND sc.subject_name = sm.subject_name
WHERE
      sc.date IS NOT NULL
GROUP BY
      sc.date
ORDER BY
      sc.date
