-- Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, 
-- который больше всех общался с нашим пользователем.
-- наш пользователь имеет id = 1
	
SELECT 
from_user_id,
COUNT(*) as cnt
FROM messages WHERE from_user_id IN 
-- выбираем друзей    
(SELECT initiator_user_id FROM friend_requests WHERE (target_user_id = 1) AND status='approved'
    union
    SELECT target_user_id FROM friend_requests WHERE (initiator_user_id = 1) AND status='approved'
)
and to_user_id = 1
GROUP BY from_user_id  -- группировка 
ORDER BY from_user_id DESC -- обратная сортриовка
LIMIT 1;
		

-- Подсчитать общее количество лайков, которые получили пользователи младше 10 лет.







-- Определить кто больше поставил лайков (всего): мужчины или женщины.