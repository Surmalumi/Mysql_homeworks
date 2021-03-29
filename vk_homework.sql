CREATE DATEBASE vk_homework;

USE vk_homework;

SHOW Tables;


CREATE TABLE users (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(145) NOT NULL, 
  last_name VARCHAR(145) NOT NULL,
  email VARCHAR(145) NOT NULL,
  phone CHAR(11) NOT NULL,
  password_hash CHAR(65) DEFAULT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, 
  UNIQUE INDEX email_unique_idx (email),
  UNIQUE INDEX phone_unique_idx (phone)
) ENGINE=InnoDB;


INSERT INTO users VALUES (DEFAULT, 'Petya', 'Petukhov', 'petya@mail.com', '89212223334', DEFAULT, DEFAULT);
INSERT INTO users VALUES (DEFAULT, 'Vasya', 'Vasilkov', 'vasya@mail.com', '89212023334', DEFAULT, DEFAULT);


SELECT * FROM users;


DESCRIBE users;


SHOW CREATE TABLE users; 


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

INSERT INTO profiles VALUES (1, 'm', '1997-12-01', NULL, NULL, 'Moscow', 'Russia'); 
INSERT INTO profiles VALUES (2, 'm', '1988-11-02', NULL, NULL, 'Moscow', 'Russia'); 

SELECT * FROM profiles;



-- Создаю таблицу с видами учебных заведений.

CREATE TABLE education_list (
  education_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  institution_name varchar(100) NOT NULL UNIQUE -- название учебного заведения
) ENGINE=InnoDB;

DROP TABLE education_list;

INSERT INTO education_list VALUES (DEFAULT, 'School'); -- школы
INSERT INTO education_list VALUES (DEFAULT, 'College'); -- колледжи
INSERT INTO education_list VALUES (DEFAULT, 'University'); -- университеты

SELECT * FROM education_list;

-- Создаю таблицу учебных заведений к каждому профилю.

CREATE TABLE study (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
  user_id BIGINT UNSIGNED NOT NULL,
  education_list_id INT UNSIGNED NOT NULL, -- номер id в таблице с видами образовательных заведений.
  study_name VARCHAR(245) DEFAULT NULL, -- название учебного заведения
  institution_sity VARCHAR(100), -- город
  institution_country VARCHAR(100), -- страна
  INDEX study_education_list_idx (education_list_id), -- Индекс по номеру из таблицы с видами образовательных заведений.
  INDEX study_users_idx (user_id), -- индекс по user id
  CONSTRAINT fk_study_education_list FOREIGN KEY (education_list_id) REFERENCES education_list (id),
  CONSTRAINT fk_study_users FOREIGN KEY (user_id) REFERENCES users (id)
);

DROP TABLE study;

INSERT INTO study VALUES (DEFAULT, 1, 1, '1010', 'Vladivostok','Russia');
INSERT INTO study VALUES (DEFAULT, 1, 3, 'NGU', 'Novosibirsk','Russia');

INSERT INTO study VALUES (DEFAULT, 2, 2, 'Trinity', 'Dublin', 'Ireland');


SELECT * FROM study;



-- Создаю черный список.

CREATE TABLE black_list (
  from_user_id BIGINT UNSIGNED NOT NULL, -- от кого
  to_user_id BIGINT UNSIGNED NOT NULL, -- кому
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, -- время добавления в черный список
  PRIMARY KEY(from_user_id, to_user_id),
  INDEX fk_black_list_from_user_idx (from_user_id),
  INDEX fk_black_list_to_user_idx (to_user_id),
  CONSTRAINT fk_black_list_users_1 FOREIGN KEY (from_user_id) REFERENCES users (id),
  CONSTRAINT fk_black_list_users_2 FOREIGN KEY (to_user_id) REFERENCES users (id)
);

DESCRIBE black_list;

-- Добавляем в черный список
INSERT INTO black_list VALUES (1, 2, DEFAULT); - Петя добавляет Васю в черный список.

SELECT * FROM black_list;



CREATE TABLE media_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name varchar(45) NOT NULL UNIQUE -- изображение, музыка, документ
) ENGINE=InnoDB;

INSERT INTO media_types VALUES (DEFAULT, 'изображение');
INSERT INTO media_types VALUES (DEFAULT, 'музыка');
INSERT INTO media_types VALUES (DEFAULT, 'документ');


SELECT * FROM media_types;

-- Делаю таблицу с лайками. От отдного к многим или многих к многим? Со столбцами: От кого лайк, какому файлу лайк. Когда был поставлен лайк.
CREATE TABLE likes (
  likes_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, -- id самого лайка
  from_user_id BIGINT UNSIGNED NOT NULL, -- от кого лайк
  to_media_types INT UNSIGNED NOT NULL, -- к какому файлу лайк
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, -- время лайка
  INDEX likes_idx (likes_id),
  INDEX likes_from_user_idx (from_user_id),
  CONSTRAINT fk_likes_users FOREIGN KEY (from_user_id) REFERENCES users (id),
  CONSTRAINT fk_likes_media_types FOREIGN KEY (to_media_types_id) REFERENCES media_types (id)
);

DROP TABLE likes;

DESCRIBE likes;

INSERT INTO likes VALUES (DEFAULT, '1', '1', DEFAULT); -- лайк Пети к какой-то картинке,
INSERT INTO likes VALUES (DEFAULT, '2', '3', DEFAULT); -- лайк Васи к какому-то документу.

SELECT * FROM likes;


