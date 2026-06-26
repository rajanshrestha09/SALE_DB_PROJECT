-- 1. Number of rows in each column
SELECT
(SELECT COUNT(*) FROM sales_schema.sales) AS sales,
(SELECT COUNT(*) FROM sales_schema.products) AS products,
(SELECT COUNT(*) FROM sales_schema.salespersons) AS salesperson;

-- 2. Show the 5 largest orders by units, newest first on ties
SELECT order_id, order_date, product, quantity
FROM sales_schema.sales
LEFT JOIN sales_schema.products ON
products.product_id = sales.product_id
ORDER BY quantity DESC, order_date DESC
LIMIT 5;

-- 3. All Laptop orders that received a discount
SELECT order_id, product, quantity, discount
FROM sales_schema.sales
LEFT JOIN sales_schema.products ON
products.product_id = sales.product_id
WHERE category = 'Laptops' and discount > 0;

--4. Distinct channels and regions
SELECT DISTINCT channel FROM sales_schema.sales;
--SELECT DISTINCT region FROM sales_schema.sales;


--5. Add revenue and profit to each order line
SELECT
    order_id,
    product,
    discount,
    ROUND(quantity * unit_price * (1-discount/100)) AS revenue,
    ROUND(quantity * unit_price * (1-discount/100)) - quantity*unit_cost AS profit
FROM sales_schema.sales AS sales
LEFT JOIN sales_schema.products AS products ON
products.product_id = sales.product_id;
    
--  6. Bucket each order by size with CASE
SELECT
    CASE
        WHEN quantity*unit_price * (1-discount/100) >= 15000 THEN 'Large'
        WHEN quantity*unit_price * (1-discount/100) >=5000 THEN 'Medium'
        ELSE 'Small'
    END AS order_band,
    COUNT(*) AS orders
FROM sales_schema.sales
LEFT JOIN sales_schema.products AS products ON
products.product_id = sales.product_id
GROUP BY order_band
ORDER BY  orders DESC
;

-- 7. Profit margin margin %
SELECT 
    order_id,
    ROUND((quantity * unit_price * (1-discount/100)-(quantity*unit_cost))/
        NULLIF(quantity*unit_price *(1-discount/100),0),2) * 100 As profit_margin
FROM sales_schema.sales
LEFT JOIN sales_schema.products ON
products.product_id = sales.product_id;

--------------------------------- Aggregation -------------
-- 9. Total revenue, profit and units (whole company)
SELECT 
    ROUND(SUM(quantity * unit_price * (1-discount/100)))AS Revenue,
    ROUND(SUM(quantity * unit_price * (1-discount/100) - quantity * unit_cost)) AS Profit,
    SUM(quantity)
FROM sales_schema.sales
LEFT JOIN sales_schema.products ON
products.product_id = sales.product_id;

-- 10. Revenue and order count by region
SELECT 
    region,
    ROUND(SUM(quantity * unit_price * (1-discount/100)))AS Revenue,
    Count(*) AS orders
FROM sales_schema.sales
LEFT JOIN sales_schema.products ON
products.product_id = sales.product_id
GROUP BY region
ORDER BY orders DESC;

-- 11. Revenue by category
SELECT 
    category,
    ROUND(SUM(quantity * unit_price * (1-discount/100)))AS Revenue   
FROM sales_schema.sales
LEFT JOIN sales_schema.products ON
products.product_id = sales.product_id
GROUP BY category
ORDER BY Revenue DESC;

-- 12. Only categories above $100k (HAVING)
SELECT 
    category,
    ROUND(SUM(quantity * unit_price * (1-discount/100)))AS Revenue   
FROM sales_schema.sales
LEFT JOIN sales_schema.products ON
products.product_id = sales.product_id
GROUP BY category
HAVING SUM(quantity * unit_price * (1-discount/100)) > 100000
ORDER BY Revenue DESC;

--13. Average order value & discount uptake
SELECT 
    ROUND(AVG(quantity * unit_price * (1-discount/100)))AS avg_order,
    SUM(CASE WHEN discount > 0 THEN 1 ELSE 0 END) AS discounted_orders   
FROM sales_schema.sales
LEFT JOIN sales_schema.products ON
products.product_id = sales.product_id;

-- 14. Average margin % by category
SELECT 
    category,
    ROUND(SUM(quantity * unit_price * (1-discount/100)))AS Revenue,
    ROUND(SUM(quantity * unit_price * (1-discount/100))- SUM(quantity * unit_cost))AS Profit,
    ROUND(100*(SUM(quantity * unit_price * (1-discount/100))- SUM(quantity * unit_cost))/SUM(quantity * unit_price * (1-discount/100)),2)
FROM sales_schema.sales
LEFT JOIN sales_schema.products ON
products.product_id = sales.product_id
GROUP BY category;


----------------------- Subqueries & CTEs -----------------------


--15. Orders larger than the average order quantity
SELECT AVG(quantity)
FROM sales_schema.sales;

SELECT COUNT(*) AS above_avg_orders
FROM sales_schema.sales
WHERE quantity > (SELECT AVG(quantity) FROM sales_schema.sales);


-- 16. Top product per region (CTE + ROW_NUMBER)
WITH ranked AS (
    SELECT 
        region, 
        product,
        ROUND(SUM(quantity * unit_price * (1-discount/100)))AS revenue,
        ROW_NUMBER() OVER (
            PARTITION BY region
            ORDER BY SUM(quantity * unit_price * (1-discount/100)) DESC 
        ) AS rn
    FROM sales_schema.sales
    LEFT JOIN sales_schema.products
    ON products.product_id = sales.product_id
    GROUP BY region,product
)
SELECT region, product, revenue
FROM ranked
WHERE rn = 1
ORDER BY region;