USE Lab3;
--1.INSERT

--БЕЗ УКАЗАНИЯ ПОЛЕЙ
INSERT INTO [Client]
VALUES 
	('ALEX', 'SMITH', '8912345678', 'TTT@MAIL.RU' );

--С УКАЗАНИЕМ ПОЛЕЙ
INSERT INTO [Client] (Name, Surname, Phone_number)
VALUES 
	('JOHN', 'SMITH', '8912123678');

INSERT INTO [Client] (Name, Surname, Phone_number)
VALUES 
	('MAX', 'MAD', '6656');

INSERT INTO [Realtor]
VALUES 
	('ALFI', 'SOLOMANCE', '02', 2);

--С ВЫБОРКОЙ ИЗ ДРУГОЙ ТАБЛИЦЫ 
INSERT INTO [Appeal] (Id_Client) SELECT Id_Client FROM Client;

	/*
INSERT INTO [Appeal]
VALUES
	('2020-03-31', 'SOME', 1, 1);

INSERT INTO [Appeal]
VALUES
	('2020-02-29', 'SOME', 2, 1);

INSERT INTO [Appeal]
VALUES
	('2000-01-31', 'SOME', 3, 2);
*/

--2.DELETE

--УДАЛЕНИЕ ВСЕХ ЗАПИСЕЙ
DELETE [Appeal];

--УДАЛЕНИЕ ОДНОЙ ЗАПИСИ 
DELETE FROM [Appeal] WHERE Id_Client = 1;

--УДАЛЕНИЕ ВСЕХ ЗАПИСЕЙ
TRUNCATE TABLE [Appeal];

--3.UPDATE

--ОБНОВЛЕНИЕ ВСЕХ ЗАПИСЕЙ
UPDATE [Appeal]
SET Id_Realtor = 1;

--По условию обновляя один атрибут
UPDATE [Client]
SET Name = 'Sam'
WHERE Surname = 'SMITH';

--По условию обновляя несколько атрибутов
UPDATE [Realtor]
SET Name = 'ARTUR',
	Surname = 'SHELBY'
WHERE Surname = 'SOLOMANCE';

--4.SELECT

--ВЫБОРКА НЕКОТОРЫХ АТРИБУТОВ
SELECT Id_Client, Name, Surname FROM [Client];

--ПОЛНАЯ ВЫБОРКА 
SELECT * FROM [Realtor];

--ВЫБОРКА С УСЛОВИЕМ 
SELECT Id_Client, Name, Surname FROM [Client] WHERE Name = 'Sam';

--5.SELECT ORDER BY + TOP(LIMIT)
--С сортировкой по возрастанию ASC + ограничение вывода количества записей
SELECT TOP 5 * FROM [Client]
ORDER BY Name ASC;

--С сортировкой по убыванию DESC
SELECT TOP 5 * FROM [Client]
ORDER BY Name DESC;

--С сортировкой по двум атрибутам + ограничение вывода количества записей
SELECT TOP 5 Name, Surname
FROM [Client]
ORDER BY Name ASC, Surname DESC;

--С сортировкой по первому атрибуту, из списка извлекаемых
SELECT TOP 5 Name, Surname
FROM [Client]
ORDER BY 1 ASC;

--6.РАБОТА С ДАТАМИ

--WHERE по дате
SELECT * FROM [Appeal] 
WHERE Date = '2020-03-31';

--ВЫБОРКА ТОЛЬКО ГОДА
SELECT YEAR(DATE) FROM [Appeal];

--7.SELECT GROUP BY

-- MIN
SELECT Id_Realtor, MIN(Date) AS FirstAppeal FROM [Appeal]
GROUP BY Id_Realtor;

--MAX
SELECT Id_Realtor, MAX(Date) AS LastAppeal FROM [Appeal]
GROUP BY Id_Realtor;

--AVG
SELECT Id_Company, AVG(Cost) AS AvgCost FROM [Apartament]
GROUP BY Id_Company;

--SUM
SELECT Id_Company, SUM(Cost) AS SumCost FROM [Apartament]
GROUP BY Id_Company;

--COUNT
SELECT Id_Realtor, COUNT(Id_Client) AS ClientsCount FROM [Appeal]
GROUP BY Id_Realtor;

--8.SELECT GROUP BY + HAVING

SELECT Id_Realtor, COUNT(Id_Client) FROM [Appeal]
GROUP BY Id_Realtor
HAVING COUNT(Id_Client) > 1;

SELECT Id_Company, SUM(Cost) AS SumCost FROM [Apartament]
GROUP BY Id_Company
HAVING SUM(Cost) > 20000000;

SELECT Address , COUNT(Id_Company) AS ApartamentCount FROM [Apartament]
GROUP BY Address
HAVING COUNT(Id_Company) > 1;

--9.SELECT JOIN

-- LEFT JOIN двух таблиц и WHERE по одному из атрибутов
SELECT * FROM [Appeal] LEFT JOIN Realtor ON Appeal.Id_Realtor = Realtor.Id_Realtor WHERE YEAR(Appeal.Date) > 2002;

--RIGHT JOIN. Получить такую же выборку, как и в 5.1 (как я понял надо как в 9.1 а не в 5.1)
SELECT TOP 5 * FROM [Appeal] RIGHT JOIN Realtor ON Appeal.Id_Realtor = Realtor.Id_Realtor WHERE YEAR(Appeal.Date) > 2002
ORDER BY Id_Client ASC;

--LEFT JOIN трех таблиц + WHERE по атрибуту из каждой таблицы
SELECT * FROM [Client] LEFT JOIN Appeal ON Client.Id_Client = Appeal.Id_Client
LEFT JOIN Realtor ON Appeal.Id_Realtor = Realtor.Id_Realtor
WHERE Realtor.Phone_number = '02' AND Client.Id_Client = 1 AND YEAR(Appeal.Date) > 2018; 

--FULL OUTER JOIN двух таблиц
SELECT * FROM [Realtor] FULL OUTER JOIN Company ON Realtor.Id_Company = Company.Id_Company; 

--10.ПОДЗАПРОСЫ

SELECT * FROM [Apartament]
WHERE Id_Company IN (SELECT TOP 5 Id_Company FROM [Company]);

SELECT Id_Client, Name, Phone_number,
	( SELECT Date FROM [Appeal] WHERE Id_Client = Client.Id_Client) AS AppealDate
FROM [Client]
WHERE Id_Client = 3;
