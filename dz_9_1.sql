
-- 1. В базе данных shop и sample присутвуют одни и те же таблицы учебной базы данных. 
-- Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.

DROP DATABASE IF EXISTS sample;
CREATE DATABASE sample;
use sample;

DROP TABLE IF EXISTS users;
CREATE TABLE users(
	id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(45) NOT NULL,
	birthday_at DATE DEFAULT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SELECT id,name,birthday_at,created_at,updated_at FROM users;

START TRANSACTION;
INSERT INTO sample.users SELECT * FROM shop_online.users WHERE id = 1;
COMMIT;

SELECT id,name,birthday_at,created_at,updated_at FROM users;




-- 2. Создайте представление, которое выводит название (name) товарной позиции из
-- таблицы products и соответствующее название (name) каталога из таблицы catalogs.
use shop;
CREATE OR REPLACE VIEW prods_desc(prod_id, prod_name, cat_name) AS
SELECT p.id AS prod_id, p.name, cat.name
	FROM products AS p
	LEFT JOIN catalogs AS cat 
ON p.catalog_id = cat.id;



-- 3. Пусть имеется таблица с календарным полем created_at.
-- В ней размещены разряженые календарные записи за август 2018 года:
-- '2018-08-01', '2016-08-04', '2018-08-16' и 2018-08-17
-- Составьте запрос, который выводит полный список дат за август,
-- выставляя в соседнем поле значение 1, если дата присутствует в исходном таблице и 0,
-- если она отсутствует.
use shop;
DROP TABLE IF EXISTS datetbl;
CREATE TABLE datetbl (
	created_at DATE
);

INSERT INTO datetbl VALUES
	('2018-08-01'),
	('2018-08-04'),
	('2018-08-16'),
	('2018-08-17');

SELECT created_at FROM datetbl ORDER BY created_at;

SELECT 
	time_period.selected_date AS day,
	(SELECT EXISTS(SELECT created_at FROM datetbl WHERE created_at = day)) AS has_already
FROM
	(SELECT v.* FROM 
		(SELECT ADDDATE('1970-01-01',t4.i*10000 + t3.i*1000 + t2.i*100 + t1.i*10 + t0.i) selected_date FROM
			(SELECT 0 i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t0,
		    (SELECT 0 i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t1,
		    (SELECT 0 i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t2,
		    (SELECT 0 i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t3,
		    (SELECT 0 i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t4) v
	WHERE selected_date BETWEEN '2018-08-01' AND '2018-08-31') AS time_period;




-- 4.  Пусть имеется любая таблица с календарным полем created_at.
-- Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей.

use shop;
DROP TABLE IF EXISTS datetbl;
CREATE TABLE datetbl (
	created_at DATE
);

INSERT INTO datetbl VALUES
	('2021-01-01'),
	('2021-01-02'),
	('2021-01-04'),
	('2021-01-12'),
	('2021-01-14'),
	('2021-01-17'),
	('2021-01-23'),
	('2021-01-27'),
	('2021-01-29'),
	('2021-01-31');

-- удаляем все что не входит в первую 5
DELETE FROM datetbl
WHERE created_at NOT IN (
	SELECT created_at
	FROM (
		SELECT created_at
		FROM datetbl
		ORDER BY created_at DESC
		LIMIT 5
	) AS foo
) ORDER BY created_at DESC;

SELECT created_at FROM datetbl ORDER BY created_at DESC;



