----------------------------------
-- INITIAL DATABASE EXPLORATION --
----------------------------------

-- --------- CATEGORIES ----------

-- Explore the categories table
SELECT * FROM  "categories";

-- Result: The store in this dataset has ten different product categories,
-- most of which are food-related (e.g., Produce, Bakery), with other categories
-- including Personal Care and Household Cleaning.

-- ---------- CUSTOMERS ----------

-- Explore the customers table
SELECT * FROM "customers" LIMIT 10;

-- Check the number of customers in the dataset
SELECT COUNT(*) AS "Number of Customers" FROM "customers";

-- Result: The database has data on 1000 customers.

-- Check which cities are represented in the dataset
SELECT DISTINCT "City" FROM "customers";

-- Result: The dataset includes customers from ten different cities, all within Turkey.

-- Check how customers are classified in the dataset
SELECT "CustomerSegment", COUNT(*) AS "Count"
FROM "customers" 
GROUP BY "CustomerSegment"
ORDER BY "Count" DESC; 

-- Result: Customers can be classified into three groups: "Standard", "Premium", and "VIP".
-- The majority of customers are in the "Standard" group, with a sizable minority in "Premium".

-- Check age range of customers in the dataset
SELECT "Age", COUNT(*) AS "Count"
FROM "customers"
GROUP BY "Age";

-- Result: Customer ages in the dataset are between 18 and 72. 

-- -------- ORDER DETAILS --------

-- Explore the order_details table
SELECT * FROM "order_details" LIMIT 10;

-- Result: An order can have one or more rows, with each row representing a different product in the order.

-- Check values of discount rates
SELECT "DiscountRate", COUNT(*) AS "Count"
FROM "order_details"
GROUP BY "DiscountRate";

-- Result: Discounts are represented as decimals, and range from 0.0 (no discount) to 0.4 (40% off).
-- The majority of products purchased by customers in this dataset were purchased at full price.

-- Check values of return dates
SELECT "ReturnDate", COUNT(*) AS "Count" 
FROM "order_details"
GROUP BY "ReturnDate";

-- Result: The earliest return date is in January of 2021, 
-- and items that have not been returned have return dates listed as '9999-12-31'.

-- Check average rate of return
SELECT ROUND(AVG("IsReturned") * 100, 2) AS "Percentage Returned" FROM "order_details";

-- Result: 4.7% of purchases have been returned by the customer in the dataset.

-- ----------- ORDERS ------------

-- Check the orders table
SELECT * FROM "orders" LIMIT 5;

-- Check when orders were first tracked
SELECT "OrderDate", COUNT(*) AS "Number of Orders"
FROM "orders"
GROUP BY "OrderDate" LIMIT 1;

-- Result: The first two orders in the dataset were made on January 1, 2021.

-- Check when orders were last tracked
SELECT "OrderDate", COUNT(*) AS "Number of Orders"
FROM "orders"
GROUP BY "OrderDate"
ORDER BY "OrderDate" DESC LIMIT 1;

-- Result: The last 13 orders in the dataset were made on June 1, 2026.

-- ---------- PRODUCTS -----------

-- Check the products table
SELECT * FROM "products" LIMIT 5;

-- Check how many products are in the dataset
SELECT COUNT(*) AS "Number of Products" FROM "products";

-- Result: 100 products being sold at this retailer are in the dataset.