# 🛒 Sales Data Analysis with PostgreSQL

A structured SQL analysis project demonstrating real-world business intelligence queries on a **B2B electronics sales dataset** — covering data exploration, revenue & profit calculations, segmentation, aggregation, subqueries, and window functions.

> **Skills demonstrated:** PostgreSQL · Joins · Aggregations · CASE/WHEN · CTEs · Window Functions · Subqueries · Business Metrics

---

## 📁 Repository Structure

```
sale_db_project/
├── outputcsv
│   ├── 01_row_counts.csv
│   ├── 02_top5_orders_by_quantity.csv
│   ├── 03_laptop_discount_orders.csv
│   ├── 04_distinct_channels.csv
│   ├── 05_revenue_and_profit_per_order.csv
│   ├── 06_order_size_buckets.csv
│   ├── 07_profit_margin_per_order.csv
│   ├── 09_company_totals.csv
│   ├── 10_revenue_by_region.csv
│   ├── 11_revenue_by_category.csv
│   ├── 12_categories_above_100k.csv
│   ├── 13_avg_order_and_discount_uptake.csv
│   ├── 14_margin_by_category.csv
│   ├── 15_above_avg_quantity_orders.csv
│   ├── 16_top_product_per_region.csv
│   └── README.md
├── postgres.session.sql
├── README.md
└── sqltables
    ├── products.csv
    ├── sales.csv
    └── salespersons.csv
```

---

## 🗄️ Dataset Overview

The database contains **3 tables** in a `sales_schema` PostgreSQL schema:

| Table | Rows | Description |
|-------|------|-------------|
| `sales` | 200 | Order-level records with region, channel, quantity, discount |
| `products` | 15 | Product catalogue with unit price and unit cost |
| `salespersons` | 10 | Sales rep information |

**Product categories:** Laptops · Displays · Audio · Peripherals · Accessories  
**Sales channels:** Online · Retail · Partner  
**Regions:** Americas · EMEA · APAC

---

## 🔍 Queries & Results

### Section 1 — Data Exploration

---

#### Q1 · Row counts across all tables

```sql
SELECT
  (SELECT COUNT(*) FROM sales_schema.sales)        AS sales,
  (SELECT COUNT(*) FROM sales_schema.products)     AS products,
  (SELECT COUNT(*) FROM sales_schema.salespersons) AS salesperson;
```

| sales | products | salesperson |
|-------|----------|-------------|
| 200   | 15       | 10          |

---

#### Q2 · Top 5 largest orders by quantity (newest first on ties)

```sql
SELECT order_id, order_date, product, quantity
FROM sales_schema.sales
LEFT JOIN sales_schema.products ON products.product_id = sales.product_id
ORDER BY quantity DESC, order_date DESC
LIMIT 5;
```

| order_id   | order_date | product             | quantity |
|------------|------------|---------------------|----------|
| ORD-10026  | 2024-12-15 | Conference Mic      | 25       |
| ORD-10170  | 2024-12-10 | Business Laptop 15  | 25       |
| ORD-10060  | 2024-12-09 | Ultrabook 14        | 25       |
| ORD-10100  | 2024-12-01 | Document Scanner    | 25       |
| ORD-10128  | 2024-10-30 | Mechanical Keyboard | 25       |

> **Concept:** `ORDER BY` with multi-column sort and `LIMIT` for top-N queries.

---

#### Q3 · All Laptop orders that received a discount

```sql
SELECT order_id, product, quantity, discount
FROM sales_schema.sales
LEFT JOIN sales_schema.products ON products.product_id = sales.product_id
WHERE category = 'Laptops' AND discount > 0;
```

**Result:** 42 discounted laptop orders (5%–20% discount range).  
Sample rows:

| order_id  | product            | quantity | discount |
|-----------|--------------------|----------|----------|
| ORD-10004 | Business Laptop 15 | 18       | 15       |
| ORD-10009 | Gaming Laptop 16   | 13       | 10       |
| ORD-10025 | Gaming Laptop 16   | 22       | 20       |

> 📄 Full result → [`outputcsv/03_laptop_discount_orders.csv`](outputcsv/03_laptop_discount_orders.csv)

