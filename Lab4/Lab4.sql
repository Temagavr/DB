/*CREATE DATABASE Lab4;
USE Lab4;*/

-- 1. �������� ������� �����.
ALTER TABLE room 
ADD FOREIGN KEY (id_hotel) REFERENCES hotel (id_hotel);

ALTER TABLE room 
ADD FOREIGN KEY (id_room_category) REFERENCES room_category (id_room_category);

ALTER TABLE room_in_booking
ADD FOREIGN KEY (id_booking) REFERENCES booking (id_booking);

ALTER TABLE room_in_booking
ADD FOREIGN KEY (id_room) REFERENCES room (id_room);

ALTER TABLE booking
ADD FOREIGN KEY (id_client) REFERENCES client (id_client);

-- 2. ������ ���������� � �������� ��������� "������", ����������� � ������� ��������� "����" �� 1 ������ 2019�. 
SELECT client.id_client, client.name, client.phone FROM room_in_booking
LEFT JOIN room ON room_in_booking.id_room = room.id_room
LEFT JOIN hotel ON hotel.id_hotel = room.id_hotel
LEFT JOIN room_category ON room_category.id_room_category = room.id_room_category
LEFT JOIN booking ON booking.id_booking = room_in_booking.id_booking
LEFT JOIN client ON client.id_client = booking.id_client
WHERE hotel.name = '������' AND room_category.name = '����' AND 
	('2019-04-01' >= room_in_booking.checkin_date AND '2019-04-01' < room_in_booking.checkout_date);

-- 3. ���� ������ ��������� ������� ���� �������� �� 22 ������. 
SELECT * FROM room WHERE id_room NOT IN (
	SELECT room.id_room FROM room_in_booking 
	RIGHT JOIN room ON room.id_room = room_in_booking.id_room
	WHERE '2019-04-22' >= room_in_booking.checkin_date AND '2019-04-22' <= room_in_booking.checkout_date
)
ORDER BY id_room, id_hotel;

-- 4. ���� ���������� ����������� � ��������� "������" �� 23 ����� �� ������ ��������� �������	
SELECT COUNT(room_in_booking.id_room) AS residents, room_category.name FROM room_category
INNER JOIN room ON room_category.id_room_category = room.id_room_category
INNER JOIN hotel ON hotel.id_hotel = room.id_hotel
INNER JOIN room_in_booking ON room.id_room = room_in_booking.id_room
WHERE hotel.name = '������' AND 
	('2019-03-23' >= room_in_booking.checkin_date AND '2019-03-23' < room_in_booking.checkout_date)
GROUP BY room_category.name;

-- 5. ���� ������ ��������� ����������� �������� �� ���� �������� ��������� "������", ��������� � ������ � ��������� ���� ������. 
-- ���������� ����� ������ room_in_booking �� ����������� id

SELECT client.name, MAX(#temp_table.departure_date) AS depature_date, #temp_table.id_room
FROM #temp_table
  LEFT JOIN room_in_booking
	ON #temp_table.id_room = room_in_booking.id_room AND #temp_table.departure_date = room_in_booking.checkout_date
  LEFT JOIN booking ON room_in_booking.id_booking = booking.id_booking
  LEFT JOIN client ON booking.id_client = client.id_client
GROUP BY client.name, #temp_table.id_room
ORDER BY client.name;

-- 6. �������� �� 2 ��� ���� ���������� � ��������� "������" ���� �������� ������ ��������� "������", ������� ���������� 10 ���.
UPDATE room_in_booking
SET room_in_booking.checkout_date = DATEADD(day, 2, checkout_date)
FROM room
	INNER JOIN hotel ON room.id_hotel = hotel.id_hotel
	INNER JOIN room_category ON room.id_room_category = room_category.id_room_category
WHERE hotel.name = '������' AND room_category.name = '������' AND room_in_booking.checkin_date = '2019-05-10';

--7. ����� ��� "��������������" �������� ����������.
SELECT *
FROM room_in_booking booking_2, room_in_booking booking_1
WHERE booking_1.id_room = booking_2.id_room AND
	(booking_2.checkin_date <= booking_1.checkin_date AND booking_1.checkout_date < booking_2.checkout_date)
ORDER BY booking_1.id_room_in_booking;


-- 8. ������� ������������ � ����������
BEGIN TRANSACTION
	INSERT INTO booking VALUES(8, '2020-03-07');  
COMMIT;


-- 9. �������� ����������� ������� ��� ���� ������
CREATE NONCLUSTERED INDEX [IX_room_id_booking_checkin_date-checkout_date] ON [dbo].[room_in_booking]
(
	[checkin_date] ASC,
	[checkout_date] ASC
)

CREATE NONCLUSTERED INDEX [IX_room_in_booking_id_room-id_booking] ON [dbo].[room_in_booking]
(
	[id_room] ASC,
	[id_booking] ASC
)

CREATE NONCLUSTERED INDEX [IX_room_id_hotel-id_room_category] ON [dbo].[room]
(
	[id_hotel] ASC,
	[id_room_category] ASC
)

CREATE NONCLUSTERED INDEX [IX_booking_id_client] ON [dbo].[booking]
(
	[id_client] ASC
)

CREATE UNIQUE NONCLUSTERED INDEX [IX_client_phone] ON [dbo].[client]
(
	[phone] ASC
)

CREATE NONCLUSTERED INDEX [IX_hotel_name] ON [dbo].[hotel]
(
	[name] ASC
)

CREATE NONCLUSTERED INDEX [IX_room_category_name] ON [dbo].[room_category]
(
	[name] ASC
)

