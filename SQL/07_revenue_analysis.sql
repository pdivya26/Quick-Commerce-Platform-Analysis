-- ============================================
-- PROJECT : Quick Commerce Platform Analysis
-- FILE    : 07_revenue_analysis.sql
-- AUTHOR  : Divya Poojari
-- PURPOSE: Understand revenue and order value patterns
-- BUSINESS QUESTION: Where does money come from and what drives it?
-- ============================================

-- 1. Total and average order value per platform
SELECT 
	company,
	COUNT(*) AS total_orders,
	ROUND(AVG(order_value), 2) AS avg_order_value,
	ROUND(SUM(order_value), 2) AS total_revenue
FROM quick_commerce_clean
GROUP BY company
ORDER BY total_revenue DESC;

-- FINDING: Swiggy Instamart generates the highest total revenue (INR 68.9M)
-- despite not having the most orders, due to highest avg order value (INR 645).
-- Blinkit ranks second in revenue (INR 65.3M) with avg order value of INR 610.
-- JioMart generates the lowest revenue (INR 51.3M) with lowest avg order value (INR 483)
-- consistent with its poor performance across all metrics.

-- 2. Does discount lead to higher order value?
SELECT
	discount_applied,
    COUNT(*) AS total_orders,
	ROUND(AVG(items_count), 2) AS avg_items_count,
	ROUND(AVG(order_value), 2) AS avg_order_value
FROM quick_commerce_clean
GROUP BY discount_applied
ORDER BY total_orders DESC;

-- FINDING: Discounted orders show dramatically higher avg order value 
-- Discounted orders (INR 713) vs non-discounted orders (INR 477) — a 49.6% difference.
-- Avg items count is nearly identical (10.00 vs 10.01)
-- meaning customers order the same number of items but spend significantly more when discounts are applied 
-- suggesting discounts attract higher value purchases or are applied to premium products.

-- Difference calculation: ((713 - 477) / 477) * 100 = 49.6%

-- 3. Revenue by city
SELECT 
	city,
	COUNT(*) AS total_orders,
	ROUND(AVG(order_value), 2) AS avg_order_value,
	ROUND(SUM(order_value), 2) AS total_revenue
FROM quick_commerce_clean
WHERE city IS NOT NULL
GROUP BY city
ORDER BY total_revenue DESC;

-- FINDING: Gurgaon leads in total revenue (INR 46.9M) and avg order value (INR 695)
-- followed closely by Noida (INR 46.2M, INR 685 avg) and Delhi (INR 40.9M, INR 606 avg).
-- Both are NCR cities, suggesting premium customer base in the Delhi-NCR region.
-- Haridwar ranks last in both total revenue (INR 29.4M) and avg order value (INR 435)
-- followed by Jaipur (INR 454 avg)
-- Tier 2 cities show significantly lower spending patterns.

-- 4. Revenue by product category
SELECT 
	product_category,
	COUNT(*) AS total_orders,
	ROUND(AVG(order_value), 2) AS avg_order_value,
	ROUND(SUM(order_value), 2) AS total_revenue
FROM quick_commerce_clean
GROUP BY product_category
ORDER BY total_revenue DESC;

-- FINDING: Dairy leads in total revenue (INR 70.4M, avg INR 573) 
-- followed by Groceries (INR 69.9M) and Household (INR 69.8M).
-- Avg revenue is nearly uniform across all 7 categories (INR 569-573 avg),
-- confirming findings from customer analysis — no single category
-- dominates quick commerce spending.

-- 5. High value orders (top 10% threshold)
SELECT 
	PERCENTILE_CONT(0.90) 
	WITHIN GROUP(ORDER BY order_value) AS top_10_percent
FROM quick_commerce_clean;

-- Analyze high value orders
WITH high_value AS (
	SELECT * 
	FROM quick_commerce_clean
	WHERE order_value >= (
		SELECT PERCENTILE_CONT(0.90) 
		WITHIN GROUP(ORDER BY order_value)
	FROM quick_commerce_clean
	)
)
SELECT 
	company,
	COUNT(*) AS high_value_orders,
	ROUND(AVG(order_value), 2) AS avg_order_value,
	ROUND(AVG(customer_rating), 2) AS avg_customer_rating
FROM high_value
GROUP BY company
ORDER BY high_value_orders DESC;

-- FINDING: Swiggy Instamart dominates high value orders (16,360 orders, avg INR 1,367)
-- more than 3x Blinkit's high value order count (13,334).
-- Blinkit however maintains highest satisfaction even among high value customers (rating 3.56 vs Swiggy's 3.29).
-- JioMart captures fewest high value orders (4,984) with lowest avg value (INR 1,276)
-- and poor satisfaction (2.85) — struggling at every tier.
-- Dunzo has worst satisfaction among high value customers (2.47) suggesting it cannot retain premium customers.

-- 6. Payment method vs revenue
SELECT 
	payment_method,
	COUNT(*) AS total_orders,
	ROUND(SUM(order_value), 2) AS total_revenue,
	ROUND(AVG(order_value), 2) AS avg_order_value
FROM quick_commerce_clean
GROUP BY payment_method
ORDER BY total_revenue DESC;

-- FINDING: Cash on Delivery generates highest total revenue (INR 98.3M)
-- and highest avg order value (INR 573), marginally ahead of other methods.
-- All payment methods show nearly identical revenue contribution (~INR 97M each)
-- and avg order values (INR 570-574), confirming payment method neutrality found in customer analysis.

-- ============================================
-- KEY INSIGHTS SUMMARY: Revenue Analysis
-- ============================================

-- 1. PLATFORM REVENUE: Swiggy Instamart leads total revenue (INR 68.9M)
--    due to highest avg order value (INR 645). Blinkit ranks second (INR 65.3M).
--    JioMart generates least revenue (INR 51.3M, INR 483 avg) consistent with poor performance across all analysis dimensions.

-- 2. DISCOUNT IMPACT: Discounted orders generate 49.6% higher avg order value (INR 713 vs INR 477).
--    Same item count in both groups suggests discounts attract premium purchases, not just more items.
--    Strongest revenue driver identified in the dataset.

-- 3. CITY REVENUE: Gurgaon and Noida (NCR cities) lead significantly
--    in avg order value (INR 695 and INR 685). Haridwar and Jaipur
--    lag considerably (INR 435 and INR 454) — clear Tier 1 vs Tier 2
--    spending gap exists in quick commerce.

-- 4. CATEGORY REVENUE: Revenue uniform across all 7 categories (INR 569-573 avg).
--    No category drives disproportionate revenue.
--    Dairy leads marginally at INR 573 avg.

-- 5. HIGH VALUE ORDERS: Swiggy Instamart captures most premium orders (16,360 high value orders).
--    Blinkit leads satisfaction even among premium customers. 
--    JioMart and Dunzo fail to attract or retain high value customers.

-- 6. PAYMENT REVENUE: All payment methods contribute equally to revenue (~INR 97M each, INR 570-574 avg).
--    COD leads marginally but differences are negligible.

-- BOTTOM LINE: Two major revenue insights stand out —
-- First, discounts drive 49.6% higher order values, 
-- making discount strategy the single biggest revenue lever in this dataset.
-- Second, a clear Tier 1 vs Tier 2 city spending gap exists with
-- NCR cities (Gurgaon, Noida) spending ~60% more per order than Tier 2 cities (Haridwar, Jaipur).
-- Platforms should prioritize premium city expansion and strategic discounting for revenue growth.
-- ============================================