/*
Установите СУБД MySQL. Создайте в домашней директории файл .my.cnf,
 задав в нем логин и пароль, который указывался при установке.
 */

-- MySQL установил. Разместил файл my.cnf в домашней директории.

/*
Создайте базу данных example, разместите в ней таблицу users,
 состоящую из двух столбцов, числового id и строкового name.
*/
-- Создание бд если она не существует.
CREATE DATABASE IF NOT EXISTS example;
-- Удаляем таблицу если она существует
DROP TABLE IF EXISTS users;
-- Создаем таблицу
CREATE TABLE users (
id INT UNSIGNED,
name VARCHAR(255)
);
/*
Создайте дамп базы данных example из предыдущего задания,
 разверните содержимое дампа в новую базу данных sample.
*/
-- Создание БД sample
CREATE DATABASE IF NOT EXISTS sample;
-- в командной строке 
-- mysqldump example > mysql.sql
-- mysql sample < mysql.sql

/*
(по желанию) Ознакомьтесь более подробно с документацией 
утилиты mysqldump. Создайте дамп единственной таблицы help_keyword
 базы данных mysql. Причем добейтесь того, чтобы 
 дамп содержал только первые 100 строк таблицы.
*/
-- в командной строке 
-- mysqldump --where="true limit 100" mysql help_keyword > newsql.sql