-- //ОБЩЕЕ ТЕКСТОВОЕ ОПИСАНИЕ БД И РЕШАЕМЫХ ЕЮ ЗАДАЧ//

-- В представленной базе данных реализована статистика топ-5 европейских чемпионатов по футболу (Англия, Испания, Германия, Италия, Франция).
-- Присутствует информация об игроках (дата рождения, стоимость, позиции, национальность), футбольных клубах (спонсоры, выигранные трофеи, домашние стадионы),
-- стадионах (вместимость, средняя посещаемость). При помощи скриптов выборок можно отследить зависимости и составить рейтинги по интересующим параметрам
-- (как примеры: самый посещаемый чемпионат, в зависимости от процента заполнения стадионов; самые дорогие футбольные клубы,
-- в зависимости от суммарной стоимости играющих в этих клубах футболистов и т.д.).

DROP DATABASE IF EXISTS pro_football;
CREATE DATABASE pro_football;

USE pro_football;

-- //СКРИПТЫ СОЗДАНИЯ ТАБЛИЦ БАЗЫ ДАННЫХ//

DROP TABLE IF EXISTS countries;
CREATE TABLE countries (
	id SERIAL PRIMARY KEY,
	name VARCHAR(30) COMMENT 'Страна',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
	) COMMENT = 'Страны';

DROP TABLE IF EXISTS football_teams;
CREATE TABLE football_teams (
	id SERIAL PRIMARY KEY,
	name VARCHAR(30) COMMENT 'Название команды',
	country_id BIGINT UNSIGNED NOT NULL COMMENT 'Страна',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	FOREIGN KEY (country_id) REFERENCES countries(id)
	) COMMENT = 'Футбольные команды';

DROP TABLE IF EXISTS football_players;
CREATE TABLE football_players (
	id SERIAL PRIMARY KEY,
	name VARCHAR(30) COMMENT 'Имя',
	surname VARCHAR(30) COMMENT 'Фамилия',
	birthday_at DATE COMMENT 'Дата рождения',
	nationality BIGINT UNSIGNED NOT NULL COMMENT 'Страна',
	team_id BIGINT UNSIGNED NOT NULL COMMENT 'Команда',
	`position` VARCHAR(20) COMMENT 'Позиция',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	FOREIGN KEY (team_id) REFERENCES football_teams(id),
	FOREIGN KEY (nationality) REFERENCES countries(id)
	) COMMENT = 'Футболисты';

DROP TABLE IF EXISTS players_price;
CREATE TABLE players_price (
	player_id BIGINT UNSIGNED NOT NULL COMMENT 'Игрок',
	price DECIMAL (15,2) COMMENT 'Стоимость игрока',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (player_id),
	FOREIGN KEY (player_id) REFERENCES football_players(id)
	) COMMENT = 'Стоимость игроков на трансферном рынке';

DROP TABLE IF EXISTS trophies;
CREATE TABLE trophies (
	id SERIAL PRIMARY KEY,
	team_id BIGINT UNSIGNED NOT NULL COMMENT 'Команда',
	local_trophies BIGINT UNSIGNED NOT NULL COMMENT 'Локальные трофеи',
	international_trophies BIGINT UNSIGNED NOT NULL COMMENT 'Международные трофеи',
	total_trophies BIGINT AS (local_trophies + international_trophies) COMMENT 'Общее число трофеев',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	FOREIGN KEY (team_id) REFERENCES football_teams(id)
	) COMMENT = 'Командные трофеи';

DROP TABLE IF EXISTS championships;
CREATE TABLE championships (
	id SERIAL PRIMARY KEY,
	name VARCHAR(30) COMMENT 'Название чемпионата',
	country_id BIGINT UNSIGNED NOT NULL COMMENT 'Страна',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	FOREIGN KEY (country_id) REFERENCES countries(id)
	) COMMENT = 'Список чемпионатов';

