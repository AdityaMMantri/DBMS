use project;
show tables;
SELECT e.EmployeeID, e.EmployeeName, COUNT(eo.OrderID) AS TotalOrders
FROM Employee_Orders eo
JOIN Employees e ON eo.EmployeeID = e.EmployeeID
GROUP BY e.EmployeeID, e.EmployeeName
ORDER BY TotalOrders DESC;

SELECT CustomerID, COUNT(*) AS OrderCount
FROM Orders
GROUP BY CustomerID;

Select CustomerID, SUM(TotalAmount) AS Revenue
FROM Orders
GROUP BY CustomerID;

select * from orders;

select * from Orders
WHERE TotalAmount > (SELECT AVG(TotalAmount) FROM Orders);


update Customers
set LoyaltyPoints = LoyaltyPoints + 50
where CustomerID in (select CustomerID from Orders where TotalAmount > 500);

select * from customers;

SELECT r.RegionName, SUM(o.TotalAmount) AS Revenue
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Addresses a ON c.AddressID = a.AddressID
JOIN Regions r ON a.RegionID = r.RegionID
GROUP BY r.RegionName
ORDER BY Revenue DESC;

select a.Country, COUNT(*) as CustomerCount
from Customers c
JOIN Addresses a ON c.AddressID = a.AddressID
GROUP BY a.Country;

SELECT COUNT(*) AS ZeroOder
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderID =0;

SELECT r.RegionName, COUNT(DISTINCT e.EmployeeID) AS EmployeeCount
FROM Employees e
JOIN Addresses a ON e.AddressID = a.AddressID
JOIN Regions r ON a.RegionID = r.RegionID
GROUP BY r.RegionName;

SELECT r.RegionName, COUNT(e.EmployeeID) AS EmployeeCount
FROM Employees e
JOIN Regions r ON e.RegionID = r.RegionID
GROUP BY r.RegionName;

SELECT a.Country, SUM(o.TotalAmount) AS Revenue
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Addresses a ON c.AddressID = a.AddressID
GROUP BY a.Country;

SELECT EmployeeID
FROM Employee_Orders
GROUP BY EmployeeID
ORDER BY COUNT(OrderID) DESC;

select * from employee_orders;

CREATE VIEW EmployeePerformance AS
SELECT e.EmployeeID, e.EmployeeName, COUNT(eo.OrderID) AS OrdersHandled
FROM Employees e
JOIN Employee_Orders eo ON e.EmployeeID = eo.EmployeeID
GROUP BY e.EmployeeID, e.EmployeeName;

select * from EmployeePerformance;

SELECT CustomerID
FROM Orders
GROUP BY CustomerID
HAVING SUM(TotalAmount) > 650;

SELECT DATE_FORMAT(OrderDate, '%Y-%m') AS OrderMonth, COUNT(*) AS OrderCount
FROM Orders
GROUP BY OrderMonth;

SELECT DISTINCT c.CustomerName, f.Rating, f.Comments
FROM Feedback f
JOIN Customers c ON f.CustomerID = c.CustomerID
WHERE f.Rating = 5;

SELECT p.ProductName, COUNT(r.ReturnID) AS ReturnCount
FROM Returns r
JOIN Products p ON r.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY ReturnCount DESC
LIMIT 1;

SELECT s.SupplierName, c.CategoryName
FROM Supplier_Categories sc
JOIN Suppliers s ON sc.SupplierID = s.SupplierID
JOIN Categories c ON sc.CategoryID = c.CategoryID
ORDER BY s.SupplierName;

SELECT p.ProductName, w.WarehouseName, i.QuantityInStock, i.ReorderLevel
FROM Inventory i
JOIN Products p ON i.ProductID = p.ProductID
JOIN Warehouses w ON i.WarehouseID = w.WarehouseID
WHERE i.QuantityInStock < i.ReorderLevel;

select * from inventory;

SELECT p.ProductName, COUNT(sp.SupplierID) AS SupplierCount
FROM Supplier_Products sp
JOIN Products p ON sp.ProductID = p.ProductID
GROUP BY p.ProductName
HAVING SupplierCount > 1;

SELECT e.EmployeeID, e.EmployeeName
FROM Employees e
LEFT JOIN Warehouse_Employees we ON e.EmployeeID = we.EmployeeID
WHERE we.EmployeeID IS NULL;

SELECT p.ProductName, ROUND(AVG(f.Rating), 2) AS AvgRating
FROM Feedback f
JOIN Products p ON f.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY AvgRating DESC;

SELECT c.CategoryName, COUNT(p.ProductID) AS ProductCount
FROM Categories c
LEFT JOIN Products p ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryName;

SELECT pos.PositionName, COUNT(e.EmployeeID) AS EmployeeCount
FROM Employees e
JOIN Positions pos ON e.PositionID = pos.PositionID
GROUP BY pos.PositionName;

SELECT w.WarehouseName, MAX(i.LastStockUpdate) AS LastUpdated
FROM Inventory i
JOIN Warehouses w ON i.WarehouseID = w.WarehouseID
GROUP BY w.WarehouseName;

SELECT CustomerName, LoyaltyPoints
FROM Customers
ORDER BY LoyaltyPoints DESC
LIMIT 5;

