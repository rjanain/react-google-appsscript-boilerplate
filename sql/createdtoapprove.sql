SeekWell updated 21721 rows at 2023-12-20 14:47:21

View this block at app.seekwell.io/run/ff6ef38d306d4a988f3eee4013c22ee7

SQL:
with masters_subjects as (
select distinct
        t.id as id,
        t.title,
        first_value(sub.name) over (partition by t.id order by x.order_num) as subject
  from solutions_textbook t
        join solutions_displaytextbook dt on dt.textbook_id = t.id
        left join solutions_textbook_subjects tsubs on tsubs.textbook_id = t.id
        left join subjects_subject sub on sub.id = tsubs.subject_id
        left join ((values ('play', 1), ('poem', 2), ('film', 3), ('movies', 4), ('autobiography', 5), ('short story', 6), ('novel', 7), ('art', 8), ('elementary education', 9), ('education', 10), ('criminal law', 11), ('administrative law', 12), ('civil law', 13), ('comparative law', 14), ('civics', 15), ('Political Science', 16), ('ethics', 17), ('neuroscience', 18), ('immunology', 19), ('cardiology', 20), ('pathology', 21), ('psychiatry', 22), ('anatomy and physiology', 23), ('genetics', 24), ('optometry', 25), ('nutrition', 26), ('public health', 27), ('health', 28), ('accounting', 29), ('econometrics', 30), ('managerial economics', 31), ('macroeconomics', 32), ('microeconomics', 33), ('finance', 34), ('international economics', 35), ('marketing', 36), ('advertising', 37), ('management', 38), ('business', 39), ('US government', 40), ('biological anthropology', 41), ('anthropology', 42), ('sociology', 43), ('abnormal psychology', 44), ('cognitive psychology', 45), ('biological psychology', 46), ('psychology', 47), ('linguistics', 48), ('literature', 49), ('literature and english', 50), ('english', 51), ('music theory', 52), ('music', 53), ('scientific history', 54), ('US history', 55), ('european history', 56), ('modern history', 57), ('ancient history', 58), ('world history', 59), ('spanish', 60), ('french', 61), ('german', 62), ('latin', 63), ('foreign languages', 64), ('geology', 65), ('geography of north america', 66), ('geography', 67), ('social sciences', 68), ('life science', 69), ('biotechnology', 70), ('civil engineering', 71), ('materials science', 72), ('electrical engineering', 73), ('mechanical engineering', 74), ('software engineering', 75), ('computer architecture', 76), ('engineering', 77), ('ecology', 78), ('animal science', 79), ('environmental science', 80), ('astronomy', 81), ('inorganic chemistry', 82), ('organic chemistry', 83), ('chemistry', 84), ('marine biology', 85), ('microbiology', 86), ('molecular biology', 87), ('cell biology', 88), ('human biology', 89), ('biology', 90), ('physics', 91), ('oceanography', 92), ('physical science', 93), ('sports', 94), ('earth science', 95), ('computer science', 96), ('economics', 97), ('abstract algebra', 98), ('complex variables', 99), ('differential equations', 100), ('linear algebra', 101), ('statistics', 102), ('probability', 103), ('calculus', 104), ('discrete math', 105), ('finite math', 106), ('analysis', 107), ('college algebra', 108), ('precalculus', 109), ('algebra 2', 110), ('geometry', 111), ('algebra', 112), ('integrated math', 113), ('trigonometry', 114), ('business math', 115), ('pre-algebra', 116), ('advanced mathematics', 117), ('math foundations', 118), ('high school math', 119), ('upper level math', 120), ('vocabulary', 121), ('critical reading', 122), ('humanities', 123), ('business studies', 124), ('AP', 125), ('IB', 126), ('SAT', 127), ('A Level', 128), ('vocational', 129), ('history', 130), ('science', 131), ('math', 132), ('animals', 133), ('more languages', 134), ('fun', 135), ('College Prep', 136), ('Solving Equations', 137), ('other', 138), ('more', 139))) as x (subject, order_num) on x.subject = sub.name
  where
    t.is_master
    and t.isbn ilike '978%%'
)

select 
      mod.username as moderator_username,
      extract(epoch from (msm.modified_on - sol.created_on))/(60 * 60 * 24) as date_difference_days,
      case
       when ms.subject is not null then ms.subject
       when qsub.name is not null then qsub.name
       else ''
      end as sub
from solutions_solution sol 
  join moderator_solutionmoderated msm on msm.solution_id = sol.id
  join auth_user mod on mod.id = moderator_id
  left join discussion_question q on q.related_exercise_id = sol.exercise_id
  left join subjects_subject qsub on qsub.id = q.subject_id 
  left join solutions_exerciseingroup eg on eg.exercise_id = sol.exercise_id
  left join solutions_textbookexercisegroup teg on teg.id = eg.group_id
  left join solutions_textbook tb on tb.id = teg.textbook_id
  left join masters_subjects ms on ms.id = tb.id
where 
  DATE(sol.created_on) >= '2023-05-03'
  and sol.active and sol.status = 'a'
  and msm.moderation_type = 'a'
  and mod.username NOT IN ('kuldeep.singh', 'niika.bobnar', 'anjumonsahin', 'markovukadinovic94', 'kuldeep8', 'SarahSchrijvers', 'this.guy', 'mdymsantiago', 'mare.aladrovic') 
  AND DATE(msm.modified_on) >= '2023-12-13'
  AND DATE(msm.modified_on) <= '2023-12-19'
;

-- change weekly:  DATE(msm.modified_on) >= '2023-05-24'

