/* Тема курсового проекта: База данных и решаемые ею задачи на примере сайта Кинопоиск. Сайт Кинопоиск содержит в себе полную информацию о фильме, так же имеет оценки пользователей на фильмы. На странице содержится персональная информация о самих пользователях, их друзьях и отзывы пользователей на фильмы. */

DROP DATABASE IF EXISTS kinopoisk;

CREATE DATABASE kinopoisk;

USE kinopoisk;

SHOW tables;

DROP TABLE IF EXISTS `users`;

-- Таблица для пользователя

CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nick_name` varchar(145) NOT NULL,
  `first_name` varchar(145) DEFAULT NULL,
  `last_name` varchar(145) DEFAULT NULL,
  `email` varchar(145) NOT NULL,
  `phone` char(11) NOT NULL,
  `password_hash` char(65) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nick_name_idx` (`nick_name`),
  UNIQUE KEY `email_idx` (`email`),
  UNIQUE KEY `phone_idx` (`phone`),
  CONSTRAINT `phone_check` CHECK (regexp_like(`phone`,_utf8mb4'^[0-9]{11}$'))
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DESCRIBE users;

INSERT INTO users VALUES (DEFAULT, 'Utka333',  'Pavel', 'Pushkin', 'push15@mail.com', '89212221616', DEFAULT, DEFAULT);
INSERT INTO users VALUES (DEFAULT, 'Warlord1990', 'Vanya', 'Ivanov', 'Ivanov16@mail.com', '89212023320', DEFAULT, DEFAULT), (DEFAULT, 'Daisy25', 'Kate', 'Samsony', 'Daisy25@mail.com', '49202023311', DEFAULT, DEFAULT), (DEFAULT, 'CookiesX', 'Gail', 'Peterson', 'Cookies10@gmail.com', '69162023311', DEFAULT, DEFAULT), (DEFAULT, 'CleverForever', 'Norma', 'Neverpack', 'Luckygirl0@gmail.com', '19120233001', DEFAULT, DEFAULT), (DEFAULT, 'Machoman', 'Alex', 'Troy', 'Man10@gmail.com', '13440233771', DEFAULT, DEFAULT), (DEFAULT, 'Kitty200', 'Kate', 'Summer', 'Kate.S@gmail.com', '03120233011', DEFAULT, DEFAULT), (DEFAULT, 'Dron', 'TJ', 'Travis', 'Travis.T@gmail.com', '33150233005', DEFAULT, DEFAULT), (DEFAULT, 'CARL', 'PD', 'Sims', 'PD@gmail.com', '87150633149', DEFAULT, DEFAULT);

-- добавляю пользователя через SET
INSERT INTO users
SET nick_name = 'coolman2000',
    first_name = 'Max',
    last_name = 'Mad',
    email = 'cool2000@mail.com',
    phone = '89213541560';


SELECT * FROM users;

SHOW CREATE TABLE users; 

DROP TABLE IF EXISTS profiles;

-- Таблица с дополнительной информацией о пользователе. 

CREATE TABLE profiles (
  user_id BIGINT UNSIGNED NOT NULL PRIMARY KEY,
  gender ENUM('f', 'm', 'x') NOT NULL,
  birthday DATE NOT NULL,
  photo_id INT UNSIGNED,
  user_status VARCHAR(30),
  city VARCHAR(130),
  country VARCHAR(130),
  CONSTRAINT fk_profiles_users FOREIGN KEY (user_id) REFERENCES users (id)
);

DESCRIBE profiles;

ALTER TABLE profiles MODIFY COLUMN photo_id BIGINT UNSIGNED DEFAULT NULL UNIQUE;


