USE hotel
GO

-- Procedure #1: archive_bookings - moves archive bookings to hotel..past_booking
    select * from past_booking
    go
    EXEC archive_bookings
    select * from past_booking
    go

-- Procedure #2: remove_employee - removes employee with specific id from hotel..employee
    select * from exemployee
    go
    EXEC remove_employee 10
    EXEC remove_employee 12
    EXEC remove_employee 14
    select * from exemployee
    go
    EXEC remove_employee 2137

-- Procedure #3: correct_booking_capacity - corrects bookings that were incorrectly registered (too many people) and prints out which one were incorrect
    EXEC correct_booking_capacity

-- Procedure #4: get_most_booked_room - most booked room on specified floor
    EXEC get_most_booked_room 2

-- Procedure #5: get_total_wage_for_all_employees - count charge for employees for specified month and year
    EXEC get_total_wage_for_all_employees '2018', 'Styczen'

-- Function #1: get_booking_cost - counts cost of specified booking
    SELECT *, dbo.get_booking_cost(booking_id) as 'booking_cost' FROM booking

-- Function #2: is_room_available - check if specified room is available within specified time
    SELECT room_id, dbo.is_room_available(room_id, '2018/8/8', 15) AS 'Is available within date range 08-23.08.2018)' FROM room WHERE room_id LIKE '3%'

--
