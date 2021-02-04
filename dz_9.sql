
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



-- 1 Создайте двух пользователей которые имеют доступ к базе данных shop.
-- Первому пользователю shop_read должны быть доступны только запросы на чтение данных,
-- второму пользователю shop — любые операции в пределах базы данных shop.

-- shop_read доступны только запросы на чтение данных
DROP USER IF EXISTS 'shop_reader'@'localhost';
CREATE USER 'shop_reader'@'localhost' IDENTIFIED WITH sha256_password BY '123';
GRANT SELECT ON shop.* TO 'shop_reader'@'localhost';


-- shop - доступны любые операции в пределах базы данных shop
DROP USER IF EXISTS 'shop'@'localhost';
CREATE USER 'shop'@'localhost' IDENTIFIED WITH sha256_password BY '123';
GRANT ALL ON shop.* TO 'shop'@'localhost';
GRANT GRANT OPTION ON shop.* TO 'shop'@'localhost';



-- 2 Пусть имеется таблица accounts содержащая три 
-- столбца id, name, password, содержащие первичный ключ, имя пользователя
-- и его пароль. Создайте представление username таблицы accounts, 
-- предоставляющий доступ к столбца id и name. Создайте пользователя user_read, 
-- который бы не имел доступа к таблице accounts, однако, 
-- мог бы извлекать записи из представления username.


DROP TABLE IF EXISTS account;
CREATE TABLE account (
	id SERIAL PRIMARY KEY,
	name VARCHAR(45),
	password VARCHAR(45)
);

INSERT INTO account VALUES
	(NULL, 'john', '123'),
	(NULL, 'chris', '123'),
	(NULL, 'ron', '123');


CREATE OR REPLACE VIEW username(user_id, user_name) AS 
	SELECT id, name FROM account;


DROP USER IF EXISTS 'user_reader'@'localhost';
CREATE USER 'user_reader'@'localhost' IDENTIFIED WITH sha256_password BY '123';
GRANT SELECT ON shop_online.username TO 'user_reader'@'localhost';


-- 1 Создайте хранимую функцию hello(), которая будет возвращать приветствие,
-- в зависимости от текущего времени суток. С 6:00 до 12:00 функция должна 
-- возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу
-- "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".

DROP PROCEDURE IF EXISTS hello;
delimiter //
CREATE PROCEDURE hello()
BEGIN
CASE 
WHEN CURTIME() BETWEEN '06:00:00' AND '12:00:00' 
	THEN SELECT 'Доброе утро';
WHEN CURTIME() BETWEEN '12:00:00' AND '18:00:00' 
	THEN SELECT 'Добрый день';
WHEN CURTIME() BETWEEN '18:00:00' AND '00:00:00' 
	THEN SELECT 'Добрый вечер';
ELSE
	SELECT 'Доброй ночи';
END CASE;
END //
delimiter ;

CALL hello();


-- 2
-- В таблице products есть два текстовых поля: name с названием товара и description 
-- с его описанием. Допустимо присутствие обоих полей или одно из них. Ситуация, 
-- когда оба поля принимают неопределенное значение NULL неприемлема.
-- Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. 
-- При попытке присвоить полям NULL-значение необходимо отменить операцию.
-- 

DROP TRIGGER IF EXISTS nullTrigger;
delimiter //
CREATE TRIGGER nullTrigger BEFORE INSERT ON products
FOR EACH ROW
BEGIN
IF(ISNULL(NEW.name) AND ISNULL(NEW.description)) 
	THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '!NULL Trigger!';
END IF;
END //
delimiter ;


