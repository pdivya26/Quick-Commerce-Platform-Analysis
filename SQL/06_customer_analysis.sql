-- ============================================
-- PROJECT : Quick Commerce Platform Analysis
-- FILE    : 06_customer_analysis.sql
-- AUTHOR  : Divya Poojari
-- PURPOSE: Understand customer behavior
-- BUSINESS QUESTION: Who orders what, how, and how satisfied are they?
-- ============================================

-- 1. Orders by age group
SELECT
	CASE
		WHEN customer_age BETWEEN 18 AND 25 THEN '18 - 25'
		WHEN customer_age BETWEEN 26 AND 35 THEN '26 - 35'
		WHEN customer_age BETWEEN 36 AND 45 THEN '36 - 45'
		WHEN customer_age BETWEEN 46 AND 60 THEN '46 - 60'
		ELSE 'Above 60'
	END AS age_group,
	COUNT(*) AS total_orders,
	ROUND(AVG(order_value), 2) AS avg_order_value,
	ROUND(AVG(customer_rating), 2) AS avg_customer_rating
FROM quick_commerce_clean
GROUP BY age_group
ORDER BY MIN(customer_age);

-- FINDING: Customers aged 46-60 place the highest number of orders (283,449), contrary to the assumption that quick commerce skews young.
-- The 26-35 and 36-45 groups follow closely (~203,000 each).
-- Average order value (~INR 571) and ratings (3.04) are identical across all age groups, suggesting satisfaction is age-independent.

-- 2. Product category popularity
SELECT 
	product_category,
    COUNT(*) AS total_orders,
	ROUND(AVG(order_value), 2) AS avg_order_value,
	ROUND(AVG(customer_rating), 2) AS avg_customer_rating,
	ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER()) AS order_percent
FROM quick_commerce_clean
GROUP BY product_category
ORDER BY total_orders DESC;

-- FINDING: All 7 product categories hold exactly 14% order share with identical ratings (3.04) and similar order values (~INR 571-573).
-- Dairy leads marginally with 122,771 orders and highest avg value (INR 573).
-- No single category drives disproportionate revenue or satisfaction.

-- 3. Payment method preference
SELECT
	payment_method,
	COUNT(*) AS total_orders,
	ROUND(AVG(order_value), 2) AS avg_order_value,
	ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER()) as payment_percent
FROM quick_commerce_clean
GROUP BY payment_method
ORDER BY total_orders DESC;

-- FINDING: All 5 payment methods hold exactly 20% share.
-- Cash on Delivery leads slightly (171,254 orders, INR 573 avg value).
-- Digital payment adoption is completely uniform across customers.

-- 4. Payment method preference by city
SELECT
	city,
	payment_method,
	COUNT(*) AS total_orders,
	ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER()) as payment_percent
FROM quick_commerce_clean
WHERE city IS NOT NULL
GROUP BY city, payment_method
ORDER BY city, total_orders DESC;

-- FINDING: Payment preferences are perfectly uniform across all 12 cities at 2% each per method per city.
-- No city shows regional payment preference — digital and cash adoption is nationally consistent.

-- 5. Which product categories get lowest ratings?
SELECT 
	product_category,
	COUNT(*) AS total_orders,
	ROUND(AVG(customer_rating), 2) AS avg_customer_rating
FROM quick_commerce_clean
WHERE customer_rating IS NOT NULL
GROUP BY product_category
ORDER BY avg_customer_rating DESC;

-- FINDING: Product category ratings are virtually identical (3.04-3.05 range).
-- No category has a satisfaction problem.
-- Customer experience is driven by platform operations, not what product is being delivered.

-- 6. Age group vs platform preference
SELECT
	CASE
		WHEN customer_age BETWEEN 18 AND 25 THEN '18 - 25'
		WHEN customer_age BETWEEN 26 AND 35 THEN '26 - 35'
		WHEN customer_age BETWEEN 36 AND 45 THEN '36 - 45'
		WHEN customer_age BETWEEN 46 AND 60 THEN '46 - 60'
		ELSE 'Above 60'
	END AS age_group,
	company,
    COUNT(*) AS total_orders
FROM quick_commerce_clean
GROUP BY age_group, company
ORDER BY age_group, total_orders;

-- FINDING: Platform usage is balanced across all age groups with no platform dominating any demographic. 
-- Blinkit leads in 18-25 (20,555) and 46-60 (35,692) segments. 
-- Flipkart Minutes leads in 26-35 (25,764) and 36-45 (25,612). 
-- The 46-60 group shows the highest per-platform order volumes (~35,000 each), consistent with it being the largest
-- overall segment.

-- ============================================
-- KEY INSIGHTS SUMMARY: Customer Analysis
-- ============================================

-- 1. AGE GROUP: 46-60 is surprisingly the largest ordering segment (283,449 orders), contrary to assumptions that quick commerce skews young.
--    26-35 and 36-45 follow at ~203,000 each.
--    Order value (~INR 571) and ratings (3.04) are identical across all age groups 
--    Satisfaction is completely age-independent.

-- 2. PRODUCT CATEGORIES: Perfectly balanced at 14% share each across 7 categories.
--    Dairy leads marginally (122,771 orders, INR 573 avg).
--    No single category drives disproportionate revenue or satisfaction.

-- 3. PAYMENT METHODS: All 5 methods hold exactly 20% share.
--    Cash on Delivery leads slightly (171,254 orders, INR 573 avg value).
--    No friction with any payment mode — complete payment neutrality.

-- 4. CITY PAYMENT PATTERNS: Perfectly uniform at 2% per method per city across all 12 cities. 
--    No regional payment preference exists.

-- 5. CATEGORY RATINGS: All categories rated 3.04 - 3.05.
--    Satisfaction is platform-driven, not category-driven.
--    No problem category exists.

-- 6. AGE VS PLATFORM: No platform dominates any age segment.
--    Blinkit leads in age groups 18-25 and 46-60. 
--    Flipkart Minutes leads in age groups 26-35 and 36-45. 
--    Differences are marginal throughout.

-- BOTTOM LINE: Customer behavior is remarkably uniform across all dimensions — age, category, payment, and city.
-- The key surprise is that 46-60 is the largest segment, challenging the assumption that quick commerce is a young person's product. 
-- No meaningful variation exists across customer dimensions 
-- Hence, platform operations and delivery performance remain the primary drivers of competitive differentiation

-- ============================================