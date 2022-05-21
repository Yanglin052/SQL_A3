--1.Create a view named ¡°view_product_order_[your_last_name]¡±, list all products and total ordered quantity for that product.
CREATE VIEW view_product_order_Lin
AS
SELECT P.ProductID, P.ProductName, SUM(OD.Quantity) as TotalQuantity
FROM Products P JOIN [Order Details] OD ON P.ProductID = OD.ProductID
GROUP BY P.ProductID, P.ProductName;


--2.Create a stored procedure ¡°sp_product_order_quantity_[your_last_name]¡± 
-- that accept product id as an input and total quantities of order as output parameter.
CREATE PROC sp_product_order_quantity_Lin
@productID int,
@totalquantities int out
AS
BEGIN
SELECT @totalquantities = SUM(OD.Quantity) 
FROM Products P JOIN [Order Details] OD ON P.ProductID = OD.ProductID 
WHERE @productID = P.ProductID
GROUP BY P.ProductID
END


--3.Create a stored procedure ¡°sp_product_order_city_[your_last_name]¡± 
-- that accept product name as an input and top 5 cities that ordered most that product 
-- combined with the total quantity of that product ordered from that city as output.
CREATE PROC sp_product_order_city_Lin
@productName varchar(50),
@city varchar(50) out,
@totalquantities int out
AS
BEGIN
SELECT @productName = ProductName, @city = ShipCity, @totalquantities = TotalQuantity
FROM (
SELECT P.ProductName, O.ShipCity, RANK() OVER(PARTITION BY P.ProductName ORDER BY SUM(OD.Quantity) DESC) AS RNK, SUM(OD.Quantity) as TotalQuantity
FROM Products p JOIN [Order Details] OD ON P.ProductID = OD.ProductID
JOIN Orders O ON O.OrderID = OD.OrderID
GROUP BY O.ShipCity, P.ProductName) NT
WHERE RNK BETWEEN 1 AND 5
END


--4.Create 2 new tables ¡°people_your_last_name¡± ¡°city_your_last_name¡±. 
-- City table has two records: {Id:1, City: Seattle}, {Id:2, City: Green Bay}. 
-- People has three records: {id:1, Name: Aaron Rodgers, City: 2}, {id:2, Name: Russell Wilson, City:1}, {Id: 3, Name: Jody Nelson, City:2}. 
-- Remove city of Seattle. If there was anyone from Seattle, put them into a new city ¡°Madison¡±. 
-- Create a view ¡°Packers_your_name¡± lists all people from Green Bay. 
-- If any error occurred, no changes should be made to DB. (after test) Drop both tables and view.
CREATE TABLE city_Lin(
CityId int primary key,
City varchar(25) NOT NULL
)
CREATE TABLE people_Lin(
Id int primary key,
Name varchar(20) NOT NULL,
CityId int foreign key references city_Lin(CityId)
)
INSERT INTO city_Lin VALUES (1, 'Seattle')
INSERT INTO city_Lin VALUES (2, 'Green Bay')
INSERT INTO people_Lin VALUES (1, 'Aaron Rodgers',2)
INSERT INTO people_Lin VALUES (2, 'Russell Wilson',1)
INSERT INTO people_Lin VALUES (3, 'Jody Nelson',2)
UPDATE city_Lin SET City = 'Madison' WHERE City = 'Seattle'

CREATE VIEW Packers_Lin
AS
SELECT P.Id, P.Name, C.City
FROM city_Lin C JOIN people_Lin P ON C.CityId = P.CityId
WHERE C.City = 'Green Bay'

DROP TABLE people_Lin
DROP TABLE city_Lin
DROP VIEW Packers_Lin


--5.Create a stored procedure ¡°sp_birthday_employees_[you_last_name]¡± 
-- that creates a new table ¡°birthday_employees_your_last_name¡± and fill it with all employees that have a birthday on Feb. 
-- (Make a screen shot) drop the table. Employee table should not be affected.
CREATE PROC sp_birthday_employees_Lin
AS
BEGIN
SELECT EmployeeID, FirstName + ' ' + LastName as FullName, BirthDate into birthday_employees_lin
FROM Employees
WHERE MONTH(BirthDate) = 02
END
DROP TABLE birthday_employees_lin

--6.How do you make sure two tables have the same data?
SELECT * FROM Table1
UNION
SELECT * FROM Table2
If the numebr of records using UNINON is not the same as the total number od two tables, then they have same data, since UNION will remove duplecte data.
