DROP DATABASE IF EXISTS vk;
CREATE DATABASE vk;
USE vk;

-- удалить таблицу если есть

DROP TABLE IF EXISTS users;
-- создать таблицу

CREATE TABLE users (
	id SERIAL PRIMARY KEY, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
    firstname VARCHAR(100),
    lastname VARCHAR(100) COMMENT 'Фамилия', -- COMMENT на случай, если имя неочевидное
    email VARCHAR(100) UNIQUE,
    password_hash varchar(100),
    phone BIGINT,
    is_deleted bit default 0,
    -- INDEX users_phone_idx(phone), -- помним: как выбирать индексы
    INDEX users_firstname_lastname_idx(firstname, lastname)
);
-- удалить таблицу если есть

DROP TABLE IF EXISTS `profiles`;
-- создать таблицу

CREATE TABLE `profiles` (
	user_id SERIAL PRIMARY KEY,
    gender CHAR(1),
    birthday DATE,
	photo_id BIGINT UNSIGNED NULL,
    created_at DATETIME DEFAULT NOW(),
    hometown VARCHAR(100)
    -- , FOREIGN KEY (photo_id) REFERENCES media(id) -- пока рано, т.к. таблицы media еще нет
);

-- NO ACTION
-- CASCADE 
-- RESTRICT
-- SET NULL
-- SET DEFAULT


ALTER TABLE `profiles` ADD CONSTRAINT fk_user_id
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON UPDATE CASCADE ON DELETE CASCADE;
-- удалить таблицу если есть

DROP TABLE IF EXISTS messages;
-- создать таблицу

