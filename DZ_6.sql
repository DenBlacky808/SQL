-- Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, 
-- который больше всех общался с нашим пользователем.

-- Пусть наш пользователь имеет id = 1
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

SELECT SUM(cnt) likes FROM -- Найдем общее количество лайков
(SELECT COUNT(*) as cnt FROM likes WHERE user_id IN -- Посчитаем в Likes по user_id
(SELECT user_id FROM profiles WHERE TIMESTAMPDIFF(YEAR, birthday, NOW()) < 10) -- найдем user_id младше 10 лет 
GROUP BY user_id) as young; 


-- Определить кто больше поставил лайков (всего): мужчины или женщины.

SELECT
-- В зависимости от результата подсчетов выводим пол
   CASE 
     WHEN count_male > count_female THEN 'мужчины'
     WHEN count_male < count_female THEN 'женщины'
     ELSE 'другой'
   END as 'больше лайков поставили' -- название столбца
-- считаем лайки мужчин по user_id в profiles где пол 'm'
FROM (SELECT COUNT(*) AS count_male 
FROM likes WHERE user_id IN 
(SELECT user_id FROM profiles WHERE gender = 'm')) 
AS count_male_select,
-- считаем лайки женщин по user_id в profiles где пол 'm'
(SELECT COUNT(*) AS count_female FROM likes WHERE user_id IN 
(SELECT user_id FROM profiles WHERE gender = 'f')) 
AS count_fmale_select;

