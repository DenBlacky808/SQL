-- 1. Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, 
-- catalogs и products в таблицу logs помещается время и дата создания записи, название таблицы,
-- идентификатор первичного ключа и содержимое поля name.


DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
	created_at DATETIME NOT NULL,
	table_name VARCHAR(45) NOT NULL,
	str_id BIGINT(20) NOT NULL,
	name_value VARCHAR(45) NOT NULL
) ENGINE = ARCHIVE;


-- TRIGGER users 
DROP TRIGGER IF EXISTS watchlog_users;
delimiter //
CREATE TRIGGER watchlog_users AFTER INSERT ON users
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at, table_name, str_id, name_value)
	VALUES (NOW(), 'users', NEW.id, NEW.name);
END //
delimiter ;


-- TRIGGER catalogs
DROP TRIGGER IF EXISTS watchlog_catalogs;
delimiter //
CREATE TRIGGER watchlog_catalogs AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at, table_name, str_id, name_value)
	VALUES (NOW(), 'catalogs', NEW.id, NEW.name);
END //
delimiter ;


-- TRIGGER products 
delimiter //
CREATE TRIGGER watchlog_products AFTER INSERT ON products
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at, table_name, str_id, name_value)
	VALUES (NOW(), 'products', NEW.id, NEW.name);
END //
delimiter ;


-- Курсовой проект
-- (по желанию) Скрипты создания структуры БД (с первичными ключами, индексами, внешними ключами)
-- Вашего курсового проекта - пункт 3 требований к курсовому проекту.


DROP DATABASE IF EXISTS uni;
CREATE DATABASE uni;
USE uni;

DROP TABLE IF EXISTS tracks;
CREATE TABLE tracks (
	id SERIAL PRIMARY KEY, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
	aj_id BIGINT UNSIGNED NOT NULL,
	storage_id BIGINT UNSIGNED NOT NULL,
	bpm INT UNSIGNED,
	tonality VARCHAR(100),
	chords VARCHAR(100),
	track_length VARCHAR(20),
	uni_views INT UNSIGNED,
	created_at﻿ DATETIME DEFAULT NOW(),
	updated_at﻿ DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	daw_name VARCHAR(100),
	description TEXT,
	all_style﻿ VARCHAR(100),
	in_sys_at﻿ DATETIME DEFAULT NOW(),
	all_tags TEXT,
	all_mood﻿ TEXT 
	
);	
	
DROP TABLE IF EXISTS storage_tracks;
CREATE TABLE storage_tracks (
	st_track_id SERIAL PRIMARY KEY,
	file_name VARCHAR(100),
	track_wav_link TEXT,
	size﻿ INT UNSIGNED,
	downloaded﻿ INT UNSIGNED,
	proj_file_link TEXT,
	samples_link TEXT,
	midi_chords_link TEXT,
	midi_melody_link TEXT
);	
	
DROP TABLE IF EXISTS aj;
CREATE TABLE aj (
	track_aj_id SERIAL PRIMARY KEY,
	sales﻿ INT UNSIGNED,
    aj_tags﻿ TEXT,
	unique_pageviews﻿ INT UNSIGNED,
	pageviews﻿ INT UNSIGNED,
	entrances﻿ INT UNSIGNED,
	avg_time_on_page﻿ VARCHAR(20),
	bounce_rate VARCHAR(20),
	perc_exits﻿ VARCHAR(20),
	discount_status﻿ ENUM('enable', 'disable', 'used'),
	mood﻿ TEXT,
	price_1﻿ INT UNSIGNED,
	price_2﻿ INT UNSIGNED,
	price_3﻿ INT UNSIGNED,
	price_4﻿ INT UNSIGNED

);

DROP TABLE IF EXISTS pages;
CREATE TABLE pages (
	page_id SERIAL PRIMARY KEY,
	post_id BIGINT UNSIGNED NOT NULL,
    track_id BIGINT UNSIGNED NOT NULL,
    media_id BIGINT UNSIGNED NOT NULL,
    created_at﻿ DATETIME DEFAULT NOW(),
	updated_at﻿ DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	INDEX (post_id),
	INDEX (track_id),
	INDEX (media_id)

);

DROP TABLE IF EXISTS posts;
CREATE TABLE posts (
	id SERIAL PRIMARY KEY,
	media_id BIGINT UNSIGNED NOT NULL,
    post_text TEXT,
    status VARCHAR(100),
    theme VARCHAR(100),
    INDEX (media_id)
);


DROP TABLE IF EXISTS media;
CREATE TABLE media (
	id SERIAL PRIMARY KEY,
	info﻿ BIGINT UNSIGNED NOT NULL,
    videos﻿_link TEXT,
    fonts﻿_link TEXT,
    pics_link﻿ TEXT,
    text_in_media TEXT,
    INDEX (info﻿)

);


DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
	id SERIAL PRIMARY KEY,
	from_user_id BIGINT UNSIGNED NOT NULL,
    status VARCHAR(100),
    created_at﻿ DATETIME DEFAULT NOW(),
    text_msg TEXT,
    INDEX (from_user_id)
);