CREATE TABLE messages (
	id SERIAL PRIMARY KEY,
	from_user_id BIGINT UNSIGNED NOT NULL,
    to_user_id BIGINT UNSIGNED NOT NULL,
    body TEXT,
    created_at DATETIME DEFAULT NOW(), -- можно будет даже не упоминать это поле при вставке

    FOREIGN KEY (from_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (to_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);
-- удалить таблицу если есть

DROP TABLE IF EXISTS friend_requests;
-- создать таблицу

CREATE TABLE friend_requests (
	-- id SERIAL PRIMARY KEY, -- изменили на составной ключ (initiator_user_id, target_user_id)
	initiator_user_id BIGINT UNSIGNED NOT NULL,
    target_user_id BIGINT UNSIGNED NOT NULL,
    -- `status` TINYINT UNSIGNED,
    `status` ENUM('requested', 'approved', 'declined', 'unfriended'),
    -- `status` TINYINT UNSIGNED, -- в этом случае в коде хранили бы цифирный enum (0, 1, 2, 3...)
	requested_at DATETIME DEFAULT NOW(),
	updated_at DATETIME on update now(),
	
    PRIMARY KEY (initiator_user_id, target_user_id),
    FOREIGN KEY (initiator_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (target_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);
-- удалить таблицу если есть

DROP TABLE IF EXISTS communities;
-- создать таблицу

CREATE TABLE communities(
	id SERIAL PRIMARY KEY,
	name VARCHAR(150),
	admin_user_id BIGINT UNSIGNED,

	INDEX communities_name_idx(name),
	FOREIGN KEY (admin_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE set null
);
-- удалить таблицу если есть

DROP TABLE IF EXISTS users_communities;
-- создать таблицу

CREATE TABLE users_communities(
	user_id BIGINT UNSIGNED NOT NULL,
	community_id BIGINT UNSIGNED NOT NULL,
  
	PRIMARY KEY (user_id, community_id), -- чтобы не было 2 записей о пользователе и сообществе
    FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (community_id) REFERENCES communities(id) ON UPDATE CASCADE ON DELETE CASCADE
);
-- удалить таблицу если есть

DROP TABLE IF EXISTS media_types;
-- создать таблицу

CREATE TABLE media_types(
	id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP

    -- записей мало, поэтому индекс будет лишним (замедлит работу)!
);
-- удалить таблицу если есть

DROP TABLE IF EXISTS media;
-- создать таблицу

CREATE TABLE media(
	id SERIAL PRIMARY KEY,
    media_type_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
  	body text,
    filename VARCHAR(255),
    `size` INT,
	metadata JSON,
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (media_type_id) REFERENCES media_types(id) ON UPDATE CASCADE ON DELETE CASCADE
);
-- удалить таблицу если есть

DROP TABLE IF EXISTS likes;
-- создать таблицу

CREATE TABLE likes(
	id SERIAL PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    media_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT NOW(),

    -- PRIMARY KEY (user_id, media_id) – можно было и так вместо id в качестве PK
  	-- слишком увлекаться индексами тоже опасно, рациональнее их добавлять по мере необходимости (напр., провисают по времени какие-то запросы)  

/* намеренно забыли, чтобы позднее увидеть их отсутствие в ER-диаграмме*/
    FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (media_id) REFERENCES media(id) ON UPDATE CASCADE ON DELETE CASCADE

);
-- удалить таблицу если есть
DROP TABLE IF EXISTS `photo_albums`;
-- создать таблицу
CREATE TABLE `photo_albums` (
	`id` SERIAL,
	`name` varchar(255) DEFAULT NULL,
    `user_id` BIGINT UNSIGNED DEFAULT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE set NULL,
  	PRIMARY KEY (`id`)
);
-- удалить таблицу если есть

DROP TABLE IF EXISTS `photos`;
CREATE TABLE `photos` (
	id SERIAL PRIMARY KEY,
	`album_id` BIGINT unsigned NOT NULL,
	`media_id` BIGINT unsigned NOT NULL,

	FOREIGN KEY (album_id) REFERENCES photo_albums(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (media_id) REFERENCES media(id) ON UPDATE CASCADE ON delete CASCADE
);

ALTER TABLE `profiles` ADD CONSTRAINT fk_photo_id
    FOREIGN KEY (photo_id) REFERENCES photos(id)
    ON UPDATE CASCADE ON DELETE set NULL;
   
  /*
   * Написать cкрипт, добавляющий в БД vk, которую создали на 3 вебинаре,
   *  3-4 новые таблицы (с перечнем полей, указанием индексов и внешних ключей).
(по желанию: организовать все связи 1-1, 1-М, М-М)
   */ 
-- удалить таблицу если есть
 -- создание таблиц 
DROP TABLE IF EXISTS `video_theme`;
CREATE TABLE `video_theme` (
	video_theme_id SERIAL PRIMARY KEY,
	id BIGINT UNSIGNED DEFAULT NULL,
	`name` varchar(255) DEFAULT NULL
);
   
-- удалить таблицу если есть
	
DROP TABLE IF EXISTS `videos`;
-- создать таблицу

CREATE TABLE `videos` (
	id SERIAL PRIMARY KEY,
	`name` varchar(255) DEFAULT NULL,
	media_types_id BIGINT UNSIGNED DEFAULT NULL
	
);
  -- удалить таблицу если есть
 
DROP TABLE IF EXISTS `video_users`;
-- создать таблицу

CREATE TABLE `video_users` (
	id SERIAL PRIMARY KEY,
	`name` varchar(255) DEFAULT NULL,
	user_id BIGINT UNSIGNED DEFAULT NULL,
	video_id BIGINT UNSIGNED DEFAULT NULL,
	created_at DATETIME DEFAULT NOW()

);
   -- созздание связей между таблицами
   
ALTER TABLE `video_theme` ADD CONSTRAINT fk_videos_id
FOREIGN KEY (video_theme_id) REFERENCES videos(id)
ON UPDATE CASCADE ON DELETE CASCADE;	
   
ALTER TABLE `videos` ADD CONSTRAINT
FOREIGN KEY (media_types_id) REFERENCES media(media_type_id)
ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE `video_users` ADD CONSTRAINT
FOREIGN KEY (user_id) REFERENCES users(id)
ON UPDATE CASCADE ON DELETE CASCADE;
   
ALTER TABLE `video_users` ADD CONSTRAINT
FOREIGN KEY (video_id) REFERENCES videos(id)
ON UPDATE CASCADE ON DELETE CASCADE;

