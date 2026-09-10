----------------------------------
--------     ANALYSIS     --------
----------------------------------

-- ------- RETURN ANALYSIS -------


-- Question: Do returned items tend to be more expensive than non-returned ones?
WITH "par" AS (
    SELECT "UnitPrice" * (1 - "DiscountRate") AS "FinalUnitPrice", "IsReturned" FROM "order_details"
)

SELECT "IsReturned", COUNT(*) AS "Count", ROUND(AVG("FinalUnitPrice"), 2) AS "Average Unit Price (after discount)"
FROM "par"
GROUP BY "IsReturned";

-- Result: After applying discounts, non-returned items had an average price of 9.47 per unit,
-- while returned items had an average price of 8.93 per unit. So, returned items in this
-- dataset show a slightly lower per-unit price, on average, than non-returned items. However, this difference
-- is quite small, indicating that returned items don't significantly differ in price from non-returned ones.


-- Question: Is number of units purchased associated with whether an item gets returned? 

WITH "qar" AS (
    SELECT
        CASE
            WHEN "Quantity" BETWEEN 1 AND 5 THEN '1-5'
            WHEN "Quantity" BETWEEN 6 AND 10 THEN '6-10'
            WHEN "Quantity" BETWEEN 11 AND 15 THEN '11-15'
            WHEN "Quantity" BETWEEN 16 AND 20 THEN '16-20'
            WHEN "Quantity" BETWEEN 21 AND 25 THEN '21-25'
        END AS "QuantityRange",
        "IsReturned"
    FROM "order_details"
)

SELECT "QuantityRange", ROUND(AVG("IsReturned") * 100, 2) AS "% Returned"
FROM "qar"
GROUP BY "QuantityRange"
ORDER BY
    CASE
        WHEN "QuantityRange" = '1-5' THEN 1
        WHEN "QuantityRange" = '6-10' THEN 2
        WHEN "QuantityRange" = '11-15' THEN 3
        WHEN "QuantityRange" = '16-20' THEN 4
        WHEN "QuantityRange" = '21-25' THEN 5
    END;

-- Result: Items with the highest number of units purchased (between 21 and 25 units) had the highest
-- rate of return at 5.88%. However, items with the lowest quantity purchased (between 1 and 5 units)
-- had the second-highest rate of return at 4.73%. Thus, as quantity purchased increases, return rates
-- show no clear pattern, suggesting little association between the number of units purchased
-- and whether an item gets returned.


-- Question: Is discount rate associated with whether an item gets returned?
SELECT "DiscountRate", ROUND(AVG("IsReturned") * 100, 2) AS "% Returned"
FROM "order_details"
GROUP BY "DiscountRate";

-- Result: Across all discount rates, the percentage of items returned is roughly the same. Items with a 25%
-- discount rate were most likely to be returned with a return rate of 6.24%, while items with a 20% discount
-- rate were least likely to be returned with a return rate of 4.25%. Given that two very close discount rates
-- are associated with both the highest and lowest percentage of items returned, there seems to be no clear
-- association between discount rate and whether an item gets returned.


-- ------ CUSTOMER ANALYSIS ------


-- Question: Does the retailer make more profit, on average, off customers from certain regions?

WITH "tpbc" AS (
    SELECT "CustomerID", "Region", SUM("RealizedProfit") AS "TotalProfit"
    FROM "v_master_orders"
    GROUP BY "CustomerID"
)

SELECT "Region", ROUND(AVG("TotalProfit"), 2) AS "Average Profit Per-Customer"
FROM "tpbc"
GROUP BY "Region"
ORDER BY "Average Profit Per-Customer" DESC;

-- Result: Customers in the Mediterranean region are the most profitable, making the store an average profit
-- per-customer of 207.33. Between the Mediterranean and three of the four other regions (Aegean, Marmara, 
-- and Central Anatolia), the average profit per customer is roughly the same, being between 201 and 208. 
-- In constrast, average profit per customer is noticeably lower in the Black Sea region at 168.16.


-- Question: Does the retailer make more profit, on average, off customers from certain cities?