-- Добавляю профили для уже созданных пользователей.
INSERT INTO profiles VALUES (1, 'm', '1981-11-11', NULL, NULL, 'St,Petersburg', 'Russia'); 
INSERT INTO profiles VALUES (2, 'm', '1960-05-22', NULL, NULL, 'Moscow', 'Russia'),
(3, 'x', '2000-01-01', NULL, NULL, 'Ekaterinburg', 'Russia'), (4, 'f', '1990-08-05', NULL, NULL, 'London', 'UK'), (5, 'x', '1980-05-02', NULL, NULL, 'New York', 'USA'), (6, 'f', '1982-12-22', NULL, NULL, 'Hamburg', 'Germany'), (7, 'm', '1985-04-01', NULL, NULL, 'Chester', 'UK'), (8, 'f', '1980-03-15', NULL, NULL, 'Barcelona', 'Spain'), (9, 'x', '1989-06-21', NULL, NULL, 'Amsterdam', 'Netherlands'), (10, 'x', '1990-11-03', NULL, NULL, 'Belgium', 'Brussel');

SELECT * FROM profiles;

-- вывожу возраст пользователя
SELECT user_id, TIMESTAMPDIFF(YEAR, birthday, NOW()) AS age
FROM profiles;

DROP TABLE IF EXISTS friend_requests;

-- таблица запроса в добавления в друзья на сайте.

CREATE TABLE friend_requests (
  from_user_id BIGINT UNSIGNED NOT NULL,
  to_user_id BIGINT UNSIGNED NOT NULL,
  accepted BOOLEAN DEFAULT False,
  PRIMARY KEY(from_user_id, to_user_id),
  INDEX fk_friend_requests_from_user_idx (from_user_id),
  INDEX fk_friend_requests_to_user_idx (to_user_id),
  CONSTRAINT fk_friend_requests_users_1 FOREIGN KEY (from_user_id) REFERENCES users (id),
  CONSTRAINT fk_friend_requests_users_2 FOREIGN KEY (to_user_id) REFERENCES users (id)
);

-- Получатель и отправитель запроса в добавление в друзья не одно и тоже лицо.

ALTER TABLE friend_requests 
ADD CONSTRAINT sender_not_reciever_check 
CHECK (from_user_id != to_user_id);


INSERT INTO friend_requests VALUES (1, 2, 1), (2, 1, 1),  (1, 3, 1),  (3, 1, 1),  (3, 2, 1),  (4, 2, 1),  (1, 4, 1),  (2, 4, 1),  (4, 3, 1),  (5, 2, 1),  (5, 1, 1),  (1, 5, 1),  (1, 6, 1),  (4, 6, 1),  (5, 6, 1),  (3, 6, 1),  (6, 2, 1),  (6, 5, 1);

SELECT * FROM friend_requests;

DROP TABLE IF EXISTS messages;

CREATE TABLE messages (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, -- id сообщения 
  from_user_id BIGINT UNSIGNED NOT NULL, -- от кого
  to_user_id BIGINT UNSIGNED NOT NULL, -- кому
  txt TEXT NOT NULL, -- текст
  is_delivered BOOLEAN DEFAULT False, -- доставлен или нет
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, -- когда создано
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
  INDEX fk_messages_from_user_idx (from_user_id),
  INDEX fk_messages_to_user_idx (to_user_id),
  CONSTRAINT fk_messages_users_1 FOREIGN KEY (from_user_id) REFERENCES users (id),
  CONSTRAINT fk_messages_users_2 FOREIGN KEY (to_user_id) REFERENCES users (id)
);

INSERT INTO messages VALUES (DEFAULT, 1, 2, 'Hi! This is very cool movie! you mush see it!', 1, DEFAULT, DEFAULT); 
INSERT INTO messages VALUES (DEFAULT, 2, 1, 'Hi. Thanks! I will see it on this weekend.', 1, DEFAULT, DEFAULT), (DEFAULT, 3, 1, 'This is a great movie.', 1, DEFAULT, DEFAULT), (DEFAULT, 5, 6, 'Can we go to the cinema on this weekend?.', 1, DEFAULT, DEFAULT), (DEFAULT, 6, 5, 'Of cause!', 1, DEFAULT, DEFAULT), (DEFAULT, 4, 5, 'Hi. Did you see this movie?.', 1, DEFAULT, DEFAULT), (DEFAULT, 5, 4, 'No. I will watch it on this weekend.', 1, DEFAULT, DEFAULT), (DEFAULT, 6, 1, 'I like film The Crow so much!', 1, DEFAULT, DEFAULT), (DEFAULT, 1, 6, 'I know. Me too.', 1, DEFAULT, DEFAULT), (DEFAULT, 1, 10, 'Please send me DVD with movie.', 1, DEFAULT, DEFAULT), (DEFAULT, 10, 8, 'I want to watch The Matrix on this evening.', 1, DEFAULT, DEFAULT), (DEFAULT, 9, 5, 'Please send me the song name from The Crow.', 1, DEFAULT, DEFAULT); 


