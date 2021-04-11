-- 1. Пусть задан некоторый пользователь. Найдите человека, который больше всех общался с нашим пользователем, иначе, кто написал пользователю наибольшее число сообщений. (можете взять пользователя с любым id).



USE vk;

SHOW tables;

SELECT from_user_id, to_user_id, count(*)
FROM messages
WHERE  to_user_id = 1
GROUP BY from_user_id
;
-- Тут видно, что больше всего пользователь 1 общался с пользователем 2. Можно его вывести через LIMIT 1, но если бы это был пользователь 9, то так сделать было бы нельзя.


-- 2. Подсчитать общее количество лайков на посты, которые получили пользователи младше 18 лет.


SELECT count(post_id) AS total_likes 
FROM posts_likes 
WHERE like_type = 1 AND post_id IN (SELECT id FROM posts WHERE user_id IN (SELECT user_id FROM profiles WHERE YEAR(CURDATE()) - YEAR(birthday) < 18))




-- 3. Определить, кто больше поставил лайков (всего) - мужчины или женщины?
SELECT count(post_id) AS total_likes, like_type, group_concat(user_id) AS m 
FROM posts_likes 
WHERE (user_id) IN (SELECT (user_id) FROM profiles WHERE gender = 'm') AND like_type = 1


SELECT count(post_id) AS total_likes, like_type, group_concat(user_id) AS w
 FROM posts_likes 
 WHERE (user_id) IN (SELECT (user_id) FROM profiles WHERE gender = 'f') AND like_type = 1