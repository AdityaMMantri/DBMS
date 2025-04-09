use Project;
show databases;
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(255) NOT NULL,
    ParentCategoryID INT NULL,
    Description TEXT,
    FOREIGN KEY (ParentCategoryID) REFERENCES Categories(CategoryID)
);
CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY,
    SupplierName VARCHAR(255) NOT NULL,
    ContactName VARCHAR(255),
    Phone VARCHAR(20),
    Email VARCHAR(255)
);
CREATE TABLE Supplier_Categories (
    SupplierID INT,
    CategoryID INT,
    PRIMARY KEY (SupplierID, CategoryID),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);
show tables;

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(255) NOT NULL,
    CategoryID INT,
    Price DECIMAL(10,2),
    StockQuantity INT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

CREATE TABLE Supplier_Products (
    SupplierID INT,
    ProductID INT,
    PRIMARY KEY (SupplierID, ProductID),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Regions (
    RegionID INT PRIMARY KEY,
    RegionName VARCHAR(255) NOT NULL,
    Country VARCHAR(100)
);

CREATE TABLE Addresses (
    AddressID INT PRIMARY KEY,
    Street VARCHAR(255),
    City VARCHAR(100),
    State VARCHAR(100),
    PostalCode VARCHAR(20),
    Country VARCHAR(100),
    RegionID INT,
    FOREIGN KEY (RegionID) REFERENCES Regions(RegionID)
);

CREATE TABLE Warehouses (
    WarehouseID INT PRIMARY KEY,
    WarehouseName VARCHAR(255) NOT NULL,
    Capacity INT,
    WarehouseType VARCHAR(50),
    AddressID INT,
    FOREIGN KEY (AddressID) REFERENCES Addresses(AddressID)
);

CREATE TABLE Inventory (
    InventoryID INT PRIMARY KEY,
    ProductID INT,
    WarehouseID INT,
    QuantityInStock INT,
    ReorderLevel INT,
    LastStockUpdate DATETIME,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (WarehouseID) REFERENCES Warehouses(WarehouseID)
);

CREATE TABLE Positions (
    PositionID INT PRIMARY KEY,
    PositionName VARCHAR(255) NOT NULL
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(255) NOT NULL,
    RegionID INT,
    PositionID INT,
    FOREIGN KEY (RegionID) REFERENCES Regions(RegionID),
    FOREIGN KEY (PositionID) REFERENCES Positions(PositionID)
);

CREATE TABLE Warehouse_Employees (
    WarehouseID INT,
    EmployeeID INT,
    PRIMARY KEY (WarehouseID, EmployeeID),
    FOREIGN KEY (WarehouseID) REFERENCES Warehouses(WarehouseID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(255) NOT NULL,
    Email VARCHAR(255),
    Phone VARCHAR(20),
    AddressID INT,
    LoyaltyPoints INT,
    FOREIGN KEY (AddressID) REFERENCES Addresses(AddressID)
);

CREATE TABLE Employee_Customers (
    EmployeeID INT,
    CustomerID INT,
    PRIMARY KEY (EmployeeID, CustomerID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    EmployeeID INT,
    SaleDate DATETIME,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATETIME,
    Status VARCHAR(50),
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Employee_Orders (
    EmployeeID INT,
    OrderID INT,
    PRIMARY KEY (EmployeeID, OrderID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY,
    OrderID INT,
    CustomerID INT,
    SaleID INT,
    PaymentDate DATETIME,
    Amount DECIMAL(10,2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (SaleID) REFERENCES Sales(SaleID)
);

CREATE TABLE Returns (
    ReturnID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    CustomerID INT,
    ReturnDate DATETIME,
    Reason TEXT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Feedback (
    FeedbackID INT PRIMARY KEY,
    CustomerID INT,
    ProductID INT,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Comments TEXT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Promotions (
    PromotionID INT PRIMARY KEY,
    PromotionName VARCHAR(255) NOT NULL,
    StartDate DATETIME,
    DiscountPercentage DECIMAL(5,2)
);

CREATE TABLE Product_Promotions (
    ProductID INT,
    PromotionID INT,
    PRIMARY KEY (ProductID, PromotionID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (PromotionID) REFERENCES Promotions(PromotionID)
);

INSERT INTO Categories (CategoryID, CategoryName, ParentCategoryID, Description) VALUES
(1, 'Home Appliances', NULL, 'Appliances for household use'),
(2, 'Consumer Electronics', NULL, 'Electronic devices for entertainment and communication'),
(3, 'Personal Gadgets', NULL, 'Wearable and portable personal electronic devices'),
(4, 'Computing Devices', NULL, 'Laptops, desktops, and related computing devices'),
(5, 'Smart Home Devices', NULL, 'Smart devices for home automation'),
(6, 'Kitchen Appliances', NULL, 'Appliances designed for kitchen use');

select * from Categories;

INSERT INTO Products (ProductID, ProductName, CategoryID, Price, StockQuantity) VALUES
-- Home Appliances
(1, 'Smart Refrigerator', 1, 1200.00, 50),
(2, 'Washing Machine', 1, 800.00, 40),
(3, 'Microwave Oven', 1, 300.00, 60),
(4, 'Air Conditioner', 1, 1000.00, 30),
(5, 'Vacuum Cleaner', 1, 200.00, 70),

-- Consumer Electronics
(6, 'Smart TV (OLED)', 2, 1500.00, 25),
(7, 'Smart TV (QLED)', 2, 1700.00, 20),
(8, 'Home Theater System', 2, 700.00, 35),
(9, 'Bluetooth Speaker', 2, 150.00, 100),
(10, 'Noise-Canceling Headphones', 2, 250.00, 80),
(11, 'Digital Camera', 2, 1200.00, 45),

-- Personal Gadgets
(12, 'Smartwatch', 3, 300.00, 90),
(13, 'Wireless Earbuds', 3, 120.00, 120),
(14, 'Fitness Tracker', 3, 180.00, 95),
(15, 'VR Headset', 3, 400.00, 50),
(16, 'Portable Power Bank', 3, 60.00, 150),

-- Computing Devices
(17, 'Gaming Laptop', 4, 2000.00, 15),
(18, '2-in-1 Convertible Laptop', 4, 1200.00, 25),
(19, 'Desktop PC', 4, 1500.00, 20),
(20, 'Tablet', 4, 600.00, 50),
(21, 'External SSD', 4, 150.00, 100),

-- Smart Home Devices
(22, 'Smart Door Lock', 5, 250.00, 40),
(23, 'Wi-Fi Smart Plug', 5, 50.00, 120),
(24, 'Smart LED Bulb', 5, 30.00, 200),
(25, 'Smart Security Camera', 5, 180.00, 60),
(26, 'Smart Thermostat', 5, 220.00, 50),

-- Kitchen Appliances
(27, 'Induction Cooktop', 6, 350.00, 55),
(28, 'Coffee Maker', 6, 100.00, 80),
(29, 'Air Fryer', 6, 180.00, 70),
(30, 'Electric Kettle', 6, 50.00, 150),
(31, 'Bread Toaster', 6, 40.00, 130);

Select * from Products;

INSERT INTO Suppliers (SupplierID, SupplierName, ContactName, Phone, Email) VALUES
(1, 'TechNova Distributors', 'John Doe', '+1-555-1234', 'johndoe@technova.com'),
(2, 'SmartHome Solutions', 'Alice Smith', '+1-555-5678', 'alice@smarthomes.com'),
(3, 'Gadget World Inc.', 'Robert Johnson', '+1-555-8765', 'robert@gadgetworld.com'),
(4, 'FutureTech Supplies', 'Emily Davis', '+1-555-4321', 'emily@futuretech.com'),
(5, 'Elite Electronics', 'Michael Brown', '+1-555-2468', 'michael@eliteelectronics.com'),
(6, 'NextGen Appliances', 'Jessica Wilson', '+1-555-1357', 'jessica@nextgen.com'),
(7, 'Visionary Tech', 'David Martinez', '+1-555-9876', 'david@visionarytech.com'),
(8, 'Home Comfort Ltd.', 'Sarah White', '+1-555-3698', 'sarah@homecomfort.com'),
(9, 'Digital Edge', 'Daniel Anderson', '+1-555-2584', 'daniel@digitaledge.com'),
(10, 'Quantum Electronics', 'Sophia Thompson', '+1-555-7412', 'sophia@quantumelectronics.com');

select * from Suppliers;

INSERT INTO Regions (RegionID, RegionName, Country) VALUES
(1, 'North America - East', 'USA'),
(2, 'North America - West', 'USA'),
(3, 'South America - North', 'Brazil'),
(4, 'South America - South', 'Argentina'),
(5, 'Europe - Western', 'Germany'),
(6, 'Europe - Northern', 'Sweden'),
(7, 'Europe - Southern', 'Italy'),
(8, 'Europe - Eastern', 'Poland'),
(9, 'Asia - Pacific', 'Japan'),
(10, 'Asia - Southeast', 'Thailand'),
(11, 'South Asia', 'India'),
(12, 'Middle East - Gulf', 'UAE'),
(13, 'Middle East - Levant', 'Saudi Arabia'),
(14, 'Middle East - North Africa', 'Egypt'),
(15, 'Africa - East', 'Kenya'),
(16, 'Africa - West', 'Nigeria'),
(17, 'Africa - Central', 'Congo'),
(18, 'Africa - South', 'South Africa'),
(19, 'Australia & Oceania - East', 'Australia'),
(20, 'Australia & Oceania - Islands', 'New Zealand');

select * from regions;

INSERT INTO Addresses (AddressID, Street, City, State, PostalCode, Country, RegionID) VALUES
(1, '123 Tech Street', 'New York', 'NY', '10001', 'USA', 1),
(2, '456 Innovation Ave', 'San Francisco', 'CA', '94105', 'USA', 2),
(3, '789 Digital Rd', 'Berlin', 'Berlin', '10117', 'Germany', 5),
(4, '101 Smart Ln', 'Tokyo', 'Tokyo', '100-0001', 'Japan', 9),
(5, '303 AI Blvd', 'Sydney', 'NSW', '2000', 'Australia', 19),
(6, '111 Future St', 'London', 'England', 'WC1A 1AA', 'UK', 7),
(7, '202 Electronics Blvd', 'Los Angeles', 'CA', '90001', 'USA', 3),
(8, '555 Data Dr', 'Toronto', 'Ontario', 'M5H 2N2', 'Canada', 4),
(9, '999 Neural St', 'Paris', 'Île-de-France', '75001', 'France', 6),
(10, '303 AI Lane', 'Dubai', 'Dubai', '00000', 'UAE', 8),
(11, '777 IoT Rd', 'Shanghai', 'Shanghai', '200000', 'China', 10),
(12, '888 Quantum Ave', 'Bangalore', 'Karnataka', '560001', 'India', 11),
(13, '456 Future Ln', 'Chicago', 'IL', '60601', 'USA', 2),
(14, '333 Startup St', 'San Diego', 'CA', '92101', 'USA', 3),
(15, '123 Silicon St', 'Austin', 'TX', '73301', 'USA', 4),
(16, '543 AI Blvd', 'Munich', 'Bavaria', '80331', 'Germany', 5),
(17, '789 Neural Drive', 'Seoul', 'Seoul', '04561', 'South Korea', 6),
(18, '555 Data Science Rd', 'Madrid', 'Madrid', '28001', 'Spain', 7),
(19, '111 Quantum Drive', 'Milan', 'Lombardy', '20121', 'Italy', 8),
(20, '999 Research Ave', 'Stockholm', 'Stockholm', '11120', 'Sweden', 9);

select * from addresses;

INSERT INTO Warehouses (WarehouseID, WarehouseName, Capacity, WarehouseType, AddressID) VALUES
(1, 'Main Tech Warehouse', 10000, 'Electronics', 1),
(2, 'West Coast Storage', 5000, 'Appliances', 2),
(3, 'Europe Distribution Hub', 7000, 'Mixed', 3),
(4, 'Tokyo Storage Center', 6000, 'Gadgets', 4),
(5, 'Sydney Logistics', 4000, 'Smart Devices', 5),
(6, 'UK SmartTech Storage', 5500, 'Wearables', 6),
(7, 'Canada Electronics Hub', 8000, 'Computers', 7),
(8, 'Dubai AI Storage', 4500, 'Home Devices', 8),
(9, 'Shanghai Tech Park', 7000, 'Industrial', 9),
(10, 'India IoT Hub', 7500, 'Smart Home', 10),
(11, 'Brazil Smart Devices', 6500, 'Personal Gadgets', 11),
(12, 'Seoul Future Storage', 5800, 'Electronics', 12);

select * from warehouses;

-- Inventory Table
INSERT INTO Inventory (InventoryID, ProductID, WarehouseID, QuantityInStock, ReorderLevel, LastStockUpdate) VALUES
(1, 1, 1, 100, 10, '2025-04-01 10:00:00'),
(2, 2, 1, 150, 15, '2025-04-01 11:00:00'),
(3, 3, 2, 80, 8, '2025-04-01 09:00:00'),
(4, 4, 2, 200, 20, '2025-04-01 14:00:00'),
(5, 5, 3, 50, 5, '2025-03-30 08:00:00'),
(6, 6, 3, 120, 12, '2025-03-30 13:00:00'),
(7, 7, 4, 200, 25, '2025-03-29 12:00:00'),
(8, 8, 4, 75, 10, '2025-03-29 14:00:00'),
(9, 9, 5, 30, 3, '2025-03-28 11:00:00'),
(10, 10, 5, 90, 8, '2025-03-28 15:00:00'),
(11, 11, 6, 100, 10, '2025-04-02 09:00:00'),
(12, 12, 6, 140, 12, '2025-04-02 13:00:00'),
(13, 13, 7, 80, 10, '2025-04-02 08:00:00'),
(14, 14, 7, 180, 20, '2025-04-03 10:00:00'),
(15, 15, 8, 50, 5, '2025-04-03 14:00:00'),
(16, 16, 8, 60, 6, '2025-04-01 16:00:00'),
(17, 17, 9, 220, 22, '2025-04-03 13:00:00'),
(18, 18, 9, 160, 18, '2025-04-02 17:00:00'),
(19, 19, 10, 30, 3, '2025-04-01 09:00:00'),
(20, 20, 10, 110, 11, '2025-03-31 10:00:00'),
(21, 21, 11, 140, 14, '2025-03-30 11:00:00'),
(22, 22, 11, 75, 7, '2025-03-30 12:00:00'),
(23, 23, 12, 50, 5, '2025-03-29 10:00:00'),
(24, 24, 12, 90, 9, '2025-03-29 13:00:00'),
(25, 25, 1, 130, 13, '2025-03-31 08:00:00'),
(26, 26, 2, 85, 9, '2025-04-01 12:00:00'),
(27, 27, 3, 170, 18, '2025-04-02 14:00:00'),
(28, 28, 4, 60, 6, '2025-04-03 11:00:00'),
(29, 29, 5, 100, 10, '2025-03-31 16:00:00'),
(30, 30, 6, 50, 5, '2025-04-02 09:00:00');

Select * from inventory;

INSERT INTO Positions (PositionID, PositionName) VALUES
(1, 'Sales Manager'),
(2, 'Warehouse Supervisor'),
(3, 'Customer Support Specialist'),
(4, 'Logistics Coordinator'),
(5, 'IT Support Specialist'),
(6, 'Product Manager'),
(7, 'Marketing Director'),
(8, 'Operations Manager'),
(9, 'Warehouse Clerk'),
(10, 'Regional Sales Representative');

select * from positions;


INSERT INTO Employees (EmployeeID, EmployeeName, RegionID, PositionID) VALUES
(1, 'Alice Johnson', 1, 1),
(2, 'Bob Smith', 2, 2),
(3, 'Charlie Brown', 3, 3),
(4, 'David Lee', 4, 4),
(5, 'Emma Davis', 5, 5),
(6, 'Oliver Wright', 6, 2),
(7, 'Sophia Turner', 7, 3),
(8, 'Liam Carter', 8, 4),
(9, 'Isabella Scott', 9, 5),
(10, 'Mason White', 10, 1),
(11, 'James Anderson', 11, 2),
(12, 'Grace Hall', 12, 3),
(13, 'Lucas King', 13, 4),
(14, 'Ava Robinson', 14, 5),
(15, 'William Harris', 15, 1),
(16, 'Ethan Martin', 16, 2),
(17, 'Harper Clark', 17, 3),
(18, 'Michael Young', 18, 4),
(19, 'Benjamin Allen', 19, 5),
(20, 'Emily Nelson', 20, 1),
(21, 'Samuel Taylor', 1, 6),
(22, 'Lily Foster', 2, 7),
(23, 'Jack Thomas', 3, 8),
(24, 'Sophia Williams', 4, 9),
(25, 'David Adams', 5, 10),
(26, 'Natalie Moore', 6, 6),
(27, 'Daniel Lee', 7, 7),
(28, 'Chloe Martinez', 8, 8),
(29, 'Joshua Perez', 9, 9),
(30, 'Sophie Harris', 10, 10);

select * from employees;

-- Customers Table
INSERT INTO Customers (CustomerID, CustomerName, Email, Phone, AddressID, LoyaltyPoints) VALUES
(1, 'John Doe', 'john.doe@example.com', '123-456-7890', 1, 150),
(2, 'Jane Smith', 'jane.smith@example.com', '234-567-8901', 2, 120),
(3, 'Michael Brown', 'michael.brown@example.com', '345-678-9012', 3, 200),
(4, 'Emily Davis', 'emily.davis@example.com', '456-789-0123', 4, 80),
(5, 'Robert Johnson', 'robert.johnson@example.com', '567-890-1234', 5, 300),
(6, 'Sophia Williams', 'sophia.williams@example.com', '678-901-2345', 6, 250),
(7, 'Daniel Taylor', 'daniel.taylor@example.com', '789-012-3456', 7, 400),
(8, 'Olivia Martinez', 'olivia.martinez@example.com', '890-123-4567', 8, 50),
(9, 'James Anderson', 'james.anderson@example.com', '901-234-5678', 9, 180),
(10, 'Isabella Jackson', 'isabella.jackson@example.com', '012-345-6789', 10, 220),
(11, 'Benjamin White', 'benjamin.white@example.com', '123-456-7890', 11, 110),
(12, 'Charlotte Harris', 'charlotte.harris@example.com', '234-567-8901', 12, 130),
(13, 'Henry Clark', 'henry.clark@example.com', '345-678-9012', 13, 160),
(14, 'Grace Lewis', 'grace.lewis@example.com', '456-789-0123', 14, 90),
(15, 'Lucas Walker', 'lucas.walker@example.com', '567-890-1234', 15, 270),
(16, 'Mason Young', 'mason.young@example.com', '678-901-2345', 16, 310),
(17, 'Ethan King', 'ethan.king@example.com', '789-012-3456', 17, 50),
(18, 'Amelia Scott', 'amelia.scott@example.com', '890-123-4567', 18, 120),
(19, 'Alexander Green', 'alexander.green@example.com', '901-234-5678', 19, 140),
(20, 'Sofia Adams', 'sofia.adams@example.com', '012-345-6789', 20, 180),
(21, 'Harper Nelson', 'harper.nelson@example.com', '123-456-7890', 1, 250),
(22, 'Aiden Baker', 'aiden.baker@example.com', '234-567-8901', 2, 90),
(23, 'Chloe Evans', 'chloe.evans@example.com', '345-678-9012', 3, 130),
(24, 'Mia Carter', 'mia.carter@example.com', '456-789-0123', 4, 170),
(25, 'Jackson Perez', 'jackson.perez@example.com', '567-890-1234', 5, 200),
(26, 'Madison Mitchell', 'madison.mitchell@example.com', '678-901-2345', 6, 160),
(27, 'William Roberts', 'william.roberts@example.com', '789-012-3456', 7, 110),
(28, 'Scarlett Collins', 'scarlett.collins@example.com', '890-123-4567', 8, 180),
(29, 'Lily Stewart', 'lily.stewart@example.com', '901-234-5678', 9, 140),
(30, 'Nathan Morris', 'nathan.morris@example.com', '012-345-6789', 10, 200);

select * from customers;

INSERT INTO Sales (SaleID, EmployeeID, SaleDate) VALUES
(1, 1, '2025-04-01 10:00:00'),
(2, 2, '2025-04-01 11:30:00'),
(3, 3, '2025-04-01 12:45:00'),
(4, 4, '2025-04-01 13:30:00'),
(5, 5, '2025-04-01 14:00:00'),
(6, 6, '2025-04-01 15:15:00'),
(7, 7, '2025-04-01 16:00:00'),
(8, 8, '2025-04-01 17:30:00'),
(9, 9, '2025-04-01 18:00:00'),
(10, 10, '2025-04-01 19:00:00'),
(11, 11, '2025-04-02 09:30:00'),
(12, 12, '2025-04-02 10:15:00'),
(13, 13, '2025-04-02 11:00:00'),
(14, 14, '2025-04-02 12:00:00'),
(15, 15, '2025-04-02 13:30:00'),
(16, 16, '2025-04-02 14:15:00'),
(17, 17, '2025-04-02 15:00:00'),
(18, 18, '2025-04-02 16:45:00'),
(19, 19, '2025-04-02 17:30:00'),
(20, 20, '2025-04-02 18:00:00'),
(21, 21, '2025-04-03 09:00:00'),
(22, 22, '2025-04-03 10:30:00'),
(23, 23, '2025-04-03 11:45:00'),
(24, 24, '2025-04-03 12:30:00'),
(25, 25, '2025-04-03 14:00:00'),
(26, 26, '2025-04-03 15:30:00'),
(27, 27, '2025-04-03 16:15:00'),
(28, 28, '2025-04-03 17:00:00'),
(29, 29, '2025-04-03 18:00:00'),
(30, 30, '2025-04-03 19:00:00');

select * from sales;
INSERT INTO Orders (OrderID, CustomerID, OrderDate, Status, TotalAmount) VALUES
(1, 1, '2025-03-29 10:00:00', 'Completed', 250.50),
(2, 2, '2025-03-29 11:30:00', 'Pending', 150.75),
(3, 3, '2025-03-29 12:45:00', 'Shipped', 320.00),
(4, 4, '2025-03-29 13:30:00', 'Completed', 85.00),
(5, 5, '2025-03-29 14:00:00', 'Completed', 500.20),
(6, 6, '2025-03-30 15:15:00', 'Pending', 300.00),
(7, 7, '2025-03-30 16:00:00', 'Shipped', 450.10),
(8, 8, '2025-03-30 17:30:00', 'Completed', 75.30),
(9, 9, '2025-03-30 18:00:00', 'Shipped', 180.90),
(10, 10, '2025-03-30 19:00:00', 'Completed', 210.00),
(11, 11, '2025-03-31 09:30:00', 'Completed', 120.50),
(12, 12, '2025-03-31 10:15:00', 'Pending', 150.00),
(13, 13, '2025-03-31 11:00:00', 'Shipped', 220.80),
(14, 14, '2025-03-31 12:00:00', 'Completed', 90.00),
(15, 15, '2025-03-31 13:30:00', 'Pending', 280.50),
(16, 16, '2025-03-31 14:15:00', 'Shipped', 310.00),
(17, 17, '2025-03-31 15:00:00', 'Completed', 60.00),
(18, 18, '2025-03-31 16:45:00', 'Completed', 135.75),
(19, 19, '2025-03-31 17:30:00', 'Shipped', 200.00),
(20, 20, '2025-03-31 18:00:00', 'Completed', 180.00),
(21, 21, '2025-04-01 09:00:00', 'Pending', 255.00),
(22, 22, '2025-04-01 10:30:00', 'Shipped', 100.00),
(23, 23, '2025-04-01 11:45:00', 'Completed', 160.00),
(24, 24, '2025-04-01 12:30:00', 'Shipped', 170.50),
(25, 25, '2025-04-01 14:00:00', 'Pending', 200.10),
(26, 26, '2025-04-01 15:30:00', 'Shipped', 150.00),
(27, 27, '2025-04-01 16:15:00', 'Completed', 110.00),
(28, 28, '2025-04-01 17:00:00', 'Pending', 180.50),
(29, 29, '2025-04-01 18:00:00', 'Shipped', 140.00),
(30, 30, '2025-04-01 19:00:00', 'Completed', 200.00),
(31, 5, '2025-04-02 09:30:00', 'Shipped', 275.50),
(32, 6, '2025-04-02 10:15:00', 'Pending', 310.75),
(33, 7, '2025-04-02 11:00:00', 'Completed', 220.30),
(34, 8, '2025-04-02 12:30:00', 'Shipped', 245.00),
(35, 9, '2025-04-02 14:00:00', 'Completed', 180.00),
(36, 10, '2025-04-02 15:45:00', 'Pending', 175.00),
(37, 11, '2025-04-02 16:30:00', 'Shipped', 300.00),
(38, 12, '2025-04-02 17:15:00', 'Completed', 185.75),
(39, 13, '2025-04-02 18:00:00', 'Pending', 220.20),
(40, 14, '2025-04-02 19:00:00', 'Shipped', 210.90),
(41, 15, '2025-04-03 09:00:00', 'Completed', 230.00),
(42, 16, '2025-04-03 10:30:00', 'Shipped', 260.00),
(43, 17, '2025-04-03 11:00:00', 'Pending', 190.10),
(44, 18, '2025-04-03 12:15:00', 'Completed', 150.00),
(45, 19, '2025-04-03 13:00:00', 'Shipped', 170.25),
(46, 20, '2025-04-03 14:30:00', 'Completed', 120.00),
(47, 21, '2025-04-03 15:00:00', 'Pending', 250.50),
(48, 22, '2025-04-03 16:45:00', 'Shipped', 200.80),
(49, 23, '2025-04-03 17:30:00', 'Completed', 135.60),
(50, 24, '2025-04-03 18:00:00', 'Pending', 215.00);

select * from orders;

INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity, UnitPrice) VALUES
(1, 1, 1, 1, 1200.00),  -- Smart Refrigerator
(2, 1, 2, 1, 800.00),  -- Washing Machine
(3, 1, 6, 1, 1500.00),  -- Smart TV (OLED)
(4, 2, 3, 2, 300.00),  -- Microwave Oven
(5, 2, 7, 1, 1700.00),  -- Smart TV (QLED)
(6, 3, 9, 3, 150.00),  -- Bluetooth Speaker
(7, 3, 12, 1, 300.00),  -- Smartwatch
(8, 4, 8, 1, 700.00),  -- Home Theater System
(9, 4, 5, 2, 200.00),  -- Vacuum Cleaner
(10, 5, 15, 1, 400.00),  -- VR Headset
(11, 5, 16, 1, 60.00),  -- Portable Power Bank
(12, 6, 20, 1, 600.00),  -- Tablet
(13, 6, 17, 1, 2000.00),  -- Gaming Laptop
(14, 7, 19, 1, 1500.00),  -- Desktop PC
(15, 7, 23, 2, 50.00),  -- Wi-Fi Smart Plug
(16, 8, 21, 1, 150.00),  -- External SSD
(17, 8, 22, 1, 250.00),  -- Smart Door Lock
(18, 9, 13, 1, 120.00),  -- Wireless Earbuds
(19, 9, 25, 1, 180.00),  -- Smart Security Camera
(20, 10, 10, 2, 250.00),  -- Noise-Canceling Headphones
(21, 10, 18, 1, 1200.00),  -- 2-in-1 Convertible Laptop
(22, 11, 11, 1, 1200.00),  -- Digital Camera
(23, 12, 14, 1, 180.00),  -- Fitness Tracker
(24, 12, 24, 3, 30.00),  -- Smart LED Bulb
(25, 13, 28, 1, 100.00),  -- Coffee Maker
(26, 13, 6, 1, 350.00),  -- Induction Cooktop
(27, 14, 29, 2, 180.00),  -- Air Fryer
(28, 14, 13, 1, 120.00),  -- Wireless Earbuds
(29, 15, 16, 3, 60.00),  -- Portable Power Bank
(30, 16, 30, 1, 50.00),  -- Electric Kettle
(31, 17, 24, 4, 30.00),  -- Smart LED Bulb
(32, 18, 26, 1, 220.00),  -- Smart Thermostat
(33, 19, 3, 1, 300.00),  -- Microwave Oven
(34, 19, 27, 1, 350.00),  -- Induction Cooktop
(35, 20, 9, 2, 150.00),  -- Bluetooth Speaker
(36, 21, 17, 1, 2000.00),  -- Gaming Laptop
(37, 22, 7, 1, 1700.00),  -- Smart TV (QLED)
(38, 23, 18, 2, 1200.00),  -- 2-in-1 Convertible Laptop
(39, 24, 2, 1, 800.00),  -- Washing Machine
(40, 25, 25, 1, 180.00),  -- Smart Security Camera
(41, 26, 12, 1, 300.00),  -- Smartwatch
(42, 27, 6, 1, 1500.00),  -- Smart TV (OLED)
(43, 28, 4, 1, 1000.00),  -- Air Conditioner
(44, 29, 5, 3, 200.00),  -- Vacuum Cleaner
(45, 30, 21, 2, 150.00),  -- External SSD
(46, 31, 19, 1, 1500.00),  -- Desktop PC
(47, 32, 8, 1, 700.00),  -- Home Theater System
(48, 33, 20, 1, 600.00),  -- Tablet
(49, 34, 15, 1, 400.00),  -- VR Headset
(50, 35, 11, 1, 1200.00);  -- Digital Camera

select * from OrderDetails;

INSERT INTO Payments (PaymentID, OrderID, CustomerID, SaleID, PaymentDate, Amount) VALUES
(1, 1, 1, 1, '2025-03-29 10:30:00', 250.50),
(2, 2, 2, 2, '2025-03-29 11:45:00', 150.75),
(3, 3, 3, 3, '2025-03-29 13:00:00', 320.00),
(4, 4, 4, 4, '2025-03-29 14:00:00', 85.00),
(5, 5, 5, 5, '2025-03-29 14:30:00', 500.20),
(6, 6, 6, 6, '2025-03-30 15:45:00', 300.00),
(7, 7, 7, 7, '2025-03-30 16:30:00', 450.10),
(8, 8, 8, 8, '2025-03-30 18:00:00', 75.30),
(9, 9, 9, 9, '2025-03-30 18:30:00', 180.90),
(10, 10, 10, 10, '2025-03-30 19:30:00', 210.00),
(11, 11, 11, 11, '2025-03-31 09:45:00', 120.50),
(12, 12, 12, 12, '2025-03-31 10:30:00', 150.00),
(13, 13, 13, 13, '2025-03-31 11:15:00', 220.80),
(14, 14, 14, 14, '2025-03-31 12:15:00', 90.00),
(15, 15, 15, 15, '2025-03-31 14:00:00', 280.50),
(16, 16, 16, 16, '2025-03-31 15:30:00', 310.00),
(17, 17, 17, 17, '2025-03-31 16:00:00', 60.00),
(18, 18, 18, 18, '2025-03-31 17:00:00', 135.75),
(19, 19, 19, 19, '2025-03-31 18:30:00', 200.00),
(20, 20, 20, 20, '2025-03-31 19:15:00', 180.00),
(21, 21, 21, 21, '2025-04-01 09:30:00', 255.00),
(22, 22, 22, 22, '2025-04-01 10:45:00', 100.00),
(23, 23, 23, 23, '2025-04-01 11:30:00', 160.00),
(24, 24, 24, 24, '2025-04-01 12:45:00', 170.50),
(25, 25, 25, 25, '2025-04-01 14:15:00', 200.10),
(26, 26, 26, 26, '2025-04-01 15:45:00', 150.00),
(27, 27, 27, 27, '2025-04-01 16:30:00', 110.00),
(28, 28, 28, 28, '2025-04-01 17:30:00', 180.50),
(29, 29, 29, 29, '2025-04-01 18:15:00', 140.00),
(30, 30, 30, 30, '2025-04-01 19:30:00', 200.00),
(31, 1, 1, 2, '2025-04-01 10:30:00', 250.00),
(32, 2, 2, 3, '2025-04-01 11:45:00', 155.00),
(33, 3, 3, 4, '2025-04-01 13:00:00', 315.00),
(34, 4, 4, 5, '2025-04-01 14:00:00', 90.50),
(35, 5, 5, 6, '2025-04-01 14:30:00', 480.00),
(36, 6, 6, 7, '2025-04-01 15:45:00', 300.50),
(37, 7, 7, 8, '2025-04-01 16:30:00', 465.00),
(38, 8, 8, 9, '2025-04-01 18:00:00', 76.00),
(39, 9, 9, 10, '2025-04-01 18:30:00', 185.00),
(40, 10, 10, 11, '2025-04-01 19:30:00', 205.00),
(41, 11, 11, 12, '2025-04-02 09:45:00', 125.50),
(42, 12, 12, 13, '2025-04-02 10:30:00', 160.00),
(43, 13, 13, 14, '2025-04-02 11:15:00', 230.00),
(44, 14, 14, 15, '2025-04-02 12:15:00', 95.00),
(45, 15, 15, 16, '2025-04-02 14:00:00', 290.00),
(46, 16, 16, 17, '2025-04-02 15:30:00', 325.00),
(47, 17, 17, 18, '2025-04-02 16:00:00', 65.00),
(48, 18, 18, 19, '2025-04-02 17:00:00', 140.50),
(49, 19, 19, 20, '2025-04-02 18:30:00', 190.00),
(50, 20, 20, 21, '2025-04-02 19:00:00', 180.00);

select * from Payments;

INSERT INTO Returns (ReturnID, OrderID, ProductID, CustomerID, ReturnDate, Reason) VALUES
(1, 1, 5, 1, '2025-03-30 12:00:00', 'Defective item'),
(2, 2, 9, 2, '2025-03-30 14:30:00', 'Changed my mind'),
(3, 3, 2, 3, '2025-03-31 11:00:00', 'Not as described'),
(4, 4, 11, 4, '2025-03-31 13:45:00', 'Received damaged product'),
(5, 5, 8, 5, '2025-04-01 09:00:00', 'No longer needed'),
(6, 6, 3, 6, '2025-04-01 10:30:00', 'Defective item'),
(7, 7, 7, 7, '2025-04-01 12:00:00', 'Wrong size'),
(8, 8, 15, 8, '2025-04-01 13:30:00', 'Poor quality'),
(9, 9, 19, 9, '2025-04-02 14:00:00', 'Item arrived late'),
(10, 10, 13, 10, '2025-04-02 16:00:00', 'Product not working');

select * from Returns;

-- Insert data into Feedback table with various combinations of CustomerID and ProductID
INSERT INTO Feedback (FeedbackID, CustomerID, ProductID, Rating, Comments)
VALUES
(1, 1, 1, 5, 'Great refrigerator, keeps food fresh for a long time!'),
(2, 1, 3, 4, 'Good microwave, fast heating, but a little loud.'),
(3, 2, 6, 3, 'Smart TV (OLED) has good picture quality but poor sound.'),
(4, 2, 9, 4, 'Bluetooth speaker has great sound quality for its size.'),
(5, 3, 5, 2, 'Vacuum cleaner could use more suction power.'),
(6, 3, 7, 5, 'Smart TV (QLED) is excellent, fantastic picture and features.'),
(7, 4, 11, 4, 'Digital camera is good but the battery life is average.'),
(8, 4, 10, 5, 'Noise-canceling headphones work amazing for blocking background noise.'),
(9, 5, 12, 4, 'Smartwatch is good, but the battery life could be longer.'),
(10, 5, 13, 5, 'Wireless earbuds are fantastic, very comfortable to wear.'),
(11, 6, 14, 3, 'Fitness tracker works well, but the app could be improved.'),
(12, 6, 15, 4, 'VR headset is great for gaming but can be heavy after long use.'),
(13, 7, 16, 5, 'Portable power bank is a lifesaver for long trips.'),
(14, 7, 17, 4, 'Gaming laptop is very powerful, but a bit heavy for portability.'),
(15, 8, 19, 3, 'Desktop PC is good but it overheats after extended use.'),
(16, 8, 18, 5, '2-in-1 convertible laptop is amazing, perfect for work and play.'),
(17, 9, 20, 4, 'Tablet is light and convenient, but I expected a better screen resolution.'),
(18, 9, 21, 3, 'External SSD is useful, but the transfer speeds could be faster.'),
(19, 10, 22, 5, 'Smart door lock is secure and easy to install, highly recommend it.'),
(20, 10, 23, 4, 'Wi-Fi smart plug is convenient but sometimes the app disconnects.'),
(21, 11, 24, 5, 'Smart LED bulb is very efficient and easy to set up.'),
(22, 11, 25, 3, 'Smart security camera works well, but the video quality could improve.'),
(23, 12, 26, 4, 'Smart thermostat is great for saving energy, easy to use.'),
(24, 12, 27, 5, 'Induction cooktop heats up very fast, saving a lot of cooking time.'),
(25, 13, 28, 4, 'Coffee maker is good, but I wish it had a larger water reservoir.'),
(26, 13, 29, 5, 'Air fryer cooks food very evenly, I love it.'),
(27, 14, 30, 3, 'Electric kettle is fine, but it takes longer to boil than expected.'),
(28, 14, 31, 4, 'Bread toaster works well, gives crispy toast every time.'),
(29, 15, 1, 5, 'Smart refrigerator is amazing, keeps my food fresh for weeks.'),
(30, 15, 7, 4, 'Smart TV (QLED) is good, but the remote control is confusing at times.'),
(31, 16, 9, 2, 'Bluetooth speaker could be louder for the price.'),
(32, 16, 5, 5, 'Vacuum cleaner is perfect, I love the powerful suction.'),
(33, 17, 14, 3, 'Fitness tracker is useful, but it has connectivity issues sometimes.'),
(34, 17, 8, 4, 'Home theater system is great for movie nights, but the setup is complicated.'),
(35, 18, 10, 5, 'Noise-canceling headphones are top notch, perfect for working in noisy environments.'),
(36, 18, 19, 4, 'Desktop PC is fast but a little bulky for my liking.'),
(37, 19, 12, 4, 'Smartwatch is great for tracking fitness but the display could be brighter.'),
(38, 19, 27, 5, 'Induction cooktop is very fast, heats up quickly and evenly.'),
(39, 20, 23, 5, 'Wi-Fi smart plug is excellent, works perfectly with voice assistants.'),
(40, 20, 13, 4, 'Wireless earbuds have good sound quality, but they are a bit uncomfortable after long use.');

select * from feedback;

-- Inserting data into the Promotions table
INSERT INTO Promotions (PromotionID, PromotionName, StartDate, DiscountPercentage)
VALUES
(1, 'Summer Sale', '2025-06-01 00:00:00', 15.00),
(2, 'Black Friday Deals', '2025-11-26 00:00:00', 25.00),
(3, 'Holiday Special', '2025-12-01 00:00:00', 20.00),
(4, 'Back to School Offer', '2025-08-01 00:00:00', 10.00),
(5, 'New Year Sale', '2025-01-01 00:00:00', 30.00),
(6, 'Spring Clearance', '2025-04-01 00:00:00', 18.00),
(7, 'Cyber Monday', '2025-11-30 00:00:00', 20.00),
(8, 'Valentine’s Day Sale', '2025-02-14 00:00:00', 10.00),
(9, 'Weekend Flash Deal', '2025-05-01 00:00:00', 12.00),
(10, 'Early Bird Discount', '2025-07-01 00:00:00', 5.00);

select * from Promotions;

INSERT INTO Supplier_Categories (SupplierID, CategoryID) VALUES
-- TechNova Distributors supplies Consumer Electronics & Computing Devices
(1, 2), (1, 4),

-- SmartHome Solutions supplies Smart Home Devices & Home Appliances
(2, 5), (2, 1),

-- Gadget World Inc. supplies Personal Gadgets & Consumer Electronics
(3, 3), (3, 2),

-- FutureTech Supplies supplies Computing Devices & Personal Gadgets
(4, 4), (4, 3),

-- Elite Electronics supplies Consumer Electronics & Smart Home Devices
(5, 2), (5, 5),

-- NextGen Appliances supplies Kitchen Appliances & Home Appliances
(6, 6), (6, 1),

-- Visionary Tech supplies Computing Devices & Smart Home Devices
(7, 4), (7, 5),

-- Home Comfort Ltd. supplies Home Appliances & Kitchen Appliances
(8, 1), (8, 6),

-- Digital Edge supplies Personal Gadgets & Consumer Electronics
(9, 3), (9, 2),

-- Quantum Electronics supplies Computing Devices & Consumer Electronics
(10, 4), (10, 2);

select * from Supplier_Categories;
show tables;

INSERT INTO Supplier_Products (SupplierID, ProductID) VALUES
-- TechNova Distributors supplies Consumer Electronics & Computing Devices
(1, 6), (1, 7), (1, 8), (1, 9), (1, 10), (1, 11), (1, 17), (1, 18), (1, 19), (1, 20), (1, 21),

-- SmartHome Solutions supplies Smart Home Devices & Home Appliances
(2, 1), (2, 2), (2, 3), (2, 4), (2, 5), (2, 22), (2, 23), (2, 24), (2, 25), (2, 26),

-- Gadget World Inc. supplies Personal Gadgets & Consumer Electronics
(3, 6), (3, 7), (3, 8), (3, 9), (3, 10), (3, 11), (3, 12), (3, 13), (3, 14), (3, 15), (3, 16),

-- FutureTech Supplies supplies Computing Devices & Personal Gadgets
(4, 12), (4, 13), (4, 14), (4, 15), (4, 16), (4, 17), (4, 18), (4, 19), (4, 20), (4, 21),

-- Elite Electronics supplies Consumer Electronics & Smart Home Devices
(5, 6), (5, 7), (5, 8), (5, 9), (5, 10), (5, 11), (5, 22), (5, 23), (5, 24), (5, 25), (5, 26),

-- NextGen Appliances supplies Kitchen Appliances & Home Appliances
(6, 1), (6, 2), (6, 3), (6, 4), (6, 5), (6, 27), (6, 28), (6, 29), (6, 30), (6, 31),

-- Visionary Tech supplies Computing Devices & Smart Home Devices
(7, 17), (7, 18), (7, 19), (7, 20), (7, 21), (7, 22), (7, 23), (7, 24), (7, 25), (7, 26),

-- Home Comfort Ltd. supplies Home Appliances & Kitchen Appliances
(8, 1), (8, 2), (8, 3), (8, 4), (8, 5), (8, 27), (8, 28), (8, 29), (8, 30), (8, 31),

-- Digital Edge supplies Personal Gadgets & Consumer Electronics
(9, 6), (9, 7), (9, 8), (9, 9), (9, 10), (9, 11), (9, 12), (9, 13), (9, 14), (9, 15), (9, 16),

-- Quantum Electronics supplies Computing Devices & Consumer Electronics
(10, 6), (10, 7), (10, 8), (10, 9), (10, 10), (10, 11), (10, 17), (10, 18), (10, 19), (10, 20), (10, 21);

INSERT INTO Warehouse_Employees (WarehouseID, EmployeeID) VALUES
-- Assigning employees to 'Main Tech Warehouse'
(1, 1), (1, 2), (1, 3),

-- Assigning employees to 'West Coast Storage'
(2, 4), (2, 5), (2, 6),

-- Assigning employees to 'Europe Distribution Hub'
(3, 7), (3, 8), (3, 9),

-- Assigning employees to 'Tokyo Storage Center'
(4, 10), (4, 11), (4, 12),

-- Assigning employees to 'Sydney Logistics'
(5, 13), (5, 14), (5, 15),

-- Assigning employees to 'UK SmartTech Storage'
(6, 16), (6, 17), (6, 18),

-- Assigning employees to 'Canada Electronics Hub'
(7, 19), (7, 20), (7, 21),

-- Assigning employees to 'Dubai AI Storage'
(8, 22), (8, 23), (8, 24),

-- Assigning employees to 'Shanghai Tech Park'
(9, 25), (9, 26), (9, 27),

-- Assigning employees to 'India IoT Hub'
(10, 28), (10, 29), (10, 30),

-- Assigning employees to 'Brazil Smart Devices'
(11, 1), (11, 6), (11, 11),

-- Assigning employees to 'Seoul Future Storage'
(12, 12), (12, 18), (12, 25);

INSERT INTO Employee_Customers (EmployeeID, CustomerID) VALUES
-- Assigning customers to 'Alice Johnson' (EmployeeID: 1)
(1, 1), (1, 2), (1, 3),

-- Assigning customers to 'Bob Smith' (EmployeeID: 2)
(2, 4), (2, 5), (2, 6),

-- Assigning customers to 'Charlie Brown' (EmployeeID: 3)
(3, 7), (3, 8), (3, 9),

-- Assigning customers to 'David Lee' (EmployeeID: 4)
(4, 10), (4, 11), (4, 12),

-- Assigning customers to 'Emma Davis' (EmployeeID: 5)
(5, 13), (5, 14), (5, 15),

-- Assigning customers to 'Oliver Wright' (EmployeeID: 6)
(6, 16), (6, 17), (6, 18),

-- Assigning customers to 'Sophia Turner' (EmployeeID: 7)
(7, 19), (7, 20), (7, 21),

-- Assigning customers to 'Liam Carter' (EmployeeID: 8)
(8, 22), (8, 23), (8, 24),

-- Assigning customers to 'Isabella Scott' (EmployeeID: 9)
(9, 25), (9, 26), (9, 27),

-- Assigning customers to 'Mason White' (EmployeeID: 10)
(10, 28), (10, 29), (10, 30),

-- Assigning customers to 'James Anderson' (EmployeeID: 11)
(11, 1), (11, 6), (11, 11),

-- Assigning customers to 'Grace Hall' (EmployeeID: 12)
(12, 12), (12, 18), (12, 25),

-- Assigning customers to 'Lucas King' (EmployeeID: 13)
(13, 2), (13, 7), (13, 14),

-- Assigning customers to 'Ava Robinson' (EmployeeID: 14)
(14, 3), (14, 9), (14, 15),

-- Assigning customers to 'William Harris' (EmployeeID: 15)
(15, 4), (15, 10), (15, 16),

-- Assigning customers to 'Ethan Martin' (EmployeeID: 16)
(16, 5), (16, 13), (16, 17),

-- Assigning customers to 'Harper Clark' (EmployeeID: 17)
(17, 8), (17, 19), (17, 22),

-- Assigning customers to 'Michael Young' (EmployeeID: 18)
(18, 11), (18, 20), (18, 23),

-- Assigning customers to 'Benjamin Allen' (EmployeeID: 19)
(19, 6), (19, 21), (19, 26),

-- Assigning customers to 'Emily Nelson' (EmployeeID: 20)
(20, 10), (20, 24), (20, 30),

-- Assigning customers to 'Samuel Taylor' (EmployeeID: 21)
(21, 1), (21, 12), (21, 15),

-- Assigning customers to 'Lily Foster' (EmployeeID: 22)
(22, 7), (22, 14), (22, 27),

-- Assigning customers to 'Jack Thomas' (EmployeeID: 23)
(23, 2), (23, 8), (23, 21),

-- Assigning customers to 'Sophia Williams' (EmployeeID: 24)
(24, 3), (24, 9), (24, 23),

-- Assigning customers to 'David Adams' (EmployeeID: 25)
(25, 5), (25, 16), (25, 28),

-- Assigning customers to 'Natalie Moore' (EmployeeID: 26)
(26, 11), (26, 18), (26, 25),

-- Assigning customers to 'Daniel Lee' (EmployeeID: 27)
(27, 6), (27, 17), (27, 22),

-- Assigning customers to 'Chloe Martinez' (EmployeeID: 28)
(28, 10), (28, 19), (28, 29),

-- Assigning customers to 'Joshua Perez' (EmployeeID: 29)
(29, 4), (29, 13), (29, 26),

-- Assigning customers to 'Sophie Harris' (EmployeeID: 30)
(30, 9), (30, 20), (30, 30);

INSERT INTO Employee_Orders (EmployeeID, OrderID) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5),
(6, 6), (7, 7), (8, 8), (9, 9), (10, 10),
(11, 11), (12, 12), (13, 13), (14, 14), (15, 15),
(16, 16), (17, 17), (18, 18), (19, 19), (20, 20),
(21, 21), (22, 22), (23, 23), (24, 24), (25, 25),
(26, 26), (27, 27), (28, 28), (29, 29), (30, 30),
(1, 31), (2, 32), (3, 33), (4, 34), (5, 35),
(6, 36), (7, 37), (8, 38), (9, 39), (10, 40),
(11, 41), (12, 42), (13, 43), (14, 44), (15, 45),
(16, 46), (17, 47), (18, 48), (19, 49), (20, 50);

-- Summer Sale - Good for seasonal electronics and cooling appliances
INSERT INTO Product_Promotions (ProductID, PromotionID) VALUES
(1, 1),  -- Smart Refrigerator
(4, 1),  -- Air Conditioner
(6, 1),  -- Smart TV (OLED)
(9, 1);  -- Bluetooth Speaker

-- Black Friday Deals - High-end and expensive items
INSERT INTO Product_Promotions (ProductID, PromotionID) VALUES
(6, 2),  -- Smart TV (OLED)
(7, 2),  -- Smart TV (QLED)
(17, 2), -- Gaming Laptop
(18, 2), -- 2-in-1 Laptop
(11, 2); -- Digital Camera

-- Holiday Special - Popular giftable gadgets
INSERT INTO Product_Promotions (ProductID, PromotionID) VALUES
(12, 3), -- Smartwatch
(13, 3), -- Wireless Earbuds
(14, 3), -- Fitness Tracker
(16, 3); -- Power Bank

-- Back to School Offer - Student-use products
INSERT INTO Product_Promotions (ProductID, PromotionID) VALUES
(18, 4), -- 2-in-1 Convertible Laptop
(20, 4), -- Tablet
(21, 4); -- External SSD

-- New Year Sale - Everything expensive
INSERT INTO Product_Promotions (ProductID, PromotionID) VALUES
(6, 5),  -- Smart TV (OLED)
(17, 5), -- Gaming Laptop
(1, 5);  -- Smart Refrigerator

-- Spring Clearance - Kitchen & Home Appliances
INSERT INTO Product_Promotions (ProductID, PromotionID) VALUES
(3, 6),  -- Microwave Oven
(5, 6),  -- Vacuum Cleaner
(27, 6), -- Induction Cooktop
(30, 6); -- Electric Kettle

-- Cyber Monday - Techie gear
INSERT INTO Product_Promotions (ProductID, PromotionID) VALUES
(8, 7),  -- Home Theater System
(15, 7), -- VR Headset
(19, 7); -- Desktop PC

-- Valentine’s Day Sale - Romantic/gift ideas
INSERT INTO Product_Promotions (ProductID, PromotionID) VALUES
(10, 8), -- Noise-Canceling Headphones
(13, 8), -- Wireless Earbuds
(14, 8); -- Fitness Tracker

-- Weekend Flash Deal - Low-cost impulse buys
INSERT INTO Product_Promotions (ProductID, PromotionID) VALUES
(23, 9), -- Wi-Fi Smart Plug
(24, 9), -- Smart LED Bulb
(30, 9), -- Electric Kettle
(31, 9); -- Bread Toaster

-- Early Bird Discount - Affordable computing/smart home
INSERT INTO Product_Promotions (ProductID, PromotionID) VALUES
(20, 10), -- Tablet
(22, 10), -- Smart Door Lock
(25, 10); -- Smart Security Camera

select * from product_promotions;
show tables;

select * From products;
select * from inventory;

SELECT 
    DATE(LastStockUpdate) AS UpdateDate,
    COUNT(*) AS UpdatesCount
FROM Inventory
GROUP BY DATE(LastStockUpdate)
ORDER BY UpdateDate;

select * from customers;
select * from categories;

select * from suppliers;
select * from warehouses;

select * from inventory;

select * from regions;
select * from addresses;
show tables;

ALTER TABLE Orders
MODIFY COLUMN OrderID INT NOT NULL AUTO_INCREMENT;




