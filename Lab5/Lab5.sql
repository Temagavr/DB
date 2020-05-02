/*CREATE DATABASE pharmacy;
USE pharmacy;*/

--1. Добавить внешние ключи
ALTER TABLE [production] 
ADD FOREIGN KEY (id_medicine) REFERENCES [medicine] (id_medicine);

ALTER TABLE [production]
ADD FOREIGN KEY (id_company) REFERENCES [company] (id_company);

ALTER TABLE [dealer] 
ADD FOREIGN KEY (id_company) REFERENCES [company] (id_company);

ALTER TABLE [order] 
ADD FOREIGN KEY (id_production) REFERENCES [production] (id_production);

ALTER TABLE [order] 
ADD FOREIGN KEY (id_dealer) REFERENCES [dealer] (id_dealer);

ALTER TABLE [order] 
ADD FOREIGN KEY (id_pharmacy) REFERENCES [pharmacy] (id_pharmacy);

--2. Выдать информацию по всем заказам лекарства “Кордерон” компании “Аргус” с указанием названий аптек, дат, объема заказов

SELECT * FROM [order]
LEFT JOIN [pharmacy] ON [order].id_pharmacy = [pharmacy].id_pharmacy
LEFT JOIN [production] ON [order].id_production = [production].id_production
LEFT JOIN [company] ON [production].id_company = [company].id_company
LEFT JOIN [medicine] ON [production].id_medicine = [medicine].id_medicine
WHERE [medicine].name = 'Кордерон' AND [company].name = 'Аргус';

--3. Дать список лекарств компании “Фарма”, на которые не были сделаны заказы до 25 января

SELECT [medicine].name FROM [medicine]
LEFT JOIN [production] ON [production].id_medicine = [medicine].id_medicine
LEFT JOIN [company] ON [production].id_company = [company].id_company
LEFT JOIN [order] ON [production].id_production = [order].id_production
WHERE [company].name = 'Фарма'
GROUP BY [medicine].id_medicine, [medicine].name
HAVING MIN([order].date) >= '2019-01-25';

--4. Дать минимальный и максимальный баллы лекарств каждой фирмы, которая оформила не менее 120 заказов

SELECT [company].name, MIN(rating) AS min_rate, MAX(rating) AS max_rate
FROM [production]
LEFT JOIN [order] ON [production].id_production = [order].id_production
LEFT JOIN [company] ON [production].id_company = [company].id_company
GROUP BY [production].id_company, [company].name
HAVING COUNT([order].id_order) >= 120;

--5. Дать списки сделавших заказы аптек по всем дилерам компании “AstraZeneca”. Если у дилера нет заказов, в названии аптеки
--проставить NULL

SELECT [pharmacy].name, [dealer].name, [dealer].id_dealer FROM [dealer]
LEFT JOIN [order] ON [dealer].id_dealer = [order].id_dealer
LEFT JOIN [pharmacy] ON [order].id_pharmacy = [pharmacy].id_pharmacy
LEFT JOIN [company] ON [dealer].id_company = [company].id_company
WHERE [company].name = 'AstraZeneca'
ORDER BY [dealer].name

--6. Уменьшить на 20% стоимость всех лекарств, если она превышает 3000, а длительность лечения не более 7 дней
 
--BEGIN TRANSACTION 
	UPDATE [production]
	SET [production].price = [production].price * 0.8
	WHERE [production].id_medicine IN ( 
		SELECT [production].id_medicine FROM [production]
		LEFT JOIN [medicine] ON [production].id_medicine = [medicine].id_medicine
		WHERE [medicine].cure_duration <= 7 AND [production].price > 3000);
--COMMIT;

--7. Добавить необходимые индексы

CREATE NONCLUSTERED INDEX [IX_dealer_id_company] ON [dbo].[dealer]
(
	[id_company] ASC
)

CREATE NONCLUSTERED INDEX [IX_production_id_company] ON [dbo].[production]
(
	[id_company] ASC
)

CREATE NONCLUSTERED INDEX [IX_production_id_medicine] ON [dbo].[production]
(
	[id_medicine] ASC
)

CREATE NONCLUSTERED INDEX [IX_production_rating] ON [dbo].[production]
(
	[rating] ASC
)

CREATE NONCLUSTERED INDEX [IX_company_name] ON [dbo].[company]
(	
	[name] ASC
)

CREATE NONCLUSTERED INDEX [IX_medicine_name] ON [dbo].[medicine]
(
	[name] ASC
)

CREATE NONCLUSTERED INDEX [IX_order_date] ON [dbo].[order]
(
	[date] ASC
)

CREATE NONCLUSTERED INDEX [IX_order_id_production] ON [dbo].[order]
(
	[id_production] ASC
)

CREATE NONCLUSTERED INDEX [IX_order_id_dealer] ON [dbo].[order]
(
	[id_dealer] ASC
)

CREATE NONCLUSTERED INDEX [IX_order_id_pharmacy] ON [dbo].[order]
(
	[id_pharmacy] ASC
)