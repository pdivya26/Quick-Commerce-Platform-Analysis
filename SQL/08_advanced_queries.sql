-- ============================================
-- PROJECT : Quick Commerce Platform Analysis
-- FILE    : 08_advanced_queries.sql
-- AUTHOR  : Divya Poojari
-- PURPOSE: Advanced SQL to demonstrate skills
-- Covers: CTEs, Window Functions, Subqueries
-- ============================================

-- 1. RANK platforms by average rating within each city
SELECT
	city,
	company,
	ROUND(AVG(customer_rating), 2) AS avg_customer_rating,
	RANK() OVER(
		PARTITION BY city
		ORDER BY AVG(customer_rating) DESC
	) AS rating_rank
FROM quick_commerce_clean
WHERE city IS NOT NULL
GROUP BY city, company
ORDER BY city, rating_rank;

-- FINDING: Blinkit ranks 1st in every single city across all 12 cities.
-- Dunzo ranks last (8th) in every single city without exception.
-- The ranking order is remarkably consistent across almost every city. 
-- Hyderabad shows the same ranking pattern but with significantly suppressed ratings across all platforms.

-- 2. Find platforms consistently below overall average rating
WITH platform_avg AS (
	SELECT
		company,
		ROUND(AVG(customer_rating), 2) AS avg_rating
	FROM quick_commerce_clean
	GROUP BY company
),
overall_avg AS (
	SELECT
		ROUND(AVG(customer_rating), 2) AS overall_avg_rating
	FROM quick_commerce_clean
)
SELECT
	p.company,
	p.avg_rating,
	o.overall_avg_rating,
	p.avg_rating - o.overall_avg_rating AS diff_from_avg
FROM platform_avg p 
CROSS JOIN overall_avg o
ORDER BY diff_from_avg;

-- FINDING: Blinkit leads above overall average by +0.51 rating points.
-- Dunzo falls furthest below average at -0.59 — the largest deviation.
-- Four platforms fall below the overall average of 3.04: Dunzo (-0.59), JioMart (-0.22), Amazon Now (-0.13), Flipkart Minutes (-0.02)
-- Four platforms perform above average of 3.04: BigBasket (+0.06), Zepto (+0.16), Swiggy Instamart (+0.24), Blinkit (+0.51)

-- 3. Top performing platform per city by combined score
WITH city_platform_stats AS (
	SELECT 
		city, 
		company,
		ROUND(AVG(customer_rating), 2) AS avg_rating,
		ROUND(AVG(order_value), 2) AS avg_value,
		ROUND(
			(AVG(customer_rating) * 20) - 
			(AVG(delivery_time_min) * 0.5), 2) AS performance_score
	FROM quick_commerce_clean
    WHERE city IS NOT NULL
    GROUP BY city, company
),
ranked_stats AS (
    SELECT 
        *,
        RANK() OVER(
            PARTITION BY city 
            ORDER BY performance_score DESC
        ) AS city_rank
    FROM city_platform_stats
)
SELECT * 
FROM ranked_stats
WHERE city_rank = 1
ORDER BY performance_score DESC;

-- FINDING: Blinkit ranks #1 across all 12 cities by performance score.
-- Bengaluru leads (71.76) with highest rating (3.97); Hyderabad lags (52.74) with lower rating (2.99).
-- High order values (Noida/Gurgaon: ₹728–732) don't correlate with higher scores — efficiency matters more than spend.
-- Smaller cities (Haridwar/Jaipur) achieve competitive scores despite lower order values.

-- 4. Classify orders into quartiles by order value
WITH order_quartiles AS (
	SELECT 
		order_id,
		order_value,
		company,
		customer_rating,
		NTILE(4) OVER(ORDER BY order_value) AS order_value_quartiles
	FROM quick_commerce_clean
)

-- Aggregate by quartile
SELECT
	order_value_quartiles,
	COUNT(*) AS total_orders,
	ROUND(AVG(order_value), 2) AS avg_order_value,
	ROUND(AVG(customer_rating), 2) AS avg_customer_rating
FROM order_quartiles
GROUP BY order_value_quartiles
ORDER BY order_value_quartiles;

