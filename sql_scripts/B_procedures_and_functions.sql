USE hotel
GO


-- Procedure #1: archive_bookings - moves archive bookings to hotel..past_booking
	IF EXISTS (SELECT 1 FROM sysobjects WHERE NAME='booking_archive')
		DROP PROCEDURE archive_bookings
	GO

	CREATE PROCEDURE archive_bookings AS
		BEGIN
			INSERT INTO past_booking
			SELECT booking_id, client_id, room_id, man_count, [start_date], DATEADD(DAY, day_count, [start_date])
			FROM booking
			WHERE DAY(GETDATE()) > DAY([start_date]) + day_count

			DELETE FROM booking WHERE DAY(GETDATE()) > DAY([start_date]) + day_count
		END
	GO


-- Procedure #2: remove_employee - removes employee with specific id from hotel..employee
	IF EXISTS (SELECT 1 FROM sysobjects WHERE NAME='remove_employee')
		DROP PROCEDURE remove_employee
	GO

	CREATE PROCEDURE remove_employee (@id INT) AS
		BEGIN
			UPDATE employee SET leave_date = GETDATE() WHERE employee_id = @id
			INSERT INTO exemployee SELECT * FROM employee WHERE employee_id = @id
			DELETE FROM employee WHERE employee_id = @id
		END
	GO


-- Procedure #3: correct_booking_capacity - corrects bookings that were incorrectly registered (too many people) and prints out which one were incorrect
	IF EXISTS (SELECT 1 FROM sysobjects WHERE NAME='man_booking_correctness')
		DROP PROCEDURE correct_booking_capacity
	GO

	CREATE PROCEDURE correct_booking_capacity AS
		BEGIN
			DECLARE pointer CURSOR FOR SELECT booking_id, room_id, man_count FROM booking

			DECLARE @b_id INT, @r_id INT, @r_size INT, @room_capacity INT

			OPEN pointer
			FETCH NEXT FROM pointer INTO @b_id, @r_id, @r_size

			WHILE @@FETCH_STATUS = 0
			BEGIN
				SET @room_capacity = (SELECT capacity FROM room WHERE @r_id = room_id)

				IF (@r_size > @room_capacity)
				BEGIN
					PRINT 'Correcting amount of man in booking ' + CONVERT(varchar(4), @b_id) + '(room ' + CONVERT(varchar(3), @r_id)
							+ ' from ' + CONVERT(varchar(5), @r_size) + ' to ' + CONVERT(varchar(1), @room_capacity) + ')'
					UPDATE booking SET man_count = @room_capacity WHERE booking_id = @b_id
				END
				FETCH NEXT FROM pointer INTO @b_id, @r_id, @r_size
			END

			CLOSE pointer
			DEALLOCATE pointer
		END
	GO


-- Procedure #4: get_most_booked_room - most booked room on specified floor
	IF EXISTS (SELECT 1 FROM sysobjects WHERE NAME = 'most_booked_room')
		DROP PROCEDURE get_most_booked_room
	GO

	CREATE PROCEDURE get_most_booked_room(@floor int) AS
		BEGIN
			DECLARE @room INT
			SELECT @room = room_id FROM past_booking
			WHERE room_id/100 = @floor
			GROUP BY room_id
			HAVING count(room_id) = (
				SELECT TOP 1 count(room_id) AS 'occurances' FROM past_booking
				WHERE room_id/100 = @floor
				GROUP BY room_id
				ORDER BY occurances DESC
			)

			PRINT 'On floor ' + convert(char(1), @floor) + ' most booked room is room ' + convert(char(3), @room)
		END
	GO