SELECT * FROM messages;

DESCRIBE messages;


DROP TABLE IF EXISTS `movie`;

CREATE TABLE `movie` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT, -- id фильма
  `movie_name` varchar(145) NOT NULL, -- название фильма
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP, -- дата создания записи о фильме
  `year` year NOT NULL, -- год выпуска
  `country` varchar(130) DEFAULT NULL, -- страна фильма
  `photo_id` bigint unsigned DEFAULT NULL, -- фото фильма
  PRIMARY KEY (`id`),
  UNIQUE KEY `photo_id` (`photo_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10000 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO movie VALUES (DEFAULT, 'The Gentlemen', DEFAULT, '2019', 'USA', NULL);
INSERT INTO movie VALUES (DEFAULT, 'The Matrix',  DEFAULT, '1999', 'USA', NULL);

INSERT INTO movie VALUES 
(DEFAULT, 'Titanic', DEFAULT, '1997', 'USA', NULL), (DEFAULT, 'The Lord of the Rings: The Fellowship of the Ring', DEFAULT, '2001', 'New Zealand', NULL), (DEFAULT, 'The Green Mile', DEFAULT, '1999', 'USA', NULL), (DEFAULT, 'Forrest Gump', DEFAULT, '1994', 'USA', NULL), (DEFAULT, 'The Lion King', DEFAULT, '1994', 'USA', NULL), (DEFAULT, 'Back to the Future', DEFAULT, '1985', 'USA', NULL), (DEFAULT, 'Inception', DEFAULT, '2010', 'USA', NULL), (DEFAULT, 'Gentlemen of fortune', DEFAULT, '1971', 'USSR', NULL), (DEFAULT, 'Home Alone', DEFAULT, '1990', 'USA', NULL), (DEFAULT, 'City Lights', DEFAULT, '1931', 'USA', NULL), (DEFAULT, 'Harry Potter and the Sorcerers Stone', DEFAULT, '2001', 'UK', NULL),
(DEFAULT, 'Treasure island',  DEFAULT, '1988', 'USSR', NULL), (DEFAULT, 'The Crow', DEFAULT, '1994', 'USA', NULL);

SELECT * FROM movie;

-- Добавляю таблицу с видами жанров фильмов.

CREATE TABLE genre_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name varchar(45) NOT NULL UNIQUE -- 
) ENGINE=InnoDB;

-- Добавим типы в каталог
INSERT INTO genre_types VALUES (DEFAULT, 'Criminal'), (DEFAULT, 'Fantastic');
INSERT INTO genre_types VALUES (DEFAULT, 'Melodrama'), (DEFAULT, 'Fantasy'), (DEFAULT, 'Drama'), (DEFAULT, 'Adventure'), (DEFAULT, 'Comedy'), (DEFAULT, 'Cartoon'), (DEFAULT, 'Action');

SELECT * FROM genre_types;

CREATE TABLE movie_genres (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
  movie_id BIGINT UNSIGNED NOT NULL, -- id фильма
  genre_types_id INT UNSIGNED NOT NULL, 
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX genre_types_idx (genre_types_id),
  INDEX movie_genres_idx (id),
  CONSTRAINT fk_genre_types_movie_genres FOREIGN KEY (genre_types_id) REFERENCES genre_types (id),
  CONSTRAINT fk_movie_genres FOREIGN KEY (movie_id) REFERENCES movie (id)
);

INSERT INTO movie_genres VALUES (DEFAULT, '10000', 1, DEFAULT), (DEFAULT, '10001', 2, DEFAULT), (DEFAULT, '10001', 9, DEFAULT), (DEFAULT, '10002', 3, DEFAULT), (DEFAULT, '10003', 4, DEFAULT), (DEFAULT, '10004', 5, DEFAULT), (DEFAULT, '10005', 5, DEFAULT),  (DEFAULT, '10005', 6, DEFAULT),  (DEFAULT, '10006', 8, DEFAULT);
INSERT INTO movie_genres VALUES (DEFAULT, '10014', 5, DEFAULT), (DEFAULT, '10014', 9, DEFAULT), (DEFAULT, '10014', 4, DEFAULT);

SELECT * FROM movie_genres;

CREATE TABLE `makers` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `first_name` varchar(145) DEFAULT NULL,
  `last_name` varchar(145) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

INSERT INTO makers VALUES (DEFAULT, 'Guy', 'Ritchie', DEFAULT), (DEFAULT, 'Matthew', 'Anderson', DEFAULT), (DEFAULT, 'Christopher', 'Benstead', DEFAULT), (DEFAULT, 'Matthew', 'McConaughey', DEFAULT);
INSERT INTO makers VALUES (DEFAULT, 'Lana', 'Wachowski', DEFAULT), (DEFAULT, 'Lilly', 'Wachowski', DEFAULT), (DEFAULT, 'Joel', 'Silver', DEFAULT), (DEFAULT, 'Don', 'Davis', DEFAULT), (DEFAULT, 'Keanu', 'Reeves', DEFAULT), (DEFAULT, 'Carrie-Anne', 'Moss', DEFAULT);

INSERT INTO makers VALUES (DEFAULT, 'James', 'Cameron', DEFAULT), (DEFAULT, 'James', 'Horner', DEFAULT), (DEFAULT,'Kate', 'Winslet', DEFAULT), (DEFAULT,'Leonardo', 'DiCaprio', DEFAULT), (DEFAULT, 'Peter', 'Jackson', DEFAULT), (DEFAULT, 'Howard', 'Shore', DEFAULT), (DEFAULT, 'Ian', 'McKellen', DEFAULT), (DEFAULT, 'Elijah', 'Wood', DEFAULT), (DEFAULT, 'Frank', 'Darabont', DEFAULT), (DEFAULT, 'Thomas', 'Newman', DEFAULT), (DEFAULT, 'Tom', 'Hanks', DEFAULT), (DEFAULT, 'Robert', 'Zemeckis', DEFAULT), (DEFAULT, 'Wendy', 'Finerman', DEFAULT), (DEFAULT, 'Alan', 'Silvestri', DEFAULT), (DEFAULT, 'Roger', 'Allers', DEFAULT), (DEFAULT, 'Don', 'Hahn', DEFAULT), (DEFAULT, 'Hans', 'Zimmer', DEFAULT), (DEFAULT, 'Matthew', 'Broderick', DEFAULT), (DEFAULT, 'Jeremy', 'Irons', DEFAULT), (DEFAULT, 'Neil', 'Canton', DEFAULT), (DEFAULT, 'Michael', 'J. Fox', DEFAULT), (DEFAULT, 'Christopher', 'Lloyd', DEFAULT), (DEFAULT, 'Christopher', 'Nolan', DEFAULT),  (DEFAULT, 'Joseph', 'Gordon-Levitt', DEFAULT), (DEFAULT, 'Aleksander', 'Seryi', DEFAULT), (DEFAULT, 'Gennadiy', 'Gladkov', DEFAULT), (DEFAULT, 'Evgeniy', 'Leonov', DEFAULT), (DEFAULT, 'Georgiy', 'Vitsin', DEFAULT), (DEFAULT, 'Chris', 'Columbus', DEFAULT), (DEFAULT, 'Tarquin', 'Gotch', DEFAULT), (DEFAULT, 'John', 'Williams', DEFAULT), (DEFAULT, 'Macaulay', 'Culkin', DEFAULT), (DEFAULT, 'Joe', 'Pesci', DEFAULT), (DEFAULT, 'Charles', 'Chaplin', DEFAULT), (DEFAULT, 'Virginia', 'Cherrill', DEFAULT), (DEFAULT, 'Chris', 'Columbus', DEFAULT), (DEFAULT, 'Todd', 'Arnow', DEFAULT), (DEFAULT, 'John', 'Williams', DEFAULT), (DEFAULT, 'Daniel', 'Radcliffe', DEFAULT), (DEFAULT, 'Alan', 'Rickman', DEFAULT);
INSERT INTO makers VALUES (DEFAULT, 'David', 'Cherkasskiy', DEFAULT), (DEFAULT, 'Vladimir', 'Vystryakov', DEFAULT), (DEFAULT,'Vladimir', 'Zadneprovskiy', DEFAULT), (DEFAULT, 'Armen', 'Djigarhanyan', DEFAULT), (DEFAULT, 'Alex', 'Proyas', DEFAULT), (DEFAULT, 'Jeff', 'Most', DEFAULT), (DEFAULT, 'Graeme', 'Revell', DEFAULT), (DEFAULT, 'Brandon', 'Lee', DEFAULT);

SELECT * FROM makers;


-- Добавляю таблицу с видами должностей в фильме.

CREATE TABLE filmmakers_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name varchar(45) NOT NULL UNIQUE -- 
) ENGINE=InnoDB;

-- Добавим типы в каталог
INSERT INTO filmmakers_types VALUES (DEFAULT, 'director'), (DEFAULT, 'producer');
INSERT INTO filmmakers_types VALUES (DEFAULT, 'compositor'), (DEFAULT, 'actor'), (DEFAULT, 'screenwriter'), (DEFAULT, 'Mounting'), (DEFAULT, 'designer');

SELECT * FROM filmmakers_types;



CREATE TABLE filmmakers (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
  makers_id BIGINT UNSIGNED NOT NULL,
  movie_id BIGINT UNSIGNED NOT NULL, -- id фильма
  filmmakers_types_id INT UNSIGNED NOT NULL, 
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX filmmakers_filmmakers_types_idx (filmmakers_types_id),
  INDEX filmmakers_makers_idx (makers_id),
  CONSTRAINT fk_filmmakers_filmmakers_types FOREIGN KEY (filmmakers_types_id) REFERENCES filmmakers_types (id),
  CONSTRAINT fk_filmmakers_makers FOREIGN KEY (makers_id) REFERENCES makers (id),
  CONSTRAINT fk_filmmakers_movie FOREIGN KEY (movie_id) REFERENCES movie (id)
);

-- Добавим принимающих участие в фильме людей и соединим их с должностью и фильмом.
INSERT INTO filmmakers VALUES (DEFAULT, 1, 10000, 1,  DEFAULT), (DEFAULT, 55, 10014, 1,  DEFAULT), (DEFAULT, 56, 10014, 2,  DEFAULT), (DEFAULT, 57, 10014, 3,  DEFAULT), (DEFAULT, 58, 10014, 4,  DEFAULT);
INSERT INTO filmmakers VALUES (DEFAULT, 2, 10000, 2,  DEFAULT), (DEFAULT, 11, 10002, 1,  DEFAULT), (DEFAULT, 11, 10002, 2,  DEFAULT), (DEFAULT, 11, 10002, 3,  DEFAULT), (DEFAULT, 12, 10002, 4,  DEFAULT), (DEFAULT, 13, 10002, 4,  DEFAULT);
INSERT INTO filmmakers VALUES (DEFAULT, 3, 10000, 3,  DEFAULT), (DEFAULT, 4, 10000, 4,  DEFAULT), (DEFAULT, 4, 10001, 1,  DEFAULT), (DEFAULT, 5, 10001, 1,  DEFAULT), (DEFAULT, 6, 10001, 1,  DEFAULT), (DEFAULT, 7, 10001, 2,  DEFAULT), (DEFAULT, 8, 10001, 3,  DEFAULT), (DEFAULT, 9, 10001, 4,  DEFAULT), (DEFAULT, 10, 10001, 4,  DEFAULT);

SELECT * FROM filmmakers;

-- Узнаем количество задейстовованных в фильме людей, каждой должности, для каждого фильма.

SELECT COUNT(*),
       (SELECT name FROM filmmakers_types WHERE id = filmmakers.filmmakers_types_id) AS name,
       makers_id, movie_id
FROM filmmakers
GROUP BY filmmakers_types_id, makers_id
ORDER BY makers_id;



-- добавляем оценку фильму.
DROP TABLE IF EXISTS `range`;

CREATE TABLE `ranges` (
ranges_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
rating INT(11) CHECK(rating >= 1 AND rating <= 10) NOT NULL,
movie_id BIGINT UNSIGNED NOT NULL, -- id фильма
user_id BIGINT UNSIGNED NOT NULL, -- id пользователя
created_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- когда поставили оценку
PRIMARY KEY(ranges_id, user_id, movie_id),
INDEX ranges_idx (ranges_id),
INDEX ranges_movie_idx (movie_id),
CONSTRAINT users_ranges_fk FOREIGN KEY (user_id) REFERENCES users (id),
-- CONSTRAINT movie_ranges_fk FOREIGN KEY (ranges_id) REFERENCES movie (id),
CONSTRAINT fk_ranges FOREIGN KEY (movie_id) REFERENCES movie (id)); 

INSERT INTO ranges VALUES (DEFAULT, 9, 10000, 2, DEFAULT), (DEFAULT, 8, 10001, 1, DEFAULT), (DEFAULT, 10, 10014, 1, DEFAULT), (DEFAULT, 9, 10010, 1, DEFAULT), (DEFAULT, 8, 10009, 2, DEFAULT), (DEFAULT, 9, 10005, 6, DEFAULT), (DEFAULT, 10, 10011, 10, DEFAULT), (DEFAULT, 8, 10007, 7, DEFAULT), (DEFAULT, 9, 10005, 10, DEFAULT), (DEFAULT, 8, 10000, 5, DEFAULT), (DEFAULT, 8, 10010, 3, DEFAULT), (DEFAULT, 7, 10002, 2, DEFAULT), (DEFAULT, 7, 10002, 1, DEFAULT), (DEFAULT, 9, 10013, 9, DEFAULT), (DEFAULT, 8, 10003, 9, DEFAULT), (DEFAULT, 10, 10013, 5, DEFAULT), (DEFAULT, 7, 10013, 2, DEFAULT), (DEFAULT, 9, 10014, 8, DEFAULT), (DEFAULT, 9, 10012, 2, DEFAULT), (DEFAULT, 7, 10009, 4, DEFAULT); 


SELECT * FROM ranges;

-- считаю количество фильмов по каждому жанру с названиями жанра
SELECT COUNT(*), genre_types_id
FROM movie_genres
GROUP BY genre_types_id;

DROP TABLE IF EXISTS media_types;

-- Виды медиафайлов которые могут быть у фильмов.

CREATE TABLE media_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name varchar(45) NOT NULL UNIQUE
) ENGINE=InnoDB;


INSERT INTO media_types VALUES (DEFAULT, 'изображение');
INSERT INTO media_types VALUES (DEFAULT, 'видео');

SELECT * FROM media_types;

DROP TABLE IF EXISTS media;

-- Таблица с медиафайлами к фильмам.

CREATE TABLE media (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  movie_id BIGINT UNSIGNED NOT NULL,
  media_types_id INT UNSIGNED NOT NULL, 
  file_name VARCHAR(245) DEFAULT NULL COMMENT '/files/folder/img.png',
  file_size BIGINT UNSIGNED,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX media_media_types_idx (media_types_id),
  INDEX media_movie_idx (movie_id),
  CONSTRAINT fk_media_media_types FOREIGN KEY (media_types_id) REFERENCES media_types (id),
  CONSTRAINT fk_media_users FOREIGN KEY (movie_id) REFERENCES movie (id)
);


INSERT INTO media VALUES (DEFAULT, 10000, 1, 'im.jpg', 100, DEFAULT), (DEFAULT, 10001, 1, 'im1.png', 78, DEFAULT), (DEFAULT, 10000, 2, 'trailer1.mov', 500, DEFAULT);
INSERT INTO media VALUES (DEFAULT, 10001, 2, 'trail1.avi', 600, DEFAULT), (DEFAULT, 10013, 2, 'trailerz1.avi', 602, DEFAULT), (DEFAULT, 10011, 1, 'img1.png', 45, DEFAULT), (DEFAULT, 10005, 1, 'img2.png', 49, DEFAULT), (DEFAULT, 10008, 1, 'img1.jpg', 71, DEFAULT), (DEFAULT, 10008, 1, 'imgs.jpg', 76, DEFAULT), (DEFAULT, 10007, 1, 'img2.jpg', 91, DEFAULT), (DEFAULT, 10004, 1, 'img6.jpg', 88, DEFAULT), (DEFAULT, 10004, 1, 'img7.jpg', 85, DEFAULT),  (DEFAULT, 10005, 1, 'img2.png', 88, DEFAULT),  
(DEFAULT, 10010, 2, 'trailers1.avi', 610, DEFAULT), (DEFAULT, 10010, 2, 'trailers19.mov', 690, DEFAULT), (DEFAULT, 10010, 2, 'trailers11.mov', 600, DEFAULT), (DEFAULT, 10011, 2, 'trailers0.avi', 590, DEFAULT), (DEFAULT, 10013, 2, 'trailers11.avi', 505, DEFAULT), (DEFAULT, 10005, 2, 'trailers5.avi', 450, DEFAULT), (DEFAULT, 10006, 2, 'trailers55.avi', 480, DEFAULT);

SELECT * FROM media;

-- таблица с отзывами на фильм.

CREATE TABLE reviews (
	movie_id BIGINT UNSIGNED NOT NULL, -- id фильма
	user_id BIGINT UNSIGNED NOT NULL, -- id автора отзыва
    txt TEXT NOT NULL, -- текст отзыва, не может быть пустым
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- когда отзыв создали
	updated_at DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP, -- когда отзыв обновили
	PRIMARY KEY (movie_id, user_id), -- PK по отзыву и пользователю, чтобы гарантировать, что пользователь может оставить только один отзыв
	INDEX movie_idx (movie_id), -- индекс для быстрого поиска по фильму, чтобы найти всех, кто оставил отзыв
	INDEX user_idx (user_id), -- индекс для быстрого поиска по пользователю, чтобы найти все его отзывы
	CONSTRAINT reviews_fk FOREIGN KEY (movie_id) REFERENCES movie (id), -- связь с таблицей movie
	CONSTRAINT users_reviews_fk FOREIGN KEY (user_id) REFERENCES users (id) -- связь с таблицей users
);

SHOW CREATE TABLE reviews; 


INSERT INTO reviews VALUES (10014, 2, 'I approached this film after reading the hype and controversy surrounding its making and release, not really expecting very much. ', DEFAULT, DEFAULT); -- Пользователь 2 оставил отзыв на фильм 10014
INSERT INTO reviews VALUES (10014, 6, 'This movie is fantastic. plain and simple. Brandon Lee delivers his lines to the point they were instantly memorable after seeing the film only once.', DEFAULT, DEFAULT); -- Пользователь 6 оставил отзыв на фильм 10014
INSERT INTO reviews VALUES (10014, 3, 'This is one amazing film, with a mesmerizing performance from Brandon Lee!', DEFAULT, DEFAULT), (10010, 2, 'All my family likes this movie! Watching it every year.', DEFAULT, DEFAULT), (10011, 3, 'I love this film very much', DEFAULT, DEFAULT), (10001, 3, 'It is so crazy.', DEFAULT, DEFAULT),  (10001, 1, 'Excellent action movie.', DEFAULT, DEFAULT), (10006, 6, 'My favorite cartoon for ever!', DEFAULT, DEFAULT), (10002, 4, 'Beautiful love and iceberg.', DEFAULT, DEFAULT), (10009, 3, 'So funny movie. Watching it every new year.', DEFAULT, DEFAULT), (10012, 1, 'It is mu favorite film and book!', DEFAULT, DEFAULT), (10007, 4, 'Doc was my favorite person in this movie.', DEFAULT, DEFAULT);

SELECT * FROM reviews;

-- Посчитаю количество медиафайлов каждого типа для каждого фильма.

SELECT COUNT(*),
       (SELECT name FROM media_types WHERE id = media.media_types_id) AS name,
       movie_id
FROM media
GROUP BY media_types_id, movie_id
ORDER BY movie_id;

-- вывожу все сообщения пользователя id = 1 и сортирую по дате
SELECT from_user_id, to_user_id, txt, is_delivered, created_at
FROM messages
WHERE from_user_id = 1 OR to_user_id = 1
ORDER BY created_at DESC;

-- вывожу данные пользователей.
SELECT users.first_name, users.last_name, profiles.birthday, profiles.gender 
FROM users
	INNER JOIN profiles ON users.id = profiles.user_id;
    
-- Определяю кто больше оставил отзывов(рецензий) всего.

SELECT profiles.gender, COUNT(reviews.movie_id) AS total_reviews-- считаем количество лайков по каждому полу
FROM reviews
    JOIN profiles
      ON reviews.user_id = profiles.user_id -- соединяем рецензии на фильмы с их авторами
GROUP BY profiles.gender -- группируем по полу
ORDER BY total_reviews DESC; -- сортирую по количеству рецензий
-- LIMIT 1; -- так как у всех одинаковое количество получилось постов, то ограничения убираю.

-- Смотрим какую активность проявляют пользователи на сайте(в общем). 

SELECT users.id,
  COUNT(DISTINCT messages.id) +  -- считаем количество отправленных сообщений
  COUNT(DISTINCT reviews.movie_id)  -- считаем количество рецензий для каждого пользователя,
   AS activity 
FROM users
    LEFT JOIN messages 
      ON users.id = messages.from_user_id -- выбираем все сообщения, написанные пользователем, если сообщений не писал - получаем NULL
    LEFT JOIN reviews
      ON users.id = reviews.movie_id -- выбираем все рецензии, оставленные пользователем, если рецензий нет - получаем NULL
GROUP BY users.id -- группируем по пользователю
ORDER BY activity; -- группируем по активности
-- LIMIT 2; -- можно выбрать самых неактивных

-- представление, выбирающее всех друзей пользователей
CREATE or replace VIEW view_friends
AS 
  SELECT u.id, u1.id AS friend_id, u1.first_name, u1.last_name
  FROM users AS u
  	JOIN friend_requests AS fr ON (u.id = fr.from_user_id OR u.id = to_user_id)
  	JOIN users AS u1 ON (u1.id = fr.from_user_id OR u1.id = to_user_id)
  WHERE u1.id != u.id
  ORDER BY u.id;
  
 -- смотрим на содержимое представления(выводим без повтора через Distinct)
SELECT DISTINCT id, friend_id, first_name, last_name
FROM view_friends;

-- представление, выбирающее все фильмы производства США

CREATE or replace VIEW USA_origin AS
SELECT movie_name, country
FROM movie as m
WHERE country = "USA";

SELECT * FROM USA_origin;

-- Создаю процедуру для рекомендации пользователю новых друзей, которые живут с ним в одной стране.

DROP PROCEDURE IF EXISTS sp_new_friendship;


DELIMITER //

CREATE PROCEDURE sp_new_friendship(IN for_user_id BIGINT UNSIGNED)
BEGIN
	SELECT p2.user_id AS user_id -- пользователи из одной страны
	FROM profiles p1
		JOIN profiles p2 ON p1.country = p2.country -- выбираем пользователей из той же страны, что и заданный пользователь
	WHERE p1.user_id = for_user_id  -- находим странузаданного пользователя
	    AND p2.user_id != for_user_id 
  ORDER BY RAND()
	LIMIT 3; -- выводим только 3 человек из рекомендаций
END // 

DELIMITER ;      


/*-- Создаю триггер, который при каждом создании записи в таблице users, в таблицу logs помещает время и дату создания записи, название таблицы, идентификатор первичного ключа и содержимое поля name.

DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
    table_name VARCHAR(100) NOT NULL,
    id BIGINT(10) NOT NULL,
    name VARCHAR(100) NOT NULL,
	created_at DATETIME NOT NULL
) ENGINE = ARCHIVE;


DROP TRIGGER IF EXISTS users_log;
DELIMITER //
CREATE TRIGGER users_log AFTER INSERT ON users
FOR EACH ROW
BEGIN
	INSERT INTO logs (table_name, id, name, created_at)
	VALUES ('users', NEW.id, NEW.name, NOW());
END //
DELIMITER ;
*/