-- FINDING: Orders are perfectly distributed across quartiles (213,456 each)
-- Average order values: Q1 - INR 135, Q2 - INR 413, Q3 - INR 656, Q4 - INR 1,082.
-- Customer ratings increase slightly with order value quartile
-- Suggesting higher value customers are marginally more satisfied — but the difference is minimal.

-- 5. Platform consistency score — which platform has least rating variance?
SELECT 
	company,
	MIN(customer_rating) AS min_rating,
	MAX(customer_rating) AS max_rating,
	ROUND(AVG(customer_rating), 2) AS avg_rating,
	ROUND(STDDEV(customer_rating), 4) AS rating_std,
	RANK() OVER(ORDER BY STDDEV(customer_rating)) AS consistency_rank
FROM quick_commerce_clean
GROUP BY company
ORDER BY consistency_rank;

-- FINDING: Blinkit is the most consistent platform (std dev 1.1015) meaning its ratings vary least across customers.
-- Dunzo is surprisingly second most consistent (1.1036) despite having the lowest avg rating
-- It consistently delivers poor experience rather than being unpredictably bad.
-- Amazon Now is least consistent (1.1646) with highest variance, suggesting uneven service quality across orders.
-- All platforms show similar variance range (1.10-1.16) indicating rating inconsistency is an industry-wide challenge.

-- 6. Cities where ALL platforms are above average rating
SELECT city
FROM (
	SELECT city, company,
	AVG(customer_rating) AS avg_platform_rating
	FROM quick_commerce_clean
	GROUP BY city, company
) city_platform_ratings
GROUP BY city
HAVING MIN(avg_platform_rating) > (SELECT AVG(customer_rating) FROM quick_commerce_clean)
ORDER BY city;

-- FINDING: No single city has ALL platforms performing above the overall average rating (3.04).
-- This confirms that in every city, at least one platform (consistently Dunzo or JioMart) drags below average.
-- Platform quality gaps exist in every market, no city has a fully high-quality ecosystem.

-- ============================================
-- KEY INSIGHTS SUMMARY: Advanced SQL Analysis
-- ============================================

-- 1. PLATFORM PERFORMANCE: Blinkit ranks #1 in customer ratings across every city,
--    demonstrating the strongest and most consistent customer satisfaction nationwide.
--    Dunzo ranks last in every city, indicating persistent operational and service issues.

-- 2. CITY-WISE EXPERIENCE: Hyderabad shows significantly lower ratings across all platforms
--    despite maintaining the same ranking order as other cities.
--    This suggests city-level operational challenges affecting the entire quick commerce ecosystem.

-- 3. PERFORMANCE SCORE ANALYSIS: Blinkit ranks #1 in every city even after combining customer ratings and delivery efficiency into a single weighted score.
--    Bengaluru achieves the strongest overall platform performance,
--    while Hyderabad records the weakest city-level performance across all platforms.

-- 4. CUSTOMER SPENDING BEHAVIOR: High-value orders (>₹500) dominate the dataset (455K+ orders) with avg order value of ₹847
--    Indicating customers commonly use quick commerce for substantial grocery and household purchases rather than micro convenience orders.

-- 5. ORDER VALUE QUARTILES: Customer satisfaction increases slightly with higher order value quartiles,
--    suggesting premium customers are marginally more satisfied.
--    However, the rating difference across quartiles is relatively small.

-- 6. PLATFORM CONSISTENCY: Blinkit shows the lowest rating variance, making it the most operationally consistent platform.
--    Dunzo is also highly consistent — but consistently poor.
--    Amazon Now has the highest variance, indicating uneven customer experience quality.

-- 7. CITY QUALITY ANALYSIS: No city has all platforms performing above the overall average rating.
--    Every market contains at least one underperforming platform,
--    confirming quality inconsistency across the quick commerce ecosystem.

-- BOTTOM LINE: The analysis reveals a highly stable competitive hierarchy in Indian quick commerce:
-- Blinkit consistently dominates customer satisfaction, delivery efficiency, and overall platform performance,
-- while Dunzo consistently underperforms across cities.
-- Operational consistency and fast delivery emerge as key differentiators between platforms.
-- Despite strong leaders, no city currently offers a uniformly high-quality quick commerce experience.
-- ============================================