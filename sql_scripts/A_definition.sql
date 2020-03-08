
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

	CONSTRAINT city_pk PRIMARY KEY (city_id)
);
GO

CREATE TABLE hotel.dbo.room (
	room_id			INT NOT NULL,
	capacity		INT NOT NULL,
	price			MONEY NOT NULL,
	has_bathtub		BIT,
	has_safe		BIT,

	CONSTRAINT room_pk PRIMARY KEY (room_id)
);
GO

CREATE TABLE hotel.dbo.client (
	client_id		INT IDENTITY(1,1),
	first_name		VARCHAR(25) NOT NULL,
	last_name		VARCHAR(25) NOT NULL,
	birth_date		DATE NOT NULL,
	city_id			INT NOT NULL,
	address			VARCHAR(45) NOT NULL,
	phone			VARCHAR(15) NOT NULL,
	type			INT NOT NULL,

	CONSTRAINT client_pk PRIMARY KEY (client_id),
	CONSTRAINT client_city_fk FOREIGN KEY (city_id) REFERENCES hotel.dbo.city (city_id),

	CONSTRAINT client_type_check CHECK (type <= 3 AND type >= 1)
);
GO

CREATE TABLE hotel.dbo.occupation (
	occupation_id 	INT IDENTITY(1,1),
	name			VARCHAR(50)	NOT NULL,
	minimum_wage	MONEY NOT NULL,

	CONSTRAINT occupation_pk PRIMARY KEY (occupation_id)
)
GO

CREATE TABLE hotel.dbo.employee (
	employee_id			INT IDENTITY(1,1),
	first_name			VARCHAR(25) NOT NULL,
	last_name			VARCHAR(25) NOT NULL,
	city_id				INT NOT NULL,
	address				VARCHAR(45) NOT NULL,
	phone				VARCHAR(15) NOT NULL,
	birth_date			DATE NOT NULL,
	employment_date		DATE NOT NULL,
	leave_date			DATE,
	occupation_id		INT NOT NULL,
	wage				MONEY NOT NULL,

	CONSTRAINT employee_pk PRIMARY KEY (employee_id),
	CONSTRAINT employee_city_fk FOREIGN KEY (city_id) REFERENCES hotel.dbo.city (city_id),
	CONSTRAINT employee_occupation_fk FOREIGN KEY (occupation_id) REFERENCES hotel.dbo.occupation (occupation_id),

	CONSTRAINT employee_date_check CHECK (birth_date < employment_date),
--	CONSTRAINT employee_wage_check CHECK (wage >= (SELECT s.minimum_wage FROM occupation AS s WHERE s.occupation_id = occupation_id))
);
GO

CREATE TABLE hotel.dbo.exemployee (
	employee_id			INT  NOT NULL,
	first_name			VARCHAR(25) NOT NULL,
	last_name			VARCHAR(25) NOT NULL,
	city_id				INT NOT NULL,
	address				VARCHAR(45) NOT NULL,
	phone				VARCHAR(15) NOT NULL,
	birth_date			DATE NOT NULL,
	employment_date		DATE NOT NULL,
	leave_date			DATE NOT NULL,
	occupation_id		INT NOT NULL,
	wage				MONEY NOT NULL,

	CONSTRAINT exemployee_pk PRIMARY KEY (employee_id),
	CONSTRAINT exemployee_city_fk FOREIGN KEY (city_id) REFERENCES hotel.dbo.city (city_id),
	CONSTRAINT exemployee_occupation_fk FOREIGN KEY (occupation_id) REFERENCES hotel.dbo.occupation (occupation_id)
);
GO

CREATE TABLE hotel.dbo.booking (
	booking_id		INT IDENTITY(1, 1),
	client_id		INT NOT NULL,
	room_id			INT NOT NULL,
	man_count		INT NOT NULL,
	start_date		DATE NOT NULL,
	day_count		INT NOT NULL,

	CONSTRAINT booking_pk PRIMARY KEY(booking_id),
	CONSTRAINT booking_room_fk FOREIGN KEY (room_id) REFERENCES hotel.dbo.room (room_id),
	CONSTRAINT booking_client_fk FOREIGN KEY (client_id) REFERENCES hotel.dbo.client (client_id),

--	CONSTRAINT booking_room_capacity_check CHECK (man_count <= (SELECT p.capacity FROM room AS p WHERE p.room_id = room_id))
);
GO

CREATE TABLE hotel.dbo.past_booking (
	booking_id		INT,
	client_id		INT NOT NULL,
	room_id			INT NOT NULL,
	man_count		INT NOT NULL,
	start_date		DATE NOT NULL,
	end_date		DATE NOT NULL,

	CONSTRAINT past_booking_pk PRIMARY KEY(booking_id),
	CONSTRAINT past_booking_room_fk FOREIGN KEY (room_id) REFERENCES hotel.dbo.room (room_id),
	CONSTRAINT past_booking_client_fk FOREIGN KEY (client_id) REFERENCES hotel.dbo.client (client_id),
);
GO
