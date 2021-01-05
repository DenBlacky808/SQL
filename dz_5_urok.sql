-- 1. Пусть в таблице users поля created_at и updated_at оказались 
-- незаполненными. Заполните их текущими датой и временем.

UPDATE products
    SET created_at = NOW() where created_at is NULL;

UPDATE products
    SET updated_at = NOW() where updated_at is NULL;
   
/**2 .Таблица users была неудачно спроектирована. 
Записи created_at и updated_at были заданы типом VARCHAR 
и в них долгое время помещались значения в формате 20.10.2017 8:10.
Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения.**/


ALTER TABLE users ADD created_at_dt DATETIME, updated_at_dt DATETIME;
UPDATE users
SET created_at_dt = STR_TO_DATE(created_at, '%d.%m.%Y %h:%i'),
    updated_at_dt = STR_TO_DATE(updated_at, '%d.%m.%Y %h:%i');
ALTER TABLE users 
    DROP created_at, DROP updated_at, 
    RENAME COLUMN created_at_dt TO created_at, RENAME COLUMN updated_at_dt TO updated_at;
   
/** 3.
 В таблице складских запасов storehouses_products в поле value могут встречаться 
 самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы.
  Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value.
   Однако нулевые запасы должны выводиться в конце, после всех  **/
SELECT
value
FROM    
storehouses_products ORDER BY IF(value > 0, 0, 1), value;

/** 4.
 (по желанию) Из таблицы users необходимо извлечь пользователей,
  родившихся в августе и мае.
   Месяцы заданы в виде списка английских названий (may, august) 
 **/
   
SELECT name, birthday_at FROM users WHERE MONTHNAME(birthday_at) IN ('may', 'august');

/** 5.
  Из таблицы catalogs извлекаются записи при помощи запроса. 
  SELECT * FROM catalogs WHERE id IN (5, 1, 2); 
  Отсортируйте записи в порядке, заданном в списке IN.
 **/

 SELECT * FROM catalogs WHERE id IN (5, 1, 2) ORDER BY FIELD(id, 5, 1, 2);


/** 6.
 Подсчитайте средний возраст пользователей в таблице users.
 **/
SELECT ROUND(AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW())), 0) AS AVG_Age FROM users;

/** 7.
 Подсчитайте количество дней рождения, которые приходятся на 
 каждый из дней недели. Следует учесть, что необходимы дни
  недели текущего года, а не года рождения.
 **/

SELECT
	DATE_FORMAT(DATE(CONCAT_WS('-', YEAR(NOW()), MONTH(birthday_at), DAY(birthday_at))), '%W') AS day,
	COUNT(*) AS total
FROM
	users
GROUP BY
	day
ORDER BY
	total DESC;

/** 8.
 Подсчитайте произведение чисел в столбце таблицы.
**/
SELECT ROUND(exp(SUM(ln(value))), 0) AS factorial FROM integers;