DROP TABLE IF EXISTS users;
CREATE TABLE users (
	user_id SERIAL PRIMARY KEY,
    track_id BIGINT UNSIGNED NOT NULL,
    aj_push﻿ INT UNSIGNED,
    name﻿ VARCHAR(100),
    email﻿ VARCHAR(120) UNIQUE,
    pass﻿ VARCHAR(120),
    white_listed﻿ CHAR(1),
    channel_yt﻿ TEXT,
    category﻿ VARCHAR(100),
    INDEX (track_id)
);


DROP TABLE IF EXISTS youtube;
CREATE TABLE youtube (
	video_id SERIAL PRIMARY KEY,
    track_id BIGINT UNSIGNED NOT NULL,
    views BIGINT UNSIGNED NOT NULL,
    link_id﻿ TEXT,
    uni_user_id﻿ BIGINT UNSIGNED NOT NULL,
    status﻿ VARCHAR(100),
    advert_status﻿ ENUM('enable', 'disable'),
    INDEX (uni_user_id﻿),
    INDEX (track_id)
);


DROP TABLE IF EXISTS info_data;
CREATE TABLE info_data (
	info_id﻿ SERIAL PRIMARY KEY,
	created_at﻿ DATETIME DEFAULT NOW(),
	FAQ﻿ TEXT,
	story﻿ TEXT,
	license﻿ TEXT,
	monetizing﻿ TEXT,
	claim_id﻿ TEXT
);


DROP TABLE IF EXISTS patreon;
CREATE TABLE patreon (
	pat_id SERIAL PRIMARY KEY,
	level_id VARCHAR(100),
	uni_user_id﻿ BIGINT UNSIGNED NOT NULL,
	request_wl﻿ ENUM('active', 'non active'),
	is_member﻿ ENUM('yes', 'no'),
	confirm_date﻿ DATETIME DEFAULT NOW(),
	created_at﻿ DATETIME DEFAULT NOW(),
	num_supporters﻿ BIGINT UNSIGNED NOT NULL,
	link_id TEXT,
	INDEX (uni_user_id﻿)
);


-- utility
-- ALTER TABLE tracks DROP CONSTRAINT yt_fk1

	

    ALTER TABLE tracks ADD CONSTRAINT st_fk1
    FOREIGN KEY (storage_id) REFERENCES storage_tracks(st_track_id)
    ON UPDATE CASCADE ON DELETE CASCADE;

    
    ALTER TABLE tracks ADD CONSTRAINT aj_fk1
    FOREIGN KEY (aj_id) REFERENCES aj(track_aj_id)
    ON UPDATE CASCADE ON DELETE CASCADE;

    ALTER TABLE tracks ADD CONSTRAINT yt_fk1
    FOREIGN KEY (id) REFERENCES youtube(track_id)
    ON UPDATE CASCADE ON DELETE CASCADE;
    
    ALTER TABLE tracks ADD CONSTRAINT usrs_fk1
    FOREIGN KEY (id) REFERENCES users(track_id)
    ON UPDATE CASCADE ON DELETE CASCADE;
    
    ALTER TABLE users ADD CONSTRAINT uni_usrs_fk1
    FOREIGN KEY (user_id) REFERENCES youtube(uni_user_id﻿)
    ON UPDATE CASCADE ON DELETE CASCADE;
    
    ALTER TABLE users ADD CONSTRAINT msgs_fk1
    FOREIGN KEY (user_id) REFERENCES messages(from_user_id)
    ON UPDATE CASCADE ON DELETE CASCADE;

    ALTER TABLE users ADD CONSTRAINT patr_usrs_fk1
    FOREIGN KEY (user_id) REFERENCES patreon(uni_user_id﻿)
    ON UPDATE CASCADE ON DELETE CASCADE;

    ALTER TABLE tracks ADD CONSTRAINT pgs_fk1
    FOREIGN KEY (id) REFERENCES pages(track_id)
    ON UPDATE CASCADE ON DELETE CASCADE;
    
    ALTER TABLE posts ADD CONSTRAINT pgs_fk2
    FOREIGN KEY (id) REFERENCES pages(post_id)
    ON UPDATE CASCADE ON DELETE CASCADE;
    
    ALTER TABLE media ADD CONSTRAINT pgs_fk3
    FOREIGN KEY (id) REFERENCES pages(media_id)
    ON UPDATE CASCADE ON DELETE CASCADE;

    ALTER TABLE media ADD CONSTRAINT psts_fk1
    FOREIGN KEY (id) REFERENCES posts(media_id)
    ON UPDATE CASCADE ON DELETE CASCADE;
       
    ALTER TABLE info_data ADD CONSTRAINT info_fk1
    FOREIGN KEY (info_id﻿) REFERENCES media(info﻿)
    ON UPDATE CASCADE ON DELETE CASCADE;
       
    
    
    
    
    
    
    
  