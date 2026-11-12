USE master;
GO
IF DB_ID('ShopDB') IS NOT NULL BEGIN ALTER DATABASE ShopDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE ShopDB; END
GO
CREATE DATABASE ShopDB;
GO
USE ShopDB;
GO

CREATE TABLE Categories (
    CategoryId INT IDENTITY(1,1) PRIMARY KEY,
    Name       NVARCHAR(100) NOT NULL
);

CREATE TABLE Products (
    ProductId  INT IDENTITY(1,1) PRIMARY KEY,
    Name       NVARCHAR(150) NOT NULL,
    Price      DECIMAL(10,2) NOT NULL CHECK (Price > 0),
    Stock      INT NOT NULL CHECK (Stock >= 0),
    CategoryId INT NOT NULL,
    CONSTRAINT FK_Products_Categories FOREIGN KEY (CategoryId) REFERENCES Categories(CategoryId)
);

CREATE TABLE Customers (
    CustomerId INT IDENTITY(1,1) PRIMARY KEY,
    FullName   NVARCHAR(100) NOT NULL,
    Email      NVARCHAR(150) NULL
);

CREATE TABLE Orders (
    OrderId    INT IDENTITY(1,1) PRIMARY KEY,
    CustomerId INT NOT NULL,
    OrderDate  DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerId) REFERENCES Customers(CustomerId)
);

CREATE TABLE OrderItems (
    OrderItemId INT IDENTITY(1,1) PRIMARY KEY,
    OrderId     INT NOT NULL,
    ProductId   INT NOT NULL,
    Quantity    INT NOT NULL CHECK (Quantity > 0),
    CONSTRAINT FK_OrderItems_Orders   FOREIGN KEY (OrderId)   REFERENCES Orders(OrderId),
    CONSTRAINT FK_OrderItems_Products FOREIGN KEY (ProductId) REFERENCES Products(ProductId)
);
GO

INSERT INTO Categories (Name) VALUES (N'Elektronika'), (N'Geyim'), (N'Kitablar');

INSERT INTO Products (Name, Price, Stock, CategoryId) VALUES
(N'Noutbuk',      1500.00, 10, 1),
(N'Smartfon',      900.00, 25, 1),
(N'Qulaqlıq',       80.00, 50, 1),
(N'Köynək',         35.00, 100, 2),
(N'Gödəkçə',       120.00, 30, 2),
(N'Roman kitabı',   15.00, 200, 3),
(N'Lüğət',          22.50, 80, 3);

INSERT INTO Customers (FullName, Email) VALUES
(N'Elvin Həsənov', 'elvin@mail.az'),
(N'Nigar Əliyeva', 'nigar@mail.az'),
(N'Kamran Babayev', 'kamran@mail.az'),
(N'Səbinə Rzayeva', 'sebine@mail.az');

INSERT INTO Orders (CustomerId, OrderDate) VALUES
(1, '2026-10-01'), (1, '2026-10-12'), (2, '2026-10-15'), (3, '2026-11-02');

INSERT INTO OrderItems (OrderId, ProductId, Quantity) VALUES
(1, 1, 1), (1, 3, 2),
(2, 6, 5),
(3, 2, 1), (3, 4, 3),
(4, 6, 4), (4, 3, 1), (4, 7, 2);
GO

SELECT c.Name AS Category, p.Name AS Product, p.Price
FROM Products p
INNER JOIN Categories c ON c.CategoryId = p.CategoryId
ORDER BY p.Price DESC;

SELECT c.Name AS Category, COUNT(p.ProductId) AS ProductCount, AVG(p.Price) AS AvgPrice
FROM Categories c
LEFT JOIN Products p ON p.CategoryId = c.CategoryId
GROUP BY c.Name;

SELECT o.OrderId, o.OrderDate, SUM(p.Price * oi.Quantity) AS TotalAmount
FROM Orders o
INNER JOIN OrderItems oi ON oi.OrderId = o.OrderId
INNER JOIN Products p    ON p.ProductId = oi.ProductId
GROUP BY o.OrderId, o.OrderDate;

SELECT c.CustomerId, c.FullName
FROM Customers c
LEFT JOIN Orders o ON o.CustomerId = c.CustomerId
WHERE o.OrderId IS NULL;

SELECT TOP 3 p.Name, SUM(oi.Quantity) AS TotalSold
FROM OrderItems oi
INNER JOIN Products p ON p.ProductId = oi.ProductId
GROUP BY p.Name
ORDER BY TotalSold DESC;
