-- Написать запрос для переименования названий типов медиа (колонка name в media_types), которые вы получили в пункте 3 в осмысленные (например, в "фото", "видео", ...).


 -- Table structure for table `media`
--

DROP DATABASE IF EXISTS medias;

CREATE DATABASE medias;


USE medias;


DROP TABLE IF EXISTS `media_types`;

CREATE TABLE `media_types` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


--
-- Dumping data for table `media_types`
--

LOCK TABLES `media_types` WRITE;

INSERT INTO `media_types` VALUES (4,'cupiditate'),(1,'ipsa'),(2,'neque'),(3,'ut');

UNLOCK TABLES;


UPDATE media_types SET name = 'музыка' WHERE id = 4;
UPDATE media_types SET name = 'фото' WHERE id = 3;
UPDATE media_types SET name = 'видео' WHERE id = 2;
UPDATE media_types SET name = 'аудиокниги' WHERE id = 1;

SELECT * FROM media_types;

