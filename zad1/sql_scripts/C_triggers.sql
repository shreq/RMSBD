USE hotel
GO


-- Trigger #1 - check if client's type should be upgraded after archiving the booking
	if exists (select 1 from sysobjects where name='client_upgrade')
		drop trigger client_upgrade
	go

	create trigger client_upgrade
	on past_booking
	after insert as
		begin
			declare @silver int = 5
			declare @gold int = 10

			declare upgrade cursor for
			select client_id from inserted
			declare @id int, @booking_count int
			open upgrade
			fetch next from upgrade into @id
			while @@FETCH_STATUS = 0
				begin
					select @booking_count = count(*) from past_booking where client_id = @id
					if @booking_count > @gold
						update client set [type] = 3 where client_id = @id
					else if @booking_count > @silver
						update client set [type] = 2 where client_id = @id
					fetch next from upgrade into @id
				end
			close upgrade
			deallocate upgrade
		end
	go


-- Trigger #2 - authorize bookings only when room is available
	if exists (select 1 from sysobjects where name='booking_authorization')
		drop trigger booking_authorization
	go

	create trigger booking_authorization
	on booking
	instead of insert as
		begin
			create table #entries (
				client_id	INT NOT NULL,
				room_id		INT NOT NULL,
				man_count	INT NOT NULL,
				start_date	DATE NOT NULL,
				day_count	INT NOT NULL
			)
			declare auth cursor for select client_id, room_id, man_count, [start_date], day_count from inserted
			declare @client int, @room int, @man_count int, @start_date date, @day_count int
			open auth
			fetch next from auth into @client, @room, @man_count, @start_date, @day_count
			while @@FETCH_STATUS = 0
				begin
					if (dbo.is_room_available(@room, @start_date, @day_count) = 0)
						print 'Error: Room ' + convert(varchar(3), @room)+ ' is not available in requested date range (' + convert(varchar(20), @start_date) + ' - ' + convert(varchar(20), dateadd(day, @day_count, @start_date)) + ')'
					else
						insert into #entries values (@client, @room, @man_count, @start_date, @day_count)
					fetch next from auth into @client, @room, @man_count, @start_date, @day_count
				end
			close auth
			deallocate auth
			insert into booking select * from #entries
		end
	go


-- Trigger #3 - check for better rooms while booking
	IF EXISTS (SELECT 1 FROM sysobjects WHERE NAME='cheaper_rooms')
		DROP TRIGGER cheaper_rooms
	GO

	CREATE TRIGGER cheaper_rooms
	ON booking
	AFTER INSERT AS
		BEGIN
			DECLARE @r_id INT, @capacity INT, @price INT, @h_b BIT, @h_s BIT, @b_id INT
			select booking_id, room_id into #b_id from inserted

			while exists (select * from #b_id)
			begin
				select top 1 @b_id = booking_id from #b_id

				DECLARE pointer CURSOR FOR SELECT room_id, capacity, price, has_bathtub, has_safe FROM room
				OPEN pointer
				FETCH NEXT FROM pointer INTO @r_id, @capacity, @price, @h_b, @h_s

				WHILE @@FETCH_STATUS = 0
				BEGIN
					DECLARE @base_price INT = (SELECT r.price FROM room AS r, #b_id AS bid WHERE bid.room_id = r.room_id and bid.booking_id = @b_id)

					IF ((@price <= @base_price) AND (@r_id NOT IN (
							SELECT b.room_id FROM booking AS b, inserted AS i WHERE ((i.[start_date] > DATEADD(DAY, b.day_count, b.[start_date]))
							OR (DATEADD(DAY, i.day_count, i.[start_date]) < b.[start_date])))))
						BEGIN
							DECLARE @description VARCHAR(200) = ''
							IF (@price < @base_price)
								SET @description = 'room is cheaper by ' + CONVERT(VARCHAR(5), (@base_price - @price))

							IF (@capacity < (SELECT r.capacity FROM room AS r, #b_id AS bid WHERE bid.room_id = r.room_id and bid.booking_id = @b_id))
								BEGIN
									IF  @description <> ''
										SET @description = @description + ', fits more people'
									ELSE
										SET @description = @description + 'fits more people'
								END

							IF (@h_s < (SELECT r.has_safe FROM room AS r, #b_id AS bid WHERE bid.room_id = r.room_id and bid.booking_id = @b_id))
								BEGIN
									IF  @description <> ''
										SET @description = @description + ', has safe'
									ELSE
										SET @description = @description + 'has safe'
								END

							IF (@h_b < (SELECT r.has_bathtub FROM room AS r, #b_id AS bid WHERE bid.room_id = r.room_id and bid.booking_id = @b_id))
								BEGIN
									IF  @description <> ''
										SET @description = @description + ', has bathtub'
									ELSE
										SET @description = @description + 'has bathtub'
								END

							IF @description <> ''
								PRINT ' Booking ' + CONVERT(VARCHAR(5), @b_id) + ': Room ' + CONVERT(VARCHAR(3), @r_id) + ' is better choice, because: ' + @description + '.'

						END
					FETCH NEXT FROM pointer INTO @r_id, @capacity, @price, @h_b, @h_s
				END

				delete #b_id where booking_id = @b_id

				CLOSE pointer
				DEALLOCATE pointer
			end
		END
	GO


--
