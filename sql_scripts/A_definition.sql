
IF EXISTS (SELECT 1 FROM master.dbo.sysdatabases WHERE NAME='hotel')
BEGIN
	USE master
	ALTER DATABASE hotel SET SINGLE_USER WITH ROLLBACK IMMEDIATE
	DROP DATABASE hotel
END
GO

CREATE DATABASE hotel
GO

CREATE TABLE hotel.dbo.city (
	city_id		INT IDENTITY(1,1),
	name		VARCHAR(25) NOT NULL,

	CONSTRAINT miasta_kg PRIMARY KEY (city_id)
);
GO

CREATE TABLE hotel.dbo.room (
	room_id			INT NOT NULL,
	capacity		INT NOT NULL,
	price			MONEY NOT NULL,
	has_bathtub		BIT,
	has_safe		BIT,

	CONSTRAINT pokoje_kg PRIMARY KEY (room_id)
);
GO

CREATE TABLE hotel.dbo.client (
	client_id		INT IDENTITY(1,1),
	first_name		VARCHAR(25) NOT NULL,
	last_name		VARCHAR(25) NOT NULL,
	birth_date		DATE NOT NULL,
	city			INT NOT NULL,
	address			VARCHAR(45) NOT NULL,
	phone			VARCHAR(15) NOT NULL,
	type			INT NOT NULL,

	CONSTRAINT klienci_kg PRIMARY KEY (client_id),
	CONSTRAINT klienci_ko_miasto FOREIGN KEY (city) REFERENCES hotel.dbo.city (city_id),

	CONSTRAINT klienci_sprawdz_typ CHECK (type <= 3 AND type >= 1)
);
GO

CREATE TABLE hotel.dbo.occupation (
	occupation_id 	INT IDENTITY(1,1),
	name			VARCHAR(50)	NOT NULL,
	minimum_wage	MONEY NOT NULL,

	CONSTRAINT stanowisko_kg PRIMARY KEY (occupation_id)
)
GO

CREATE TABLE hotel.dbo.employee (
	employee_id			INT IDENTITY(1,1),
	first_name			VARCHAR(25) NOT NULL,
	last_name			VARCHAR(25) NOT NULL,
	city				INT NOT NULL,
	address				VARCHAR(45) NOT NULL,
	phone				VARCHAR(15) NOT NULL,
	birth_date			DATE NOT NULL,
	employment_date		DATE NOT NULL,
	leave_date			DATE,
	occupation_id		INT NOT NULL,
	wage				MONEY NOT NULL,

	CONSTRAINT pracownicy_kg PRIMARY KEY (employee_id),
	CONSTRAINT pracownicy_ko_miasto FOREIGN KEY (city) REFERENCES hotel.dbo.city (city_id),
	CONSTRAINT pracownicy_ko_stanowisko FOREIGN KEY (occupation_id) REFERENCES hotel.dbo.occupation (occupation_id),

	CONSTRAINT pracownicy_sprawdz_daty CHECK (birth_date < employment_date),
--	CONSTRAINT pracownicy_sprawdz_placa CHECK (wage >= (SELECT s.minimum_wage FROM occupation AS s WHERE s.occupation_id = occupation_id))
);
GO

CREATE TABLE hotel.dbo.exemployee (
	employee_id			INT  NOT NULL,
	first_name			VARCHAR(25) NOT NULL,
	last_name			VARCHAR(25) NOT NULL,
	city				INT NOT NULL,
	address				VARCHAR(45) NOT NULL,
	phone				VARCHAR(15) NOT NULL,
	birth_date			DATE NOT NULL,
	employment_date		DATE NOT NULL,
	leave_date			DATE NOT NULL,
	occupation_id		INT NOT NULL,
	wage				MONEY NOT NULL,

	CONSTRAINT byli_pracownicy_kg PRIMARY KEY (employee_id),
	CONSTRAINT byli_pracownicy_ko_miasto FOREIGN KEY (city) REFERENCES hotel.dbo.city (city_id),
	CONSTRAINT byli_pracownicy_ko_stanowisko FOREIGN KEY (occupation_id) REFERENCES hotel.dbo.occupation (occupation_id)
);
GO

CREATE TABLE hotel.dbo.booking (
	booking_id		INT IDENTITY(1, 1),
	client_id		INT NOT NULL,
	room_id			INT NOT NULL,
	man_count		INT NOT NULL,
	start_date		DATE NOT NULL,
	day_count		INT NOT NULL,

	CONSTRAINT rezerwacje_kg PRIMARY KEY(booking_id),
	CONSTRAINT rezerwacje_ko_pokoj FOREIGN KEY (room_id) REFERENCES hotel.dbo.room (room_id),
	CONSTRAINT rezerwacje_ko_klient FOREIGN KEY (client_id) REFERENCES hotel.dbo.client (client_id),

--	CONSTRAINT rezerwacje_sprawdz_il_os CHECK (man_count <= (SELECT p.capacity FROM room AS p WHERE p.room_id = room_id))
);
GO

CREATE TABLE hotel.dbo.past_booking (
	booking_id		INT,
	client_id		INT NOT NULL,
	room_id			INT NOT NULL,
	man_count		INT NOT NULL,
	start_date		DATE NOT NULL,
	end_date		DATE NOT NULL,

	CONSTRAINT byle_rezerwacje_kg PRIMARY KEY(booking_id),
	CONSTRAINT byle_rezerwacje_ko_pokoj FOREIGN KEY (room_id) REFERENCES hotel.dbo.room (room_id),
	CONSTRAINT byle_rezerwacje_ko_klient FOREIGN KEY (client_id) REFERENCES hotel.dbo.client (client_id),
);
GO
