create database Zepto_in;
 use Zepto_in;
  drop table if exists zepto;


CREATE TABLE zepto_v2 (
category VARCHAR(120),
  name VARCHAR(150) NOT NULL,
  mrp DECIMAL(8,2),
  discountPercent DECIMAL(5,2),
  availableQuantity INT,
  discountedSellingPrice DECIMAL(8,2),
  weightInGms INT,
  outOfStock TINYINT(1) DEFAULT 0, 
  quantity INT
);


-- Data Exploration

-- Count of rows
select count(*) from zepto_v2;

-- Sample data 
SELECT 
    *
FROM
    zepto_v2
LIMIT 10;


ALTER TABLE zepto_in.zepto_v2
ADD COLUMN serial_number INT AUTO_INCREMENT PRIMARY KEY;

-- Null values
SELECT 
    *
FROM
    zepto_v2
WHERE
    name IS NULL OR Category IS NULL
        OR mrp IS NULL
        OR discountPercent IS NULL
        OR availableQuantity IS NULL
        OR discountedSellingPrice IS NULL
        OR weightInGms IS NULL
        OR outOfStock IS NULL
        OR quantity IS NULL;
        
--         different product categoiries
SELECT DISTINCT
    Category
FROM
    zepto_v2
ORDER BY category;

-- products in stock and outofstock
SELECT 
    outOfstock, COUNT(serial_number)
FROM
    zepto_v2
GROUP BY outOfstock;

-- product name present multiple times
SELECT 
    name, COUNT(serial_number) AS Number_of_SKUs
FROM
    zepto_v2
GROUP BY name
HAVING COUNT(serial_number) > 1
ORDER BY COUNT(serial_number) DESC;

-- data cleaning

-- products of price 0

SELECT 
    *
FROM
    zepto_v2
WHERE
    mrp = 0 OR discountedSellingPrice = 0;
    
    SET SQL_SAFE_UPDATES = 0;
    DELETE FROM zepto_v2 
WHERE
    mrp = 0;
    
--     data transformmation

-- convert paise to rupees    

UPDATE zepto_v2 
SET 
    mrp = mrp / 100.0,
    discountedSellingPrice = discountedSellingPrice / 100.0;

select * from zepto_v2;
SELECT 
    name, mrp, discountedSellingPrice
FROM
    zepto_v2;

--  Top 10 best-value products based on discount percentage
SELECT DISTINCT
    name, mrp, discountPercent
FROM
    zepto_v2
ORDER BY discountPercent DESC
LIMIT 10;

-- Identified high-MRP products that are currently out of stock
SELECT DISTINCT
    name, mrp, outOfstock
FROM
    zepto_v2
WHERE
    outOfstock = "TRUE" AND mrp > 300
ORDER BY mrp DESC;
-- Estimated potential revenue for each product category
SELECT 
    Category,
    SUM(discountedSellingPrice * quantity) AS estimated_revenue_from_each_Category
FROM
    zepto_v2
GROUP BY Category
ORDER BY estimated_revenue_from_each_Category DESC;


-- Filtered expensive products (MRP > ₹500) and discount is less than 10%
select avg(discountPercent)
from zepto_v2;
SELECT DISTINCT
    name, mrp, discountPercent
FROM
    zepto_v2
WHERE
    mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC;
-- Ranked top 5 categories offering highest average discounts
SELECT 
    category, AVG(discountPercent) avg_discount
FROM
    zepto_v2
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

-- Calculated price per gram products above 100 g and sort by best value
SELECT DISTINCT
    name,
    mrp,
    weightInGms,
    discountedSellingPrice,
    (discountedSellingPrice / weightInGms) AS Price_per_gm
FROM
    zepto_v2
WHERE
    weightInGms >= 100
ORDER BY Price_per_gm desc;

-- Grouped products based on weight into Low, Medium, and Bulk categories

SELECT DISTINCT
    name,
    weightInGms,
    CASE
        WHEN weightInGms < 1000 THEN 'Low'
        WHEN weightInGms < 5000 THEN 'Medium'
        ELSE 'Bulk'
    END AS weight_category
FROM
    zepto_v2
ORDER BY weightInGms DESC;

-- Measured total inventory weight per product category
SELECT 
    category,
    SUM(weightInGms * availableQuantity) AS total_weight
FROM
    zepto_v2
GROUP BY category
ORDER BY total_weight;