SELECT o.CustomerID, p.ProductName, COUNT(*) AS TimesOrdered
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY o.CustomerID, od.ProductID
HAVING TimesOrdered > 1;

SELECT OrderID, OrderDate, DAYNAME(OrderDate) AS DayOfWeek
FROM Orders
WHERE DAYOFWEEK(OrderDate) IN (1, 7);


select * from customers;

SELECT Status, COUNT(*) AS Count
FROM Orders
GROUP BY Status;

CREATE VIEW Top_Customers AS
SELECT c.CustomerID, c.CustomerName, SUM(o.TotalAmount) AS TotalSpent
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY TotalSpent DESC
LIMIT 10;

select * from top_customers;

select * from promotions;

select * from orders;

show tables;

select * from product_promotions;

SELECT p.ProductName, promo.PromotionName, promo.DiscountPercentage
FROM Product_Promotions pp
JOIN Products p ON pp.ProductID = p.ProductID
JOIN Promotions promo ON pp.PromotionID = promo.PromotionID
WHERE promo.DiscountPercentage > 10.00;

SELECT promo.PromotionName, COUNT(pp.ProductID) AS ProductCount
FROM Product_Promotions pp
JOIN Promotions promo ON pp.PromotionID = promo.PromotionID
GROUP BY promo.PromotionName;

SELECT promo.PromotionName, COUNT(pp.ProductID) AS ProductCount
FROM Product_Promotions pp
JOIN Promotions promo ON pp.PromotionID = promo.PromotionID
GROUP BY promo.PromotionName
ORDER BY ProductCount DESC
LIMIT 5;

CREATE VIEW TopEmployees AS
SELECT s.EmployeeID, e.EmployeeName, SUM(p.Amount) AS TotalSales
FROM Sales s
JOIN Payments p ON s.SaleID = p.SaleID
JOIN Employees e ON s.EmployeeID = e.EmployeeID
GROUP BY s.EmployeeID, e.EmployeeName;

select * from topemployees
order by totalSales DESC;

SELECT OrderID, COUNT(*) AS PaymentCount
FROM Payments
GROUP BY OrderID
HAVING COUNT(*) > 1;

SELECT DATE(PaymentDate) AS Day, AVG(Amount) AS AvgSale
FROM Payments
GROUP BY Day;

select * from payments;

UPDATE Promotions
SET DiscountPercentage = 35.00
WHERE PromotionID IN (
    SELECT PromotionID
    FROM Product_Promotions
    GROUP BY PromotionID
    HAVING COUNT(ProductID) > 3
);

select * from promotions;

SELECT ProductName 
FROM Products
WHERE ProductID NOT IN (SELECT ProductID FROM Product_Promotions);

SELECT p.ProductName, COUNT(pay.OrderID) AS TimesSold
FROM Payments pay
JOIN Products p ON pay.OrderID = p.ProductID
GROUP BY p.ProductName
HAVING TimesSold < 2;

-- Top reasons for returns
SELECT Reason, COUNT(*) AS Frequency
FROM Returns
GROUP BY Reason
ORDER BY Frequency DESC;

select * from returns;

SELECT r.RegionName, SUM(i.QuantityInStock) AS TotalStock
FROM Inventory i
JOIN Warehouses w ON i.WarehouseID = w.WarehouseID
JOIN Addresses a ON w.AddressID = a.AddressID
JOIN Regions r ON a.RegionID = r.RegionID
GROUP BY r.RegionName;

SELECT r.RegionName, COUNT(w.WarehouseID) AS WarehouseCount
FROM Warehouses w
JOIN Addresses a ON w.AddressID = a.AddressID
JOIN Regions r ON a.RegionID = r.RegionID
GROUP BY r.RegionName
ORDER BY WarehouseCount DESC;

SELECT p.ProductName, SUM(od.Quantity * od.UnitPrice) AS TotalRevenue
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY TotalRevenue DESC
LIMIT 5;

SELECT w.WarehouseName, COUNT(DISTINCT i.ProductID) AS ProductTypes
FROM Inventory i
JOIN Warehouses w ON i.WarehouseID = w.WarehouseID
GROUP BY w.WarehouseName
HAVING COUNT(DISTINCT i.ProductID) > 2;

SELECT c.CategoryName, ROUND(AVG(p.Price), 2) AS AvgPrice
FROM Categories c
JOIN Products p ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryName
HAVING AVG(p.Price) > 100;

SELECT DISTINCT e.EmployeeID, e.EmployeeName
FROM Employees e
JOIN Employee_Orders eo ON e.EmployeeID = eo.EmployeeID
JOIN Orders o ON eo.OrderID = o.OrderID
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Addresses a ON c.AddressID = a.AddressID
WHERE a.Country = 'India';

select * from inventory;

DELIMITER $$

CREATE TRIGGER update_stock_after_order
AFTER INSERT ON Orders
FOR EACH ROW
BEGIN
  UPDATE Inventory
  SET QuantityInStock = QuantityInStock - NEW.QuantityOrdered
  WHERE ProductID = NEW.ProductID;
END$$

DELIMITER ;

select * from orders;

select * from customers;

select * from products;

select * from feedback;