WITH "tpbc" AS (
    SELECT "CustomerID", "City", SUM("RealizedProfit") AS "TotalProfit"
    FROM "v_master_orders"
    GROUP BY "CustomerID"
)

SELECT "City", ROUND(AVG("TotalProfit"), 2) AS "Average Profit Per-Customer"
FROM "tpbc"
GROUP BY "City"
ORDER BY "Average Profit Per-Customer" DESC;

-- Result: When looking at individual cities, differences in average profit per customer are quite noticeable.
-- In Eskisehir, the average profit per customer is 221.55, while in Kocaeli, the average profit per customer is just 180.49.
-- This could show that a customer's city is a better indicator of potential profit than their region.


-- Question: Does the retailer make more profit, on average, off customers from a certain gender?

WITH "tpbc" AS (
    SELECT "CustomerID", "Gender", SUM("RealizedProfit") AS "TotalProfit"
    FROM "v_master_orders"
    GROUP BY "CustomerID"
)

SELECT "Gender", ROUND(AVG("TotalProfit"), 2) AS "Average Profit Per-Customer"
FROM "tpbc"
GROUP BY "Gender"
ORDER BY "Average Profit Per-Customer" DESC;

-- Result: The average profit per customer is roughly the same across all genders. Female customers make the retailer the
-- most profit per-customer, with an average profit per-customer of 204.74.


-- Question: Do Premium and VIP customers spend more, on average, than Standard customers?

WITH "trbc" AS (
    SELECT "CustomerID", "CustomerSegment", SUM("TotalRevenue") AS "TotalRevenue"
    FROM "v_master_orders"
    GROUP BY "CustomerID"
)

SELECT "CustomerSegment", ROUND(AVG("TotalRevenue"), 2) AS "Average Revenue Per-Customer"
FROM "trbc"
GROUP BY "CustomerSegment"
ORDER BY "Average Revenue Per-Customer";

-- Result: Premium and VIP members spend noticeably more than Standard customers. Standard customers generate the retailer an average
-- revenue per-customer of 486.81, while Premium members spend almost double that, generating the retailer an average revenue per-customer
-- of 964.69. VIP members spend almost double that amount again, generating the retailer an average revenue per-customer of 1848.04.


-- ------ PRODUCT ANALYSIS -------


-- Question: Is item price (price per-unit) associated with popularity (total number of units purchased)?

WITH "tq" AS (
    SELECT  
        CASE
            WHEN "UnitPrice" BETWEEN 0 AND 10 THEN '0-10'
            WHEN "UnitPrice" BETWEEN 10.01 AND 20 THEN '10-20'
            WHEN "UnitPrice" BETWEEN 20.01 AND 30 THEN '20-30'
            WHEN "UnitPrice" BETWEEN 30.01 AND 40 THEN '30-40'
        END AS "UnitPriceRange",
        "ProductID",
        SUM("Quantity") AS "Total Units Purchased"
    FROM "order_details"
    GROUP BY "ProductID"
)

SELECT "UnitPriceRange", ROUND(AVG("Total Units Purchased"), 2) AS "Average Total Units Purchased"
FROM "tq"
GROUP BY "UnitPriceRange";

-- Result: Items with higher prices per-unit do tend to be a bit more popular, as items with unit prices in the ranges of 20-30 and 30-40,
-- the two highest ranges for per-unit price, also had the highest averages for total units purchased, at 990.5 and 1038.5 respectively.


-- Question: Which categories are the most popular products typically from?

WITH "upp" AS (
    SELECT "ProductID", SUM("Quantity") AS "Total Units Purchased"
    FROM "order_details"
    GROUP BY "ProductID"
)

SELECT "categories"."CategoryName", "Total Units Purchased"
FROM "upp" 
JOIN "products" 
    ON "upp"."ProductID" = "products"."ProductID"
JOIN "categories"
    ON "products"."CategoryID" = "categories"."CategoryID"
ORDER BY "Total Units Purchased" DESC
LIMIT 10;

-- Of the ten most popular items (based on units purchased), five are from the "Produce" category, three are from the "Dairy & Eggs"
-- category, and two are from the "Meat & Poultry" category.