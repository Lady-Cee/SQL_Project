CREATE DATABASE TechMart;
USE TechMart;

-- Customers Table
CREATE TABLE Customers (
    CustomerId INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Age INT,
    City VARCHAR(100)
);

-- Products Table
CREATE TABLE Products (
    ProductId INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(100),
    Price DECIMAL(10, 2)
);

-- Sales Table
CREATE TABLE Sales (
    SaleId INT PRIMARY KEY,
    CustomerId INT,
    ProductId INT,
    StoreId INT,
    Quantity INT,
    SaleDate DATE,
    FOREIGN KEY (CustomerId) REFERENCES Customers(CustomerId),
    FOREIGN KEY (ProductId) REFERENCES Products(ProductId),
    FOREIGN KEY (StoreId) REFERENCES Stores(StoreId)
);

-- Stores Table
CREATE TABLE Stores (
    StoreId INT PRIMARY KEY,
    StoreName VARCHAR(100) UNIQUE,
    City VARCHAR(100)
);


select  * from customers;
select  * from products;
select  * from sales;
select  * from stores;
drop table sales;

--  data cleaning
SELECT * FROM Customers WHERE age IS NULL OR city IS NULL;
SELECT * FROM Products WHERE category IS NULL;
SELECT * FROM Sales WHERE quantity <= 0 OR saledate IS NULL;

UPDATE Stores SET city = 'San Francisco' WHERE city IN ('SF', 'San Fran');

-- Customer Analysis
-- Top 5 cities with highest unique customers:
SELECT City, COUNT(DISTINCT customerid) AS unique_customers
FROM Customers
GROUP BY city
ORDER BY unique_customers DESC
LIMIT 5;

--  - Determine the age group that spends the most on average. 
SELECT 
    CASE 
        WHEN age < 20 THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29 THEN '20-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age >= 40 THEN '40+'
    END AS age_group,
    AVG(p.price * s.quantity) AS avg_spending
FROM Sales s
JOIN Customers c ON s.customerid = c.customerid
JOIN Products p ON s.productid = p.productid
GROUP BY age_group
ORDER BY avg_spending DESC;

-- Product Analysis: 
 -- List the top 5 most frequently purchased products.
 SELECT p.productname, SUM(s.quantity) AS total_purchased
FROM Sales s
JOIN Products p ON s.productid = p.productid
GROUP BY p.productname
ORDER BY total_purchased DESC
LIMIT 5;

-- Calculate the total sales for each product category.
SELECT p.category, SUM(p.price * s.quantity) AS total_sales
FROM Sales s
JOIN Products p ON s.productid = p.productid
GROUP BY p.category
ORDER BY total_sales DESC;

-- . Sales Performance: 
 -- Calculate the total monthly sales for the year.
SELECT 
    DATE_FORMAT(s.saledate, '%Y-%m') AS month, 
    SUM(p.price * s.quantity) AS total_sales
FROM Sales s
JOIN Products p ON s.productid = p.productid
GROUP BY month
ORDER BY month;

-- store with highest revenue
SELECT st.name, SUM(p.price * s.quantity) AS revenue
FROM Sales s
JOIN Products p ON s.productid = p.productid
JOIN Stores st ON s.storeid = st.storeid
GROUP BY st.name
ORDER BY revenue DESC
LIMIT 1;

--  Regional trends
-- sales by region 
SELECT st.city, SUM(p.price * s.quantity) AS total_sales
FROM Sales s
JOIN Stores st ON s.store_id = st.store_id
JOIN Products p ON s.product_id = p.product_id
GROUP BY st.city
ORDER BY total_sales DESC;

-- Region with the highest average sale value:
SELECT st.city, AVG(p.price * s.quantity) AS avg_sale_value
FROM Sales s
JOIN Stores st ON s.store_id = st.store_id
JOIN Products p ON s.product_id = p.product_id
GROUP BY st.city
ORDER BY avg_sale_value DESC
LIMIT 1;

-- Customer loyalty
-- Customers who purchased every month:
SELECT customer_id
FROM Sales
GROUP BY customer_id
HAVING COUNT(DISTINCT strftime('%Y-%m', sale_date)) = 12;

-- Percentage of repeat customers:
SELECT 
    (COUNT(DISTINCT customer_id) * 1.0 / (SELECT COUNT(*) FROM Customers)) * 100 AS repeat_percentage
FROM Sales
GROUP BY customer_id
HAVING COUNT(sale_id) > 1;




