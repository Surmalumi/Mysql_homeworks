-- 1. Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, catalogs и products в таблицу logs помещается время и дата создания записи, название таблицы, идентификатор первичного ключа и содержимое поля name.


DROP DATABASE IF EXISTS logs;
CREATE DATABASE logs;
use logs;


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



DROP TRIGGER IF EXISTS catalogs_logs;
DELIMITER //
CREATE TRIGGER catalogs_logs AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
	INSERT INTO logs (table_name, id, name, created_at)
	VALUES ('catalogs', NEW.id, NEW.name, NOW());
END //
DELIMITER ;


DROP TRIGGER IF EXISTS products_logs;
DELIMITER //
CREATE TRIGGER products_logs AFTER INSERT ON products
FOR EACH ROW
BEGIN
	INSERT INTO logs (table_name, id, name, created_at)
	VALUES ('products', NEW.id, NEW.name, NOW());
END //
DELIMITER ;