-- Procedure #5: get_total_wage_for_all_employees - count charge for employees for specified month and year
	IF EXISTS (SELECT 1 FROM sysobjects WHERE NAME='charges')
		DROP PROCEDURE get_total_wage_for_all_employees
	GO

	CREATE PROCEDURE get_total_wage_for_all_employees (@year varchar(4), @month varchar(20)) AS
		BEGIN
			DECLARE @income INT = 0
			DECLARE @wage INT, @employment_date DATE, @leave_date DATE

			DECLARE pointer CURSOR FOR SELECT wage, employment_date FROM employee
			OPEN pointer
			FETCH NEXT FROM pointer INTO @wage, @employment_date
			WHILE @@FETCH_STATUS = 0
				BEGIN
					IF ((DATENAME(yy, @employment_date) < @year) AND (DATENAME(mm, @employment_date) < @month))
						SET @income = @income + @wage

					FETCH NEXT FROM pointer INTO @wage, @employment_date
				END
			CLOSE pointer
			DEALLOCATE pointer

			DECLARE pointer CURSOR FOR SELECT  wage, employment_date, leave_date FROM exemployee
			OPEN pointer
			FETCH NEXT FROM pointer INTO @wage, @employment_date, @leave_date
			WHILE @@FETCH_STATUS = 0
				BEGIN
					IF (@year BETWEEN DATENAME(yy, @employment_date) AND DATENAME(yy, @leave_date))
						AND (@month BETWEEN DATENAME(mm, @employment_date) AND DATENAME(mm, @leave_date))
						SET @income = @income + @wage

					FETCH NEXT FROM pointer INTO @wage, @employment_date, @leave_date
				END
			CLOSE pointer
			DEALLOCATE pointer

			PRINT('Charges for employees in ' + @year + '-' + @month + ': ' + CAST(@income AS varchar(100)))
		END
	GO


-- Function #1: get_booking_cost - counts cost of specified booking
	IF EXISTS (SELECT 1 FROM sysobjects WHERE NAME='booking_cost')
		DROP FUNCTION get_booking_cost
	GO

	CREATE FUNCTION get_booking_cost(@id int)
	RETURNS int AS
		BEGIN
			DECLARE @sum int
			SET @sum = 0
			IF EXISTS (SELECT booking_id FROM booking WHERE booking_id = @id)
			BEGIN
				SET @sum += ((SELECT price FROM booking AS b, room AS r WHERE b.booking_id = @id AND b.room_id = r.room_id)
								* (SELECT day_count FROM booking WHERE booking_id = @id))

				IF EXISTS (SELECT [type] FROM client AS c, booking AS b WHERE [type] = 2 AND b.client_id = c.client_id AND b.booking_id = @id)
					SET @sum = @sum * 0.9

				IF EXISTS (SELECT [type] FROM client AS c, booking AS b WHERE [type] = 3 AND b.client_id = c.client_id AND b.booking_id = @id)
					SET @sum = @sum * 0.8

				RETURN @sum
			END

			ELSE
				SET @sum += ((SELECT price FROM past_booking AS pb, room AS r WHERE pb.booking_id = @id AND pb.room_id = r.room_id)
								* (SELECT DATEDIFF(DAY, [start_date], end_date) FROM past_booking WHERE booking_id = @id))

				IF EXISTS (SELECT [type] FROM client AS c, past_booking AS pb WHERE [type] = 2 AND pb.client_id = c.client_id AND pb.booking_id = @id)
					SET @sum = @sum * 0.9

				IF EXISTS (SELECT [type] FROM client AS c, past_booking AS pb WHERE [type] = 3 AND pb.client_id = c.client_id AND pb.booking_id = @id)
					SET @sum = @sum * 0.8

				RETURN @sum
		END
	GO


-- Function #2: is_room_available - check if specified room is available within specified time
	if exists (select 1 from sysobjects where name = 'room_availability')
		drop function is_room_available
	go

	create function is_room_available(@room int, @start date, @days int)
	returns bit as
		begin
			if exists (
				select * from booking where @room = room_id and (
					(@start >= [start_date] and @start <= dateadd(day, day_count, [start_date]))
					or
					(dateadd(day, @days, @start) >= [start_date] and dateadd(day, @days, @start) <= dateadd(day, day_count, [start_date]))
					or
					(@start <= [start_date] and dateadd(day, @days, @start) >= dateadd(day, day_count, [start_date]))
				)
			)
			return 0

			return 1
		end
	go


--