> **Concept:** Filtering with `WHERE` on joined columns using `AND` conditions.

---

#### Q4 · Distinct sales channels

```sql
SELECT DISTINCT channel FROM sales_schema.sales;
```

| channel |
|---------|
| Online  |
| Retail  |
| Partner |

> **Concept:** `DISTINCT` for deduplication.

---

### Section 2 — Revenue & Profit Calculations

---

#### Q5 · Revenue and profit per order line

```sql
SELECT
    order_id,
    product,
    discount,
    ROUND(quantity * unit_price * (1 - discount/100))              AS revenue,
    ROUND(quantity * unit_price * (1 - discount/100)) - quantity * unit_cost AS profit
FROM sales_schema.sales
LEFT JOIN sales_schema.products ON products.product_id = sales.product_id;
```

Sample rows:

| order_id  | product            | discount | revenue | profit |
|-----------|--------------------|----------|---------|--------|
| ORD-10004 | Business Laptop 15 | 15       | 16,065  | 2,385  |
| ORD-10009 | Gaming Laptop 16   | 10       | 20,475  | 3,575  |
| ORD-10025 | Gaming Laptop 16   | 20       | 30,800  | 2,200  |

> 📄 Full result → [`outputcsv/05_revenue_and_profit_per_order.csv`](outputcsv/05_revenue_and_profit_per_order.csv)

> **Concept:** Inline arithmetic expressions, `ROUND()`, and discount factor `(1 - discount/100)`.

---

#### Q6 · Order size segmentation with CASE/WHEN

```sql
SELECT
    CASE
        WHEN quantity * unit_price * (1 - discount/100) >= 15000 THEN 'Large'
        WHEN quantity * unit_price * (1 - discount/100) >= 5000  THEN 'Medium'
        ELSE 'Small'
    END AS order_band,
    COUNT(*) AS orders
FROM sales_schema.sales
LEFT JOIN sales_schema.products ON products.product_id = sales.product_id
GROUP BY order_band
ORDER BY orders DESC;
```

| order_band | orders |
|------------|--------|
| Small      | 146    |
| Medium     | 31     |
| Large      | 23     |

> **Business insight:** 73% of orders are Small (< $5K), but Large orders (≥ $15K) represent premium deals worth tracking closely.

> **Concept:** `CASE/WHEN` for conditional bucketing + `GROUP BY` on a derived column.

---

#### Q7 · Profit margin % per order

```sql
SELECT 
    order_id,
    ROUND(
        (quantity * unit_price * (1 - discount/100) - quantity * unit_cost) /
        NULLIF(quantity * unit_price * (1 - discount/100), 0),
    2) * 100 AS profit_margin
FROM sales_schema.sales
LEFT JOIN sales_schema.products ON products.product_id = sales.product_id;
```

Sample rows (margin ranges from ~7% to 60%):

| order_id  | profit_margin |
|-----------|---------------|
| ORD-10199 | 60%           |
| ORD-10123 | 58%           |
| ORD-10025 | 7%            |

> **Concept:** `NULLIF()` to safely prevent division-by-zero errors.

> 📄 Full result → [`outputcsv/07_profit_margin_per_order.csv`](outputcsv/07_profit_margin_per_order.csv)

---

### Section 3 — Aggregations

---

#### Q9 · Company-wide totals

```sql
SELECT 
    ROUND(SUM(quantity * unit_price * (1 - discount/100))) AS Revenue,
    ROUND(SUM(quantity * unit_price * (1 - discount/100) - quantity * unit_cost)) AS Profit,
    SUM(quantity) AS total_units
FROM sales_schema.sales
LEFT JOIN sales_schema.products ON products.product_id = sales.product_id;
```

| Revenue      | Profit     | Total Units |
|--------------|------------|-------------|
| $1,058,839   | $207,891   | 2,705       |

> **Business insight:** Overall profit margin of **~19.6%** across 200 orders and 2,705 units sold.

---

#### Q10 · Revenue and order count by region

