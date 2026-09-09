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
-- dataset show a slightly lower average per-unit price than non-returned items. However, this difference
-- is quite small, indicating that there is little association between whether an item was returned
-- and average per-unit price.


-- Question: Is number of units purchased associated with whether an item gets returned? 

WITH "qar" AS (
SELECT
    CASE
        WHEN "Quantity" BETWEEN 1 AND 5 THEN '1-5'
        WHEN "Quantity" BETWEEN 6 AND 10 THEN '6-10'
        WHEN "Quantity" BETWEEN 11 AND 15 THEN '11-15'
        WHEN "Quantity" BETWEEN 16 AND 20 THEN '16-20'
        WHEN "Quantity" BETWEEN 21 AND 25 THEN '21-25'
    END AS "Quantity (Range)",
    "IsReturned"
FROM "order_details"
)

SELECT "Quantity (Range)", ROUND(AVG("IsReturned") * 100, 2) AS "PercentageReturned"
FROM "qar"
GROUP BY "Quantity (Range)"
ORDER BY
    CASE
        WHEN "Quantity (Range)" = '1-5' THEN 1
        WHEN "Quantity (Range)" = '6-10' THEN 2
        WHEN "Quantity (Range)" = '11-15' THEN 3
        WHEN "Quantity (Range)" = '16-20' THEN 4
        WHEN "Quantity (Range)" = '21-25' THEN 5
    END;

-- Result: Items with the highest number of units purchased (between 21 and 25 units) had the highest
-- rate of return at 5.88%. However, items with the lowest quantity purchased (between 1 and 5 units)
-- had the second-highest rate of return at 4.73%. Thus, as quantity purchased increases, return rates
-- show no clear pattern, suggesting little association between the number of units purchased
-- and whether an item gets returned.


-- Question: Is discount rate associated with whether an item gets returned?
SELECT "DiscountRate", ROUND(AVG("IsReturned") * 100, 2) AS "PercentageReturned"
FROM "order_details"
GROUP BY "DiscountRate";

-- Result: Across all discount rates, the percentage of items returned is roughly the same. Items with a 25%
-- discount rate were most likely to be returned with a return rate of 6.24%, while items with a 20% discount
-- rate were least likely to be returned with a return rate of 4.25%. Given that two very close discount rates
-- are associated with both the highest and lowest percentage of items returned, there seems to be no clear
-- association between discount rate and whether an item gets returned.


-- ------ CUSTOMER ANALYSIS ------


-- Question: Are customers from certain regions more lucrative for the retailer?

WITH "tp_by_customer" AS (
SELECT "CustomerID", "Region", SUM("RealizedProfit") AS "TotalProfit"
FROM "v_master_orders"
GROUP BY "CustomerID"
)

SELECT "Region", ROUND(AVG("TotalProfit"), 2) AS "Average Profit, Per Customer"
FROM "tp_by_customer"
GROUP BY "Region"
ORDER BY "Average Profit, Per Customer" DESC;

-- Result: Customers in the Mediterranean region make the store the most profit per customer on average, with an
-- average total profit per customer of 207.33. In four of the five regions (Mediterranean, Aegean, Marmara, and
-- Central Anatolia), the average profit per customer is roughly the same, being between 201 and 208. However, in the
-- Black Sea region, average profit per customer is noticeably lower, at 168.16.

-- Question: Are customers from certain cities more lucrative for the retailer?
WITH "tp_by_customer" AS (
SELECT "CustomerID", "City", SUM("RealizedProfit") AS "TotalProfit"
FROM "v_master_orders"
GROUP BY "CustomerID"
)

SELECT "City", ROUND(AVG("TotalProfit"), 2) AS "Average Profit, Per Customer"
FROM "tp_by_customer"
GROUP BY "City"
ORDER BY "Average Profit, Per Customer" DESC;

-- Result: When looking at individual cities, differences in average total profit per customer are more noticeable.
-- In Eskisehir, the average profit per customer is 221.55, while in Kocaeli, the average profit per customer is just 180.49.
-- This could mean that a customer's city may be a better indicator of how much profit they will generate the retailer, rather than
-- their region.