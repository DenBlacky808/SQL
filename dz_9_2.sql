
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