DROP TABLE IF EXISTS stadiums;
CREATE TABLE stadiums (
	id SERIAL PRIMARY KEY,
	name VARCHAR(30) COMMENT 'Название стадиона',
	seats_number BIGINT UNSIGNED NOT NULL COMMENT 'Вместимость (кол-во мест)',
	team_id BIGINT UNSIGNED NOT NULL COMMENT 'Команда',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	FOREIGN KEY (team_id) REFERENCES football_teams(id)
	) COMMENT = 'Стадионы';

DROP TABLE IF EXISTS attendance;
CREATE TABLE attendance (
	id SERIAL PRIMARY KEY,
	stadium_id BIGINT UNSIGNED NOT NULL COMMENT 'Стадион',
	sold_tickets BIGINT UNSIGNED NOT NULL COMMENT 'Среднее кол-во проданных билетов за матч',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	FOREIGN KEY (stadium_id) REFERENCES stadiums(id)
	) COMMENT = 'Посещаемость';

DROP TABLE IF EXISTS sponsors;
CREATE TABLE sponsors (
	id SERIAL PRIMARY KEY,
	sponsor_name VARCHAR(30) COMMENT 'Название спонсора',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
	) COMMENT 'Спонсоры';

DROP TABLE IF EXISTS team_sponsors;
CREATE TABLE team_sponsors (
	team_id BIGINT UNSIGNED NOT NULL COMMENT 'Команда',
	sponsor_id BIGINT UNSIGNED NOT NULL COMMENT 'Спонсор',
	PRIMARY KEY (team_id, sponsor_id),
	FOREIGN KEY (team_id) REFERENCES football_teams(id),
	FOREIGN KEY (sponsor_id) REFERENCES sponsors(id)
	) COMMENT = 'Командные спонсоры';

-- //СКРИПТЫ НАПОЛНЕНИЯ ТАБЛИЦ ДАННЫМИ//

INSERT INTO countries (name) VALUES
	('Italy'),
	('Spain'),
	('Germany'),
	('France'),
	('England'),
	('Croatia'),
	('Brazil'),
	('Argentina'),
	('Russia'),
	('Belgium');

INSERT INTO football_teams (name, country_id) VALUES
	('Real Madrid', 2),
	('Valencia', 2),
	('Chelsea', 5),
	('Liverpool', 5),
	('Milan', 1),
	('Lazio', 1),
	('Marseille', 4),
	('Stuttgart', 3),
	('Bayern Munchen', 3),
	('Olympique Lyonnais', 4);

INSERT INTO football_players (name, surname, birthday_at, nationality, team_id, `position`) VALUES
	('Toni', 'Kroos', '1990-01-04', 3, 1, 'midfielder'),
	('Sergio', 'Ramos', '1986-03-30', 2, 1, 'defender'),
	('Luca', 'Modric', '1985-09-09', 6, 1, 'midfielder'),
	('Denis', 'Cheryshev', '1990-12-26', 9, 2, 'midfielder'),
	('Cristiano', 'Piccini', '1992-09-26', 1, 2, 'defender'),
	('Mouctar', 'Diakhaby', '1996-12-19', 4, 2, 'defender'),
	('Antonio', 'Rudiger', '1993-03-03', 3, 3, 'defender'),
	('Kai', 'Havertz', '1999-06-11', 3, 3, 'forward'),
	('Ross', 'Barkley', '1993-12-05', 5, 3, 'midfielder'),
	('Fabio', 'Tavarez', '1993-10-23', 7, 4, 'midfielder'),
	('Trent', 'Alexander-Arnold', '1998-10-07', 5, 4, 'defender'),
	('Divock', 'Origi', '1995-04-18', 10, 4, 'forward'),
	('Theo', 'Hernandez', '1997-10-06', 4, 5, 'defender'),
	('Antonio', 'Donnarumma', '1990-07-07', 1, 5, 'goalkeeper'),
	('Brahim', 'Diaz', '1999-08-03', 2, 5, 'forward'),
	('Carlos', 'Correa', '1994-08-13', 8, 6, 'midfielder'),
	('Ciro', 'Immobile', '1990-02-20', 1, 6, 'forward'),
	('Jordan', 'Lukaku', '1994-07-25', 10, 6, 'defender'),
	('Valere', 'Germain', '1990-04-17', 4, 7, 'forward'),
	('Florian', 'Thauvin', '1993-01-26', 4, 7, 'midfielder'),
	('Dimitri', 'Payet', '1987-03-29', 4, 7, 'midfielder'),
	('Orel', 'Mangala', '1998-03-18', 10, 8, 'midfielder'),
	('Lilian', 'Egloff', '2002-08-20', 3, 8, 'midfielder'),
	('Pascal', 'Stenzel', '1996-03-20', 3, 8, 'defender'),
	('Manuel', 'Neuer', '1986-03-27', 3, 9, 'goalkeeper'),
	('Thomas', 'Muller', '1989-09-13', 3, 9, 'forward'),
	('Leon', 'Goretzka', '1995-02-06', 3, 9, 'midfielder'),
	('Leo', 'Dubois', '1994-09-14', 4, 10, 'defender'),
	('Memphis', 'Depay', '1994-02-13', 4, 10, 'forward'),
	('Thiago', 'Mendes', '1992-03-15', 7, 10, 'midfielder');
	
