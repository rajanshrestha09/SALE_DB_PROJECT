# 📊 B2B Electronics Sales — Data Analysis Case Study

> **Analyst's perspective:** This project goes beyond writing SQL — it uses query results to surface actionable business insights across revenue, profitability, discounting, and regional performance for a fictional B2B electronics distributor.

---

## 🗂️ Dataset at a Glance

| Metric | Value |
|--------|-------|
| Orders analysed | 200 |
| Products in catalogue | 15 |
| Sales representatives | 10 |
| Sales channels | Online · Retail · Partner |
| Regions | Americas · EMEA · APAC |
| Total units sold | 2,705 |
| **Total revenue** | **$1,058,839** |
| **Total profit** | **$207,891** |
| **Overall profit margin** | **19.6%** |

---

## 🔑 Executive Summary

Five findings a business stakeholder would care about immediately:

1. **Laptops are the revenue engine but a margin liability** — 72.6% of revenue, only 15.3% margin vs. 31.2% for the rest of the catalogue.
2. **Discounting is rampant and costly** — 82.5% of orders carried a discount, cutting average margin from 44.1% to 33.4%.
3. **Large orders are a double-edged sword** — 23 orders (11.5%) drive 49.5% of revenue but at just 11.8% margin; small orders are 3× more profitable per dollar.
4. **Americas and EMEA are healthy; APAC is underleveraged** — APAC has the lowest order volume (46) and lowest average order value ($4,206).
5. **Gaming Laptop 16 is the undisputed #1 product** — top revenue generator in every single region.

---

## 📈 Finding 1 — The Laptop Paradox

Laptops generate most of the revenue but least of the margin. Non-laptop categories punch well above their weight on profitability.

| Category    | Revenue    | Revenue Share | Profit    | Profit Share | Margin  |
|-------------|------------|---------------|-----------|--------------|---------|
| Laptops     | $768,485   | **72.6%**     | $117,345  | 56.4%        | 15.3%   |
| Displays    | $156,214   | 14.8%         | $36,364   | 17.5%        | 23.3%   |
| Audio       | $81,980    | 7.8%          | $32,838   | 15.8%        | 40.1%   |
| Peripherals | $35,676    | 3.4%          | $13,258   | 6.4%         | 37.2%   |
| Accessories | $16,484    | 1.6%          | $8,086    | 3.9%         | 49.1%   |

**The gap that matters:** Laptops are 72.6% of revenue but only 56.4% of profit. The remaining 27.4% of revenue (non-laptop categories) delivers 43.6% of profit — at a blended margin of **31.2%** vs. Laptops' **15.3%**.

> **Business recommendation:** Accessories and Audio have margins of 49% and 40% respectively. Even modest growth in these categories — without discounting — adds disproportionate profit. The business should invest in upselling accessories alongside laptop sales.

---

## 💸 Finding 2 — The Discount Problem

**165 out of 200 orders (82.5%)** had a discount applied. This is the single biggest drag on profitability.

| Segment | Orders | Avg Margin |
|---------|--------|------------|
| No discount | 35 (17.5%) | **44.1%** |
| Discounted | 165 (82.5%) | 33.4% |
| **Difference** | | **−10.7 percentage points** |

Discounts compress margin by over 10 points on average. With 165 discounted orders, this represents a significant amount of revenue converted to lower profit — the business is leaving money on the table by applying discounts too broadly.

> **Business recommendation:** Implement a discount approval policy. Reserve discounts for large, strategic orders or repeat customers — not as a default selling tool. Even moving 20% of discounted orders to full price would materially lift profit margin.

---

## 📦 Finding 3 — Order Size vs. Profitability (The Inverse Relationship)

Intuitively, large orders seem most valuable. The data tells a more nuanced story.

| Order Band | Count | Revenue Share | Total Profit | **Margin** |
|------------|-------|---------------|--------------|------------|
| Large (≥ $15K) | 23 | 49.5% | $61,561 | **11.8%** |
| Medium ($5K–$15K) | 31 | 28.8% | $63,917 | **21.0%** |
| Small (< $5K) | 146 | 21.7% | $82,425 | **35.8%** |

The 146 small orders — 73% of order count — generate more total profit ($82,425) than large orders ($61,561) despite producing only 21.7% of revenue. Large orders are almost certainly being won with steep discounts (confirmed by Q3 — highest discounts appear on large laptop orders at 15–20%).