```sql
SELECT 
    region,
    ROUND(SUM(quantity * unit_price * (1 - discount/100))) AS Revenue,
    COUNT(*) AS orders
FROM sales_schema.sales
LEFT JOIN sales_schema.products ON products.product_id = sales.product_id
GROUP BY region
ORDER BY orders DESC;
```

| Region   | Revenue    | Orders |
|----------|------------|--------|
| Americas | $471,356   | 83     |
| EMEA     | $394,005   | 71     |
| APAC     | $193,478   | 46     |

> **Business insight:** Americas leads in both volume and revenue. APAC has the fewest orders but relatively high average order value (~$4,206).

---

#### Q11 · Revenue by product category

```sql
SELECT 
    category,
    ROUND(SUM(quantity * unit_price * (1 - discount/100))) AS Revenue
FROM sales_schema.sales
LEFT JOIN sales_schema.products ON products.product_id = sales.product_id
GROUP BY category
ORDER BY Revenue DESC;
```

| Category    | Revenue    |
|-------------|------------|
| Laptops     | $768,485   |
| Displays    | $156,214   |
| Audio       | $81,980    |
| Peripherals | $35,676    |
| Accessories | $16,484    |

> **Business insight:** Laptops alone generate **72.6% of total revenue** — the clear top category to protect and grow.

---

#### Q12 · Categories above $100K revenue (HAVING)

```sql
SELECT category, ROUND(SUM(quantity * unit_price * (1 - discount/100))) AS Revenue
FROM sales_schema.sales
LEFT JOIN sales_schema.products ON products.product_id = sales.product_id
GROUP BY category
HAVING SUM(quantity * unit_price * (1 - discount/100)) > 100000
ORDER BY Revenue DESC;
```

| Category | Revenue  |
|----------|----------|
| Laptops  | $768,485 |
| Displays | $156,214 |

> **Concept:** `HAVING` filters groups after aggregation — unlike `WHERE` which filters individual rows before grouping.

---

#### Q13 · Average order value and discount uptake

```sql
SELECT 
    ROUND(AVG(quantity * unit_price * (1 - discount/100))) AS avg_order,
    SUM(CASE WHEN discount > 0 THEN 1 ELSE 0 END)          AS discounted_orders
FROM sales_schema.sales
LEFT JOIN sales_schema.products ON products.product_id = sales.product_id;
```

| avg_order | discounted_orders |
|-----------|-------------------|
| $5,294    | 165               |

> **Business insight:** **82.5%** of orders (165 out of 200) received a discount. Average order value is $5,294.

---

#### Q14 · Profit margin % by category

```sql
SELECT 
    category,
    ROUND(SUM(quantity * unit_price * (1 - discount/100)))                                          AS Revenue,
    ROUND(SUM(quantity * unit_price * (1 - discount/100)) - SUM(quantity * unit_cost))              AS Profit,
    ROUND(100 * (SUM(quantity * unit_price * (1-discount/100)) - SUM(quantity * unit_cost)) /
                 SUM(quantity * unit_price * (1-discount/100)), 2)                                  AS margin_pct
FROM sales_schema.sales
LEFT JOIN sales_schema.products ON products.product_id = sales.product_id
GROUP BY category;
```

| Category    | Revenue  | Profit   | Margin % |
|-------------|----------|----------|----------|
| Accessories | $16,484  | $8,086   | 49.05%   |
| Audio       | $81,980  | $32,838  | 40.06%   |
| Peripherals | $35,676  | $13,258  | 37.16%   |
| Displays    | $156,214 | $36,364  | 23.28%   |
| Laptops     | $768,485 | $117,345 | 15.27%   |

> **Business insight:** Accessories and Audio have the highest margins (49% and 40%), while Laptops — despite dominating revenue — have the lowest margin at **15.3%**. A classic high-volume, lower-margin dynamic.

---

### Section 4 — Subqueries & CTEs

---

#### Q15 · Orders above average quantity (Subquery)

```sql
SELECT COUNT(*) AS above_avg_orders
FROM sales_schema.sales
WHERE quantity > (SELECT AVG(quantity) FROM sales_schema.sales);
```

| above_avg_orders |
|-----------------|
| 103             |

> **Business insight:** 103 out of 200 orders (51.5%) are above the average order quantity.

