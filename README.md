# Quick Commerce Platform Analysis

**An end-to-end data analysis project examining the Indian quick commerce market across 8 platforms, 12 cities, and 854K orders — using PostgreSQL for data analysis and Power BI for visualization.**

This project analyzes the competitive landscape of India's quick commerce industry. Using a dataset of ~854,000 orders, the analysis explores platform performance, delivery efficiency, customer behavior, and revenue patterns across major players like Blinkit, Zepto, Swiggy Instamart, Dunzo, JioMart, BigBasket, Amazon Now, and Flipkart Minutes.

The project was built to answer one central question: **Which platform is leading India's quick commerce market, and why?**

## Power BI Dashboards

Three interactive Power BI dashboards were developed to present the analytical findings:

### 1. Quick Commerce Analysis (Overview)
<img width="1251" height="703" alt="quick_commerce_analysis_overview" src="https://github.com/user-attachments/assets/9aec393d-4eb7-456d-9cf4-1c575b221f36" />

Key KPIs: ₹488.1M total revenue | 854K orders | 3.04 avg rating | 16.5 min avg delivery

- Revenue by city (bar chart)
- Market share by platform (donut chart)
- Order distribution by customer rating (bar chart)
- Slicers: Company, City, Product Category

### 2. Platform & Delivery Performance
<img width="1250" height="701" alt="platform_and_delivery_performance" src="https://github.com/user-attachments/assets/886560ca-5a1f-4045-83df-ff95f6a85f23" />

- Avg delivery time by platform (JioMart slowest at ~22 min; Zepto fastest at ~9.5 min)
- Delivery time vs customer rating scatter plot
- City-wise delivery times (Haridwar slowest; Delhi fastest)
- Partner rating vs customer rating scatter (weak correlation)
- Discount rate by platform (uniform ~39–40% across all)

### 3. Customer & Revenue Insights
<img width="1249" height="701" alt="customer_and_revenue_insights" src="https://github.com/user-attachments/assets/3c6edd54-a606-40d6-a0c9-796105770938" />

- Revenue by platform (Swiggy Instamart leads at ₹68.9M)
- Product category orders treemap (all 7 categories near-equal at ~14%)
- Discount impact on order value (₹713 discounted vs ₹477 non-discounted)
- Payment method split (perfectly uniform at ~20% per method)
- Order value distribution histogram

## Project Structure
```
quick-commerce-analysis/
│
├── sql/
│   ├── 01_create_table.sql          # Schema creation and data loading
│   ├── 04_platform_analysis.sql     # Platform comparison queries
│   ├── 05_delivery_analysis.sql     # Delivery performance queries
│   ├── 06_customer_analysis.sql     # Customer behavior queries
│   ├── 07_revenue_analysis.sql      # Revenue and order value queries
│   └── 08_advanced_queries.sql      # CTEs, window functions, subqueries
│
├── dashboards/
│   ├── quick_commerce_analysis_overview.png
│   ├── platform_and_delivery_performance.png
│   └── customer_and_revenue_insights.png
│
└── README.md
```

## Tech Stack

- **PostgreSQL:** Data storage, cleaning, and all SQL analysis
- **Power BI:** Interactive dashboards and data visualization 

## Dataset Overview

Dataset Source: [Quick Commerce Operational Dataset (Kaggle)](https://www.kaggle.com/datasets/rohitgrewal/quick-commerce-dataset)

| Attribute | Details |
| :---     | :---   |
| Raw Dataset Size | ~1 Million Orders |
| Cleaned Dataset Size | 854K Orders |
| Platforms |	8 Quick Commerce Platforms |
| Cities |	12 Indian Cities |
| Columns |	13 Features |
| Data Type |	Synthetic Quick Commerce Operational Data |

**Note on Dataset:** This dataset is synthetic and exhibits highly balanced distributions across several dimensions such as product categories, payment methods, and platform order volumes. The project focuses primarily on demonstrating analytical workflow, SQL techniques, business interpretation, and dashboard storytelling.

## Project Workflow

1. Imported raw CSV data into PostgreSQL
2. Performed data exploration and quality checks
3. Cleaned invalid and inconsistent records
4. Conducted platform, delivery, customer, and revenue analysis using SQL
5. Built advanced analytical queries using window functions and CTEs
6. Exported cleaned data to Power BI
7. Designed interactive dashboards for business storytelling
8. Generated operational and strategic business recommendations

## Key Findings

### Platform Performance
- **Blinkit** is the overall winner — highest customer ratings (avg 3.55), top-ranked in all 12 cities, and highest composite performance score (63.56).
- **Zepto** is the fastest deliverer (avg 9.58 min) but ranks below Blinkit in satisfaction — delivery speed alone does not guarantee higher customer satisfaction.
- **Dunzo** has the worst ratings (avg 2.45) across every single city, despite moderately fast delivery (14.13 min). The findings suggest operational or service-quality issues beyond delivery speed.
- **JioMart** is the slowest (avg 22.97 min) and poorly rated (avg 2.82) — weakest performer overall.
- Market share is nearly equal across all 8 platforms (~12% each), confirming no dominant player yet.

### Delivery Insights
- **The 20-minute mark is the critical SLA threshold.** Ratings remain stable below 20 min, then drop from 3.06 → 2.97 and further to 2.82 beyond 35 min.
- Delivery partner ratings show weak correlation with customer satisfaction — customers rate the full experience, not just the courier.
- **Delhi** delivers fastest; **Haridwar** is the slowest city overall.

### Customer Behavior
- The **46–60 age group** is the largest ordering segment (283,449 orders) — contrary to the assumption that q-commerce skews young.
- Order value (~₹571), ratings (3.04), and category preferences are virtually identical across all age groups.
- All 7 product categories hold exactly 14% order share with near-identical average values — no single category dominates.
- Payment method distribution is perfectly even (20% each across COD, UPI, Credit Card, Debit Card, Wallet).

### Revenue Insights
- **Swiggy Instamart** generates the most revenue (₹68.9M) due to the highest average order value (₹645).
- **Discounts drive 49.6% higher order values** (₹713 discounted vs ₹477 non-discounted) — the single biggest revenue lever identified.
- A clear **Tier 1 vs Tier 2 spending gap** exists: NCR cities (Gurgaon ₹695, Noida ₹685) spend ~60% more per order than Tier 2 cities (Haridwar ₹435, Jaipur ₹454).

### City Anomalies
- **Hyderabad** shows suppressed ratings across all platforms — even Blinkit scores only 2.99 there vs its national average of 3.55. City-level factors beyond platform control are likely at play.
- No single city has all platforms performing above the national average rating — every market has at least one underperformer (consistently Dunzo or JioMart).

## Business Recommendations

1. **Set a 20-minute delivery SLA** as a hard operational target — satisfaction measurably drops beyond this threshold.
2. **Investigate Dunzo's non-delivery issues** — poor ratings despite decent speed point to service quality problems (packaging, product accuracy, app experience, etc.).
3. **Prioritize Tier 1 / NCR expansion** — Gurgaon and Noida customers spend 60% more per order than Tier 2 cities.
4. **Use discounts strategically** — discounted orders generate 49.6% higher order values, making targeted promotions the strongest revenue lever.
5. **Don't overlook the 46–60 demographic** — they are the largest customer segment and should be factored into UX, product, and marketing decisions.
6. **Investigate Hyderabad separately** — the city-wide rating suppression warrants a dedicated operational and customer experience audit.

**Connect with the Author:** [LinkedIn](https://www.linkedin.com/in/divya-poojari/), [Portfolio Link](https://pdivya26.github.io/Portfolio/)