> **Business recommendation:** Don't chase volume at the expense of margin. A strategic shift toward mid-market ($5K–$15K) orders — which balance healthy volume and 21% margin — may outperform chasing large deals that erode profitability.

---

## 🌍 Finding 4 — Regional Performance

All three regions sell predominantly the same product (Gaming Laptop 16) but show different efficiency.

| Region   | Revenue  | Orders | Avg Order Value | Revenue Share |
|----------|----------|--------|-----------------|---------------|
| Americas | $471,356 | 83     | $5,679          | 44.5%         |
| EMEA     | $394,005 | 71     | $5,549          | 37.2%         |
| APAC     | $193,478 | 46     | $4,206          | 18.3%         |

Americas and EMEA are close in average order value ($5,679 vs $5,549), suggesting similar deal dynamics. APAC has **34% fewer orders than EMEA and 26% lower average deal size** — a compounding gap that results in APAC generating less than half of EMEA's revenue.

> **Business recommendation:** APAC is the highest-potential growth region. Increasing either order frequency (from 46 toward 70+) or average deal size (toward $5,500) could add $100K+ in revenue. This warrants investigation: is APAC under-resourced in sales headcount, or facing pricing pressure that demands product or channel strategy changes?

---

## 🥇 Finding 5 — Product Concentration Risk

Gaming Laptop 16 is the #1 revenue product in all three regions:

| Region   | Top Product      | Revenue  |
|----------|------------------|----------|
| Americas | Gaming Laptop 16 | $195,913 |
| EMEA     | Gaming Laptop 16 | $124,250 |
| APAC     | Gaming Laptop 16 | $101,763 |

This is both a strength and a risk. **Gaming Laptop 16 alone accounts for ~$422K** — approximately 40% of total company revenue. Any supply disruption, price change, or competitive product could have an outsized impact on the business.

> **Business recommendation:** The product portfolio lacks diversification. The business is highly dependent on one SKU. Actively promoting the second and third products in each region — and tracking whether any strong regional #2 product exists — should be a strategic priority.

---

## 🔍 Additional Observations

**Profit margin range is wide (7%–60%):** The most profitable orders are small-quantity, no-discount Accessories and Peripherals. The worst margins come from high-quantity Laptop orders with 20% discounts. This gap suggests inconsistent pricing discipline.

**51.5% of orders exceed average quantity:** The average order quantity is the midpoint of a relatively spread distribution — suggesting two distinct customer types: bulk buyers (likely resellers or enterprise) and smaller buyers (likely SMB or retail).

**Only 2 categories exceed $100K revenue:** Laptops ($768K) and Displays ($156K). All other categories sit below the $100K threshold. This concentration means revenue is fragile to any disruption in the top two categories.

---

## 📐 Analytical Methods Used

| Technique | Applied In | Purpose |
|-----------|-----------|---------|
| Aggregation (`SUM`, `AVG`, `COUNT`) | Revenue, profit, order totals | Baseline KPIs |
| Conditional logic (`CASE/WHEN`) | Order band segmentation | Bucketing for segment analysis |
| `HAVING` clause | Category filter >$100K | Post-aggregation threshold filtering |
| `NULLIF()` | Margin calculation | Safe division — avoids divide-by-zero |
| Scalar subquery | Above-average orders | Dynamic threshold comparison |
| CTE + `ROW_NUMBER() OVER (PARTITION BY)` | Top product per region | Window function for within-group ranking |
| Derived metrics | Margin %, profit share | KPIs not stored in raw data — computed analytically |
| Cross-metric comparison | Order band vs. margin | Finding non-obvious inverse relationships |

---

## 💡 What This Project Demonstrates

This isn't just SQL syntax practice. The queries are structured to answer real business questions:

- *Where is our money actually coming from?* → Category and region breakdowns
- *Are we pricing well?* → Margin analysis and discount impact
- *Which customers / orders are most valuable?* → Order band segmentation
- *Where should we focus next?* → Regional gap analysis and product concentration

The ability to move from raw query output to a narrative recommendation is what separates a **data analyst** from someone who can run SQL.

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

## 📬 Contact

**Rajan Shrestha** · Data & Full Stack Developer · Edmonton, AB 🇨🇦
- 📧 Email: [rajanshr09@gmail.com]


[![GitHub](https://img.shields.io/badge/GitHub-Profile-181717?style=flat-square&logo=github)](https://github.com/rajanshrestha09)

> 📄 Project 1 → [Sale Data Analysis](https://github.com/rajanshrestha09/sales_data_analysis/)
