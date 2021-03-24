/* Практическое задание #2. */
/* Задание # 2.
 * Создайте базу данных example, разместите в ней таблицу users, 
 состоящую из двух столбцов, числового id и строкового name.
*/
-- создание базы данных
CREATE DATABASE IF NOT EXISTS example;
-- создание таблицы users
CREATE TABLE users (id INT, name VARCHAR(100));
CREATE TABLE IF NOT EXISTS users (id INT, name VARCHAR(100));