INSERT INTO players_price (player_id, price) VALUES
	(1, 45000000.00),
	(2, 35000000.00),
	(3, 25000000.00),
	(4, 10000000.00),
	(5, 7500000.00),
	(6, 6900000.00),
	(7, 15700000.00),
	(8, 75000000.00),
	(9, 52000000.00),
	(10, 38650000.00),
	(11, 69000000.00),
	(12, 8000000.00),
	(13, 27000000.00),
	(14, 50000000.00),
	(15, 54000000.00),
	(16, 31000000.00),
	(17, 28400000.00),
	(18, 10000000.00),
	(19, 5000000.00),
	(20, 12000000.00),
	(21, 19000000.00),
	(22, 8500000.00),
	(23, 13700000.00),
	(24, 24000000.00),
	(25, 60000000.00),
	(26, 40500000.00),
	(27, 80000000.00),
	(28, 18600000.00),
	(29, 37000000.00),
	(30, 21400000.00);

INSERT INTO trophies (team_id, local_trophies, international_trophies) VALUES
	(1, 66, 32),
	(2, 18, 8),
	(3, 27, 6),
	(4, 55, 14),
	(5, 35, 35),
	(6, 15, 3),
	(7, 26, 2),
	(8, 11, 2),
	(9, 67, 12),
	(10, 24, 1);

INSERT INTO championships (name, country_id) VALUES
	('La liga', 2),
	('Serie A', 1),
	('Premier League', 5),
	('Ligue 1', 4),
	('Bundesliga', 3);

INSERT INTO stadiums (name, seats_number, team_id) VALUES
	('Grand Stade de Lyon', 59186, 10),
	('Allianz Arena', 75000, 9),
	('Mercedes-Benz Arena', 60451, 8),
	('Orange Velodrome', 67394, 7),
	('Stadio Olimpico', 72700, 6),
	('Stadio Giuseppe Meazza', 80018, 5),
	('Anfield', 53394, 4),
	('Stamford Bridge', 41631, 3),
	('Estadio Mestalla', 55000, 2),
	('Estadio Santiago Bernabeu', 81044, 1);

INSERT INTO attendance (stadium_id, sold_tickets) VALUES
	(1, 42385),
	(2, 71459),
	(3, 57231),
	(4, 59324),
	(5, 51278),
	(6, 73455),
	(7, 51123),
	(8, 36572),
	(9, 49933),
	(10, 77622);

INSERT INTO sponsors (sponsor_name) VALUES
	('Fly Emirates'),
	('Audi'),
	('Nike'),
	('Puma'),
	('Under Armour'),
	('Adidas'),
	('Mercedes-Benz'),
	('Qatar Airways'),
	('Reebok'),
	('Samsung');

