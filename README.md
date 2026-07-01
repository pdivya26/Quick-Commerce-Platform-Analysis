# Quick Commerce Platform Analysis

An end-to-end data analytics project that analyzes the competitive landscape of India's quick commerce industry — examining platform performance, delivery efficiency, customer behavior, and revenue patterns across 8 platforms and 12 cities using a dataset of ~854,000 orders.

The project was built to answer one central question: **Which platform is leading India's quick commerce market, and why?**

## Power BI Dashboards

Three interactive Power BI dashboards were developed to present the analytical findings:

### 1. Quick Commerce Analysis (Overview)
<img width="1251" height="703" alt="quick_commerce_analysis_overview" src="https://github.com/user-attachments/assets/9aec393d-4eb7-456d-9cf4-1c575b221f36" />

- Revenue by City — Which cities drive the most revenue? Gurgaon, Noida and Delhi dominate; Tier 2 cities like Haridwar and Jaipur lag significantly.
- Orders by Platform — Is any platform dominating market share? No — every platform holds ~12%, the market is still wide open.
- Orders by Customer Rating — Are customers actually satisfied? Mostly average — ratings 2, 3, 4 dominate; very few customers give a 5.

### 2. Platform & Delivery Performance
<img width="1250" height="701" alt="platform_and_delivery_performance" src="https://github.com/user-attachments/assets/886560ca-5a1f-4045-83df-ff95f6a85f23" />

- Delivery Time by Platform — Which platform keeps its delivery promise? Zepto is fastest at 9.5 min; JioMart consistently fails at 23 min.
- Delivery Time vs Rating Scatter — Does faster delivery mean happier customers? Only up to 20 minutes — beyond that, speed alone doesn't improve ratings.
- City Delivery Times — Where are logistics breaking down? Haridwar is the slowest city; Delhi is the fastest.
- Partner Rating vs Customer Rating — Do better delivery partners lead to better reviews? No — the correlation is weak; customers rate the full experience.
- Discount Rate by Platform — Are platforms competing on discounts? No — all platforms offer identical rates (~39-40%), no differentiation here.

### 3. Customer & Revenue Insights
<img width="1249" height="701" alt="customer_and_revenue_insights" src="https://github.com/user-attachments/assets/3c6edd54-a606-40d6-a0c9-796105770938" />

- Revenue by Platform — Who is winning commercially? Swiggy Instamart leads at ₹68.9M, driven by highest average order value not order volume.
- Product Category Treemap — What are customers actually buying? Every category holds exactly 14% — no single category anchors the business.
- Discount Impact — Do discounts actually pay off? Yes — discounted orders average ₹713 vs ₹477 without, a 49.6% uplift.
- Payment Method Split — How do customers prefer to pay? Evenly across all five methods at 20% each — no method can be deprioritized.
- Order Value Distribution — What does the typical order look like? High frequency low value orders dominate; large baskets are extremely rare.

## Project Structure
```
quick-commerce-analysis/
│
├── data/
|   ├── quick_commerce_analysis_raw
|   └── quick_commerce_analysis_clean
|
├── powerbi/
│   └── quick_commerce_platform_analysis_dashboard.pbix
|
├── sql/
│   ├── 01_create_table.sql          # Schema creation and data loading
|   ├── 02_data_exploration.sql      # Initial data exploration, summary statistics, and quality checks
|   ├── 03_data_cleaning.sql         # Data cleaning, null handling, duplicate removal, and validation
│   ├── 04_platform_analysis.sql     # Platform comparison queries
│   ├── 05_delivery_analysis.sql     # Delivery performance queries
│   ├── 06_customer_analysis.sql     # Customer behavior queries
│   ├── 07_revenue_analysis.sql      # Revenue and order value queries
│   └── 08_advanced_queries.sql      # CTEs, window functions, subqueries
│
├── screenshots/
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

**Note on Dataset:** This dataset is **synthetic** and exhibits highly balanced distributions across several dimensions such as product categories, payment methods, platform order volumes and includes platforms such as Dunzo that may no longer be fully operational in the current market. The project focuses primarily on demonstrating analytical workflow, SQL techniques, business interpretation, and dashboard storytelling.

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

## Author

Divya Poojari - [LinkedIn](https://www.linkedin.com/in/divya-poojari/) | [Portfolio](https://pdivya26.github.io/Portfolio/)
