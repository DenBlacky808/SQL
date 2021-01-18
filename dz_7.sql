Составьте список пользователей users, 
которые осуществили хотя бы один заказ orders в интернет магазине.

SELECT name
FROM users 
INNER JOIN orders ON (orders.user_id = users.id)
GROUP BY users.name
HAVING COUNT(orders.id) > 0

Выведите список товаров products и разделов catalogs, который соответствует товару.

SELECT products.name, catalogs.name
FROM products
INNER JOIN catalogs ON (products.catalog_id = catalogs.id)
GROUP BY products.id


(по желанию) Пусть имеется таблица рейсов flights 
(id, from, to) и таблица городов cities (label, name). 
Поля from, to и label содержат английские названия городов,
поле name — русское.
Выведите список рейсов flights с русскими названиями городов.


DROP TABLE IF EXISTS flights;
CREATE TABLE flights (
  id SERIAL PRIMARY KEY,
  `from_id` VARCHAR(255), 
  `to_id` VARCHAR(255)
  );

INSERT INTO flights VALUES
 (default, 'moscow', 'omsk'),
 (default, 'novgorod', 'kazan'),
 (default, 'irkutsk', 'moscow'),
 (default, 'omsk', 'irkutsk'),
 (default, 'moscow', 'kazan')
 
 
 
 DROP TABLE IF EXISTS cities;
 CREATE TABLE cities (
  `label` VARCHAR(255) PRIMARY KEY, 
  `name` VARCHAR(255)
  );

INSERT INTO cities VALUES
 ('moscow', 'Москва'),
 ('irkutsk', 'Иркутск'),
 ('novgorod', 'Новгород'),
 ('kazan', 'Казань'),
 ('omsk', 'Омск')
 
 ALTER TABLE flights ADD CONSTRAINT fk_flights_id FOREIGN KEY (`from_id`) REFERENCES cities(label) ON UPDATE CASCADE ON DELETE CASCADE;	
 ALTER TABLE flights ADD CONSTRAINT fk_flights_2_id FOREIGN KEY (`to_id`) REFERENCES cities(label) ON UPDATE CASCADE ON DELETE CASCADE;	


SELECT 
    id AS flight_id,
	(SELECT name FROM cities WHERE label = `from_id`) AS `from_id`,
	(SELECT name FROM cities WHERE label = `to_id`) AS `to_id`
FROM
	flights
ORDER BY
	flight_id;