INSERT INTO team_sponsors (team_id, sponsor_id) VALUES
	(1, 1),
	(2, 10),
	(3, 3),
	(4, 6),
	(5, 8),
	(6, 9),
	(7, 4),
	(8, 7),
	(9, 2),
	(10, 5);

-- Проверка содержимого таблиц БД.

SELECT * FROM countries;
SELECT * FROM football_teams;
SELECT * FROM football_players;
SELECT * FROM players_price;
SELECT * FROM trophies;
SELECT * FROM championships;
SELECT * FROM stadiums;
SELECT * FROM attendance;
SELECT * FROM sponsors;
SELECT * FROM team_sponsors;

-- //СКРИПТЫ ВЫБОРОК//

-- определяем самые дорогие футбольные клубы, в зависимости от суммарной стоимости играющих в этих клубах футболистов.

SELECT
	ft.name, SUM(pp.price) AS summary_cost
FROM 
	players_price AS pp
JOIN
	football_players AS fp
ON
	pp.player_id = fp.id
JOIN
	football_teams AS ft
ON
	fp.team_id = ft.id
GROUP BY 
	ft.name
ORDER BY
	summary_cost DESC;

-- определяем самый посещаемый чемпионат, в зависимости от суммарного процента заполнения стадионов каждого чемпионата (в виде представления).

CREATE OR REPLACE VIEW most_visited_championship (championship_name, country_name, summary_seats, summary_sold_tickets, summary_occupancy_percent) AS 
	SELECT
		c2.name, c.name, SUM(s.seats_number) AS summary_seats, SUM(a.sold_tickets) AS summary_sold_tickets, SUM(ROUND((a.sold_tickets / s.seats_number * 100), 2)) AS occupancy_percent 
	FROM
		stadiums AS s
	JOIN
		attendance AS a
	ON 
		s.id = a.stadium_id
	JOIN
		football_teams AS ft
	ON
		s.team_id = ft.id
	JOIN
		countries AS c
	ON
		ft.country_id = c.id 
	JOIN 
		championships AS c2
	ON
		c.id = c2.country_id
	GROUP BY 
		c2.name
	ORDER BY 
		occupancy_percent DESC;

SELECT * FROM most_visited_championship; -- вызов представления.

-- определяем самые сильные страны в европейском клубном футболе по количеству международных трофеев, завоеванных их клубами (в виде представления).

CREATE OR REPLACE VIEW most_strength_countries (country_name, summary_international_club_trophies) AS 
	SELECT
		c.name, SUM(t.international_trophies) AS summary_international_trophies
	FROM
		trophies AS t 
	JOIN
		football_teams AS ft
	ON 
		t.team_id = ft.id
	JOIN
		countries AS c
	ON
		c.id = ft.country_id
	GROUP BY
		c.name 
	ORDER BY 
		summary_international_trophies DESC;
	
SELECT * FROM most_strength_countries; -- вызов представления.

-- //ХРАНИМЫЕ ПРОЦЕДУРЫ, ТРИГГЕРЫ//

-- Хранимая процедура для отбора игроков по позициям (в качестве передаваемого аргумента используется искомая позиция).
DROP PROCEDURE IF EXISTS positions;
delimiter //
CREATE PROCEDURE positions(position_arg VARCHAR(30))
BEGIN
	SELECT
		name, surname
	FROM
		football_players
	WHERE
		`position` = position_arg;
END //
delimiter ;

CALL positions('midfielder'); -- вызов хранимой процедуры.

-- Триггер на проверку значения стоимости игрока (должна быть больше нуля).
DROP TRIGGER IF EXISTS PlayerCostTrigger;
delimiter //
CREATE TRIGGER PlayerCostTtrigger BEFORE INSERT ON players_price
FOR EACH ROW
BEGIN
	IF NEW.price <= 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Trigger Warning! Value of cost of player is lower or equal to zero';
	END IF;
END //
delimiter ;
