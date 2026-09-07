----------------------------------
--------     ANALYSIS     --------
----------------------------------

-- ------- RETURN ANALYSIS -------


-- Question: Is final unit price associated with whether an item gets returned?
WITH "par" AS (
SELECT "UnitPrice" * (1 - "DiscountRate") AS "FinalUnitPrice", "IsReturned" FROM "order_details"
)

SELECT "IsReturned", COUNT(*) AS "Count", ROUND(AVG("FinalUnitPrice"), 2) AS "Average Unit Price (after discount)"
FROM "par"
GROUP BY "IsReturned";

-- Result: After applying discounts, non-returned items had an average price of 9.47 per unit,
-- while returned items had an average price of 8.93 per unit. While returned items in this
-- dataset do show a slightly lower average per-unit price than non-returned items, this difference
-- is quite small, indicating that there is little association between average per-unit price
-- and whether an item was returned.

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