> **Concept:** Scalar subquery in `WHERE` clause — the inner query runs first and its result is used as a filter value.

---

#### Q16 · Top-selling product per region (CTE + Window Function)

```sql
WITH ranked AS (
    SELECT 
        region, 
        product,
        ROUND(SUM(quantity * unit_price * (1 - discount/100))) AS revenue,
        ROW_NUMBER() OVER (
            PARTITION BY region
            ORDER BY SUM(quantity * unit_price * (1 - discount/100)) DESC 
        ) AS rn
    FROM sales_schema.sales
    LEFT JOIN sales_schema.products ON products.product_id = sales.product_id
    GROUP BY region, product
)
SELECT region, product, revenue
FROM ranked
WHERE rn = 1
ORDER BY region;
```

| Region   | Product          | Revenue  |
|----------|------------------|----------|
| Americas | Gaming Laptop 16 | $195,913 |
| APAC     | Gaming Laptop 16 | $101,763 |
| EMEA     | Gaming Laptop 16 | $124,250 |

> **Business insight:** Gaming Laptop 16 is the **#1 product across all three regions** — a strong signal for sales focus, inventory planning, and marketing investment.

> **Concept:** CTE (`WITH` clause) to stage aggregated results, then `ROW_NUMBER() OVER (PARTITION BY ...)` to rank within each region without a self-join.

---

## 📊 Key Business Takeaways

| Insight | Detail |
|--------|--------|
| 💰 Total Revenue | $1,058,839 across 200 orders |
| 📈 Overall Profit | $207,891 (~19.6% margin) |
| 🏆 Top Category | Laptops — $768,485 (72.6% of revenue) |
| 🌍 Top Region | Americas — $471,356 / 83 orders |
| 🥇 Top Product | Gaming Laptop 16 — #1 in every region |
| 🏷️ Discount Uptake | 82.5% of orders had a discount |
| 📦 Highest Margin Category | Accessories at 49% |
| 📉 Lowest Margin Category | Laptops at 15.3% |

---

## 🛠️ How to Run This Yourself

### Prerequisites
- PostgreSQL 14+ installed locally, or a free cloud instance (e.g. [Supabase](https://supabase.com/), [ElephantSQL](https://www.elephantsql.com/))
- A SQL client: [pgAdmin](https://www.pgadmin.org/), [DBeaver](https://dbeaver.io/), or the `psql` CLI

### Steps

```bash
# 1. Create the schema and tables (DDL not included — adapt from the data)
psql -U your_user -d your_db

# 2. Inside psql or your SQL client, run:
\i postgres_session.sql

# 3. Export results as CSV from your client,
#    or use the pre-run results in the /results folder
```

---

## 🧠 SQL Concepts Covered

| Concept | Query |
|---------|-------|
| `LEFT JOIN` | Q2, Q3, Q5, Q6, Q7, Q9–Q16 |
| `WHERE` filtering | Q3 |
| `DISTINCT` | Q4 |
| Arithmetic expressions | Q5, Q7 |
| `CASE / WHEN / THEN` | Q6, Q13 |
| `NULLIF()` for safe division | Q7 |
| `SUM`, `COUNT`, `AVG`, `ROUND` | Q9–Q14 |
| `GROUP BY` + `ORDER BY` | Q10–Q14 |
| `HAVING` (post-aggregation filter) | Q12 |
| Scalar subquery in `WHERE` | Q15 |
| CTE (`WITH` clause) | Q16 |
| `ROW_NUMBER() OVER (PARTITION BY ...)` | Q16 |

---

## 📬 Contact

## 📬 Contact

**Rajan Shrestha** · Data & Full Stack Developer · Edmonton, AB 🇨🇦
- 📧 Email: [rajanshr09@gmail.com]


[![GitHub](https://img.shields.io/badge/GitHub-Profile-181717?style=flat-square&logo=github)](https://github.com/rajanshrestha09)

> 📄 Project 1 → [Sale Data Analysis](https://github.com/rajanshrestha09/sales_data_analysis/)
> 📄 Project 2 → [Sale Data Analysis-SQL](https://github.com/rajanshrestha09/SALE_DB_PROJECT)
