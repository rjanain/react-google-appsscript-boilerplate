select u.id moderator_id,
       u.username as moderator,
       lead_mod.username as lead_moderator
from auth_user u
left join reputation_userreputation repu on repu.user_id = u.id
left join auth_user lead_mod on lead_mod.id = repu.moderator_id
where u.is_active
    and repu.recruited
    and repu.content_manager_id = '2651710' -- CM is Mislav
order by lead_moderator